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


# ---------------------------------------------------------------------
"""
This source contains a collection of the FemtoAPI calls
Python API wrapper functions for femtoAPI 2.0 version
"""


import sys, time, array, random, shutil
from PySide2.QtCore import *
from PySide2.QtWebSockets import *
from femtoapi import PyFemtoAPI
import json
from pathlib import Path

def initConnection(host = 'ws://localhost:8888'):
    """
    creates the websocket object used in all communications with the API server
    the URL can be changed in the PyFemtoAPI.APIWebSocketClient call if the API server is running on a different machine, default port is set to 8888 in MESc
    returns the ws object which is used in all other functions
    """
    ws=PyFemtoAPI.APIWebSocketClient(host)
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
    """
    Enables signaling on websocket
    """
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
    """
    Check is signaling enabled on websocket
    """
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
    """
    Returns the list of the opened files. With the "string" argument ('subscribe'|'unsubscribe') you can subscribe for opening/closing files.
    """
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
    """
    Returns the metadata JSON of the opened file defined by "handle". With the "string" argument ('subscribe'|'unsubscribe') you can subscribe for opening/closing the file.
    """
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
    """
    Returns the metadata JSON of MSESSION section of the specific session described by "handle". With the "string" argument ('subscribe'|'unsubscribe') you can subscribe for opening/closing the session.
    """
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
        ReferenceViewport
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
        BreakView
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
        return None
    else:
        #print(simpleCmdParser.getJSEngineResult())
        cmdResult = simpleCmdParser.getJSEngineResult()
        if cmdResult:
            cmdResult = json.loads(cmdResult)
        return cmdResult


def setUnitMetadata(ws, handle, JsonItemName, jsonString):
    """
    Sets the metadata of "JsonItemName" in unit defined by "handle". "jsonString" argument must be the the modified result of "getSessionMetadataJson()" function.
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
    """
    Returns with the file tree. With no handle argument, returns the whole file tree. Otherwise returns the file, session or unit property tree, according to the given "handle" argument.
    """
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


def getCurrentSession(ws, string=""):
    """
    Returns with the handler of the actual session in JSON format. With "string" argument the client subscribes on changes.
    """
    if not string:
        command = "FemtoAPIFile.getCurrentSession()"
    else:
        command = "FemtoAPIFile.getCurrentSession('" + string + "')"
    simpleCmdParser=ws.sendJSCommand(command)
    resultCode=simpleCmdParser.getResultCode()
    #logging.info(resultCode)
    if resultCode > 0:
        print("Return code: " + str(resultCode))
        print(simpleCmdParser.getErrorText())
        return None
    else:
        cmdResult = simpleCmdParser.getJSEngineResult()
        return cmdResult


def setCurrentSession(ws, handle):
    """
    Sets the current session according to the "handle" given.
    """
    command="FemtoAPIFile.setCurrentSession('" + handle + "')"
    simpleCmdParser=ws.sendJSCommand(command)
    resultCode=simpleCmdParser.getResultCode()
    #logging.info(resultCode)
    if resultCode > 0:
        print("Return code: " + str(resultCode))
        print(simpleCmdParser.getErrorText())
        return None
    else:
        cmdResult = simpleCmdParser.getJSEngineResult()
        return cmdResult

    
def getProcessingState(ws):
    """
    DEPRECATED
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
    """
    Starts a galvo XY scan snap asynchronously
    """
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
    """
    Starts a galvo XY scan asynchronously
    """
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
    """
    Stops a galvo XY scan asynchronously.
    """
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
    """
    Starts a resonant scan snap asynchronously.
    """
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
    """
    Starts a resonant scan asynchronously
    """
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
    """
    Stops a resonant scan asynchronously
    """
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
    """
    Creates a new, unnamed file, and sets it as the current file (i.e., the file where new measurements are placed).
    As this file has no name yet, you cannot permanently save it with saveFileAsync or closeFileAndSaveAsync.
    To do so, you need to give it a name and a destination folder with saveFileAsAsync or closeFileAndSaveAsAsync
    """
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
    DEPRECATED , removed
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
    resultCode=simpleCmdParser.getResultCode()
    if resultCode > 0:
        print ("Return code: " + str(resultCode))
        print (simpleCmdParser.getErrorText())
        return None
    else:	
        cmdResult = json.loads(simpleCmdParser.getJSEngineResult())
        return cmdResult


