import sys, time, array
from PySide2.QtCore import *
from PySide2.QtWebSockets import *
from mescapi import PyMEScAPI
import json

def initConnection(server='ws://localhost:8888'):
    """
    creates the websocket object used in all communications with the API server
    returns the ws object which is used in all other functions
    """
    ws = PyMEScAPI.APIWebSocketClient(server)
    if ws is False:
        print("WebSocketHost could not be found?")
        sys.exit(1)
    timer = 0
    while timer < 10:
        print("Trying to connect to server...")
        done = ws.connectToServer()
        if done is False:
            time.sleep(1)
        else:
            break
        timer = timer + 1
    print("Connection initialized: " + str(done))
    if done is False:
        sys.exit(1)
    return ws


def login(ws, name, passw):
    """
    login to the API server
    login function was created for possible future use in the APIserver
    no check is implemented, does not need real name and password at the moment
    """
    timer = 0
    while timer < 10:
        print("Trying to login to server...")
        loginParser = ws.login(name, passw)
        resultCode = loginParser.getResultCode()
        if resultCode > 0:
            time.sleep(1)
        else:
            break
        timer = timer + 1
    if resultCode > 0:
        print(loginParser.getErrorText())
        sys.exit(1)
    else:
        print("Successful login to MEScAPI server")


def closeConnection(ws):
    """
    closes the connection in the ws object
    """
    res = ws.close()
    print("Connection closed")

def getProcessingState(ws):
    """
    returns a dictionary containing all data about the processing state
    """
    command = 'MEScFile.getProcessingState()'
    simpleCmdParser = ws.sendJSCommand(command)
    resultCode = simpleCmdParser.getResultCode()
    if resultCode > 0:
        print("Return code: " + str(resultCode))
        print(simpleCmdParser.getErrorText())
        return None
    else:
        cmdResult = json.loads(simpleCmdParser.getJSEngineResult())
        return cmdResult


def setProcessingState(ws, jsonString):
    """
    the input json format restrictions can be found in the function description on the femtonics knowledgebase
    returns a boolean value
    """
    command = "MEScFile.setProcessingState('" + jsonString + "')"
    simpleCmdParser = ws.sendJSCommand(command)
    resultCode = simpleCmdParser.getResultCode()
    if resultCode > 0:
        print("Return code: " + str(resultCode))
        print(simpleCmdParser.getErrorText())
        return None
    else:
        cmdResult = simpleCmdParser.getJSEngineResult()
        return cmdResult


def getMicroscopeState(ws):
    """
    returns a dictionary containing data about the microscope state
    """
    command = 'MEScMicroscope.getMicroscopeState()'
    simpleCmdParser = ws.sendJSCommand(command)
    resultCode = simpleCmdParser.getResultCode()
    if resultCode > 0:
        print("Return code: " + str(resultCode))
        print(simpleCmdParser.getErrorText())
        return None
    else:
        cmdResult = json.loads(simpleCmdParser.getJSEngineResult())
        return cmdResult


def getAcquisitionState(ws):
    """
    returns a dictionary containing all data about the processing state
    """
    command = 'MEScMicroscope.getAcquisitionState()'
    simpleCmdParser = ws.sendJSCommand(command)
    resultCode = simpleCmdParser.getResultCode()
    if resultCode > 0:
        print("Return code: " + str(resultCode))
        print(simpleCmdParser.getErrorText())
        return None
    else:
        cmdResult = json.loads(simpleCmdParser.getJSEngineResult())
        return cmdResult


def startGalvoScanSnapAsync(ws):
    command = 'MEScMicroscope.startGalvoScanSnapAsync()'
    simpleCmdParser = ws.sendJSCommand(command)
    resultCode = simpleCmdParser.getResultCode()
    if resultCode > 0:
        print("Return code: " + str(resultCode))
        print(simpleCmdParser.getErrorText())
        return None
    else:
        cmdResult = simpleCmdParser.getJSEngineResult()
        return cmdResult


def startGalvoScanAsync(ws):
    command = 'MEScMicroscope.startGalvoScanAsync()'
    simpleCmdParser = ws.sendJSCommand(command)
    resultCode = simpleCmdParser.getResultCode()
    if resultCode > 0:
        print("Return code: " + str(resultCode))
        print(simpleCmdParser.getErrorText())
        return None
    else:
        cmdResult = simpleCmdParser.getJSEngineResult()
        return cmdResult


def stopGalvoScanAsync(ws):
    command = 'MEScMicroscope.stopGalvoScanAsync()'
    simpleCmdParser = ws.sendJSCommand(command)
    resultCode = simpleCmdParser.getResultCode()
    if resultCode > 0:
        print("Return code: " + str(resultCode))
        print(simpleCmdParser.getErrorText())
        return None
    else:
        cmdResult = simpleCmdParser.getJSEngineResult()
        return cmdResult


def startResonantScanSnapAsync(ws):
    command = 'MEScMicroscope.startResonantScanSnapAsync()'
    simpleCmdParser = ws.sendJSCommand(command)
    resultCode = simpleCmdParser.getResultCode()
    if resultCode > 0:
        print("Return code: " + str(resultCode))
        print(simpleCmdParser.getErrorText())
        return None
    else:
        cmdResult = simpleCmdParser.getJSEngineResult()
        return cmdResult


