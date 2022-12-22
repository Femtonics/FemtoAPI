import sys, os, time, numpy
import APIFunctions
import miscFunctions
from PySide2.QtCore import *
from PySide2.QtWebSockets import *
from pathlib import Path
from femtoapi import PyFemtoAPI

"""
How to read channel data from measurements stored in mesc files
Compatible with API 1.0
"""


fileHandle = 58
sessionHandle = 0 
unitHandle = 4
munitHandle = '58,0,4'

channel = 0
framenum = 0
isRaw = True # if true the extracted data will be in raw form, if false the data will already include the offset value


app = QCoreApplication(sys.argv)
ws = APIFunctions.initConnection()
APIFunctions.login(ws, 'asd', '123')
time.sleep(2)
print("API login successfull.")


res = APIFunctions.getProcessingState(ws)
for file in res['openedMEScFiles']:
    if file['handle'][0] == fileHandle:
        for session in file['measurementSessions']:
            if session['handle'][1] == sessionHandle:
                for unit in session['measurements']:
                    if unit['handle'][2] == unitHandle:
                        dimensions = []
                        for dim in unit['dimensions']:
                            dimensions.append(dim['size'])
                        offset = unit['channels'][channel]['conversion']['offset']

if len(dimensions) == 3:
    dimX = dimensions[0]
    dimY = dimensions[1]
    dimZ = dimensions[2]
    fromDims = '0,0,0'
    toDims = str(dimX) + ',' + str(dimY) + ',' + str(dimZ)

elif len(dimensions) == 4:
    dimX = dimensions[0]
    dimY = dimensions[1]
    dimZ = dimensions[2]
    dimT = dimensions[3]
    fromDims = '0,0,0,0'
    toDims = str(dimX) + ',' + str(dimY) + ',' + str(dimZ) + ',' + str(dimT)
else:
    print('Bad measurement type! Invalid file or newer/unexpected type.')
    sys.exit(0)

if isRaw:
    rawdata = APIFunctions.readRawChannelDataToClientsBlob(ws, munitHandle + ',' + str(channel), fromDims, toDims)
else:
    rawdata = APIFunctions.readChannelDataToClientsBlob(ws, munitHandle + ',' + str(channel), fromDims, toDims)


stream = QDataStream(rawdata)
stream.setByteOrder(QDataStream.ByteOrder.LittleEndian)
tmplist = []
while not stream.atEnd():
    if isRaw:
        pixelvalue = stream.readUInt16()
        pixelvalue += offset
    else:
        pixelvalue = stream.readDouble()
    tmplist.append(numpy.uint16(pixelvalue))
data = numpy.array(tmplist)

if len(dimensions) == 3:
    shapedData = numpy.reshape(data, (dimX, dimY, dimZ), order='F')
    #rotatedData = numpy.rot90(shapedData, 1, axes=(0,1))  # the 0,0 coordinate in MEScGUI is the bottom-left corner, rotation might be needed for properly display the data when starter coordinate is top-left
if len(dimensions) == 4:
    shapedData = numpy.reshape(data, (dimX, dimY, dimZ, dimT), order='F')
    #rotatedData = numpy.rot90(shapedData, 1, axes=(0,1))  # the 0,0 coordinate in MEScGUI is the bottom-left corner, rotation might be needed for properly display the data when starter coordinate is top-left
    
APIFunctions.closeConnection(ws)

