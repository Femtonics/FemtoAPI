"""
Python API wrapper functions for femtoAPI 2.0 version
!!! Not final version, nor is it fully tested yet!!!
"""
import sys, time, array
from PySide2.QtCore import *
from PySide2.QtWebSockets import *
from femtoapi import PyFemtoAPI
import json

def initConnection():
    """
    creates the websocket object used in all communications with the API server
    returns the ws object which is used in all other functions
    """
    ws=PyFemtoAPI.APIWebSocketClient('ws://localhost:8888')
    if ws == False:
        print("WebSocketHost could not be found?")
        sys.exit(1)
    timer = 0
    while timer < 10:
        print("Trying to connect to server...")
        done=ws.connectToServer()
        if done == False:
            time.sleep(1)
        else:
            break
        timer = timer + 1
    print("Connection initialized: " + str(done))
    if done == False:
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
        loginParser=ws.login(name,passw)
        resultCode=loginParser.getResultCode()
        if resultCode >0:
            time.sleep(1)
        else:
            break
        timer = timer + 1
    if resultCode > 0:
        print (loginParser.getErrorText())
        sys.exit(1)
    else:
        print("Successful login to FemtoAPI server")
        return True


def closeConnection(ws):
    """
    closes the connection in the ws object
    """
    res = ws.close()
    print("Connection closed")




def enableSignals(ws):
    command="FemtoAPITools.enableSignals('true')"
    simpleCmdParser=ws.sendJSCommand(command)
    resultCode=simpleCmdParser.getResultCode()
    if resultCode > 0:
        print ("Return code: " + str(resultCode))
        print (simpleCmdParser.getErrorText())
        return None
    else:
        cmdResult = simpleCmdParser.getJSEngineResult()
        return cmdResult

def isSignalEnabled(ws):
    command='FemtoAPITools.isSignalEnabled()'
    simpleCmdParser=ws.sendJSCommand(command)
    resultCode=simpleCmdParser.getResultCode()
    if resultCode > 0:
        print ("Return code: " + str(resultCode))
        print (simpleCmdParser.getErrorText())
        return None
    else:
        cmdResult = simpleCmdParser.getJSEngineResult()
        return cmdResult
    

def getFileList(ws, string=""):
    if not string:
        command = "FemtoAPIFile.getFileList()"
    else:
        command = "FemtoAPIFile.getFileList('" + string + "')"
    simpleCmdParser=ws.sendJSCommand(command)
    #print(simpleCmdParser)
    resultCode=simpleCmdParser.getResultCode()
    if resultCode > 0:
        print("Return code: %d" % resultCode)
        print(simpleCmdParser.getErrorText())
    else:	
        cmdResult = json.loads(simpleCmdParser.getJSEngineResult())
        return cmdResult


def getFileMetadata(ws, handle, string=""):
    if not string:
        command = "FemtoAPIFile.getFileMetadata('" + str(handle) + "')"
    else:
        command = "FemtoAPIFile.getFileMetadata('" + str(handle) + "', '" + string + "')"
    simpleCmdParser=ws.sendJSCommand(command)
    #print(simpleCmdParser)
    resultCode=simpleCmdParser.getResultCode()
    if resultCode > 0:
        print("Return code: %d" % resultCode)
        print(simpleCmdParser.getErrorText())
    else:	
        cmdResult = json.loads(simpleCmdParser.getJSEngineResult())
        return cmdResult


def getSessionMetadata(ws, handle, string=""):
    if not string:
        command = "FemtoAPIFile.getSessionMetadata('" + str(handle) + "')"
    else:
        command = "FemtoAPIFile.getSessionMetadata('" + str(handle) + "', '" + string + "')"
    simpleCmdParser=ws.sendJSCommand(command)
    #print(simpleCmdParser)
    resultCode=simpleCmdParser.getResultCode()
    if resultCode > 0:
        print("Return code: %d" % resultCode)
        print(simpleCmdParser.getErrorText())
    else:	
        cmdResult = json.loads(simpleCmdParser.getJSEngineResult())
        return cmdResult


def setSessionMetadata(ws, handle, jsonString):
    """
    jsonString must be the same format as the result of getSessionMetadata with the proper modified values
    """
    command = "FemtoAPIFile.setSessionMetadata('" + str(handle) + "', '" + jsonString + "')"
    simpleCmdParser=ws.sendJSCommand(command)
    #print(simpleCmdParser)
    resultCode=simpleCmdParser.getResultCode()
    if resultCode > 0:
        print("Return code: %d" % resultCode)
        print(simpleCmdParser.getErrorText())
    else:	
        cmdResult = simpleCmdParser.getJSEngineResult()
        return cmdResult


def getUnitMetadata(ws, handle, JsonItemName, string=""):
    """
    JsonItemName:
        BaseUnitMetadata
        Roi
        referenceViewport
        Points
        Device 
        AxisControl
        UserData
        Protocol
        AoSettings
        IntensityCompensationo
        CoordinateTuning
        MultiProtocolJson
        CurveInfo
        FullFrameparams
        ChannelInfo
        Modality
        CameraSettings
    """
    if not string:
        command = "FemtoAPIFile.getUnitMetadata('" + str(handle) + "', '" + JsonItemName + "')"
    else:
        command = "FemtoAPIFile.getUnitMetadata('" + str(handle) + "', '" + JsonItemName + "', '" + string + "')"
    simpleCmdParser=ws.sendJSCommand(command)
    #print(simpleCmdParser)
    resultCode=simpleCmdParser.getResultCode()
    if resultCode > 0:
        print("Return code: %d" % resultCode)
        print(simpleCmdParser.getErrorText())
    else:
        #print(simpleCmdParser.getJSEngineResult())
        cmdResult = simpleCmdParser.getJSEngineResult()
        if cmdResult:
            cmdResult = json.loads(cmdResult)
        return cmdResult


def setUnitMetadata(ws, handle, JsonItemName, jsonString):
    """
    """
    command = "FemtoAPIFile.setUnitMetadata('" + str(handle) + "', '" + JsonItemName + "', '" + jsonString + "')"
    simpleCmdParser=ws.sendJSCommand(command)
    #print(simpleCmdParser)
    resultCode=simpleCmdParser.getResultCode()
    if resultCode > 0:
        print("Return code: %d" % resultCode)
        print(simpleCmdParser.getErrorText())
    else:	
        cmdResult = simpleCmdParser.getJSEngineResult()
        return cmdResult


def getChildTree(ws, handle=''):
    command="FemtoAPIFile.getChildTree('"+handle+"')"
    simpleCmdParser=ws.sendJSCommand(command)
    resultCode=simpleCmdParser.getResultCode()
    #logging.info(resultCode)
    if resultCode > 0:
        print("Return code: " + str(resultCode))
        print(simpleCmdParser.getErrorText())
        return None
    else:
        cmdResult = json.loads(simpleCmdParser.getJSEngineResult())
        print("ChildTree acquired")
        return cmdResult


    