def startResonantScanAsync(ws):
    command = 'MEScMicroscope.startResonantScanAsync()'
    simpleCmdParser = ws.sendJSCommand(command)
    resultCode = simpleCmdParser.getResultCode()
    if resultCode > 0:
        print("Return code: " + str(resultCode))
        print(simpleCmdParser.getErrorText())
        return None
    else:
        cmdResult = simpleCmdParser.getJSEngineResult()
        return cmdResult


def stopResonantScanAsync(ws):
    command = 'MEScMicroscope.stopResonantScanAsync()'
    simpleCmdParser = ws.sendJSCommand(command)
    resultCode = simpleCmdParser.getResultCode()
    if resultCode > 0:
        print("Return code: " + str(resultCode))
        print(simpleCmdParser.getErrorText())
        return None
    else:
        cmdResult = simpleCmdParser.getJSEngineResult()
        return cmdResult


def createNewFile(ws):
    command = 'MEScFile.createNewFile()'
    simpleCmdParser = ws.sendJSCommand(command)
    resultCode = simpleCmdParser.getResultCode()
    if resultCode > 0:
        print("Return code: " + str(resultCode))
        print(simpleCmdParser.getErrorText())
        return None
    else:
        cmdResult = json.loads(simpleCmdParser.getJSEngineResult())
        return cmdResult


def setCurrentFile(ws, handle):
    """
    set the current file to 'handle' in the processing view
    """
    command = "MEScFile.setCurrentFile('" + str(handle) + "')"
    simpleCmdParser = ws.sendJSCommand(command)
    resultCode = simpleCmdParser.getResultCode()
    if resultCode > 0:
        print("Return code: " + str(resultCode))
        print(simpleCmdParser.getErrorText())
        return None
    else:
        cmdResult = simpleCmdParser.getJSEngineResult()
        return cmdResult


def saveFileAsync(ws, handle=''):
    if handle:
        command = "MEScFile.saveFileAsync('" + str(handle) + "')"
    simpleCmdParser = ws.sendJSCommand(command)
    resultCode = simpleCmdParser.getResultCode()
    if resultCode > 0:
        print("Return code: " + str(resultCode))
        print(simpleCmdParser.getErrorText())
        return None
    else:
        cmdResult = json.loads(simpleCmdParser.getJSEngineResult())
        return cmdResult


def saveFileAsAsync(ws, filePath, handle='', overwrite='false'):
    """
    save the current file as 'filepath' or the file defined by 'handle' if given
    """
    command = "MEScFile.saveFileAsAsync('" + str(filePath) + "', '" + str(handle) + "', " + str(overwrite) + ")"
    simpleCmdParser = ws.sendJSCommand(command)
    print(command)
    resultCode = simpleCmdParser.getResultCode()
    if resultCode > 0:
        print("Return code: " + str(resultCode))
        print(simpleCmdParser.getErrorText())
        return None
    else:
        cmdResult = json.loads(simpleCmdParser.getJSEngineResult())
        return cmdResult


def closeFileNoSaveAsync(ws, handle =''):
    """
    close the current file without saving or the file defined by 'handle' if given
    """
    command = "MEScFile.closeFileNoSaveAsync('" + str(handle) + "')"
    simpleCmdParser = ws.sendJSCommand(command)
    resultCode = simpleCmdParser.getResultCode()
    if resultCode > 0:
        print("Return code: " + str(resultCode))
        print(simpleCmdParser.getErrorText())
        return None
    else:
        cmdResult = json.loads(simpleCmdParser.getJSEngineResult())
        return cmdResult


def closeFileAndSaveAsync(ws, handle='', compress='false'):
    """
    save and close the current file without saving or the file defined by 'handle' if given
    """
    command = "MEScFile.closeFileAndSaveAsync(" + str(handle) + "', '" + str(handle) + "', " + str(compress) + ")"
    simpleCmdParser = ws.sendJSCommand(command)
    resultCode = simpleCmdParser.getResultCode()
    if resultCode > 0:
        print("Return code: " + str(resultCode))
        print(simpleCmdParser.getErrorText())
        return None
    else:
        cmdResult = json.loads(simpleCmdParser.getJSEngineResult())
        return cmdResult


def closeFileAndSaveAsAsync(ws, filePath, handle='', overwrite='false', compress='false'):
    """
    save the current file as 'filepath' or the file defined by 'handle' if given and close it
    """
    command = "MEScFile.closeFileAndSaveAsAsync('" + str(filePath) + "', '" + str(handle) + "', " + str(overwrite) + ", " + str(compress) + ")"
    simpleCmdParser = ws.sendJSCommand(command)
    resultCode = simpleCmdParser.getResultCode()
    if resultCode > 0:
        print("Return code: " + str(resultCode))
        print(simpleCmdParser.getErrorText())
        return None
    else:
        cmdResult = json.loads(simpleCmdParser.getJSEngineResult())
        return cmdResult


