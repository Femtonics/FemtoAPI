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
This script implements the tile scan functionality in MESc through the API.
The result will be a new mesc file session with the pictures taken accordintg to the defined tile pattern and size.
"""

import sys, time, logging
import APIFunctions
import miscFunctions
from PySide2.QtCore import *
from PySide2.QtWebSockets import *
from pathlib import Path
# from mescapi import PyMEScAPI
import argparse

vpX = 400
vpY = 400
resX = 512
overlap = 50
xDim = 3
yDim = 3
scanner = "resonant"

parser = argparse.ArgumentParser(
    description="This script implements the tile scan functionality in MESc through the API."
                "The result will be a new mesc file session with the pictures taken accordintg to the defined tile pattern and size.")

parser.add_argument('viewportX', metavar='VIEWPORTX',
                    help='Viewport size in μm on the X axis.')
parser.add_argument('viewportY', metavar='VIEWPORTY',
                    help='Viewport size μm on the Y axis.')
parser.add_argument('--resolution', default = resX,
                    help='Resolution value on the X axis. Default is 512.  The Y is automaticly calculated according to the viewport.')
parser.add_argument('--overlap', default = overlap,
                    help='Overlap between the tiles in μm. Default value is 50.')
parser.add_argument('--xDimension', default = xDim,
                    help='Defines the number of tiles to create on the X axis. Default value is 3.')
parser.add_argument('--yDimension', default = yDim,
                    help='Defines the number of tiles to create on the Y axis. Default value is 3.')
parser.add_argument('--Scanner', default = scanner,
                    help='Defines the number of tiles to create with the given scanner. Default value is resonant.')


args = parser.parse_args()
vpX = int(args.viewportX)
vpY = int(args.viewportY)
resX = int(args.resolution)
resY = int(resX / (vpX / vpY))
overlap = int(args.overlap)
xDim = int(args.xDimension)
yDim = int(args.yDimension)
xMove = vpX - overlap
yMove = vpY - overlap
scanner = args.scanner

ts = time.localtime()
timestamp = time.strftime("%Y%m%d%H%M%S", ts)
fname = "D:\\work\\svntest\\branches\\APIpythonTest_" + timestamp + ".txt"
logging.basicConfig(filename = Path(fname), level=logging.DEBUG)

app = QCoreApplication(sys.argv)

#time.sleep(30)

ws = APIFunctions.initConnection()
print("Connected to API websocket host.")

APIFunctions.login(ws, 'csp', 'asdf')
time.sleep(5)
print("API login successfull.")


res = APIFunctions.getImagingWindowParameters(ws)
print(res)


#string = '[{"space": "space1", "measurementType": "resonant", "size": [' + str(vpX) + ', ' + str(vpY) + '], \
#        "resolution": [' + str(resX) + ', ' + str(resY) + '], "transformation": {"translation": [-' + str(vpX/2) + ', -' + str(vpY/2) + ', 0]}}]'
string = '[{"space": "space1", "measurementType": "resonant", "resolution": [' + str(resX) + ', ' + str(resY) + '], \
"userViewport": {"geomTransRot": [0,0,0,1],"geomTransTransl": [-' + str(vpX/2) + ',-' + str(vpY/2) + ',0],"height": ' + str(vpY) + ',"width": ' + str(vpX) + '}}]'

#"resolutionXLimits": [ 64, 512], "resolutionYLimits": [16,1024],
print(string)

command="FemtoAPIMicroscope.setImagingWindowParameters('"+string+"')"
simpleCmdParser=ws.sendJSCommand(command)
resultCode=simpleCmdParser.getResultCode()
if resultCode > 0:
    print("Return code: " + str(resultCode))
    print(simpleCmdParser.getErrorText())
else:
    cmdResult = simpleCmdParser.getJSEngineResult()
    print("Set Image Window parameters success:" + str(cmdResult))


res = APIFunctions.getProcessingState(ws)
print(res)
currFileHandle = res['currentFileHandle']
currHandle = res['currentMeasurementSessionHandle']

cols = 0

while True:

    #res = APIFunctions.getAxisPosition(w, "SlowX")
    #print("x " + str(res))
    #res = APIFunctions.getAxisPosition(ws, "SlowY")
    #print("y " + str(res))

        
    for rows in range(0, xDim):
        res = APIFunctions.getAxisPosition(ws, "dummyX")
        print("x " + str(res['relative']))
        res = APIFunctions.getAxisPosition(ws, "dummyY")
        print("y " + str(res['relative']))
        res = APIFunctions.startResonantScanSnapAsync(ws)
        time.sleep(2)
        while miscFunctions.isMeasurementRunning(ws):
            time.sleep(0.5)

        res = APIFunctions.addLastFrameToMSession(ws)
        print(res)

        if xMove < 0:
            rownum = xDim - 1 - rows
        else:
            rownum = rows
        print(rownum,cols)
        matrixPos = str(rownum) + "x" + str(cols)
        measUnit = (cols * xDim) + rows
        string = '{"openedMEScFiles": [{"handle": '+ str(currFileHandle) +', "measurementSessions": [{"handle": '+ str(currHandle) + \
                ', "measurements": [{"comment": "'+ matrixPos +'", "handle": ['+ str(currHandle[0]) +', '+ str(currHandle[1]) +', '+ str(measUnit) +']}]}]}]}'
        #print(string)
        res = APIFunctions.setProcessingState(ws, string)
        
        if rows >= xDim - 1:
            break
        res = APIFunctions.setAxisPosition(ws, "SlowX", xMove, isRelativePosition = 'true', isRelativeToCurrentPosition = 'true')
        time.sleep(2)
        while APIFunctions.isAxisMoving(ws, "SlowX"):
            time.sleep(1)
            
    cols += 1
    if cols >= yDim:
        time.sleep(2)
        break
    res = APIFunctions.setAxisPosition(ws, "SlowY", yMove, isRelativePosition = 'true', isRelativeToCurrentPosition = 'true')
    time.sleep(2)
    while APIFunctions.isAxisMoving(ws, "SlowY"):
        time.sleep(1)
    xMove *= -1


"""    
res = APIFunctions.getAxisPosition(ws, "SlowX")
print("x " + str(res))
res = APIFunctions.getAxisPosition(ws, "SlowY")
print("y " + str(res))
"""

APIFunctions.closeConnection(ws)
