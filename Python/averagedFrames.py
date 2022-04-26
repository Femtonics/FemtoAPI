# Copyright ©2021. Femtonics Ltd. (Femtonics). All Rights Reserved. 
# Permission to use, copy, modify this software and its documentation for educational,
# research, and not-for-profit purposes, without fee and without a signed licensing agreement, is 
# hereby granted, provided that the above copyright notice, this paragraph and the following two 
# paragraphs appear in all copies, modifications, and distributions. Contact info@femtonics.eu
# for commercial licensing opportunities.
# 
# IN NO EVENT SHALL FEMTONICS BE LIABLE TO ANY PARTY FOR DIRECT, INDIRECT, SPECIAL, 
# INCIDENTAL, OR CONSEQUENTIAL DAMAGES, INCLUDING LOST PROFITS, ARISING OUT OF 
# THE USE OF THIS SOFTWARE AND ITS DOCUMENTATION, EVEN IF FEMTONICS HAS BEEN 
# ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
# 
# FEMTONICS SPECIFICALLY DISCLAIMS ANY WARRANTIES, INCLUDING, BUT NOT LIMITED TO, 
# THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR 
# PURPOSE. THE SOFTWARE AND ACCOMPANYING DOCUMENTATION, IF ANY, PROVIDED 
# HEREUNDER IS PROVIDED "AS IS". FEMTONICS HAS NO OBLIGATION TO PROVIDE 
# MAINTENANCE, SUPPORT, UPDATES, ENHANCEMENTS, OR MODIFICATIONS.

import sys, time, logging, os, numpy, argparse, re
import APIFunctions
import miscFunctions
from PySide2.QtCore import *
from PySide2.QtWebSockets import *
from pathlib import Path
from femtoapi import PyFemtoAPI


