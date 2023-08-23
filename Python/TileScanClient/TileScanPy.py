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

# This Python file uses the following encoding: utf-8
from PySide2 import QtCore
from PySide2 import QtWidgets
import APIFunctions
import miscFunctions
import time
import logging
import json


class TileScanPy:

    def __init__(self):
        self.wsConnection = APIFunctions.initConnection('ws://localhost:8888')  # 192.168.43.4
        self.axisX = "SlowX"
        self.axisY = "SlowY"
        self.abortRun = False
        self.connect()

    def connect(self, userName="TileScanPy", password="12345"):
        APIFunctions.login(self.wsConnection, userName, password)
        time.sleep(5)

    def disConnect(self):
        APIFunctions.closeConnection(self.wsConnection)

    def abortTileScan(self, scannerType):
        if scannerType == "resonant":
            APIFunctions.stopResonantScanAsync(self.wsConnection)
        else:
            APIFunctions.stopGalvoScanAsync(self.wsConnection)

    def getCurrentX(self):
        json_in = APIFunctions.getAxisPosition(self.wsConnection, self.axisX)
        json_out = json_in['absolute']
        return json_out

    def getCurrentY(self):
        json_in = APIFunctions.getAxisPosition(self.wsConnection, self.axisY)
        json_out = json_in['absolute']
        return json_out

    def calculatetScanArea(self, coords, viewPortX, viewPortY, overlap):
        """
        coords: dictionary which contains x and y lists
        return a dictionary with the starting x,y coordinates and the dimensions of the tiles as x, y, dimX, dimY
        """
        coords['x'].sort()
        coords['y'].sort()
        startX = coords['x'][0]
        startY = coords['y'][0]
        end = len(coords['x'])
        endX = coords['x'][end - 1]
        endY = coords['y'][end - 1]
        distX = endX - startX
        distY = endY - startY

        tmpdist = viewPortX
        x = 1
        while tmpdist < distX:
            tmpdist += viewPortX - overlap
            x += 1

        tmpdist = viewPortY
        y = 1
        while tmpdist < distY:
            tmpdist += viewPortY - overlap
            y += 1

        return {'x': startX, 'y': startY, 'dimX': x, 'dimY':y}

    def abortMeasurement(self, scannerType):
        if scannerType == "resonant":
            res = APIFunctions.stopResonantScanAsync(self.wsConnection)
        else:
            res = APIFunctions.stopGalvoScanAsync(self.wsConnection)

    def setParameters(self, scannerType, viewPortX, viewPortY,
                      resolutionX, resolutionY, dimensionX, dimensionY,
                      overlap, firstX, firstY, outputDir, directionX, directionY):
        #string = '[{"space": "space1", "measurementType": "' + scannerType + '", "size": [' + str(viewPortX) + ', ' + str(viewPortY) + '], \
        #        "resolution": [' + str(resolutionX) + ', ' + str(resolutionY) + '], "transformation": {"translation": [-' + str(viewPortX/2) + ', -' + str(viewPortY/2) + ', 0]}}]'
        string = '[{"space": "space1", "measurementType": "resonant", "resolution": [' + str(resolutionX) + ', ' + str(resolutionY) + '], \
"userViewport": {"geomTransRot": [0,0,0,1],"geomTransTransl": [-' + str(viewPortX/2) + ',-' + str(viewPortY/2) + ',0],"height": ' + str(viewPortY) + ',"width": ' + str(viewPortX) + '}}]'
        command = "FemtoAPIMicroscope.setImagingWindowParameters('" + string + "')"
        simpleCmdParser = self.wsConnection.sendJSCommand(command)
        resultCode = simpleCmdParser.getResultCode()
        if resultCode > 0:
            logging.info("Return code: " + str(resultCode))
            logging.info(simpleCmdParser.getErrorText())
        else:
            cmdResult = simpleCmdParser.getJSEngineResult()
            logging.info("Set Image Window parameters success:" + str(cmdResult))

        APIFunctions.createNewFile(self.wsConnection)
        res = APIFunctions.getCurrentSession(self.wsConnection)
        pos = res.find(",")
        currFileHandle = res[:pos]
        currHandle = []
        currHandle.append(currFileHandle)
        currHandle.append(res[pos+1:])
        print(currHandle)
        cols = 0
        xMove = (viewPortX - overlap) * directionX
        yMove = (viewPortY - overlap) * directionY
        APIFunctions.setAxisPosition(self.wsConnection, self.axisX, firstX, 'false', 'true')
        APIFunctions.setAxisPosition(self.wsConnection, self.axisY, firstY, 'false', 'true')
        time.sleep(2)
        while APIFunctions.isAxisMoving(self.wsConnection, self.axisX):
            time.sleep(1)
        while APIFunctions.isAxisMoving(self.wsConnection, self.axisY):
            time.sleep(1)

        while not self.abortRun:

            # res = APIFunctions.getAxisPosition(w, "SlowX")
            # logging.info("x " + str(res))
            # res = APIFunctions.getAxisPosition(self.wsConnection, "SlowY")
            # logging.info("y " + str(res))

            for rows in range(0, dimensionX):
                xPos = APIFunctions.getAxisPosition(self.wsConnection, self.axisX)
                yPos = APIFunctions.getAxisPosition(self.wsConnection, self.axisY)
                if scannerType == "resonant":
                    res = APIFunctions.startResonantScanSnapAsync(self.wsConnection)
                else:
                    res = APIFunctions.startGalvoScanSnapAsync(self.wsConnection)
                time.sleep(2)
                while miscFunctions.isMeasurementRunning(self.wsConnection):
                    time.sleep(0.5)

                res = APIFunctions.addLastFrameToMSession(self.wsConnection)
                logging.info(res)

                if xMove < 0:
                    rownum = dimensionX - 1 - rows
                else:
                    rownum = rows
                logging.info(str(rownum) + ", " + str(cols))
                matrixPos = str(rownum) + "x" + str(cols)
                measUnit = (cols * dimensionX) + rows
                xPosAbs = xPos['absolute']
                yPosAbs = yPos['absolute']
                
                string = '{"comment": "' + matrixPos + ' X:' + str(xPosAbs) + ' Y:' + str(yPosAbs) + '"}'
                logging.info(string)
                APIFunctions.setUnitMetadata(self.wsConnection, str(currHandle[0]) + ', '+ str(currHandle[1]) + ', ' + str(measUnit) ,\
                                             'BaseUnitMetadata', string);
                if rows >= dimensionX - 1:
                    break
                res = APIFunctions.setAxisPosition(self.wsConnection, self.axisX, xMove, 'true', 'true')
                time.sleep(2)
                while APIFunctions.isAxisMoving(self.wsConnection, self.axisX):
                    time.sleep(1)

            cols += 1
            if cols >= dimensionY:
                time.sleep(2)
                break
            res = APIFunctions.setAxisPosition(self.wsConnection, self.axisY, yMove, 'true', 'true')
            time.sleep(2)
            while APIFunctions.isAxisMoving(self.wsConnection, self.axisY):
                time.sleep(1)
            xMove *= -1
        ts = time.localtime()
        timestamp = time.strftime("%Y%m%d%H%M%S", ts)
        logging.info("saveFileAsync" + outputDir + " " + timestamp)
        APIFunctions.saveFileAsAsync(self.wsConnection, outputDir + "/" + timestamp + ".mesc")