def getProcessingState(ws):
    """
    returns a dictionary containing all data about the processing state
    """
    command='FemtoAPIFile.getProcessingState()'
    simpleCmdParser=ws.sendJSCommand(command)
    resultCode=simpleCmdParser.getResultCode()
    if resultCode > 0:
        print ("Return code: " + str(resultCode))
        print (simpleCmdParser.getErrorText())
        return None
    else:
        cmdResult = json.loads(simpleCmdParser.getJSEngineResult())
        return cmdResult

#removed
def setProcessingState(ws, jsonString):
    """
    the input json format restrictions can be found in the function description on the FemtoAPInics knowledgebase
    returns a boolean value
    """
    command="FemtoAPIFile.setProcessingState('"+jsonString+"')"
    simpleCmdParser=ws.sendJSCommand(command)
    resultCode=simpleCmdParser.getResultCode()
    if resultCode > 0:
        print ("Return code: " + str(resultCode))
        print (simpleCmdParser.getErrorText())
        return None
    else:
        cmdResult = simpleCmdParser.getJSEngineResult()
        return cmdResult
    
    
def getMicroscopeState(ws):
    """
    returns a dictionary containing data about the microscope state
    """
    command='FemtoAPIMicroscope.getMicroscopeState()'
    simpleCmdParser=ws.sendJSCommand(command)
    resultCode=simpleCmdParser.getResultCode()
    if resultCode > 0:
        print ("Return code: " + str(resultCode))
        print (simpleCmdParser.getErrorText())
        return None
    else:
        cmdResult = json.loads(simpleCmdParser.getJSEngineResult())
        return cmdResult


def getAcquisitionState(ws):
    """
    returns a dictionary containing all data about the processing state
    """
    command='FemtoAPIMicroscope.getAcquisitionState()'
    simpleCmdParser=ws.sendJSCommand(command)
    resultCode=simpleCmdParser.getResultCode()
    if resultCode > 0:
        print ("Return code: " + str(resultCode))
        print (simpleCmdParser.getErrorText())
        return None
    else:
        cmdResult = json.loads(simpleCmdParser.getJSEngineResult())
        return cmdResult


def startGalvoScanSnapAsync(ws):
    command='FemtoAPIMicroscope.startGalvoScanSnapAsync()'
    simpleCmdParser=ws.sendJSCommand(command)
    resultCode=simpleCmdParser.getResultCode()
    if resultCode > 0:
        print ("Return code: " + str(resultCode))
        print (simpleCmdParser.getErrorText())
        return None
    else:	
        cmdResult = simpleCmdParser.getJSEngineResult()
        return cmdResult


def startGalvoScanAsync(ws):
    command='FemtoAPIMicroscope.startGalvoScanAsync()'
    simpleCmdParser=ws.sendJSCommand(command)
    resultCode=simpleCmdParser.getResultCode()
    if resultCode > 0:
        print ("Return code: " + str(resultCode))
        print (simpleCmdParser.getErrorText())
        return None
    else:
        cmdResult = simpleCmdParser.getJSEngineResult()
        return cmdResult


def stopGalvoScanAsync(ws):
    command='FemtoAPIMicroscope.stopGalvoScanAsync()'
    simpleCmdParser=ws.sendJSCommand(command)
    resultCode=simpleCmdParser.getResultCode()
    if resultCode > 0:
        print ("Return code: " + str(resultCode))
        print (simpleCmdParser.getErrorText())
        return None
    else:	
        cmdResult = simpleCmdParser.getJSEngineResult()
        return cmdResult


def startResonantScanSnapAsync(ws):
    command='FemtoAPIMicroscope.startResonantScanSnapAsync()'
    simpleCmdParser=ws.sendJSCommand(command)
    resultCode=simpleCmdParser.getResultCode()
    if resultCode > 0:
        print ("Return code: " + str(resultCode))
        print (simpleCmdParser.getErrorText())
        return None
    else:
        cmdResult = simpleCmdParser.getJSEngineResult()
        return cmdResult

def startResonantScanAsync(ws):
    command='FemtoAPIMicroscope.startResonantScanAsync()'
    simpleCmdParser=ws.sendJSCommand(command)
    resultCode=simpleCmdParser.getResultCode()
    if resultCode > 0:
        print ("Return code: " + str(resultCode))
        print (simpleCmdParser.getErrorText())
        return None
    else:
        cmdResult = simpleCmdParser.getJSEngineResult()
        return cmdResult
    

def stopResonantScanAsync(ws):
    command='FemtoAPIMicroscope.stopResonantScanAsync()'
    simpleCmdParser=ws.sendJSCommand(command)
    resultCode=simpleCmdParser.getResultCode()
    if resultCode > 0:
        print ("Return code: " + str(resultCode))
        print (simpleCmdParser.getErrorText())
        return None
    else:	
        cmdResult = simpleCmdParser.getJSEngineResult()
        return cmdResult


def createNewFile(ws):
    command='FemtoAPIFile.createNewFile()'
    simpleCmdParser=ws.sendJSCommand(command)
    resultCode=simpleCmdParser.getResultCode()
    if resultCode > 0:
        print ("Return code: " + str(resultCode))
        print (simpleCmdParser.getErrorText())
        return None
    else:	
        cmdResult = json.loads(simpleCmdParser.getJSEngineResult())
        return cmdResult


def setCurrentFile(ws, handle):
    """
    set the current file to 'handle' in the processing view
    """
    command="FemtoAPIFile.setCurrentFile('" + str(handle) + "')"
    simpleCmdParser=ws.sendJSCommand(command)
    resultCode=simpleCmdParser.getResultCode()
    if resultCode > 0:
        print ("Return code: " + str(resultCode))
        print (simpleCmdParser.getErrorText())
        return None
    else:	
        cmdResult = simpleCmdParser.getJSEngineResult()
        return cmdResult


def saveFileAsync(ws, handle = '' ):
    """
    save the current file or the file defined by handle
    """
    command="FemtoAPIFile.saveFileAsync('" + str(handle) + "')"
    simpleCmdParser=ws.sendJSCommand(command)
    resultCode=simpleCmdParser.getResultCode()
    if resultCode > 0:
        print ("Return code: " + str(resultCode))
        print (simpleCmdParser.getErrorText())
        return None
    else:	
        cmdResult = json.loads(simpleCmdParser.getJSEngineResult())
        return cmdResult


def saveFileAsAsync(ws, filePath, handle = '', overwrite = 'false'):
    """
    save the current file as 'filepath' or the file defined by 'handle' if given
    """
    command="FemtoAPIFile.saveFileAsAsync('" + str(filePath) + "', '" + str(handle) + "', " + str(overwrite) + ")"
    simpleCmdParser=ws.sendJSCommand(command)
    print(command)
    resultCode=simpleCmdParser.getResultCode()
    if resultCode > 0:
        print ("Return code: " + str(resultCode))
        print (simpleCmdParser.getErrorText())
        return None
    else:	
        cmdResult = json.loads(simpleCmdParser.getJSEngineResult())
        return cmdResult
    