class AverageFrames:
    def __init__(self):
        self.bufferSize = 0
        self.avgFrameNum = 0

    def getArguments(self):
        parser = argparse.ArgumentParser(description="Creates a new measurement unit from the given source with averaged pixel values."
                                                     "Usable with MESc 4.5 and femtoAPI 2.0 versions.")
        parser.add_argument('source', metavar='SOURCE',
                            help='Handler of the source measurement unit with channel number. e.g.: "10,0,0,0"')
        parser.add_argument('avgFrames', metavar='FRAMES',
                            help='A number that defines how many frames are used to create an averaged frame. The frame will be crated by averaging the X number of frames before and after the frame together.')
        parser.add_argument('--bufferSize', default = 100,
                    help='Defines the number of frames to read at once from the server. Default value is 100')
        args = parser.parse_args()
        sourceString = str(args.source)
        self.avgFrameNum = int(args.avgFrames)
        self.bufferSize = int(args.bufferSize)
        print(sourceString, type(sourceString))
        print(self.avgFrameNum, self.bufferSize)
        return sourceString

        
    def createAveragedTimeSeries(self, ws, file_handler, session_handler, unit_handler, channel_handler, avgFrameNum = None, bufferSize = None):
        """
        """
        if bufferSize:
            self.bufferSize = bufferSize
        if avgFrameNum:
            self.avgFrameNum = avgFrameNum
        
        firstBuffer = 0
        res = APIFunctions.createNewFile(ws)
        print("newid " + str(res['id']))
        pstate = APIFunctions.getChildTree(ws)
        currHandle = APIFunctions.getCurrentSession(ws)
        pos = currHandle.find(",")
        currHandle = currHandle[:pos]
        print(currHandle)
    
        for e in pstate['openedMEScFiles']:
            if e['handle'] == [int(file_handler)]:
                for session in e['measurementSessions']:
                    if session['handle'] == [int(file_handler),int(session_handler)]:
                        for munit in session['measurements']:
                            if munit['handle'] == [int(file_handler),int(session_handler), int(unit_handler)]:
                                dimx = munit['logicalDimSizes'][0]
                                dimy = munit['logicalDimSizes'][1]
                                dimz = munit['logicalDimSizes'][2]

        res = APIFunctions.copyMUnit(ws, file_handler + ',' + session_handler + ',' + unit_handler, '' + str(currHandle) + ',0', 'true')
        newHandle = res['copiedMUnitIdx']

        firstBuffer = 0
        if dimz < self.bufferSize:
            firstBuffer = dimz
        else:
            firstBuffer = self.bufferSize
        rawdata = APIFunctions.readChannelDataToClientsBlob(ws, str(currHandle) + ',0,0,' + str(channel_handler) , '0,0,0', str(dimx) + ',' + str(dimy) + ',' + str(firstBuffer))
        stream = QDataStream(rawdata)
        stream.setByteOrder(QDataStream.ByteOrder.LittleEndian)
        tmplist = []
        while not stream.atEnd():
            floatData = stream.readDouble()
            tmplist.append(floatData)
        data = numpy.array(tmplist)
        newdata = numpy.reshape(data, (dimx, dimy, firstBuffer), order='F')
        avgarray = numpy.array([])
        tmparr = numpy.array([])
        workingarr = numpy.array([])
 
        for x in range(0 , firstBuffer - self.avgFrameNum):
            if x - self.avgFrameNum < 0:
                tmparr = newdata[0:dimx, 0:dimy, 0:(x + self.avgFrameNum)]
            else:
                tmparr = newdata[0:dimx, 0:dimy, (x - self.avgFrameNum):(x + self.avgFrameNum + 1)]
            avrg = numpy.mean(tmparr, axis=2)
            avrg = numpy.reshape(avrg, (dimx, dimy, 1), order='F')
            if avgarray.size == 0:
                avgarray = avrg
            else:
                avgarray = numpy.append(avgarray, avrg, axis=2)
  
        workingarr = newdata[0:dimx, 0:dimy, (firstBuffer - (self.avgFrameNum * 2)):firstBuffer]
        numpy.swapaxes(avgarray, 0, 1)
        stream = QByteArray(avgarray.tobytes(order='F'))
        res = APIFunctions.writeChannelDataFromAttachment(ws, stream,  str(currHandle) + ',0,0,' + str(channel_handler), '0,0,0', str(dimx) + ',' + str(dimy) + ',' + str(firstBuffer - self.avgFrameNum))  

        frameCount = firstBuffer

        while frameCount + self.bufferSize <= dimz:
            print("frameCount : " + str(frameCount))
            rawdata = APIFunctions.readChannelDataToClientsBlob(ws, str(currHandle) + ',0,0,' + str(channel_handler), '0,0,' + str(frameCount), str(dimx) + ',' + str(dimy) + ',' + str(self.bufferSize))
            stream = QDataStream(rawdata)
            stream.setByteOrder(QDataStream.ByteOrder.LittleEndian)
            tmplist = []
            while not stream.atEnd():
                floatData = stream.readDouble()
                tmplist.append(floatData)
            data = numpy.array(tmplist)
            newdata = numpy.reshape(data, (dimx, dimy, self.bufferSize), order='F')
            workingarr = numpy.append(workingarr, newdata, axis=2)
            avgarray = numpy.array([])         
            for x in range(0 + self.avgFrameNum, self.bufferSize + self.avgFrameNum):
                tmparr = workingarr[0:dimx, 0:dimy, (x - self.avgFrameNum):(x + self.avgFrameNum + 1)]
                avrg = numpy.mean(tmparr, axis=2)
                avrg = numpy.reshape(avrg, (dimx, dimy, 1), order='F')
                if avgarray.size == 0:
                    avgarray = avrg
                else:
                    avgarray = numpy.append(avgarray, avrg, axis=2) 
            workingarr = workingarr[0:dimx, 0:dimy, self.bufferSize:(self.bufferSize + (self.avgFrameNum * 2))]     
            numpy.swapaxes(avgarray, 0, 1)
            stream = QByteArray(avgarray.tobytes(order='F'))
            res = APIFunctions.writeChannelDataFromAttachment(ws, stream,  str(currHandle) + ',0,0,' + str(channel_handler), '0,0,' + str(frameCount - self.avgFrameNum), str(dimx) + ',' + str(dimy) + ',' + str(self.bufferSize))
            frameCount = frameCount + self.bufferSize

        if firstBuffer == self.bufferSize and (dimz % self.bufferSize) > 0:
            print("frameCount : " + str(frameCount) + ", lastFrames : " + str(dimz % self.bufferSize))
            rawdata = APIFunctions.readChannelDataToClientsBlob(ws, str(currHandle) + ',0,0,' + str(channel_handler), '0,0,' + str(frameCount), str(dimx) + ',' + str(dimy) + ',' + str(dimz % self.bufferSize))
            stream = QDataStream(rawdata)
            stream.setByteOrder(QDataStream.ByteOrder.LittleEndian)
            tmplist = []
            while not stream.atEnd():
                floatData = stream.readDouble()
                tmplist.append(floatData)
            data = numpy.array(tmplist)
            newdata = numpy.reshape(data, (dimx, dimy, dimz % self.bufferSize), order='F')
            workingarr = numpy.append(workingarr, newdata, axis=2)


        lastBuffer = workingarr.shape[2]
        print(lastBuffer)
        avgarray = numpy.array([])
        for x in range(0 + self.avgFrameNum, lastBuffer):
            if ((lastBuffer - 1) - x) < 5:
                tmparr = workingarr[0:dimx, 0:dimy, (x - self.avgFrameNum):lastBuffer]
            else:
                tmparr = workingarr[0:dimx, 0:dimy, (x - self.avgFrameNum):(x + self.avgFrameNum + 1)]
            avrg = numpy.mean(tmparr, axis=2)
            avrg = numpy.reshape(avrg, (dimx, dimy, 1), order='F')
            if avgarray.size == 0:
                avgarray = avrg
            else:
                avgarray = numpy.append(avgarray, avrg, axis=2)
        print(avgarray.shape[2])
        numpy.swapaxes(avgarray, 0, 1)
        stream = QByteArray(avgarray.tobytes(order='F'))
        res = APIFunctions.writeChannelDataFromAttachment(ws, stream,  str(currHandle) + ',0,0,' + str(channel_handler), '0,0,' + str(frameCount - self.avgFrameNum), str(dimx) + ',' + str(dimy) + ',' + str(lastBuffer))
        return str(currHandle) + ',0,0,' + str(channel_handler)
    
    def connect(self):
        app = QCoreApplication(sys.argv)
        ws = APIFunctions.initConnection()
        print("Connected to API websocket host.")
        APIFunctions.login(ws, 'csp', 'asdf')
        time.sleep(5)
        print("API login successfull.")
        return ws
        
    def disconnect(self, ws):
        APIFunctions.closeConnection(ws)


if __name__ == '__main__':
    app = AverageFrames()
    source = app.getArguments()
    if re.search("[0-9]+,[0-9]+,[0-9]+,[0-9]+", source):
        pos = source.find(",")
        file = source[:pos]
        source = source[pos+1:]
        pos = source.find(",")
        session = source[:pos]
        source = source[pos+1:]
        pos = source.find(",")
        unit = source[:pos]
        channel = source[pos+1:]
    else:
        print("Bad source format given!/nThe source should look like: '10,0,0,0'")
    ws = app.connect()
    string = app.createAveragedTimeSeries(ws, file, session, unit, channel)
    print(string)
    