def openFilesAsync(ws, filePath):
    command = "MEScFile.openFilesAsync('" + str(filePath) + "')"
    simpleCmdParser = ws.sendJSCommand(command)
    resultCode = simpleCmdParser.getResultCode()
    if resultCode > 0:
        print("Return code: " + str(resultCode))
        print(simpleCmdParser.getErrorText())
        return None
    else:
        cmdResult = json.loads(simpleCmdParser.getJSEngineResult())
        return cmdResult


def getImagingWindowParameters(ws, mType='', spaceName=''):
    """
    returns a dictionary containing data about the imaging window parameters
    the function will only return data about the measurement type defined in mType or all if undefined
    """
    command = "MEScMicroscope.getImagingWindowParameters(measurementType = '" + str(mType) + "', spaceName  = '" + str(spaceName) + "')"
    simpleCmdParser = ws.sendJSCommand(command)
    resultCode = simpleCmdParser.getResultCode()
    if resultCode > 0:
        print("Return code: " + str(resultCode))
        print(simpleCmdParser.getErrorText())
        return None
    else:
        cmdResult = json.loads(simpleCmdParser.getJSEngineResult())
        return cmdResult


def setImagingWindowParameters(ws, jsonString):
    """
    the input json format restrictions can be found in the function description on the femtonics knowledgebase
    """
    command = "MEScMicroscope.setImagingWindowParameters('"+jsonString+"')"
    simpleCmdParser = ws.sendJSCommand(command)
    resultCode = simpleCmdParser.getResultCode()
    if resultCode > 0:
        print("Return code: " + str(resultCode))
        print(simpleCmdParser.getErrorText())
        return None
    else:
        cmdResult = simpleCmdParser.getJSEngineResult()
        return cmdResult


def getZStackLaserIntensityProfile(ws, mType='', spaceName=''):
    """
    gets the Z-stack depth correction profile
    mType: defines the measurement type (resonant, galvo), all types if undefined
    """
    command = "MEScMicroscope.getZStackLaserIntensityProfile(measurementType = '" + str(mType) + "', spaceName = '" + str(spaceName) + "')"
    simpleCmdParser = ws.sendJSCommand(command)
    resultCode = simpleCmdParser.getResultCode()
    if resultCode > 0:
        print("Return code: " + str(resultCode))
        print(simpleCmdParser.getErrorText())
        return None
    else:
        cmdResult = json.loads(simpleCmdParser.getJSEngineResult())
        return cmdResult


def setZStackLaserIntensityProfile(ws, jsonString):
    """
    the input json format restrictions can be found in the function description on the femtonics knowledgebase
    """
    command = "MEScMicroscope.setZStackLaserIntensityProfile('"+jsonString+"')"
    simpleCmdParser = ws.sendJSCommand(command)
    resultCode = simpleCmdParser.getResultCode()
    if resultCode > 0:
        print("Return code: " + str(resultCode))
        print(simpleCmdParser.getErrorText())
        return None
    else:
        cmdResult = simpleCmdParser.getJSEngineResult()
        return cmdResult


def getAxisPositions(ws):
    """
    get positions for all the axes
    """
    command = "MEScMicroscope.getAxisPositions()"
    simpleCmdParser = ws.sendJSCommand(command)
    resultCode = simpleCmdParser.getResultCode()
    if resultCode > 0:
        print("Return code: " + str(resultCode))
        print(simpleCmdParser.getErrorText())
        return None
    else:
        cmdResult = json.loads(simpleCmdParser.getJSEngineResult())
        return cmdResult

def getAxisPosition(ws, axisName, posType='', space=''):
    """
    get position of one specific axis
    """
    command = "MEScMicroscope.getAxisPosition('" + axisName + "', positionType = '" +posType+ "', spaceName = '" + space + "')"
    simpleCmdParser = ws.sendJSCommand(command)
    resultCode = simpleCmdParser.getResultCode()
    if resultCode > 0:
        print("Return code: " + str(resultCode))
        print(simpleCmdParser.getErrorText())
        return None
    else:
        cmdResult = json.loads(simpleCmdParser.getJSEngineResult())
        return cmdResult


def isAxisMoving(ws, axisName):
    command = "MEScMicroscope.isAxisMoving('" + axisName + "')"
    simpleCmdParser = ws.sendJSCommand(command)
    resultCode = simpleCmdParser.getResultCode()
    if resultCode > 0:
        print("Return code: " + str(resultCode))
        print(simpleCmdParser.getErrorText())
        return None
    else:
        cmdResult = simpleCmdParser.getJSEngineResult()
        return cmdResult


def doZero(ws, axisName, spaceName=''):
    command = "MEScMicroscope.doZero('" + str(axisName) + "', spaceName  = '" + str(spaceName) + "')"
    simpleCmdParser = ws.sendJSCommand(command)
    resultCode = simpleCmdParser.getResultCode()
    if resultCode > 0:
        print("Return code: " + str(resultCode))
        print(simpleCmdParser.getErrorText())
        return None
    else:
        cmdResult = simpleCmdParser.getJSEngineResult()
        return cmdResult