def closeFileNoSaveAsync(ws, handle = '' ):
    """
    close the current file without saving or the file defined by 'handle' if given
    """
    command="FemtoAPIFile.closeFileNoSaveAsync('" + str(handle) + "')"
    simpleCmdParser=ws.sendJSCommand(command)
    resultCode=simpleCmdParser.getResultCode()
    if resultCode > 0:
        print ("Return code: " + str(resultCode))
        print (simpleCmdParser.getErrorText())
        return None
    else:	
        cmdResult = json.loads(simpleCmdParser.getJSEngineResult())
        return cmdResult


def closeFileAndSaveAsync(ws, handle = '', compress = 'false'):
    """
    save and close the current file without saving or the file defined by 'handle' if given
    """
    command="FemtoAPIFile.closeFileAndSaveAsync('" + str(handle) + "', '" + str(handle) + "', " + str(compress) + ")"
    simpleCmdParser=ws.sendJSCommand(command)
    resultCode=simpleCmdParser.getResultCode()
    if resultCode > 0:
        print ("Return code: " + str(resultCode))
        print (simpleCmdParser.getErrorText())
        return None
    else:	
        cmdResult = json.loads(simpleCmdParser.getJSEngineResult())
        return cmdResult


def closeFileAndSaveAsAsync(ws, filePath, handle = '', overwrite = 'false', compress = 'false'):
    """
    save the current file as 'filepath' or the file defined by 'handle' if given and close it
    """
    command="FemtoAPIFile.closeFileAndSaveAsAsync('" + str(filePath) + "', '" + str(handle) + "', " + str(overwrite) + ", " + str(compress) + ")"
    simpleCmdParser=ws.sendJSCommand(command)
    #print(command)
    resultCode=simpleCmdParser.getResultCode()
    if resultCode > 0:
        print ("Return code: " + str(resultCode))
        print (simpleCmdParser.getErrorText())
        return None
    else:	
        cmdResult = json.loads(simpleCmdParser.getJSEngineResult())
        return cmdResult


def openFilesAsync(ws, filePath):
    command="FemtoAPIFile.openFilesAsync('" + str(filePath) + "')"
    simpleCmdParser=ws.sendJSCommand(command)
    resultCode=simpleCmdParser.getResultCode()
    if resultCode > 0:
        print ("Return code: " + str(resultCode))
        print (simpleCmdParser.getErrorText())
        return None
    else:	
        cmdResult = json.loads(simpleCmdParser.getJSEngineResult())
        return cmdResult

    
def getImagingWindowParameters(ws, mType = '', spaceName = ''):
    """
    returns a dictionary containing data about the imaging window parameters
    the function will only return data about the measurement type defined in mType or all if undefined
    """
    command="FemtoAPIMicroscope.getImagingWindowParameters(measurementType = '" + str(mType) + "', spaceName  = '" + str(spaceName) + "')"
    simpleCmdParser=ws.sendJSCommand(command)
    resultCode=simpleCmdParser.getResultCode()
    if resultCode > 0:
        print ("Return code: " + str(resultCode))
        print (simpleCmdParser.getErrorText())
        return None
    else:	
        cmdResult = json.loads(simpleCmdParser.getJSEngineResult())
        return cmdResult


def setImagingWindowParameters(ws, jsonString):
    """
    the input json format restrictions can be found in the function description on the FemtoAPInics knowledgebase
    """
    command="FemtoAPIMicroscope.setImagingWindowParameters('"+jsonString+"')"
    simpleCmdParser=ws.sendJSCommand(command)
    resultCode=simpleCmdParser.getResultCode()
    if resultCode > 0:
        print ("Return code: " + str(resultCode))
        print (simpleCmdParser.getErrorText())
        return None
    else:
        cmdResult = simpleCmdParser.getJSEngineResult()
        return cmdResult


def getZStackLaserIntensityProfile(ws, mType = '', spaceName = ''):
    """
    gets the Z-stack depth correction profile
    mType: defines the measurement type (resonant, galvo), all types if undefined
    """
    command="FemtoAPIMicroscope.getZStackLaserIntensityProfile(measurementType = '" + str(mType) + "', spaceName = '" + str(spaceName) + "')"
    simpleCmdParser=ws.sendJSCommand(command)
    resultCode=simpleCmdParser.getResultCode()
    if resultCode > 0:
        print ("Return code: " + str(resultCode))
        print (simpleCmdParser.getErrorText())
        return None
    else:	
        cmdResult = json.loads(simpleCmdParser.getJSEngineResult())
        return cmdResult


def setZStackLaserIntensityProfile(ws, jsonString):
    """
    the input json format restrictions can be found in the function description on the FemtoAPInics knowledgebase
    """
    command="FemtoAPIMicroscope.setZStackLaserIntensityProfile('"+jsonString+"')"
    simpleCmdParser=ws.sendJSCommand(command)
    resultCode=simpleCmdParser.getResultCode()
    if resultCode > 0:
        print ("Return code: " + str(resultCode))
        print (simpleCmdParser.getErrorText())
        return None
    else:
        cmdResult = simpleCmdParser.getJSEngineResult()
        return cmdResult


def getAxisPositions(ws):
    """
    get positions for all the axes
    """
    command="FemtoAPIMicroscope.getAxisPositions()"
    simpleCmdParser=ws.sendJSCommand(command)
    resultCode=simpleCmdParser.getResultCode()
    if resultCode > 0:
        print ("Return code: " + str(resultCode))
        print (simpleCmdParser.getErrorText())
        return None
    else:
        cmdResult = json.loads(simpleCmdParser.getJSEngineResult())
        return cmdResult

def getAxisPosition(ws, axisName, posType = '', space = ''):
    """
    get position of one specific axis
    """
    command="FemtoAPIMicroscope.getAxisPosition('" + axisName + "', positionType = '" +posType+ "', spaceName = '" + space + "')"
    simpleCmdParser=ws.sendJSCommand(command)
    resultCode=simpleCmdParser.getResultCode()
    if resultCode > 0:
        print ("Return code: " + str(resultCode))
        print (simpleCmdParser.getErrorText())
        return None
    else:
        cmdResult = json.loads(simpleCmdParser.getJSEngineResult())
        return cmdResult

def isAxisMoving(ws, axisName):
    command="FemtoAPIMicroscope.isAxisMoving('" + axisName + "')"
    simpleCmdParser=ws.sendJSCommand(command)
    resultCode=simpleCmdParser.getResultCode()
    if resultCode > 0:
        print ("Return code: " + str(resultCode))
        print (simpleCmdParser.getErrorText())
        return None
    else:
        cmdResult = simpleCmdParser.getJSEngineResult()
        return cmdResult