def openFilesAsync(ws, filePath):
    """
    Opens one or more file(s) asynchronously
    """
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
    """
    Returns True if specified axis movement is in progress
    """
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
    """
    Sets the axis relative position to 0.0, and sets the labeling origin to the current absolute position
    """
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


def createTimeSeriesMUnit(ws, xDim, yDim, taskXMLParameters, viewportJson, z0InMs = 0.0, zStepInMs = 1.0, zDimInitial = 1):
    """
    available types in taskXMLParameters : TaskResonantCommon, TaskFastXYGalvo, TaskAOFullFrame
    *from mesc veresion 4.5 taskXMLParameters is replaced by a single string containing the scaning mode: galvo, resonant, AOFullFrame
    
    
    xDim: measurement image x resolution 
    yDim: measurement image y resolution 
    taskXMLParameters: measurementParamsXML for resonant/galvo/AO fullframe scan time series measurement.
        *from mesc veresion 4.5 taskXMLParameters is replaced by a single string containing the scanin mode: galvo, resonant, AO
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



def createZStackMUnit(ws, xDim, yDim, zDim, taskXMLParameters, viewportJson, zStepInMicrons = 1.0):
    """
    Creates new measurement unit for galvo/resonant/AO fullframe scan time series measurement
    """
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


def createVolumeScanMUnit(ws, xDim, yDim, zDim, tDim, technologyType, referenceViewportJson):
    command="FemtoAPIFile.createVolumeScanMUnit(" + str(xDim) + ", " + str(yDim)+ ", " + str(zDim)+ ", " + str(tDim) + ", '" + technologyType + "', '" + referenceViewportJson + "')"
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


def createMultiLayerMUnit(ws, xDim, yDim, tDim, technologyType, referenceViewportJson):
    command="FemtoAPIFile.createMultiLayerMUnit(" + str(xDim) + ", " + str(yDim)+ ", " + str(tDim) + ", '" + technologyType + "', '" + referenceViewportJson + "')"
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


#MESc version 4.5 and above only
def createBackgroundFrame(ws, xDim, yDim, technologyType: str, backgroundImageRole: str, viewportJson: str, fileNodeDescriptor = '', z0InMs = 0.0, zStepInMs = 1.0, zDimInitial = 1):
    """
    Creates new measurement session and a time series measurement unit in it with the specified
    technology type, and adds one (or optionally more) frame to it.
    This measurement session is special: it cannot be target of new measurements,
    and only multiROI images can be created in it.
    """
    command="FemtoAPIFile.createBackgroundFrame(" + str(xDim) + ", " + str(yDim) + ", '" + technologyType + "', '" + backgroundImageRole + "', '" + viewportJson + "', '" + fileNodeDescriptor + "', z0InMs = " + str(z0InMs) + ", zStepInMs = " + str(zStepInMs) + ", zDimInitial = " + str(zDimInitial) + ")"
    simpleCmdParser=ws.sendJSCommand(command)
    resultCode=simpleCmdParser.getResultCode()
    if resultCode > 0:
        print ("Return code: " + str(resultCode))
        print (simpleCmdParser.getErrorText())
        return None
    else:
        cmdResult = json.loads(simpleCmdParser.getJSEngineResult())
        return cmdResult

#MESc version 4.5 and above only
def createBackgroundZStack(ws, xDim, yDim, zDim, technologyType: str, backgroundImageRole: str, viewportJson: str, fileNodeDescriptor = '', zStepInMicrons = 1.0):
    """
    Creates new measurement session and a z-stack series measurement unit in it with the
    specified technology type, This measurement session is special:
    it cannot be target of new measurements, and only multiROI images can be created in it. 
    """
    command="FemtoAPIFile.createBackgroundZStack(" + str(xDim) + ", " + str(yDim) + ", " + str(zDim) + ", '" + technologyType + "', '" + backgroundImageRole + "', '" + viewportJson + "', '" + fileNodeDescriptor + "', zStepInMicrons = " + str(zStepInMicrons) +  ")"
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
    command="FemtoAPIFile.createMultiROI2DMUnit(" + str(xDim) + ", " + str(tDim) + ", '" +  methodType + "', '" + str(backgroundImagePath) + "', deltaTInMs = " + str(deltaTInMs) + ", t0InMs = " + str(t0InMs) + ")"
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
    command="FemtoAPIFile.createMultiROI3DMUnit(" + str(xDim) + ", " + str(yDim) + ", " + str(tDim) + ", '" +  methodType + "', '" + str(backgroundImagePath) + "', deltaTInMs = " + str(deltaTInMs) + ", t0InMs = " + str(t0InMs) + ")"
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
    command="FemtoAPIFile.createMultiROI4DMUnit(" + str(xDim) + ", " + str(yDim) + ", " + str(zDim) + ", " + str(tDim) + ", '" +  methodType + "', '" + str(backgroundImagePath) + "', deltaTInMs = " + str(deltaTInMs) + ", t0InMs = " + str(t0InMs) + ")"
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
    """
    Extends a measurement unit given by 'mUnitHandle' with the number of frames 'countDims'.
    """
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
    """
    Deletes a measurement unit from a .mesc file given by 'mUnitHandle' .
    """
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
    command="FemtoAPIFile.copyMUnit('" + str(sourceMUnitHandle) + "', '" + str(destMSessionHandle) + "', " + str(bCopyChannelContents) + ")"
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
    """
    Adds a new channel to the measurement unit with the given channel name,
    if there is no existing channel with this name, otherwise 'false' is set
    in the returned json. 
    """
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
    """
    Removes the specified channel. If there is no channel exists
    with the given channel handle, 'false' is set in the returned json.
    """
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
    """
    Creates a new MUnit in the given MSession, and adds the frame
    on the immediate window (last frame of a measurement/live or snap) to it.
    If "destMSessionHandle" parameter  is empty string, the current MSession
    is considered. Last frame is considered as the frame of immediate window
    of the space given by "space", or from the default space if "space" is empty.
    """
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
    return value:
        result: it is the file size if file found, None if filepath is not valid
        data: binary data
    """
    command="FemtoAPIFile.sendFileToClientsBlob('" + str(sPathAndFileName) + "')"
    simpleCmdParser=ws.sendJSCommand(command)
    resultCode=simpleCmdParser.getResultCode()
    if resultCode > 0:
        print ("Return code: " + str(resultCode))
        print (simpleCmdParser.getErrorText())
        return None
    else:
        cmdResult = {}
        binaryData = QByteArray()
        for parts in simpleCmdParser.getPartList():
            binaryData.append(parts)
            print( "Binary part sizes: " + str(parts.size()))
        cmdResult.update({"data": binaryData}) 
        cmdResult.update({"result": simpleCmdParser.getJSEngineResult()})
        return cmdResult