def setAxisPosition(ws, axisName, newPosition, isRelativePosition='true', isRelativeToCurrentPosition='true', spaceName=''):
    """
    required parameters:
        axisName - string, must be configured axis name
        newPosition - double
    optional parameters:
        isRelativePosition - boolean
        isRelativeToCurrentPosition - boolean
        spaceName - string, empty string means default namespace
    """
    command = "MEScMicroscope.setAxisPosition('" + str(axisName) + "', " + str(newPosition) + ", isRelativePosition = " + isRelativePosition + ", isRelativeToCurrentPosition = " + isRelativeToCurrentPosition + ", spaceName = '" + spaceName + "')"
    simpleCmdParser = ws.sendJSCommand(command)
    resultCode = simpleCmdParser.getResultCode()
    if resultCode > 0:
        print("Return code: " + str(resultCode))
        print(simpleCmdParser.getErrorText())
        return None
    else:
        cmdResult = simpleCmdParser.getJSEngineResult()
        return cmdResult


def getPMTAndLaserIntensityDeviceValues(ws):
    """
    returns a dictionary containing PMT/Laser intensity device values
    """
    command = "MEScMicroscope.getPMTAndLaserIntensityDeviceValues()"
    simpleCmdParser = ws.sendJSCommand(command)
    resultCode = simpleCmdParser.getResultCode()
    if resultCode > 0:
        print("Return code: " + str(resultCode))
        print(simpleCmdParser.getErrorText())
        return None
    else:
        cmdResult = json.loads(simpleCmdParser.getJSEngineResult())
        return cmdResult


def setPMTAndLaserIntensityDeviceValues(ws, jsonString):
    """
    the input json format restrictions can be found in the function description on the femtonics knowledgebase
    """
    command = "MEScMicroscope.setPMTAndLaserIntensityDeviceValues('"+jsonString+"')"
    simpleCmdParser = ws.sendJSCommand(command)
    resultCode = simpleCmdParser.getResultCode()
    if resultCode > 0:
        print("Return code: " + str(resultCode))
        print(simpleCmdParser.getErrorText())
        return None
    else:
        cmdResult = simpleCmdParser.getJSEngineResult()
        return cmdResult


def createTimeSeriesMUnit(ws, xDim, yDim, taskXMLParameters, viewportJson, z0InMs=0.0, zStepInMs=1.0, zDimInitial=1):
    """
    available types in taskXMLParameters : TaskResonantCommon, TaskFastXYGalvo, TaskAOFullFrame

    xDim: measurement image x resolution 
    yDim: measurement image y resolution 
    taskXMLParameters: measurementParamsXML for resonant/galvo/AO fullframe scan time series measurement. 
    viewportJson: viewport for measurement 
    z0InMs: Measurement start time offset in ms. Double, default value is 0.0 
    zStepInMs: Frame duration time in ms (1/frame rate). Positive double, default value is 1.0. 
    zDimInitial: Number of frames to create in z dimension. Positive integer, default value is 1. 
    """
    command = "MEScFile.createTimeSeriesMUnit(" + str(xDim) + ", " + str(yDim) + ", '" + taskXMLParameters + "', '" + viewportJson + "', z0InMs = " + str(z0InMs) + ", zStepInMs = " + str(zStepInMs) + ", zDimInitial = " + str(zDimInitial) + ")"
    simpleCmdParser = ws.sendJSCommand(command)
    resultCode = simpleCmdParser.getResultCode()
    if resultCode > 0:
        print("Return code: " + str(resultCode))
        print(simpleCmdParser.getErrorText())
        return None
    else:
        cmdResult = json.loads(simpleCmdParser.getJSEngineResult())
        return cmdResult


# deprecated function
def createAOFullFrameScanSeriesMUnit(ws, xDim, yDim, taskXMLParameters, viewportJson, z0InMs=0.0, zStepInMs=1.0, zDimInitial=1):
    command = "MEScFile.createAOFullFrameScanSeriesMUnit(" + str(xDim) + ", " + str(yDim) + ", '" + taskXMLParameters + "', '" + viewportJson + "', z0InMs = " + str(z0InMs) + ", zStepInMs = " + str(zStepInMs) + ", zDimInitial = " + str(zDimInitial) + ")"
    simpleCmdParser = ws.sendJSCommand(command)
    resultCode = simpleCmdParser.getResultCode()
    if resultCode > 0:
        print("Return code: " + str(resultCode))
        print(simpleCmdParser.getErrorText())
        return None
    else:
        cmdResult = json.loads(simpleCmdParser.getJSEngineResult())
        return cmdResult


def extendMUnit(ws, mUnitHandle, countDims):
    command = "MEScFile.extendMUnit('" + str(mUnitHandle) + "', " + str(countDims) + ")"
    simpleCmdParser = ws.sendJSCommand(command)
    resultCode = simpleCmdParser.getResultCode()
    if resultCode > 0:
        print("Return code: " + str(resultCode))
        print(simpleCmdParser.getErrorText())
        return None
    else:
        cmdResult = json.loads(simpleCmdParser.getJSEngineResult())
        return cmdResult


def deleteMUnit(ws, mUnitHandle):
    command = "MEScFile.deleteMUnit('" + str(mUnitHandle) + "')"
    simpleCmdParser = ws.sendJSCommand(command)
    resultCode = simpleCmdParser.getResultCode()
    if resultCode > 0:
        print("Return code: " + str(resultCode))
        print(simpleCmdParser.getErrorText())
        return None
    else:
        cmdResult = json.loads(simpleCmdParser.getJSEngineResult())
        return cmdResult

