'''
Simple example script for reading channel data from a mesc timeseries measurement unit, converting it to numpy array and exporint it into a TIFF file.
The functionality is based on the femtoAPI modul which requires a valid license to run under MESc.
Python version >=3.8 is recommended. femtoAPI version 1.0 (MESc 4.0.2) required.
The code is based on the python wrapper APIFunctions.py which can be found in the public github repository : 'https://github.com/Femtonics/FemtoAPI/tree/1.0.0'
The full documentation of the API functions can be found at 'https://femtonics.atlassian.net/wiki/spaces/SUP/pages/2225144846/The+FemtoAPI+command+reference'
'''


import sys, re, time, numpy

from PySide2.QtCore import *
from PySide2.QtWebSockets import *
from femtoapi import PyFemtoAPI
import APIFunctions

from pathlib import Path
from PIL import Image
import tifffile


"""
Parameters
Change them accordingly.
The identifying numbers of an opened mesc file for example '57,0,0' are respectively 'file_handle,session_handle,unit_handle'.
The numbering of the channles starts at 0. For example if the measurement has UG,UR channels the channel_handle is 0 for UG and 1 for UR.
"""
file_handle = 58
session_handle = 0
unit_handle = 0
channel_handle = 0
startFrame = 0 #starting frame number
framesNum = 0 # number of frames to read, keep 0 to read all in this script , cannot be higher than the number of frames in the measurement minus the starting frame number(reshaping the data will fail)



app = QCoreApplication(sys.argv) #necessary for the connection to work
ws = APIFunctions.initConnection()
if ws == None:
    sys.exit()
print("Connected to API websocket host.")

res = APIFunctions.login(ws, 'asd', '123') #the login functions does not actually checks the given data as of version 1.0 but it is still a necessary step to start up an API conncetion
if not res:
    sys.exit()


dimx = 0
dimy = 0
dimt = 0
offset = 0

"""
the following block will read metadata from the mesc file
"""
pstate = APIFunctions.getProcessingState(ws)
for e in pstate['openedMEScFiles']:
    if e['handle'] == [int(file_handle)]:
        for session in e['measurementSessions']:
            if session['handle'] == [int(file_handle),int(session_handle)]:
                for munit in session['measurements']:
                    if munit['handle'] == [int(file_handle),int(session_handle), int(unit_handle)]:
                        dimx = munit['dimensions'][0]['size']
                        dimy = munit['dimensions'][1]['size']
                        dimt = munit['dimensions'][2]['size']
                    offset = munit['channels'][channel_handle]['conversion']['offset']
                    offset *= munit['channels'][channel_handle]['conversion']['scale']

handle = str(file_handle) + ','+ str(session_handle) + ','+ str(unit_handle) + ',' + str(channel_handle)

if startFrame >= dimt:
    print("Requested starting frame number is outside the measurement's t dimension. Aborting script...")
    sys.exit()

if framesNum > 0:
    if framesNum + startFrame > dimt:
        print("The requested frame number(" + str(framesNum) + ") is higher than the frames available in the measurement (" + str(dimt) + "). ")
        framesNum = dimt - startFrame
        print("framesNum is set to " + str(framesNum))
    dimt = framesNum
else:
    dimt -= startFrame
"""
Important to note that the readChannelDataToClientsBlob function will accept a larger slab than the actuall size of the data in the mesc measurement unit, in this case it will read the maximum dimensions.
For example if in this code the framesNum is bigger than the actual t dimension on the munit the function will return with the available frames.
This will cause an issue in this script at the data reshape step. In this version of the wrapper function only the byte array is returned by the function.
"""
rawdata = APIFunctions.readChannelDataToClientsBlob(ws, handle, '0,0,' + str(startFrame), str(dimx) + ',' + str(dimy) + ',' + str(dimt))
"""
readRawChannelDataToClientsBlob function can also be used, result values will be uint16 type instead of double but offset needs to be manually added (if necessary)
"""


stream = QDataStream(rawdata)
stream.setByteOrder(QDataStream.ByteOrder.LittleEndian)
tmplist = []
while not stream.atEnd():
    pixelvalue = stream.readDouble()
    
    """
    with readRawChannelDataToClientsBlob use the following lines instead
    """
    #pixelvalue = stream.readUInt16()
    #pixelvalue += offset # if needed

    tmplist.append(numpy.uint16(pixelvalue))
    
data = numpy.array(tmplist)
shapedData = numpy.reshape(data, (dimx, dimy, dimt), order='F')
shapedData = numpy.rot90(shapedData, 1, axes=(0,1))  # the 0,0 coordinate in MEScGUI is the bottom-left corner, rotation might be needed for properly display the data when starter coordinate is top-left


frame_arr = []
for i in range(dimt):
    frame_arr.append(shapedData[:dimx-1, :dimy-1, i])


with tifffile.TiffWriter('newtif.tif') as tiff:
    for img in frame_arr:
        tiff.write(img)
