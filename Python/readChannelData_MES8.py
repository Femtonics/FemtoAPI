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
How to read channel data from MES8 AO measurements into numpy array
API 2.0
"""

import sys, os, time, numpy
import APIFunctions
from PySide2.QtCore import *
from PySide2.QtWebSockets import *
from pathlib import Path
from femtoapi import PyFemtoAPI


munitHandle = '61,0,4'
channel = 0
framenum = 0
isRaw = True # if true the extracted data will be in raw form, if false the data will already include the offset value


#app = QApplication(sys.argv)
app = QCoreApplication(sys.argv)
ws = APIFunctions.initConnection()
APIFunctions.login(ws, 'asd', '123')
time.sleep(2)
print("API login successfull.")


res = APIFunctions.getChildTree(ws, munitHandle)
if not res:
    print('Cannot read metadata. Bad unithandle given or something else went wrong ...')
    sys.exit(0)
mType = res['methodType']
offset = res['channels'][channel]['conversion']['offset']
#print(offset)
if mType in ('multiROIPointScan', 'multiROIMultiLine', 'multiROILineScan'):
    dimX = res['logicalDimSizes'][0]
    dimY = res['logicalDimSizes'][1]
    fromDims = '0,0'
    toDims =str(dimX) + ',' + str(dimY)
elif mType in ('timeSeries', 'zStack', 'multiROIChessBoard', 'multiROILongitudinalRibbonScan', 'multiROITransverseRibbonScan'):
    dimX = res['logicalDimSizes'][0]
    dimY = res['logicalDimSizes'][1]
    dimZ = res['logicalDimSizes'][2]
    fromDims = '0,0,0'
    toDims = str(dimX) + ',' + str(dimY) + ',' + str(dimZ)
elif mType in ('volumeScan', 'multiLayer', 'multiROIMultiCube', 'multiROISnake'):
    dimX = res['logicalDimSizes'][0]
    dimY = res['logicalDimSizes'][1]
    dimZ = res['logicalDimSizes'][2]
    dimT = res['logicalDimSizes'][3]
    fromDims = '0,0,0,0'
    toDims = str(dimX) + ',' + str(dimY) + ',' + str(dimZ) + ',' + str(dimT)
else:
    print('Bad measurement type! Invalid file or newer/unexpected type.')
    sys.exit(0)

print(mType)

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

if mType in ('multiROIPointScan', 'multiROIMultiLine', 'multiROILineScan'):
    shapedData = numpy.reshape(data, (dimX, dimY), order='F')
if mType in ('timeSeries', 'zStack', 'multiROIChessBoard', 'multiROILongitudinalRibbonScan', 'multiROITransverseRibbonScan'):
    shapedData = numpy.reshape(data, (dimX, dimY, dimZ), order='F')
    #rotatedData = numpy.rot90(shapedData, 1, axes=(0,1))  # the 0,0 coordinate in MEScGUI is the bottom-left corner, rotation might be needed for properly display the data when starter coordinate is top-left
if mType in ('volumeScan', 'multilayer', 'multiROIMultiCube', 'multiROISnake'):
    shapedData = numpy.reshape(data, (dimX, dimY, dimZ, dimT), order='F')
    #rotatedData = numpy.rot90(shapedData, 1, axes=(0,1))  # the 0,0 coordinate in MEScGUI is the bottom-left corner, rotation might be needed for properly display the data when starter coordinate is top-left
    
APIFunctions.closeConnection(ws)