# source x,y,z, dest x,y
def copyMUnit(ws, sourceMUnitHandle, destMSessionHandle, bCopyChannelContents='true'):
    """
    sourceMUnitHandle is the measurementunit handle of the source 
    destMSessionHandle is the session handle of the destination
    """
    command = "MEScFile.copyMUnit('" + str(sourceMUnitHandle) + "', '" + str(destMSessionHandle) + "', " + bCopyChannelContents + ")"
    simpleCmdParser = ws.sendJSCommand(command)
    resultCode = simpleCmdParser.getResultCode()
    if resultCode > 0:
        print("Return code: " + str(resultCode))
        print(simpleCmdParser.getErrorText())
        return None
    else:
        cmdResult = json.loads(simpleCmdParser.getJSEngineResult())
        return cmdResult

# source x,y,z, dest x,y
def moveMUnit(ws, sourceMUnitHandle, destMSessionHandle):
    """
    sourceMUnitHandle is the measurementunit handle of the source 
    destMSessionHandle is the sessionhandle of the destination
    """
    command = "MEScFile.moveMUnit('" + str(sourceMUnitHandle) + "', '" + str(destMSessionHandle) + "')"
    simpleCmdParser = ws.sendJSCommand(command)
    resultCode = simpleCmdParser.getResultCode()
    if resultCode > 0:
        print("Return code: " + str(resultCode))
        print(simpleCmdParser.getErrorText())
        return None
    else:
        cmdResult = json.loads(simpleCmdParser.getJSEngineResult())
        return cmdResult


def addChannel(ws, mUnitHandle, channelName):
    command = "MEScFile.addChannel('" + str(mUnitHandle) + "', '" + str(channelName) + "')"
    simpleCmdParser = ws.sendJSCommand(command)
    resultCode = simpleCmdParser.getResultCode()
    if resultCode > 0:
        print("Return code: " + str(resultCode))
        print(simpleCmdParser.getErrorText())
        return None
    else:
        cmdResult = json.loads(simpleCmdParser.getJSEngineResult())
        return cmdResult


def deleteChannel(ws, channelHandle):
    command = "MEScFile.deleteChannel('" + str(channelHandle) + "')"
    simpleCmdParser = ws.sendJSCommand(command)
    resultCode = simpleCmdParser.getResultCode()
    if resultCode > 0:
        print("Return code: " + str(resultCode))
        print(simpleCmdParser.getErrorText())
        return None
    else:
        cmdResult = json.loads(simpleCmdParser.getJSEngineResult())
        return cmdResult


def addLastFrameToMSession(ws, destMSessionHandle = '', space = ''):
    command = "MEScFile.addLastFrameToMSession('" + str(destMSessionHandle) + "', '" + space + "')"
    simpleCmdParser = ws.sendJSCommand(command)
    resultCode = simpleCmdParser.getResultCode()
    if resultCode > 0:
        print("Return code: " + str(resultCode))
        print(simpleCmdParser.getErrorText())
        return None
    else:
        cmdResult = simpleCmdParser.getJSEngineResult()
        return cmdResult


def sendFileToClientsBlob(ws, sPathAndFileName):
    """
    return value is the file size if file found, None if filepath is not valid
    """
    command = "MEScFile.sendFileToClientsBlob('" + str(sPathAndFileName) + "')"
    simpleCmdParser = ws.sendJSCommand(command)
    resultCode = simpleCmdParser.getResultCode()
    if resultCode > 0:
        print("Return code: " + str(resultCode))
        print(simpleCmdParser.getErrorText())
        return None
    else:
        cmdResult = simpleCmdParser.getJSEngineResult()
        return cmdResult


def saveAttachmentToFile(ws, sPathAndFileName):
    """
    If there is data attached to the websocket session it is gonna be saved as the given file.
    ws.uploadAttachment() function can be used for ataching data to the websocket session.
    No data means empty file.
    """
    command = "MEScFile.saveAttachmentToFile('" + str(sPathAndFileName) + "')"
    simpleCmdParser = ws.sendJSCommand(command)
    resultCode = simpleCmdParser.getResultCode()
    if resultCode > 0:
        print("Return code: " + str(resultCode))
        print(simpleCmdParser.getErrorText())
        return None
    else:
        cmdResult = simpleCmdParser.getJSEngineResult()
        #return cmdResult
        return True

    
def modifyConversion(ws, sConversionName, dScale, dOffset, bSave = 'false'):
    """
    sConversionName: string, name of the conversion, as it can be seen in MESc conversion manager. 
    dScale: double, the new scale to set 
    dOffset: double, the new offset to set
    bSave: boolean, if true, the conversion is saved to disk if it has been modified. Otherwise, the specified conversion modified only in memory. Default value is false.
    """
    command = "MEScFile.modifyConversion('" + str(sConversionName) + "', '" + str(dScale) + "', '" + str(dOffset) + "', bSave = " + bSave + ")"
    simpleCmdParser = ws.sendJSCommand(command)
    resultCode = simpleCmdParser.getResultCode()
    if resultCode > 0:
        print("Return code: " + str(resultCode))
        print(simpleCmdParser.getErrorText())
        return None
    else:
        cmdResult = simpleCmdParser.getJSEngineResult()
        return cmdResult