def doZero(ws, axisName, spaceName = ''):
    command="FemtoAPIMicroscope.doZero('" + str(axisName) + "', spaceName  = '" + str(spaceName) + "')"
    simpleCmdParser=ws.sendJSCommand(command)
    resultCode=simpleCmdParser.getResultCode()
    if resultCode > 0:
        print ("Return code: " + str(resultCode))
        print (simpleCmdParser.getErrorText())
        return None
    else:	
        cmdResult = simpleCmdParser.getJSEngineResult()
        return cmdResult


def setAxisPosition(ws, axisName, newPosition, isRelativePosition = 'true', isRelativeToCurrentPosition = 'true', spaceName = ''):
    """
    required parameters:
        axisName - string, must be configured axis name
        newPosition - double
    optional parameters:
        isRelativePosition - boolean
        isRelativeToCurrentPosition - boolean
        spaceName - string, empty string means default namespace
    """
    command="FemtoAPIMicroscope.setAxisPosition('" + str(axisName) + "', " + str(newPosition) + ", isRelativePosition = " + isRelativePosition + ", isRelativeToCurrentPosition = " + isRelativeToCurrentPosition + ", spaceName = '" + spaceName + "')"
    simpleCmdParser=ws.sendJSCommand(command)
    resultCode=simpleCmdParser.getResultCode()
    if resultCode > 0:
        print ("Return code: " + str(resultCode))
        print (simpleCmdParser.getErrorText())
        return None
    else:
        cmdResult = simpleCmdParser.getJSEngineResult()
        return cmdResult


def getPMTAndLaserIntensityDeviceValues(ws):
    """
    returns a dictionary containing PMT/Laser intensity device values
    """
    command="FemtoAPIMicroscope.getPMTAndLaserIntensityDeviceValues()"
    simpleCmdParser=ws.sendJSCommand(command)
    resultCode=simpleCmdParser.getResultCode()
    if resultCode > 0:
        print ("Return code: " + str(resultCode))
        print (simpleCmdParser.getErrorText())
        return None
    else:
        cmdResult = json.loads(simpleCmdParser.getJSEngineResult())
        return cmdResult
    

def setPMTAndLaserIntensityDeviceValues(ws, jsonString):
    """
    the input json format restrictions can be found in the function description on the FemtoAPInics knowledgebase
    """
    command="FemtoAPIMicroscope.setPMTAndLaserIntensityDeviceValues('"+jsonString+"')"
    simpleCmdParser=ws.sendJSCommand(command)
    resultCode=simpleCmdParser.getResultCode()
    if resultCode > 0:
        print ("Return code: " + str(resultCode))
        print (simpleCmdParser.getErrorText())
        return None
    else:
        cmdResult = simpleCmdParser.getJSEngineResult()
        return cmdResult

#utolsó 3 paraméter változni fog!!!
def createTimeSeriesMUnit(ws, xDim, yDim, taskXMLParameters, viewportJson, z0InMs = 0.0, zStepInMs = 1.0, zDimInitial = 1):
    """
    available types in taskXMLParameters : TaskResonantCommon, TaskFastXYGalvo, TaskAOFullFrame
    *from mesc veresion 4.5 taskXMLParameters is replaced by a single string containing the scaning mode: galvo, resonant, AOFullFrame
    
    
    xDim: measurement image x resolution 
    yDim: measurement image y resolution 
    taskXMLParameters: measurementParamsXML for resonant/galvo/AO fullframe scan time series measurement.
        *from mesc veresion 4.5 taskXMLParameters is replaced by a single string containing the scanin mode: galvo, resonant, AOFullFrame
    viewportJson: viewport for measurement 
    z0InMs: Measurement start time offset in ms. Double, default value is 0.0 
    zStepInMs: Frame duration time in ms (1/frame rate). Positive double, default value is 1.0. 
    zDimInitial: Number of frames to create in z dimension. Positive integer, default value is 1.
    """
    command="FemtoAPIFile.createTimeSeriesMUnit(" + str(xDim) + ", " + str(yDim) + ", '" + taskXMLParameters + "', '" + viewportJson + "', z0InMs = " + str(z0InMs) + ", zStepInMs = " + str(zStepInMs) + ", zDimInitial = " + str(zDimInitial) + ")"
    simpleCmdParser=ws.sendJSCommand(command)
    resultCode=simpleCmdParser.getResultCode()
    if resultCode > 0:
        print ("Return code: " + str(resultCode))
        print (simpleCmdParser.getErrorText())
        return None
    else:
        cmdResult = json.loads(simpleCmdParser.getJSEngineResult())
        return cmdResult


# deprecated function
def createAOFullFrameScanSeriesMUnit(ws, xDim, yDim, taskXMLParameters, viewportJson, z0InMs = 0.0, zStepInMs = 1.0, zDimInitial = 1):
    command="FemtoAPIFile.createAOFullFrameScanSeriesMUnit(" + str(xDim) + ", " + str(yDim) + ", '" + taskXMLParameters + "', '" + viewportJson + "', z0InMs = " + str(z0InMs) + ", zStepInMs = " + str(zStepInMs) + ", zDimInitial = " + str(zDimInitial) + ")"
    simpleCmdParser=ws.sendJSCommand(command)
    resultCode=simpleCmdParser.getResultCode()
    if resultCode > 0:
        print ("Return code: " + str(resultCode))
        print (simpleCmdParser.getErrorText())
        return None
    else:
        cmdResult = json.loads(simpleCmdParser.getJSEngineResult())
        return cmdResult


def createZStackMUnit(ws, xDim, yDim, zDim, taskXMLParameters, viewportJson, zStepInMicrons = 1.0):
    command="FemtoAPIFile.createZStackMUnit(" + str(xDim) + ", " + str(yDim) + ", " + str(zDim) + ", '" + taskXMLParameters + "', '" + viewportJson + "', zStepInMicrons = " + str(zStepInMicrons) +  ")"
    simpleCmdParser=ws.sendJSCommand(command)
    resultCode=simpleCmdParser.getResultCode()
    if resultCode > 0:
        print ("Return code: " + str(resultCode))
        print (simpleCmdParser.getErrorText())
        return None
    else:
        cmdResult = json.loads(simpleCmdParser.getJSEngineResult())
        return cmdResult

#utolsó 3 paraméter változni fog!!!
def createBackgroundFrame(ws, xDim, yDim, technologyType, viewportJson, fileNodeDescriptor = '', z0InMs = 0.0, zStepInMs = 1.0, zDimInitial = 1):
    command="FemtoAPIFile.createBackgroundFrame(" + str(xDim) + ", " + str(yDim) + ", '" + technologyType + "', '" + viewportJson + "', '" + fileNodeDescriptor + "', z0InMs = " + str(z0InMs) + ", zStepInMs = " + str(zStepInMs) + ", zDimInitial = " + str(zDimInitial) + ")"
    simpleCmdParser=ws.sendJSCommand(command)
    resultCode=simpleCmdParser.getResultCode()
    if resultCode > 0:
        print ("Return code: " + str(resultCode))
        print (simpleCmdParser.getErrorText())
        return None
    else:
        cmdResult = json.loads(simpleCmdParser.getJSEngineResult())
        return cmdResult


