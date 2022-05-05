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

import sys, re, time, argparse
import APIFunctions
from PySide2.QtCore import *
from PySide2.QtWebSockets import *
from pathlib import Path
from femtoapi import PyFemtoAPI


class copyFrames:
    """
    FemtoAPI application to copy data between two specified frames into a new measurement unit.
    """
    
    
    def __init__(self):
        self.sourceMeas = ''
        self.startingFrame = 0
        self.frameNum = 0
        self.sourcePath = ''
        self.targetPath = ''
        

    def getArguments(self):
        parser = argparse.ArgumentParser(description="FemtoAPI application to copy data between two specified frames into a new measurement unit.")
        parser.add_argument('source', metavar='SOURCE',
                            help='Handle of the source measurement unit. e.g.: "10,0,0"')
        parser.add_argument('frameStart', metavar='FRAMESTART',
                            help='First frame to be copied.')
        parser.add_argument('frameNum', metavar='FRAMENUM',
                            help='Number of frames to be copied.')
        parser.add_argument('path', metavar='PATH',
                            help='Path of the source measurement file.')
        parser.add_argument('--target', default = None,
                            help="Path of the output measurement file which is going to be created by the script. "
                                "If nothing is given a default 'copied_frames.mesc' file will be created in the containing folder of the source file.")
        args = parser.parse_args()
        self.sourceMeas = str(args.source)
        self.startingFrame = int(args.frameStart)
        self.frameNum = int(args.frameNum)
        self.sourcePath = Path(str(args.path))
        self.targetPath = args.target
        
        if not self.sourcePath.exists():
            print("ERROR: Source file does not exist!")
            sys.exit()
        folder = str(self.sourcePath.parent.resolve())
        folder = folder.replace("\\", "/")
        if self.targetPath:
            if not Path(self.targetPath).parent.exists():
                print("Target folder does not exists.\nUsing default output folder: " + folder)
                self.targetPath = folder + '/' + str(Path(self.targetPath).name)
            else:
                self.targetPath = str(Path(self.targetPath).parent.resolve()) + '/' + str(Path(self.targetPath).name)
            self.targetPath = self.targetPath.replace("\\", "/")
        else:
            self.targetPath = folder + "/copied_frames.mesc"
            print("No target file was given.\nUsing default output location and default filename: " + self.targetPath)


    def run(self):
        source = self.sourceMeas
        if re.search("[0-9]+,[0-9]+,[0-9]+", source):
            pos = source.find(",")
            file_handler = source[:pos]
            source = source[pos+1:]
            pos = source.find(",")
            session_handler = source[:pos]
            unit_handler  = source[pos+1:]
        else:
            print(source)
            print("Bad source format given!\nThe source should look like: '10,0,0'")
            sys.exit()

        app = QCoreApplication(sys.argv)
        ws = APIFunctions.initConnection()
        if ws == None:
            sys.exit()
        print("Connected to API websocket host.")
        #the login functions does not actually checks the given data as of version 1.0 but it is still a necessary step to start up an API conncetion
        res = APIFunctions.login(ws, 'asd', '123')
        if not res:
            sys.exit()
        time.sleep(5)
        print("API login successfull.")
        pstate = APIFunctions.getChildTree(ws)

        for e in pstate['openedMEScFiles']:
            if e['handle'] == [int(file_handler)]:
                for session in e['measurementSessions']:
                    if session['handle'] == [int(file_handler),int(session_handler)]:
                        for munit in session['measurements']:
                            if munit['handle'] == [int(file_handler),int(session_handler), int(unit_handler)]:
                                channelNames = []
                                for channel in munit['channels']:
                                    channelNames.append(channel['name'])
                                taskType = munit['technologyType']
                                dimx = munit['xDim']
                                #xscale = munit['pixelSizeX']
                                dimy = munit['yDim']
                                #yscale = munit['pixelSizeY']
                                dimt = munit['zDim']
                                tscale = munit['tStepInMs']
                                referenceViewportJSON = munit['referenceViewportJSON']
                                transl = str(munit['referenceViewportJSON']['viewports'][0]['geomTransTransl'])
                                rotQ = str(munit['referenceViewportJSON']['viewports'][0]['geomTransRot'])
                                width = str(munit['referenceViewportJSON']['viewports'][0]['width'])
                                height = str(munit['referenceViewportJSON']['viewports'][0]['height'])

        if  self.startingFrame >= dimt:
            print("PARAMETER ERROR! Starting frame number is larger than the actual length of the mUnit. Exiting script...")
            sys.exit()

        if (self.startingFrame + self.frameNum) > dimt:
            print("WARNING! Some of the frames are outside of the dimensions of the mUnit.")
            self.frameNum = dimt - self.startingFrame
            print("Number of copied framse are dropped to " + str(self.frameNum))

        APIFunctions.createNewFile(ws)
        currHandle = APIFunctions.getCurrentSession(ws)
        pos = currHandle.find(",")
        newfilehandle = currHandle[:pos]

        

        viewport='{"referenceViewportFormatVersion": 1, "viewports":[{"geomTransTransl": ' + transl + ',"geomTransRot": ' + rotQ + ',"width": ' + str(width) + ',"height": ' + str(height) + '}]}'

        res = APIFunctions.createTimeSeriesMUnit(ws, dimx, dimy, taskType, viewport, z0InMs = 0, zStepInMs = tscale)
        time.sleep(2)
        handle = res['addedMUnitIdx']
        for name in channelNames:
            res = APIFunctions.addChannel(ws, handle, name)

        for frame in range(self.frameNum):
            baseFrame = self.startingFrame + frame
            for channelNum in range(len(channelNames)):
                res = APIFunctions.readChannelData(ws, 'tmpvar', self.sourceMeas + ',' +str(channelNum), '0,0,' + str(baseFrame), str(dimx) + ',' + str(dimy) + ',1')
                res = APIFunctions.writeChannelData(ws, 'tmpvar',  handle + ',' + str(channelNum), '0,0,' + str(frame), str(dimx) + ',' + str(dimy) + ',1')
            if frame < self.frameNum - 1:
                res = APIFunctions.extendMUnit(ws, handle, 1)

        file = self.targetPath
        tmp = 2
        while Path(file).exists():
            file = Path(Path(self.targetPath).parent, str(Path(self.targetPath).stem) + str(tmp) + '.mesc')
            tmp += 1
        file = str(file).replace("\\", "/")
        res = APIFunctions.closeFileAndSaveAsAsync(ws, file, newfilehandle)
        time.sleep(5)
        
        ws = APIFunctions.closeConnection(ws)


if __name__ == "__main__":
    app = copyFrames()
    app.getArguments()
    app.run()       
