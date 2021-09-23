# Copyright ©2021. Femtonics Kft. (Femtonics). All Rights Reserved. 
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

import sys, time, argparse, pathlib, re
import APIFunctions
import miscFunctions
from PySide2.QtCore import *
from PySide2.QtWebSockets import *
import xml.etree.ElementTree as ET

from femtoapi import PyFemtoAPI


class layerSeparator:

    '''
    Script creating separate measurement units from the different layers in a multilayer or volumescan measurement including all channels.
    '''

    def __init__(self):
        self.sourceMeas = ''
        self.sourcePath = ''
        self.targetPath = ''
        
    def getArguments(self):
        parser = argparse.ArgumentParser(description="FemtoAPI application to create separate measurement units from the different layers in multilayer and volumescan measurements."
                                                     "Usable with MESc 4.0 and femtoAPI 1.0 versions.")
        parser.add_argument('source', metavar='SOURCE',
                            help='Handle of the source measurement unit with channel number. e.g.: "10,0,0"')
        parser.add_argument('path', metavar='PATH',
                            help='Path of the source measurement file.')
        parser.add_argument('--target', default = None,
                            help="Path of the output measurement file which is gonna be created by the script. "
                                "If nothing is given a default 'separated_layers.mesc' file will be created in the containing folder of the source file.")
        args = parser.parse_args()
        self.sourceMeas = str(args.source)
        self.sourcePath = pathlib.Path(str(args.path))
        self.targetPath = args.target
        
        if not self.sourcePath.exists():
            print("ERROR: Source file does not exist!")
            sys.exit()
        folder = str(self.sourcePath.parent.resolve())
        folder = folder.replace("\\", "/")
        if self.targetPath:
            if not pathlib.Path(self.targetPath).parent.exists():
                print("Target folder does not exists.\nUsing default output folder: " + folder)
                self.targetPath = folder + '/' + str(pathlib.Path(self.targetPath).name)
            else:
                self.targetPath = str(pathlib.Path(self.targetPath).parent.resolve()) + '/' + str(pathlib.Path(self.targetPath).name)
            self.targetPath = self.targetPath.replace("\\", "/")
        else:
            self.targetPath = folder + "/separated_layers.mesc"
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
            print("Bad source format given!\nThe source should look like: '10,0,0,0'")
            sys.exit()
            
        app = QCoreApplication(sys.argv)
        ws = APIFunctions.initConnection()
        print("Connected to API websocket host.")
        #login credentials are not checked on server side yet but this step is still necessary to estabilist an API connection
        APIFunctions.login(ws, 'asd', '123')
        time.sleep(5)
        print("API login successfull.")
        res = APIFunctions.createNewFile(ws)
        
        pstate = APIFunctions.getProcessingState(ws)
        newfilehandle = pstate['currentFileHandle'][0]
        #collecting measurement specific data like dimensions and viewports
        for e in pstate['openedMEScFiles']:
            if e['handle'] == [int(file_handler)]:
                for session in e['measurementSessions']:
                    if session['handle'] == [int(file_handler),int(session_handler)]:
                        for munit in session['measurements']:
                            if munit['handle'] == [int(file_handler),int(session_handler), int(unit_handler)]:
                                channelNames = []
                                for channel in munit['channels']:
                                    channelNames.append(channel['name'])
                                
                                for dim in munit['dimensions']:
                                    if dim['role'] == 'z':
                                        dimz = dim['size']
                                    elif dim['role'] == 't':
                                        dimt = dim['size']
                                        tscale = dim['conversion']['scale']
                                    else:
                                        pass

                                layerData = []
                                
                                if 'viewportList' in munit['measurementParams']:
                                    vpList = munit['measurementParams']['viewportList']
                                    counter = 0
                                    for vp in vpList:
                                        layerData.append({})
                                        layerData[counter].update({})
                                        layerData[counter].update({"dimx": vp['viewport']['pixelNumberX']})
                                        layerData[counter].update({"dimy": vp['viewport']['pixelNumberY']})
                                        rotQ = vp['viewport']['geomTrans']['m_rot']
                                        tmp = rotQ.pop(0)
                                        rotQ.append(tmp)
                                        layerData[counter].update({"rotQ": rotQ})
                                        transl = vp['viewport']['geomTrans']['m_transl']
                                        layerData[counter].update({"transl": transl})
                                        height = vp['viewport']['height']
                                        layerData[counter].update({"height": height})
                                        width = vp['viewport']['width']
                                        layerData[counter].update({"width": width})
                                        counter += 1
                                else:
                                    transl = str(munit['translation'])
                                    rotQ = str(munit['rotationQuaternion'])
                                    width = str(munit['measurementParams']['axinfo'][channelNames[0]]['viewport']['width'])
                                    height = str(munit['measurementParams']['axinfo'][channelNames[0]]['viewport']['height'])
                                    dimx = str(munit['measurementParams']['axinfo'][channelNames[0]]['viewport']['pixelNumberX'])
                                    dimy = str(munit['measurementParams']['axinfo'][channelNames[0]]['viewport']['pixelNumberY'])

        #creating the new measurement units for each layer and storing the handle
        handleArray = []                   
        tp='<Task Type="TaskAOFullFrame" Version="1.0">'
        for i in range(dimz):
            if len(layerData) > 0:
                transl = str(layerData[i]["transl"])
                rotQ = str(layerData[i]["rotQ"])
                width = str(layerData[i]["width"])
                height = str(layerData[i]["height"])
                dimx = str(layerData[i]["dimx"])
                dimy =str(layerData[i]["dimy"])
            viewport='{"transformation": {"translation": ' + transl + ',"rotationQuaternion": ' + rotQ + '},"size": [' + width + ',' + height + ']}'
            res = APIFunctions.createTimeSeriesMUnit(ws, dimx, dimy, tp, viewport, z0InMs = i * (tscale / dimz), zStepInMs = tscale)
            time.sleep(2)
            handle = res['addedMUnitIdx']
            for name in channelNames:
                res = APIFunctions.addChannel(ws, handle, name)
            handleArray.append(handle)

        #copy the proper frames into the new measurement units
        for frame in range(dimt):
            baseNum = frame * dimz
            for layerNum in range(dimz):
                if len(layerData) > 0:
                    dimx = str(layerData[layerNum]["dimx"])
                    dimy =str(layerData[layerNum]["dimy"])
                frameNum = baseNum + layerNum
                for channelNum in range(len(channelNames)):
                    res = APIFunctions.readChannelData(ws, 'tmpvar', self.sourceMeas + ',' +str(channelNum), '0,0,' + str(frameNum), dimx + ',' + dimy + ',1')
                    res = APIFunctions.writeChannelData(ws, 'tmpvar',  handleArray[layerNum] + ',' + str(channelNum), '0,0,' + str(frame), dimx + ',' + dimy + ',1')
                    if frame < dimt - 1:
                        res = APIFunctions.extendMUnit(ws, handleArray[layerNum], 1)
        #save the new measurement file and rename if necessary
        file2 = self.targetPath
        tmp = 2
        while pathlib.Path(file2).exists():
            file2 = pathlib.Path(pathlib.Path(self.targetPath).parent, str(pathlib.Path(self.targetPath).stem) + str(tmp) + '.mesc')
            tmp += 1
        file2 = str(file2).replace("\\", "/")
        res = APIFunctions.closeFileAndSaveAsAsync(ws, file2, newfilehandle)
        time.sleep(5)
        ws = APIFunctions.closeConnection(ws)


if __name__ == "__main__":
    app = layerSeparator()
    app.getArguments()
    app.run()
    