def createBackgroundZStack(ws, xDim, yDim, zDim, technologyType, viewportJson, fileNodeDescriptor = '', zStepInMicrons = 1.0):
    command="FemtoAPIFile.createBackgroundZStack(" + str(xDim) + ", " + str(yDim) + ", " + str(zDim) + ", '" + technologyType + "', '" + viewportJson + "', '" + fileNodeDescriptor + "', zStepInMicrons = " + str(zStepInMicrons) +  ")"
    print(command)
    simpleCmdParser=ws.sendJSCommand(command)
    resultCode=simpleCmdParser.getResultCode()
    if resultCode > 0:
        print ("Return code: " + str(resultCode))
        print (simpleCmdParser.getErrorText())
        return None
    else:
        cmdResult = json.loads(simpleCmdParser.getJSEngineResult())
        return cmdResult


def createMultiROI2DMUnit(ws, xDim, tDim, methodType, backgroundImagePath, deltaTInMs = 1.0, t0InMs= 0.0):
    """
    methodType : 2D multiROI type, it can be 'multiROIPointScan', 'multiROILineScan', or 'multiROIMultiLine' 
    """
    command="FemtoAPIFile.createMultiROIMUnit(" + str(xDim) + ", " + str(tDim) + ", '" +  methodType + "', '" + str() + "', deltaTInMs = " + str(x0InMicrons) + ", t0InMs = " + str(y0InMicrons) + ")"
    #print(command)
    simpleCmdParser=ws.sendJSCommand(command)
    resultCode=simpleCmdParser.getResultCode()
    if resultCode > 0:
        print ("Return code: " + str(resultCode))
        print (simpleCmdParser.getErrorText())
        return None
    else:
        cmdResult = json.loads(simpleCmdParser.getJSEngineResult())
        print ("Create createMultiROI2DMUnit success:" + str(cmdResult))
        return cmdResult


def createMultiROI3DMUnit(ws, xDim, yDim, tDim, methodType, backgroundImagePath, deltaTInMs = 1.0, t0InMs= 0.0):
    """
    methodType : 3D multiROI type, it can be 'multiROIChessBoard', 'multiROITransverseRibbonScan', 'multiROILongitudinalRibbonScan'e' 
    """
    command="FemtoAPIFile.createMultiROIMUnit(" + str(xDim) + ", " + str(yDim) + ", " + str(tDim) + ", '" +  methodType + "', '" + str() + "', deltaTInMs = " + str(x0InMicrons) + ", t0InMs = " + str(y0InMicrons) + ")"
    #print(command)
    simpleCmdParser=ws.sendJSCommand(command)
    resultCode=simpleCmdParser.getResultCode()
    if resultCode > 0:
        print ("Return code: " + str(resultCode))
        print (simpleCmdParser.getErrorText())
        return None
    else:
        cmdResult = json.loads(simpleCmdParser.getJSEngineResult())
        print ("Create createMultiROI2DMUnit success:" + str(cmdResult))
        return cmdResult

    
def createMultiROI4DMUnit(ws, xDim, yDim, zDim, tDim, methodType, backgroundImagePath, deltaTInMs = 1.0, t0InMs= 0.0):
    """
    methodType : 4D multiROI type, it can be 'multiROIMultiCube', 'multiROISnake'
    """
    command="FemtoAPIFile.createMultiROIMUnit(" + str(xDim) + ", " + str(yDim) + ", " + str(zDim) + ", " + str(tDim) + ", '" +  methodType + "', '" + str() + "', deltaTInMs = " + str(x0InMicrons) + ", t0InMs = " + str(y0InMicrons) + ")"
    #print(command)
    simpleCmdParser=ws.sendJSCommand(command)
    resultCode=simpleCmdParser.getResultCode()
    if resultCode > 0:
        print ("Return code: " + str(resultCode))
        print (simpleCmdParser.getErrorText())
        return None
    else:
        cmdResult = json.loads(simpleCmdParser.getJSEngineResult())
        print ("Create createMultiROI2DMUnit success:" + str(cmdResult))
        return cmdResult
    

def extendMUnit(ws, mUnitHandle, countDims):
    command="FemtoAPIFile.extendMUnit('" + str(mUnitHandle) + "', " + str(countDims) + ")"
    simpleCmdParser=ws.sendJSCommand(command)
    resultCode=simpleCmdParser.getResultCode()
    if resultCode > 0:
        print ("Return code: " + str(resultCode))
        print (simpleCmdParser.getErrorText())
        return None
    else:
        cmdResult = json.loads(simpleCmdParser.getJSEngineResult())
        return cmdResult


def deleteMUnit(ws, mUnitHandle):
    command="FemtoAPIFile.deleteMUnit('" + str(mUnitHandle) + "')"
    simpleCmdParser=ws.sendJSCommand(command)
    resultCode=simpleCmdParser.getResultCode()
    if resultCode > 0:
        print ("Return code: " + str(resultCode))
        print (simpleCmdParser.getErrorText())
        return None
    else:
        cmdResult = json.loads(simpleCmdParser.getJSEngineResult())
        return cmdResult

# source x,y,z, dest x,y
def copyMUnit(ws, sourceMUnitHandle, destMSessionHandle, bCopyChannelContents = 'true'):
    """
    sourceMUnitHandle is the measurementunit handle of the source 
    destMSessionHandle is the session handle of the destination
    """
    command="FemtoAPIFile.copyMUnit('" + str(sourceMUnitHandle) + "', '" + str(destMSessionHandle) + "', " + bCopyChannelContents + ")"
    simpleCmdParser=ws.sendJSCommand(command)
    resultCode=simpleCmdParser.getResultCode()
    if resultCode > 0:
        print ("Return code: " + str(resultCode))
        print (simpleCmdParser.getErrorText())
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
    command="FemtoAPIFile.moveMUnit('" + str(sourceMUnitHandle) + "', '" + str(destMSessionHandle) + "')"
    simpleCmdParser=ws.sendJSCommand(command)
    resultCode=simpleCmdParser.getResultCode()
    if resultCode > 0:
        print ("Return code: " + str(resultCode))
        print (simpleCmdParser.getErrorText())
        return None
    else:
        cmdResult = json.loads(simpleCmdParser.getJSEngineResult())
        return cmdResult

    
def addChannel(ws, mUnitHandle, channelName, compressionPreset=0):
    command="FemtoAPIFile.addChannel('" + str(mUnitHandle) + "', '" + str(channelName) + "', '" + str(compressionPreset) + "')"
    simpleCmdParser=ws.sendJSCommand(command)
    resultCode=simpleCmdParser.getResultCode()
    if resultCode > 0:
        print ("Return code: " + str(resultCode))
        print (simpleCmdParser.getErrorText())
        return None
    else:
        cmdResult = json.loads(simpleCmdParser.getJSEngineResult())
        return cmdResult