def saveAttachmentToFile(ws, sPathAndFileName):
    """
    If there is data attached to the websocket session it is gonna be saved as the given file.
    ws.uploadAttachment() function can be used for attaching data to the websocket session.
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
    """
    Returns information about the selected curve
    """
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


def readCurve(ws, mUnitHandle, curveIdx, vectorFormat: bool = True, forceDouble: bool = True):
    """
    returns a dictionary with 2 elements
    Result: contains data about the specified curve
    BinaryData: is a dictionary with 2 elements
        - 'xData' is a list with the x data of the curve
        - 'yData' is a list with the y data of the curve
    the elements of these 2 list make up data pairs (xData[0] - yData[0], xData[1] - yData[1], etc.)
    """
    if vectorFormat:
        vFormat = 'true'
    else:
        vFormat = 'false'
    if forceDouble:
        fDouble = 'true'
    else:
        fDouble = 'false'
    command="FemtoAPIFile.readCurve('" + str(mUnitHandle) + "', '" + str(curveIdx) + "', " + str(vFormat) + ", " + str(fDouble) + ")"
    #print(command)
    simpleCmdParser=ws.sendJSCommand(command)
    #print(simpleCmdParser.hasBinaryParts())
    resultCode=simpleCmdParser.getResultCode()
    if resultCode > 0:
        print ("Return code: " + str(resultCode))
        print (simpleCmdParser.getErrorText())
        return None
    else:
        cmdResult = {}
        result = json.loads(simpleCmdParser.getJSEngineResult())
        cmdResult.update({"Result": result})
        dataSize = result['size']
        xType = result['xType']
        yType = result['yType']
        xDataType = result['xDataType']
        yDataType = result['yDataType']

        xData = []
        yData = []
        curveData = {"xData": xData, "yData": yData}
        cntr = 0
        raw_data = QByteArray()
        for parts in simpleCmdParser.getPartList():
            raw_data.append(parts)
            
            xSize = 0
            if xType == 'vector':
                xSize = dataSize
            else:
                xSize = 2
            
        stream = QDataStream(raw_data)
        stream.setByteOrder(QDataStream.ByteOrder.LittleEndian)
        while not stream.atEnd():
            if cntr < xSize:
                if xDataType == 'double':
                    tmpData = stream.readDouble()
                    curveData["xData"].append(tmpData)
                else:
                    tmpData = stream.readUInt16()
                    curveData["xData"].append(tmpData)
            else:
                if yType== 'rle':
                    if yDataType == 'double':
                        tmpData = stream.readUInt32()
                        curveData["yData"].append(tmpData)
                        tmpData = stream.readDouble()
                        curveData["yData"].append(tmpData)
                    else:
                        tmpData = stream.readUInt32()
                        curveData["yData"].append(tmpData)
                        tmpData = stream.readUInt16()
                        curveData["yData"].append(tmpData)
                else:
                    if yDataType == 'double':
                        tmpData = stream.readDouble()
                        curveData["yData"].append(tmpData)
                    else:
                        tmpData = stream.readUInt16()
                        curveData["yData"].append(tmpData)
            cntr += 1
                
        cmdResult.update({"CurveData": curveData})                 
        return cmdResult

    
def deleteCurve(ws, mUnitHandle, curveIdx):
    """
    Deletes a curve
    """
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

#might change in the future
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

#function might not be fully functional
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
    """
    Gets the available (configured) focusing modes for the specified space
    in json array, as it can be seen in the MESc GUI.
    If space name is not given, default space ('space1') is considered.
    """
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
    """
    Switches to the given focusing mode  'sfocusingMode', if it is valid.
    """
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
    """
    Gets the error information of the last issued command.
    """
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
    """
    Gets the error information of the last issued command
    """
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
    """
    Sets measurement duration for the given task and space. If taskName is empty,
    the current active task is considered. If spaceName is empty,
    default space ('space1') is considered
    """
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
        cmdResult = {}
        result = simpleCmdParser.getJSEngineResult()
        cmdResult.update({"result": result})
        if filePath:
            binaryData = QByteArray()
            for parts in simpleCmdParser.getPartList():
                binaryData.append(parts)
            tmp = binaryData.data()
            with open(filePath, "wb") as f:
                f.write(tmp)
            return cmdResult
        else:
            binaryData = QByteArray()
            for parts in simpleCmdParser.getPartList():
                binaryData.append(parts)
            cmdResult.update({"data": binaryData}) 
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
        cmdResult = {}
        result = json.loads(simpleCmdParser.getJSEngineResult())
        cmdResult.update({"result": result})
        if filePath:
            binaryData = QByteArray()
            for parts in simpleCmdParser.getPartList():
                binaryData.append(parts)
            print("Res type: " + str(type(binaryData)) + ", Res size: "  + str(binaryData.size()))
            tmp = binaryData.data()
            with open(filePath, "wb") as f:
                f.write(tmp)
            return cmdResult
        else:
            binaryData = QByteArray()
            for parts in simpleCmdParser.getPartList():
                binaryData.append(parts)
            cmdResult.update({"data": binaryData}) 
            return cmdResult


def readRawChannelDataJSON(ws, handle, fromDims, countDims):
    """
    The server sends the requested raw image data as a JSON string to the FemtoAPI client
    """
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
    """
    The server sends the requested converted image data as a JSON string to the FemtoAPI client.
    """
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
    """
    Reads raw channel data on the server side to a JavaScript variable.
    """
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
    """
    Reads converted channel data on the server side into a JavaScript variable. 
    """
    command="var " + varName + " = FemtoAPIFile.readChannelData('" + str(handle) + "', '" + str(fromDims) + "', '" + str(countDims) + "')"
    simpleCmdParser=ws.sendJSCommand(command)
    resultCode=simpleCmdParser.getResultCode()
    #print(command)
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
    """
    Writes raw channel data from the variable to the specified
    sub-hyperrectangle. The variable should be of the same type
    as the channel to write specified by handle, and the
    sub-hyperrectangle specified by fromDims and countDims
    must fulfill the conditions described in the introduction.
    """
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
    """
    Writes the converted data from a variable.
    """
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
    """
    Writes the specified raw data from an attached binary data file.
    The attached binary data type must be the same as the
    channel data type of the specified data, and the fromDims
    and countDims parameters must fulfill the conditions
    described in the introduction.
    """
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
    """
    Writes the specified converted data from an attached binary data file.
    The attached binary data type must be the same as the
    channel data type of the specified data.
    """
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


def getTmpTiff(ws, uId, filePath):
    print('gettif')
    command = "FemtoAPIFile.getTmpTiff('" + uId + "')"
    simpleCmdParser=ws.sendJSCommand(command)
    resultCode=simpleCmdParser.getResultCode()
    if resultCode > 0:
        print ("Return code: " + str(resultCode))
        print (simpleCmdParser.getErrorText())
        return None
    else:
        result =  simpleCmdParser.getJSEngineResult()
        print ("getTiff result: " + str(result))
        cmdResult = QByteArray()
        for parts in simpleCmdParser.getPartList():
            cmdResult.append(parts)
        with open(Path(filePath), "wb") as f:
            f.write(cmdResult.data())
        return True

            
def tiffExport(ws, filePath, handle, applyLut, channelList = '', compressed = 1, breakView = 0, exportRawData = 0, startTimeSlice = 0, endTimeSlice = ''):
    filePath = Path(filePath)
    rndm = random.randrange(0, 1000000)
    uId = 'tmptif_' + str(rndm)
    command="FemtoAPIFile.createTmpTiff('" + uId + "', '" + str(handle) + "', " + str(applyLut) + ",'" + str(channelList) + "'," + str(compressed) + "," + str(breakView) + "," + str(exportRawData) + "," + str(startTimeSlice) + "," + str(endTimeSlice) + ")"
    simpleCmdParser=ws.sendJSCommand(command)
    resultCode=simpleCmdParser.getResultCode()
    if resultCode > 0:
        print ("Return code: " + str(resultCode))
        print (simpleCmdParser.getErrorText())
        return None
    else:
        createTiffRes =  simpleCmdParser.getJSEngineResult()
        print ("createTmpTiff result: " + str(createTiffRes))
        cmdResult = QByteArray()
        for parts in simpleCmdParser.getPartList():
            cmdResult.append(parts)
        tmp = cmdResult.data()
        mDataFile = Path(filePath.parent, str(filePath.name) + '.metadata.txt')
        with open(mDataFile, "wb") as f:
            f.write(tmp)
        if ws.getUrl().toString == 'ws://localhost:8888':
            tmpPath = Path(createTiffRes['tmp'])
            shutil.move(tmpPath, filePath)
        else:
            result = getTmpTiff(ws, uId, filePath)
        return result
   
    