#############################################
#not working?
def saveVarToFile(ws, jsValue, PathAndFileName):
    command = "MEScFile.saveVarToFile(" + str(jsValue) + ", '" + str(PathAndFileName) + "')"
    print(command)
    simpleCmdParser = ws.sendJSCommand(command)
    resultCode = simpleCmdParser.getResultCode()
    if resultCode > 0:
        print("Return code: " + str(resultCode))
        print(simpleCmdParser.getErrorText())
        return None
    else:
        cmdResult = simpleCmdParser.getJSEngineResult()
        return cmdResult
#############################################
    

def getStatus(ws, sCommandID = None):
    """
        If sCommand is defined the function will get the status of the assyncronous file operation represented by the given ID. - not tested
        If sCommand is not given the function will return information about the currently opened files.
    """
    if sCommandID:
        command = "MEScFile.getStatus('" + str(sCommandID) + "')"
    else:
        command = "MEScFile.getStatus()"
    simpleCmdParser = ws.sendJSCommand(command)
    resultCode = simpleCmdParser.getResultCode()
    if resultCode > 0:
        print("Return code: " + str(resultCode))
        print(simpleCmdParser.getErrorText())
        return None
    else:
        cmdResult = json.loads(simpleCmdParser.getJSEngineResult())
        return cmdResult
    

def getCurve(ws, mUnitHandle, curveIdx):
    """
    returns a dictionary with 2 elements
    Result: contains data about the specified curve
    BinaryData: is a dictionary with 2 elements
        - 'xData' is a list with the x data of the curve
        - 'yData' is a list with the y data of the curve
    the elements of these 2 list make up data pairs (xData[0] - yData[0], xData[1] - yData[1], etc.)
    """
    command = "MEScFile.getCurve('" + str(mUnitHandle) + "', '" + str(curveIdx) + "')"
    simpleCmdParser = ws.sendJSCommand(command)
    resultCode = simpleCmdParser.getResultCode()
    if resultCode > 0:
        print("Return code: " + str(resultCode))
        print(simpleCmdParser.getErrorText())
        return None
    else:
        cmdResult = {}
        cmdResult.update({"Result": simpleCmdParser.getJSEngineResult()})
        xData = []
        yData = []
        curveData = {"xData": xData, "yData": yData}

        for parts in simpleCmdParser.getPartList():
            #tmp.append(parts)
            #tmp = tmp[8:]
            size = int(parts.size() / 2)
            binaryDataX = QByteArray()
            binaryDataY = QByteArray()
            binaryDataX.append(parts[:size])
            binaryDataY.append(parts[size:])
            
            stream = QDataStream(binaryDataX)
            stream.setByteOrder(QDataStream.ByteOrder.LittleEndian)
            while not stream.atEnd():
                floatData = stream.readDouble()
                #print(floatData)
                curveData["xData"].append(floatData)
                
            stream = QDataStream(binaryDataY)
            stream.setByteOrder(QDataStream.ByteOrder.LittleEndian)
            while not stream.atEnd():
                floatData = stream.readDouble()
                #print(floatData)
                curveData["yData"].append(floatData)

        print( "Binary part with size: " + str(parts.size()))
        cmdResult.update({"BinaryData": curveData})
        return cmdResult


def setFocusingMode(ws, sfocusingMode, spaceName = ''):
    command = "MEScMicroscope.setFocusingMode('" + str(sfocusingMode) + "', '" + spaceName + "')"
    simpleCmdParser = ws.sendJSCommand(command)
    resultCode = simpleCmdParser.getResultCode()
    if resultCode > 0:
        print("Return code: " + str(resultCode))
        print(simpleCmdParser.getErrorText())
        return None
    else:
        cmdResult = simpleCmdParser.getJSEngineResult()
        return cmdResult


def getActiveProtocol(ws):
    """
    returns a directory containing the following data:
    -currently active user waveforms, channels, and patterns
    -which waveform is currently set to be displayed on which channels
    -display order and timing of the waveforms
    -pattern metadata: path description, path order, cycle time, etc. 
    """
    command = "MEScMicroscope.getActiveProtocol()"
    simpleCmdParser = ws.sendJSCommand(command)
    resultCode = simpleCmdParser.getResultCode()
    if resultCode > 0:
        print("Return code: " + str(resultCode))
        print(simpleCmdParser.getErrorText())
        return None
    else:
        cmdResult = json.loads(simpleCmdParser.getJSEngineResult())
        return cmdResult


def setActiveTaskAndSubTask(ws, taskName, subTaskName='timeSeries'):
    """
    taskName: string, name of the task to set, can be 'resonant' or 'galvo'
    subTaskName: string, optional parameter, name of the sub task to set, value can be 'timeSeries', 'zStack' or 'volumeScan'
    If not given, timeseries measurement will be selected on the MESc GUI by default. 
    """
    command = "MEScMicroscope.setActiveTaskAndSubTask( '" + taskName + "', '" + subTaskName + "')"
    simpleCmdParser = ws.sendJSCommand(command)
    resultCode = simpleCmdParser.getResultCode()
    if resultCode > 0:
        print("Return code: " + str(resultCode))
        print(simpleCmdParser.getErrorText())
        return None
    else:
        cmdResult = simpleCmdParser.getJSEngineResult()
        return cmdResult