def deleteChannel(ws, channelHandle):
    command="FemtoAPIFile.deleteChannel('" + str(channelHandle) + "')"
    simpleCmdParser=ws.sendJSCommand(command)
    resultCode=simpleCmdParser.getResultCode()
    if resultCode > 0:
        print ("Return code: " + str(resultCode))
        print (simpleCmdParser.getErrorText())
        return None
    else:
        cmdResult = json.loads(simpleCmdParser.getJSEngineResult())
        return cmdResult


def addLastFrameToMSession(ws, destMSessionHandle = '', space = ''):
    command="FemtoAPIFile.addLastFrameToMSession('" + str(destMSessionHandle) + "', '" + space + "')"
    simpleCmdParser=ws.sendJSCommand(command)
    resultCode=simpleCmdParser.getResultCode()
    if resultCode > 0:
        print ("Return code: " + str(resultCode))
        print (simpleCmdParser.getErrorText())
        return None
    else:
        cmdResult = simpleCmdParser.getJSEngineResult()
        return cmdResult


def sendFileToClientsBlob(ws, sPathAndFileName):
    """
    return value is the file size if file found, None if filepath is not valid
    """
    command="FemtoAPIFile.sendFileToClientsBlob('" + str(sPathAndFileName) + "')"
    simpleCmdParser=ws.sendJSCommand(command)
    resultCode=simpleCmdParser.getResultCode()
    if resultCode > 0:
        print ("Return code: " + str(resultCode))
        print (simpleCmdParser.getErrorText())
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
    command="FemtoAPIFile.saveAttachmentToFile('" + str(sPathAndFileName) + "')"
    simpleCmdParser=ws.sendJSCommand(command)
    resultCode=simpleCmdParser.getResultCode()
    if resultCode > 0:
        print ("Return code: " + str(resultCode))
        print (simpleCmdParser.getErrorText())
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
    command="FemtoAPIFile.modifyConversion('" + str(sConversionName) + "', '" + str(dScale) + "', '" + str(dOffset) + "', bSave = " + bSave + ")"
    simpleCmdParser=ws.sendJSCommand(command)
    resultCode=simpleCmdParser.getResultCode()
    if resultCode > 0:
        print ("Return code: " + str(resultCode))
        print (simpleCmdParser.getErrorText())
        return None
    else:
        cmdResult = simpleCmdParser.getJSEngineResult()
        return cmdResult


def saveVarToFile(ws, jsValue, PathAndFileName):
    command="FemtoAPIFile.saveVarToFile(" + str(jsValue) + ", '" + str(PathAndFileName) + "')"
    print(command)
    simpleCmdParser=ws.sendJSCommand(command)
    resultCode=simpleCmdParser.getResultCode()
    if resultCode > 0:
        print ("Return code: " + str(resultCode))
        print (simpleCmdParser.getErrorText())
        return None
    else:
        cmdResult = simpleCmdParser.getJSEngineResult()
        return cmdResult

    

def getStatus(ws, sCommandID = None):
    """
        If sCommand is defined the function will get the status of the assyncronous file operation represented by the given ID. - not tested
        If sCommand is not given the function will return information about the currently opened files.
    """
    if sCommandID:
        command="FemtoAPIFile.getStatus('" + str(sCommandID) + "')"
    else:
        command="FemtoAPIFile.getStatus()"
    simpleCmdParser=ws.sendJSCommand(command)
    resultCode=simpleCmdParser.getResultCode()
    if resultCode > 0:
        print ("Return code: " + str(resultCode))
        print (simpleCmdParser.getErrorText())
        return None
    else:
        cmdResult = json.loads(simpleCmdParser.getJSEngineResult())
        return cmdResult
    

def curveInfo(ws, mUnitHandle, curveIdx):
    command="FemtoAPIFile.curveInfo('" + str(mUnitHandle) + "', '" + str(curveIdx) + "')"
    #print(command)
    simpleCmdParser=ws.sendJSCommand(command)
    resultCode=simpleCmdParser.getResultCode()
    if resultCode > 0:
        print ("Return code: " + str(resultCode))
        print (simpleCmdParser.getErrorText())
        return None
    else:
        cmdResult = json.loads(simpleCmdParser.getJSEngineResult())
        return cmdResult


def readCurve(ws, mUnitHandle, curveIdx, vectorFormat = '', forceDouble = ''):
    """
    returns a dictionary with 2 elements
    Result: contains data about the specified curve
    BinaryData: is a dictionary with 2 elements
        - 'xData' is a list with the x data of the curve
        - 'yData' is a list with the y data of the curve
    the elements of these 2 list make up data pairs (xData[0] - yData[0], xData[1] - yData[1], etc.)
    """
    command="FemtoAPIFile.readCurve('" + str(mUnitHandle) + "', '" + str(curveIdx) + "', '" + str(vectorFormat) + "', '" + str(forceDouble) + "')"
    print(command)
    simpleCmdParser=ws.sendJSCommand(command)
    #print(simpleCmdParser.hasBinaryParts())
    resultCode=simpleCmdParser.getResultCode()
    if resultCode > 0:
        print ("Return code: " + str(resultCode))
        print (simpleCmdParser.getErrorText())
        return None
    else:
        cmdResult = {}
        cmdResult.update({"Result": json.loads(simpleCmdParser.getJSEngineResult())})
        xData = []
        yData = []
        curveData = {"xData": xData, "yData": yData}

        for parts in simpleCmdParser.getPartList():
            size = int(parts.size() / 2)
            binaryDataX = QByteArray()
            binaryDataY = QByteArray()
            binaryDataX.append(parts[:size])
            binaryDataY.append(parts[size:])
            
            stream = QDataStream(binaryDataX)
            stream.setByteOrder(QDataStream.ByteOrder.LittleEndian)
            while not stream.atEnd():
                floatData = stream.readDouble()
                curveData["xData"].append(floatData) 
            stream = QDataStream(binaryDataY)
            stream.setByteOrder(QDataStream.ByteOrder.LittleEndian)
            while not stream.atEnd():
                floatData = stream.readDouble()
                curveData["yData"].append(floatData)
            print( "Binary part with size: " + str(parts.size()))
        cmdResult.update({"CurveData": curveData})                 
        return cmdResult

    
def deleteCurve(ws, mUnitHandle, curveIdx):
    command="FemtoAPIFile.deleteCurve('" + str(mUnitHandle) + "', '" + str(curveIdx) + "')"
    #print(command)
    simpleCmdParser=ws.sendJSCommand(command)
    resultCode=simpleCmdParser.getResultCode()
    if resultCode > 0:
        print ("Return code: " + str(resultCode))
        print (simpleCmdParser.getErrorText())
        return None
    else:
        cmdResult = simpleCmdParser.getJSEngineResult()
        return cmdResult

