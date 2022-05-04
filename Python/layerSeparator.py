import sys, time, re, os, argparse, numpy, pathlib, json
import APIFunctions
import miscFunctions
from PySide2.QtCore import *
from PySide2.QtWebSockets import *
import xml.etree.ElementTree as ET

from femtoapi import PyFemtoAPI


class layerSeparator:
    """
    FemtoAPI application to create separate measurement units from the different layers in multilayer and volumescan measurements.
    """

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
        APIFunctions.login(ws, 'asd', '123')
        time.sleep(5)
        print("API login successfull.")
        res = APIFunctions.createNewFile(ws)
        
        pstate = APIFunctions.getChildTree(ws)
        currHandle = APIFunctions.getCurrentSession(ws)
        pos = currHandle.find(",")
        newfilehandle = currHandle[:pos]
        
        channelName = ''
        for e in pstate['openedMEScFiles']:
            if e['handle'] == [int(file_handler)]:
                for session in e['measurementSessions']:
                    if session['handle'] == [int(file_handler),int(session_handler)]:
                        for munit in session['measurements']:
                            if munit['handle'] == [int(file_handler),int(session_handler), int(unit_handler)]:
                                if not munit['methodType'] in ('volumeScan', 'multiLayer'):
                                    print("Bad type of measurement detected: " + munit['methodType'] + " . layerSeparator only work on volumeScan or multiLayer measurements.")
                                channelNames = []
                                for channel in munit['channels']:
                                    channelNames.append(channel['name'])
                                dimx = munit['logicalDimSizes'][0]
                                dimy = munit['logicalDimSizes'][1]
                                dimz = munit['logicalDimSizes'][2]
                                dimt = munit['logicalDimSizes'][3]
                                tscale = munit['tStepInMs']

                                layerData = []
                                
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
            viewport='{"referenceViewportFormatVersion": 1, "viewports":[{"geomTransTransl": ' + transl + ',"geomTransRot": ' + rotQ + ',"width": ' + width + ',"height": ' + height + '}]}'
            res = APIFunctions.createTimeSeriesMUnit(ws, dimx, dimy, tp, viewport, z0InMs = i * tscale , zStepInMs = tscale * dimz)
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
    
