# This Python file uses the following encoding: utf-8
from PySide2 import QtCore
from PySide2 import QtWidgets
import APIFunctions
import miscFunctions
import time
import logging


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
                      overlap, firstX, firstY, outputDir):
        string = '[{"space": "space1", "measurementType": "' + scannerType + '", "size": [' + str(viewPortX) + ', ' + str(viewPortY) + '], \
                "resolution": [' + str(resolutionX) + ', ' + str(resolutionY) + '], "transformation": {"translation": [-' + str(viewPortX/2) + ', -' + str(viewPortY/2) + ', 0]}}]'
        command = "MEScMicroscope.setImagingWindowParameters('" + string + "')"
        simpleCmdParser = self.wsConnection.sendJSCommand(command)
        resultCode = simpleCmdParser.getResultCode()
        if resultCode > 0:
            logging.info("Return code: " + str(resultCode))
            logging.info(simpleCmdParser.getErrorText())
        else:
            cmdResult = simpleCmdParser.getJSEngineResult()
            logging.info("Set Image Window parameters success:" + str(cmdResult))

        APIFunctions.createNewFile(self.wsConnection)
        res = APIFunctions.getProcessingState(self.wsConnection)
        currFileHandle = res['currentFileHandle']
        currHandle = res['currentMeasurementSessionHandle']
        cols = 0
        xMove = viewPortX - overlap
        yMove = viewPortY - overlap
        APIFunctions.setAxisPosition(self.wsConnection, self.axisX, firstX, 'false', 'true')
        APIFunctions.setAxisPosition(self.wsConnection, self.axisY, firstY, 'false', 'true')

        while not self.abortRun:

            # res = APIFunctions.getAxisPosition(w, "SlowX")
            # logging.info("x " + str(res))
            # res = APIFunctions.getAxisPosition(self.wsConnection, "SlowY")
            # logging.info("y " + str(res))

            for rows in range(0, dimensionX):
                res = APIFunctions.getAxisPosition(self.wsConnection, self.axisX)
                res = APIFunctions.getAxisPosition(self.wsConnection, self.axisY)
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
                string = '{"openedMEScFiles": [{"handle": '+ str(currFileHandle) + \
                        ', "measurementSessions": [{"handle": '+ str(currHandle) + \
                        ', "measurements": [{"comment": "' + matrixPos + \
                        '","handle": ['+ str(currHandle[0]) + ', '+ str(currHandle[1]) + \
                        ', ' + str(measUnit) + ']}]}]}]}'
                logging.info(string)
                res = APIFunctions.setProcessingState(self.wsConnection, string)

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