def getCommandSetVersion(ws):
    """
    Gets the version of the MESc API command set in string
    """
    command = "MEScMicroscope.getCommandSetVersion()"
    simpleCmdParser = ws.sendJSCommand(command)
    resultCode = simpleCmdParser.getResultCode()
    if resultCode > 0:
        print("Return code: " + str(resultCode))
        print(simpleCmdParser.getErrorText())
        return None
    else:
        cmdResult = simpleCmdParser.getJSEngineResult()
        return cmdResult


def getCommandSetVersionProcessing(ws):
    """
    Gets the version of the MESc API command set in string
    """
    command = "MEScFile.getCommandSetVersion()"
    simpleCmdParser = ws.sendJSCommand(command)
    resultCode = simpleCmdParser.getResultCode()
    if resultCode > 0:
        print("Return code: " + str(resultCode))
        print(simpleCmdParser.getErrorText())
        return None
    else:
        cmdResult = simpleCmdParser.getJSEngineResult()
        return cmdResult


def getLastCommandError(ws):
    command = "MEScMicroscope.getLastCommandError()"
    simpleCmdParser = ws.sendJSCommand(command)
    resultCode = simpleCmdParser.getResultCode()
    if resultCode > 0:
        print("Return code: " + str(resultCode))
        print(simpleCmdParser.getErrorText())
        return None
    else:
        cmdResult = json.loads(simpleCmdParser.getJSEngineResult())
        return cmdResult


def getLastCommandErrorProcessing(ws):
    command = "MEScFile.getLastCommandError()"
    simpleCmdParser = ws.sendJSCommand(command)
    resultCode = simpleCmdParser.getResultCode()
    if resultCode > 0:
        print("Return code: " + str(resultCode))
        print(simpleCmdParser.getErrorText())
        return None
    else:
        cmdResult = json.loads(simpleCmdParser.getJSEngineResult())
        return cmdResult


def setMeasurementDuration(ws, duration, taskName='', spaceName=''):
    command = "MEScMicroscope.setMeasurementDuration(" + str(duration) + ", taskName = '" + taskName + "', spaceName = '" + spaceName + "')"
    simpleCmdParser = ws.sendJSCommand(command)
    resultCode = simpleCmdParser.getResultCode()
    if resultCode > 0:
        print("Return code: " + str(resultCode))
        print(simpleCmdParser.getErrorText())
        return None
    else:
        cmdResult = simpleCmdParser.getJSEngineResult()
        return cmdResult

def readRawChannelDataToClientsBlob(ws, handle, fromDims, countDims, filePath=None):
    """
    handle
    fromDims
    countDims
    filePath: optional parameter, default None
    if filePath defined: - binary data will be writen in the given file, return value is True if successfull or False is failed
    if filePath not defined: - binary data will be written in QByteArray and returned as a variable
    """
    command = "MEScFile.readRawChannelDataToClientsBlob('" + str(handle) + "', '" + str(fromDims) + "', '" + str(countDims) + "')"
    simpleCmdParser = ws.sendJSCommand(command)
    resultCode = simpleCmdParser.getResultCode()
    if resultCode > 0:
        print("Return code: " + str(resultCode))
        print(simpleCmdParser.getErrorText())
        return None
    else:
        print("readRawChannelDataToClientsBlob result: " + simpleCmdParser.getJSEngineResult())
        if filePath:
            cmdResult = QByteArray()
            for parts in simpleCmdParser.getPartList():
                cmdResult.append(parts)
            print("Res type: " + str(type(cmdResult)) + ", Res size: " + str(cmdResult.size()))
            tmp = cmdResult.data()
            with open(filePath, "wb") as f:
                f.write(tmp)
            return True
        else:
            cmdResult = QByteArray()
            for parts in simpleCmdParser.getPartList():
                cmdResult.append(parts)
                print("Binary part sizes: " + str(parts.size()))
            return cmdResult


def readChannelDataToClientsBlob(ws, handle, fromDims, countDims, filePath=None):
    """
    handle
    fromDims
    countDims
    filePath: optional parameter, default None
    if filePath defined: - binary data will be written in the given file, return value is True if successfull or False is failed
    if filePath not defined: - binary data will be written in QByteArray and returned as a variable
    """
    command = "MEScFile.readChannelDataToClientsBlob('" + str(handle) + "', '" + str(fromDims) + "', '" + str(countDims) + "')"
    simpleCmdParser = ws.sendJSCommand(command)
    resultCode = simpleCmdParser.getResultCode()
    if resultCode > 0:
        print("Return code: " + str(resultCode))
        print(simpleCmdParser.getErrorText())
        return None
    else:
        print("readRawChannelDataToClientsBlob result: " + simpleCmdParser.getJSEngineResult())
        if filePath:
            cmdResult = QByteArray()
            for parts in simpleCmdParser.getPartList():
                cmdResult.append(parts)
            #print("Res type: " + str(type(cmdResult)) + ", Res size: "  + str(cmdResult.size()))
            tmp = cmdResult.data()
            toLog = str(type(tmp)) + " , " + str(len(tmp))
            with open(filePath, "wb") as f:
                f.write(tmp)
            return True
        else:
            cmdResult = QByteArray()
            for parts in simpleCmdParser.getPartList():
                cmdResult.append(parts)
                print( "Binary part with size: " + str(parts.size()))
            return cmdResult


