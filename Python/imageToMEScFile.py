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

import sys, time, numpy
import APIFunctions
import miscFunctions
from PySide2.QtCore import *
from PySide2.QtWebSockets import *
from pathlib import Path
from femtoapi import PyFemtoAPI
from PIL import Image

"""
Example script to show how convert a image file into a mesc measurement file.
In this example the different color channels are imported into separate channels in the measurement unit.
"""

sizeX = 400
sizeY = 400

app = QCoreApplication(sys.argv)
ws = APIFunctions.initConnection()
print("Connected to API websocket host.")
#the login functions does not actually checks the given data as of version 1.0 but it is still a necessary step to start up an API conncetion
APIFunctions.login(ws, 'asd', '123')
time.sleep(5)
print("API login successfull.")

APIFunctions.createNewFile(ws)
state = APIFunctions.getProcessingState(ws)
current = state['currentFileHandle'][0]

viewport='{"transformation": {"translation": [0,0,0],"rotationQuaternion": [0,0,0,1]},"size": [' + str(sizeX) + ',' + str(sizeY) +']}'
tp='<Task Type="TaskFastXYGalvo" Version="1.0"><Devices/><Params/></Task>' 

res = APIFunctions.createTimeSeriesMUnit(ws, sizeX, sizeY, tp, viewport)
res = APIFunctions.addChannel(ws, str(current) + ',0,0' , 'R')
res = APIFunctions.addChannel(ws, str(current) + ',0,0' , 'G')
res = APIFunctions.addChannel(ws, str(current) + ',0,0' , 'B')
res = APIFunctions.extendMUnit(ws, str(current) + ',0,0', 1)


im = Image.open("mouse.png")
im =  im.rotate(270)


arr = numpy.array(im)
#print(arr.shape, arr.size, arr.dtype)
arrR = arr[0:400, 0:400, 0]
arrG = arr[0:400, 0:400, 1]
arrB = arr[0:400, 0:400, 2]

arrR = arrR.astype(numpy.double)
arrG = arrG.astype(numpy.double)
arrB = arrB.astype(numpy.double)


newarr = arr.astype(numpy.double)
#print(newarr.shape, newarr.size, newarr.dtype)

stream = QByteArray(arrR.tobytes(order='F'))
res = APIFunctions.writeChannelDataFromAttachment(ws, stream,  str(current) + ',0,0,0', '0,0,0', '400,400,1')
stream = QByteArray(arrG.tobytes(order='F'))
res = APIFunctions.writeChannelDataFromAttachment(ws, stream,  str(current) + ',0,0,1', '0,0,0', '400,400,1')
stream = QByteArray(arrB.tobytes(order='F'))
res = APIFunctions.writeChannelDataFromAttachment(ws, stream,  str(current) + ',0,0,2', '0,0,0', '400,400,1')



APIFunctions.closeConnection(ws)
