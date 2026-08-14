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

"""
FemtoAPI application to create separate measurement units from the different layers in multilayer and volumescan measurements.
"""

import sys, time, re, os, argparse, numpy, json
import APIFunctions
import miscFunctions
from PySide2.QtCore import *
from PySide2.QtWebSockets import *
import xml.etree.ElementTree as ET

from femtoapi import PyFemtoAPI
from pathlib import Path

class layerSeparator:

    def __init__(self):
        self.sourceMeas = ''
        self.sourcePath = ''
        self.targetPath = ''
        
    def getArguments(self):
        parser = argparse.ArgumentParser(description="FemtoAPI application to create separate measurement units from the different layers in multilayer and volumescan measurements."
                                                     "Usable with MESc 4.5 and femtoAPI 2.0 versions.")
        parser.add_argument('source', metavar='SOURCE',
                            help='Handle of the source measurement unit with channel number. e.g.: "10,0,0"')
        parser.add_argument('--target', default = None,
                            help="Path of the output measurement file which is gonna be created by the script. "
                                "If nothing is given a default 'separated_layers.mesc' file will be created in the containing folder of the source file.")
        args = parser.parse_args()
        self.sourceMeas = str(args.source)
        self.targetPath = args.target

        if self.targetPath:
            if not Path(self.targetPath).parent.exists():
                print("Target folder does not exists.\nUsing default output folder: " + folder)
                self.targetPath = folder + '/' + str(Path(self.targetPath).name)
            else:
                self.targetPath = str(Path(self.targetPath).parent.resolve()) + '/' + str(Path(self.targetPath).name)
            self.targetPath = self.targetPath.replace("\\", "/")



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
            sys.exit(0)
            
        app = QCoreApplication(sys.argv)
        ws = APIFunctions.initConnection()
        print("Connected to API websocket host.")
        APIFunctions.login(ws, 'asd', '123')
        time.sleep(5)
        print("API login successfull.")
        res = APIFunctions.createNewFile(ws)
        currHandle = APIFunctions.getCurrentSession(ws)
        pos = currHandle.find(",")
        newfilehandle = currHandle[:pos]

        if not self.targetPath:
            filedata = APIFunctions.getFileMetadata(ws, file_handler)
            tmppath = Path(filedata['path'])
            self.targetPath = Path(tmppath.parent, tmppath.stem + "_" + file_handler + "_" + session_handler + "_" + unit_handler +"_separated_layers" + ".mesc")
        #print(self.targetPath)
        channelName = ''
        munit = APIFunctions.getChildTree(ws, self.sourceMeas)
        
        if not munit['methodType'] in ('volumeScan', 'multiLayer'):
            print("Bad type of measurement detected: " + munit['methodType'] + " . layerSeparator only work on volumeScan or multiLayer measurements.")
            sys.exit(0)
        channelNames = []
        for channel in munit['channels']:
            channelNames.append(channel['name'])
        dimx = munit['logicalDimSizes'][0]
        dimy = munit['logicalDimSizes'][1]
        dimz = munit['logicalDimSizes'][2]
        dimt = munit['logicalDimSizes'][3]
        tscale = munit['tStepInMs']

        layerData = []
        step = 0
        zDiff = 0
        vpList = munit['referenceViewportJSON']['viewports']
        counter = 0
        for vp in vpList:
            layerData.append({})
            layerData[counter].update({})
            rotQ = vp['geomTransRot']
            layerData[counter].update({"rotQ": rotQ})
            transl = vp['geomTransTransl']
            layerData[counter].update({"transl": transl})
            height = vp['height']
            layerData[counter].update({"height": height})
            width = vp['width']
            layerData[counter].update({"width": width})
            counter += 1
        if munit['methodType'] == 'volumeScan':
            minZ = munit['minZ']
            maxZ = munit['maxZ']
            slices = munit['slices']
            direct = 1
            direction = munit['scanningDirection']
            if direction == 'topToBottom':
                direct = -1
            step = ((maxZ - minZ) / (slices -1)) * direct
            zDiff = maxZ - minZ
            tscale = tscale / slices
                                    
                                
             
        handleArray = []                   
        tp='aO'
        for i in range(dimz):
            if len(layerData) > 1:
                transl = str(layerData[i]["transl"])
                rotQ = str(layerData[i]["rotQ"])
                width = str(layerData[i]["width"])
                height = str(layerData[i]["height"])
            else:
                transl = str(layerData[0]["transl"])
                rotQ = str(layerData[0]["rotQ"])
                width = str(layerData[0]["width"])
                height = str(layerData[0]["height"])
                trnslparts = transl.split()
                tempZ = float(trnslparts[2][:-1])
                #print(tempZ)
                newZ = str(tempZ + (step * i) + zDiff)
                #print(newZ, type(newZ))
                newtrnsl = trnslparts[0] + ' ' + trnslparts[1] + ' ' + str(newZ) + ']'
                transl = newtrnsl
            viewport='{"referenceViewportFormatVersion": 1, "viewports":[{"geomTransTransl": ' + transl + ',"geomTransRot": ' + rotQ + ',"width": ' + width + ',"height": ' + height + '}]}'
            res = APIFunctions.createTimeSeriesMUnit(ws, dimx, dimy, tp, viewport, z0InMs = i * tscale , zStepInMs = tscale * slices)
            time.sleep(2)
            handle = res['addedMUnitIdx']
            for name in channelNames:
                res = APIFunctions.addChannel(ws, handle, name)
            handleArray.append(handle)

        
        for layerNum in range(dimz):
            res = APIFunctions.extendMUnit(ws, handleArray[layerNum], dimt-1)
            for frame in range(dimt):
                for channelNum in range(len(channelNames)): #',' + str(layerNum) + ','
                    res = APIFunctions.readChannelData(ws, 'tmpvar', self.sourceMeas + ',' +str(channelNum), '0,0,' + str(layerNum) + ',' + str(frame), str(dimx) + ',' + str(dimy) + ',1,1')
                    res = APIFunctions.writeChannelData(ws, 'tmpvar',  handleArray[layerNum] + ',' + str(channelNum), '0,0,' + str(frame), str(dimx) + ',' + str(dimy) + ',1')

                
        file2 = self.targetPath
        tmp = 2
        while Path(file2).exists():
            file2 = Path(Path(self.targetPath).parent, str(Path(self.targetPath).stem) + str(tmp) + '.mesc')
            tmp += 1
        file2 = str(file2).replace("\\", "/")
        print(file2)
        res = APIFunctions.closeFileAndSaveAsAsync(ws, file2, newfilehandle)
        time.sleep(5)
        ws = APIFunctions.closeConnection(ws)


if __name__ == "__main__":
    app = layerSeparator()
    app.getArguments()
    app.run()
    