def readRawChannelDataJSON(ws, handle, fromDims, countDims):
    command = "MEScFile.readRawChannelDataJSON('" + str(handle) + "', '" + str(fromDims) + "', '" + str(countDims) + "')"
    simpleCmdParser = ws.sendJSCommand(command)
    resultCode = simpleCmdParser.getResultCode()
    if resultCode > 0:
        print("Return code: " + str(resultCode))
        print(simpleCmdParser.getErrorText())
        return None
    else:
        cmdResult = json.loads(simpleCmdParser.getJSEngineResult())
        return cmdResult


def readChannelDataJSON(ws, handle, fromDims, countDims):
    command = "MEScFile.readChannelDataJSON('" + str(handle) + "', '" + str(fromDims) + "', '" + str(countDims) + "')"
    simpleCmdParser = ws.sendJSCommand(command)
    resultCode = simpleCmdParser.getResultCode()
    if resultCode > 0:
        print("Return code: " + str(resultCode))
        print(simpleCmdParser.getErrorText())
        return None
    else:
        cmdResult = json.loads(simpleCmdParser.getJSEngineResult())
        return cmdResult


def readRawChannelData(ws, varName, handle, fromDims, countDims):
    command = "var " + varName + " = MEScFile.readRawChannelData('" + str(handle) + "', '" + str(fromDims) + "', '" + str(countDims) + "')"
    simpleCmdParser = ws.sendJSCommand(command)
    resultCode = simpleCmdParser.getResultCode()
    if resultCode > 0:
        print("Return code: " + str(resultCode))
        print(simpleCmdParser.getErrorText())
        return None
    else:
        cmdResult = simpleCmdParser.getJSEngineResult()
        return cmdResult


def readChannelData(ws, varName, handle, fromDims, countDims):
    command = "var " + varName + " = MEScFile.readChannelData('" + str(handle) + "', '" + str(fromDims) + "', '" + str(countDims) + "')"
    simpleCmdParser = ws.sendJSCommand(command)
    resultCode = simpleCmdParser.getResultCode()
    print(command)
    if resultCode > 0:
        print("Return code: " + str(resultCode))
        print(simpleCmdParser.getErrorText())
        return None
    else:
        # on successful run the return value is None from the server and as such the getJSEngineResult result is useless for us here
        #cmdResult = simpleCmdParser.getJSEngineResult()
        #return cmdResult
        return True


def writeRawChannelData(ws, varName, handle, fromDims, countDims):
    command = "MEScFile.writeRawChannelData(" + str(varName) + ", '" + str(handle) + "', '" + str(fromDims) + "', '" + str(countDims) + "')"
    simpleCmdParser = ws.sendJSCommand(command)
    resultCode = simpleCmdParser.getResultCode()
    if resultCode > 0:
        print("Return code: " + str(resultCode))
        print(simpleCmdParser.getErrorText())
        return None
    else:
        cmdResult = simpleCmdParser.getJSEngineResult()
        return cmdResult


def writeChannelData(ws, varName, handle, fromDims, countDims):
    command = "MEScFile.writeChannelData(" + str(varName) + ", '" + str(handle) + "', '" + str(fromDims) + "', '" + str(countDims) + "')"
    simpleCmdParser = ws.sendJSCommand(command)
    resultCode = simpleCmdParser.getResultCode()
    if resultCode > 0:
        print("Return code: " + str(resultCode))
        print(simpleCmdParser.getErrorText())
        return None
    else:
        cmdResult = simpleCmdParser.getJSEngineResult()
        return cmdResult


def writeRawChannelDataFromAttachment(ws, buffer, handle, fromDims, countDims):
    command = "MEScFile.writeRawChannelDataFromAttachment('" + str(handle) + "', '" + str(fromDims) + "', '" + str(countDims) + "')"
    ws.uploadAttachment(buffer)
    simpleCmdParser = ws.sendJSCommand(command)
    resultCode = simpleCmdParser.getResultCode()
    if resultCode > 0:
        print("Return code: " + str(resultCode))
        print(simpleCmdParser.getErrorText())
        return None
    else:
        cmdResult = simpleCmdParser.getJSEngineResult()
        return cmdResult


def writeChannelDataFromAttachment(ws, buffer, handle, fromDims, countDims):
    command = "MEScFile.writeChannelDataFromAttachment('" + str(handle) + "', '" + str(fromDims) + "', '" + str(countDims) + "')"
    ws.uploadAttachment(buffer)
    simpleCmdParser = ws.sendJSCommand(command)
    resultCode = simpleCmdParser.getResultCode()
    if resultCode > 0:
        print("Return code: " + str(resultCode))
        print(simpleCmdParser.getErrorText())
        return None
    else:
        cmdResult = simpleCmdParser.getJSEngineResult()
        return cmdResult