#will change
def writeCurve(ws, buffer, mUnitHandle, size, name, xType, xDataType, yType, yDataType, optimize = ''):
    """parameter info on Confluence -> API2.0 """
    ws.uploadAttachment(buffer)
    command="FemtoAPIFile.writeCurve('" + str(mUnitHandle) + "', '" + str(size) + "', '" + name + "', '" + xType + "', '" + xDataType + "', '" + yType + "', '" + yDataType + "', '" + str(optimize) + "')"
    simpleCmdParser=ws.sendJSCommand(command)
    resultCode=simpleCmdParser.getResultCode()
    if resultCode > 0:
        print ("Return code: " + str(resultCode))
        print (simpleCmdParser.getErrorText())
        return None
    else:
        cmdResult = json.loads(simpleCmdParser.getJSEngineResult())
        return cmdResult

#not working !! fix needed
def appendToCurve(ws, buffer, mUnitHandle, curveIdx, size, xType, xDataType, yType, yDataType):
    """parameter info on Confluence -> API2.0 """
    ws.uploadAttachment(buffer)
    command="FemtoAPIFile.appendToCurve('" + str(mUnitHandle) + "', '" + str(curveIdx) + "', '" + str(size) + "', '" + xType + "', '" + xDataType + "', '" + yType + "', '" + yDataType + "')"
    print(command)
    simpleCmdParser=ws.sendJSCommand(command)
    resultCode=simpleCmdParser.getResultCode()
    if resultCode > 0:
        print ("Return code: " + str(resultCode))
        print (simpleCmdParser.getErrorText())
        return None
    else:
        cmdResult = simpleCmdParser.getJSEngineResult()
        return cmdResult


def getFocusingModes(ws, spaceName = ''):
    command="FemtoAPIMicroscope.getFocusingModes('" + spaceName + "')"
    print(command)
    simpleCmdParser=ws.sendJSCommand(command)
    resultCode=simpleCmdParser.getResultCode()
    if resultCode > 0:
        print ("Return code: " + str(resultCode))
        print (simpleCmdParser.getErrorText())
        return None
    else:
        cmdResult = json.loads(simpleCmdParser.getJSEngineResult())
        return cmdResult

    
def setFocusingMode(ws, sfocusingMode, spaceName = ''):
    command="FemtoAPIMicroscope.setFocusingMode('" + str(sfocusingMode) + "', '" + spaceName + "')"
    simpleCmdParser=ws.sendJSCommand(command)
    resultCode=simpleCmdParser.getResultCode()
    if resultCode > 0:
        print ("Return code: " + str(resultCode))
        print (simpleCmdParser.getErrorText())
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
    command="FemtoAPIMicroscope.getActiveProtocol()"
    simpleCmdParser=ws.sendJSCommand(command)
    resultCode=simpleCmdParser.getResultCode()
    if resultCode > 0:
        print ("Return code: " + str(resultCode))
        print (simpleCmdParser.getErrorText())
        return None
    else:
        cmdResult = json.loads(simpleCmdParser.getJSEngineResult())
        return cmdResult


def setActiveTaskAndSubTask(ws, taskName, subTaskName = 'timeSeries'):
    """
    taskName: string, name of the task to set, can be 'resonant' or 'galvo'
    subTaskName: string, optional parameter, name of the sub task to set, value can be 'timeSeries', 'zStack' or 'volumeScan'
    If not given, timeseries measurement will be selected on the MESc GUI by default. 
    """
    command="FemtoAPIMicroscope.setActiveTaskAndSubTask( '" + taskName + "', '" + subTaskName + "')"
    simpleCmdParser=ws.sendJSCommand(command)
    resultCode=simpleCmdParser.getResultCode()
    if resultCode > 0:
        print ("Return code: " + str(resultCode))
        print (simpleCmdParser.getErrorText())
        return None
    else:
        cmdResult = simpleCmdParser.getJSEngineResult()
        return cmdResult


def getCommandSetVersion(ws):
    """
    Gets the version of the FemtoAPI API command set in string
    """
    command="FemtoAPIMicroscope.getCommandSetVersion()"
    simpleCmdParser=ws.sendJSCommand(command)
    resultCode=simpleCmdParser.getResultCode()
    if resultCode > 0:
        print ("Return code: " + str(resultCode))
        print (simpleCmdParser.getErrorText())
        return None
    else:
        cmdResult = simpleCmdParser.getJSEngineResult()
        return cmdResult


def getCommandSetVersionProcessing(ws):
    """
    Gets the version of the FemtoAPI API command set in string
    """
    command="FemtoAPIFile.getCommandSetVersion()"
    simpleCmdParser=ws.sendJSCommand(command)
    resultCode=simpleCmdParser.getResultCode()
    if resultCode > 0:
        print ("Return code: " + str(resultCode))
        print (simpleCmdParser.getErrorText())
        return None
    else:
        cmdResult = simpleCmdParser.getJSEngineResult()
        return cmdResult


def getLastCommandError(ws):
    command="FemtoAPIMicroscope.getLastCommandError()"
    simpleCmdParser=ws.sendJSCommand(command)
    resultCode=simpleCmdParser.getResultCode()
    if resultCode > 0:
        print ("Return code: " + str(resultCode))
        print (simpleCmdParser.getErrorText())
        return None
    else:
        cmdResult = json.loads(simpleCmdParser.getJSEngineResult())
        return cmdResult


def getLastCommandErrorProcessing(ws):
    command="FemtoAPIFile.getLastCommandError()"
    simpleCmdParser=ws.sendJSCommand(command)
    resultCode=simpleCmdParser.getResultCode()
    if resultCode > 0:
        print ("Return code: " + str(resultCode))
        print (simpleCmdParser.getErrorText())
        return None
    else:
        cmdResult = json.loads(simpleCmdParser.getJSEngineResult())
        return cmdResult


def setMeasurementDuration(ws, duration, taskName = '', spaceName = ''):
    command="FemtoAPIMicroscope.setMeasurementDuration(" + str(duration) + ", taskName = '" + taskName + "', spaceName = '" + spaceName + "')"
    simpleCmdParser=ws.sendJSCommand(command)
    resultCode=simpleCmdParser.getResultCode()
    if resultCode > 0:
        print ("Return code: " + str(resultCode))
        print (simpleCmdParser.getErrorText())
        return None
    else:
        cmdResult = simpleCmdParser.getJSEngineResult()
        return cmdResult

