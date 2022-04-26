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

import sys
import APIFunctions
import miscFunctions
from PySide2.QtCore import *
from PySide2.QtWebSockets import *
from femtoapi import PyFemtoAPI

"""
Example for accessing some metadata in the MESc 4.5 measurement file
"""

app = QCoreApplication(sys.argv)
ws = APIFunctions.initConnection()
APIFunctions.login(ws, 'user', 'pass') #no login data check is implemented yet, any string works

#measurement file handle
handle = '68,0,0'
print("")


"""
First example: read metadata with the getChildTree function
    - getChildTree readd the whole opened files structure if no handle is given
    - non unit handles are also accepted, in this case it returns the appropriate parts of the file data structure
"""
res = APIFunctions.getChildTree(ws, handle)
#channel info
for channel in res['channels']:
    for param in channel:
        print(str(param) + " : " + str(channel[param]))
print("")

#device info
if res['deviceJSON']['deviceJSONFormat'] == 'MES': #MES format
    for i in res['deviceJSON']['devices']:
        print(i)
if res['deviceJSON']['deviceJSONFormat'] == 'MESc': #MESc format
    for i in res['deviceJSON']['gear']:
        print(i)
print("")

#dimensions and pixel size
print("xDim: " + str(res['xDim']))
print("yDim: " + str(res['yDim']))
print("xPixelSize: " + str(res['pixelSizeX']))
print("yPixelSize: " + str(res['pixelSizeY']))
print("\n")

#vieport (some measurement types can have multiple viewports so it is actually a list of viewports)
for i in res['referenceViewportJSON']['viewports']:
    print(i)
print("")

#axisControlJSON
print("MeasurementDate: " + res['measurementDate'])
print("")

#Technology and Method type
print("TechnologyType: " + str(res['technologyType']))
print("MethodType: " + str(res['methodType']))
print("")

#ZlevelOrigin
# 0 elements is X, 1 element is Y
print("LabelingOrigin Z: " + str(res['labelingOrigin'][2]))
print("")

#creating MES version
print("versions: " +str(res['versionInfoJSON']))
print("")

#experimenterUsername
print("Experimenter Username: " + str(res['experimenterUsername']))
print("")

#experimenterProfilename
print("Experimenter Profilename: " + str(res['experimenterProfilename']))


"""
Second example: read metaData with getUnitMetadata functions
"""
res = APIFunctions.getUnitMetadata(ws, handle, 'ChannelInfo')
for channel in res:
    for param in channel:
        print(str(param) + " : " + str(channel[param]))
print()

res = APIFunctions.getUnitMetadata(ws, handle, 'Device')
if res['deviceJSONFormat'] == 'MES': #MES format
    for i in res['devices']:
        print(i)
if res['deviceJSONFormat'] == 'MESc': #MESc format
    for i in res['gear']:
        print(i)
print()

res = APIFunctions.getUnitMetadata(ws, handle, 'referenceViewport')
for i in res['viewports']:
    print(i)
print()

res = APIFunctions.getUnitMetadata(ws, handle, 'BaseUnitMetadata')
print("xDim: " + str(res['xDim']))
print("yDim: " + str(res['yDim']))
print("xPixelSize: " + str(res['pixelSizeX']))
print("yPixelSize: " + str(res['pixelSizeY']))
print()
print("MeasurementDate: " + res['measurementDate'])
print()
print("TechnologyType: " + str(res['technologyType']))
print("MethodType: " + str(res['methodType']))
print()
print("LabelingOrigin Z: " + str(res['labelingOrigin'][2]))
print()
print("Experimenter Username: " + str(res['experimenterUsername']))
print()
print("Experimenter Profilename: " + str(res['experimenterProfilename']))
print()


res = APIFunctions.getUnitMetadata(ws, handle, 'versionInfoJSON')
if res:
    print("versionInfo: " + str(res))
else:
    print("versionInfoJSON does not exist in meanurement unit")


APIFunctions.closeConnection(ws)
