import sys, time, logging, os
import APIFunctions
import miscFunctions
import logFormatter
from PySide2.QtCore import *
from PySide2.QtWebSockets import *
from pathlib import Path
from mescapi import PyMEScAPI
import argparse


fname = "C:\\Jenkins\\workspace\\test_logs\\TileScan.log"
logging.basicConfig(filename = Path(fname), level=logging.DEBUG)
logger = logging.getLogger()
formatter = logFormatter.MyFormatter(fmt='<%(asctime)s> [%(levelname)s] <%(module)s> %(message)s',datefmt='%Y-%m-%d,%H:%M:%S.%f')
console = logger.handlers[0]
console.setFormatter(formatter)



vpX = 400
vpY = 400
resX = 512
overlap = 50
xDim = 3
yDim = 3


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



app = QCoreApplication(sys.argv)

#time.sleep(30)

ws = APIFunctions.initConnection()
logging.info("Connected to API websocket host.")

APIFunctions.login(ws, 'csp', 'asdf')
time.sleep(5)
logging.info("API login successfull.")


res = APIFunctions.getImagingWindowParameters(ws)
#logging.info(res)


string = '[{"space": "space1", "measurementType": "resonant", "size": [' + str(vpX) + ', ' + str(vpY) + '], \
            "resolution": [' + str(resX) + ', ' + str(resY) + '], "transformation": {"translation": [-' + str(vpX/2) + ', -' + str(vpY/2) + ', 0]}}]'
#logging.info(string)

command="MEScMicroscope.setImagingWindowParameters('"+string+"')"
simpleCmdParser=ws.sendJSCommand(command)
resultCode=simpleCmdParser.getResultCode()
if resultCode > 0:
    logging.info("Return code: " + str(resultCode))
    logging.info(simpleCmdParser.getErrorText())
else:
    cmdResult = simpleCmdParser.getJSEngineResult()
    logging.info("Set Image Window parameters success:" + str(cmdResult))


res = APIFunctions.getProcessingState(ws)
#logging.info(res)
currFileHandle = res['currentFileHandle']
currHandle = res['currentMeasurementSessionHandle']

cols = 0

while True:

    #res = APIFunctions.getAxisPosition(ws, "SlowX")
    #logging.info("x " + str(res))
    #res = APIFunctions.getAxisPosition(ws, "SlowY")
    #logging.info("y " + str(res))

        
    for rows in range(0, xDim):
        res = APIFunctions.getAxisPosition(ws, "SlowX")
        #logging.info("x " + str(res['relative']))
        res = APIFunctions.getAxisPosition(ws, "SlowY")
        #logging.info("y " + str(res['relative']))
        res = APIFunctions.startResonantScanSnapAsync(ws)
        time.sleep(2)
        while miscFunctions.isMeasurementRunning(ws):
            time.sleep(0.5)

        res = APIFunctions.addLastFrameToMSession(ws)
        #logging.info(res)

        if xMove < 0:
            rownum = xDim - 1 - rows
        else:
            rownum = rows
        #logging.info(rownum,cols)
        matrixPos = str(rownum) + "x" + str(cols)
        measUnit = (cols * xDim) + rows
        string = '{"openedMEScFiles": [{"handle": '+ str(currFileHandle) +', "measurementSessions": [{"handle": '+ str(currHandle) + \
                ', "measurements": [{"comment": "'+ matrixPos +'", "handle": ['+ str(currHandle[0]) +', '+ str(currHandle[1]) +', '+ str(measUnit) +']}]}]}]}'
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


APIFunctions.closeConnection(ws)