def readRawChannelDataToClientsBlob(ws, handle, fromDims, countDims, filePath = None):
    """
    handle
    fromDims
    countDims
    filePath: optional parameter, default None
    if filePath defined: - binary data will be writen in the given file, return value is True if successfull or False is failed
    if filePath not defined: - binary data will be written in QByteArray and returned as a variable
    """
    command="FemtoAPIFile.readRawChannelDataToClientsBlob('" + str(handle) + "', '" + str(fromDims) + "', '" + str(countDims) + "')"
    simpleCmdParser=ws.sendJSCommand(command)
    resultCode=simpleCmdParser.getResultCode()
    if resultCode > 0:
        print ("Return code: " + str(resultCode))
        print (simpleCmdParser.getErrorText())
        return None
    else:
        print ("readRawChannelDataToClientsBlob result: " + simpleCmdParser.getJSEngineResult())
        if filePath:
            cmdResult = QByteArray()
            for parts in simpleCmdParser.getPartList():
                cmdResult.append(parts)
            print("Res type: " + str(type(cmdResult)) + ", Res size: "  + str(cmdResult.size()))
            tmp = cmdResult.data()
            with open(filePath, "wb") as f:
                f.write(tmp)
            return True
        else:
            cmdResult = QByteArray()
            for parts in simpleCmdParser.getPartList():
                cmdResult.append(parts)
                #print( "Binary part sizes: " + str(parts.size()))
            return cmdResult


def readChannelDataToClientsBlob(ws, handle, fromDims, countDims, filePath = None):
    """
    handle
    fromDims
    countDims
    filePath: optional parameter, default None
    if filePath defined: - binary data will be written in the given file, return value is True if successfull or False is failed
    if filePath not defined: - binary data will be written in QByteArray and returned as a variable
    """
    command="FemtoAPIFile.readChannelDataToClientsBlob('" + str(handle) + "', '" + str(fromDims) + "', '" + str(countDims) + "')"
    simpleCmdParser=ws.sendJSCommand(command)
    resultCode=simpleCmdParser.getResultCode()
    if resultCode > 0:
        print ("Return code: " + str(resultCode))
        print (simpleCmdParser.getErrorText())
        return None
    else:
        print ("readRawChannelDataToClientsBlob result: " + simpleCmdParser.getJSEngineResult())
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
                #print( "Binary part with size: " + str(parts.size()))
            return cmdResult


def readRawChannelDataJSON(ws, handle, fromDims, countDims):
    command="FemtoAPIFile.readRawChannelDataJSON('" + str(handle) + "', '" + str(fromDims) + "', '" + str(countDims) + "')"
    print(command)
    simpleCmdParser=ws.sendJSCommand(command)
    resultCode=simpleCmdParser.getResultCode()
    if resultCode > 0:
        print ("Return code: " + str(resultCode))
        print (simpleCmdParser.getErrorText())
        return None
    else:
        cmdResult = json.loads(simpleCmdParser.getJSEngineResult())
        return cmdResult


def readChannelDataJSON(ws, handle, fromDims, countDims):
    command="FemtoAPIFile.readChannelDataJSON('" + str(handle) + "', '" + str(fromDims) + "', '" + str(countDims) + "')"
    print(command)
    simpleCmdParser=ws.sendJSCommand(command)
    resultCode=simpleCmdParser.getResultCode()
    if resultCode > 0:
        print ("Return code: " + str(resultCode))
        print (simpleCmdParser.getErrorText())
        return None
    else:
        cmdResult = json.loads(simpleCmdParser.getJSEngineResult())
        print(cmdResult)
        return cmdResult

    
def readRawChannelData(ws, varName, handle, fromDims, countDims):
    command="var " + varName + " = FemtoAPIFile.readRawChannelData('" + str(handle) + "', '" + str(fromDims) + "', '" + str(countDims) + "')"
    simpleCmdParser=ws.sendJSCommand(command)
    resultCode=simpleCmdParser.getResultCode()
    if resultCode > 0:
        print ("Return code: " + str(resultCode))
        print (simpleCmdParser.getErrorText())
        return None
    else:
        cmdResult = simpleCmdParser.getJSEngineResult()
        print("done", cmdResult)
        return cmdResult


def readChannelData(ws, varName, handle, fromDims, countDims):
    command="var " + varName + " = FemtoAPIFile.readChannelData('" + str(handle) + "', '" + str(fromDims) + "', '" + str(countDims) + "')"
    simpleCmdParser=ws.sendJSCommand(command)
    resultCode=simpleCmdParser.getResultCode()
    print(command)
    if resultCode > 0:
        print ("Return code: " + str(resultCode))
        print (simpleCmdParser.getErrorText())
        return None
    else:
        # on successful run the return value is None from the server and as such the getJSEngineResult result is useless for us here
        #cmdResult = simpleCmdParser.getJSEngineResult()
        #return cmdResult
        return True
    

def writeRawChannelData(ws, varName, handle, fromDims, countDims):
    command="FemtoAPIFile.writeRawChannelData(" + str(varName) + ", '" + str(handle) + "', '" + str(fromDims) + "', '" + str(countDims) + "')"
    simpleCmdParser=ws.sendJSCommand(command)
    resultCode=simpleCmdParser.getResultCode()
    if resultCode > 0:
        print ("Return code: " + str(resultCode))
        print (simpleCmdParser.getErrorText())
        return None
    else:
        cmdResult = simpleCmdParser.getJSEngineResult()
        return cmdResult
    

def writeChannelData(ws, varName, handle, fromDims, countDims):
    command="FemtoAPIFile.writeChannelData(" + str(varName) + ", '" + str(handle) + "', '" + str(fromDims) + "', '" + str(countDims) + "')"
    simpleCmdParser=ws.sendJSCommand(command)
    resultCode=simpleCmdParser.getResultCode()
    if resultCode > 0:
        print ("Return code: " + str(resultCode))
        print (simpleCmdParser.getErrorText())
        return None
    else:
        cmdResult = simpleCmdParser.getJSEngineResult()
        return cmdResult

    
def writeRawChannelDataFromAttachment(ws, buffer, handle, fromDims, countDims):
    command="FemtoAPIFile.writeRawChannelDataFromAttachment('" + str(handle) + "', '" + str(fromDims) + "', '" + str(countDims) + "')"
    ws.uploadAttachment(buffer)
    simpleCmdParser=ws.sendJSCommand(command)
    resultCode=simpleCmdParser.getResultCode()
    if resultCode > 0:
        print ("Return code: " + str(resultCode))
        print (simpleCmdParser.getErrorText())
        return None
    else:
        cmdResult = simpleCmdParser.getJSEngineResult()
        return cmdResult


def writeChannelDataFromAttachment(ws, buffer, handle, fromDims, countDims):
    command="FemtoAPIFile.writeChannelDataFromAttachment('" + str(handle) + "', '" + str(fromDims) + "', '" + str(countDims) + "')"
    ws.uploadAttachment(buffer)
    simpleCmdParser=ws.sendJSCommand(command)
    resultCode=simpleCmdParser.getResultCode()
    if resultCode > 0:
        print ("Return code: " + str(resultCode))
        print (simpleCmdParser.getErrorText())
        return None
    else:
        cmdResult = simpleCmdParser.getJSEngineResult()
        return cmdResult
