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

## This source contains a collection of the FemtoAPI 2.0 calls available for the Atlas systems



import sys, time, array
from PySide2.QtCore import *
from PySide2.QtWebSockets import *
from femtoapi import PyFemtoAPI
import json

def initConnection():
    """
    creates the websocket object used in all communications with the API server
    the URL can be changed in the PyFemtoAPI.APIWebSocketClient call if the API server is running on a different machine, default port is set to 8888 in MESc
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
    returns information about the opened files
    handle defines the range of data returned, can be empty, file level('10'), session level('10,0') and munit level('10,0,0')
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


def createTimeSeriesMUnit(ws, xDim, yDim, taskXMLParameters, viewportJson, z0InMs = 0.0, zStepInMs = 1.0, zDimInitial = 1):
    """
    xDim: measurement image x resolution 
    yDim: measurement image y resolution
    
    taskXMLParameters: previously measurementParamsXML for resonant/galvo/AO fullframe scan time series measurement.
    In MESc version 4.5 taskXMLParameters is replaced by a single string containing the scanin mode: galvo, resonant, aO
       
    viewportJson: viewport for measurement 
    z0InMs: Measurement start time offset in ms. Double, default value is 0.0 
    zStepInMs: Frame duration time in ms (1/frame rate). Positive double, default value is 1.0. 
    zDimInitial: Number of frames to create in z dimension. Positive integer, default value is 1.
    """
    command="FemtoAPIFile.createTimeSeriesMUnit(" + str(xDim) + ", " + str(yDim) + ", '" + taskXMLParameters + "', '" + viewportJson + "', z0InMs = " + str(z0InMs) + ", zStepInMs = " + str(zStepInMs) + ", zDimInitial = " + str(zDimInitial) + ")"
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


def createZStackMUnit(ws, xDim, yDim, zDim, taskXMLParameters, viewportJson, zStepInMicrons = 1.0):
    """
    zDim: number of Z planes

    rest of the parameters are the same as in createTimeSeriesMUnit
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
        print ("readChannelDataToClientsBlob result: " + simpleCmdParser.getJSEngineResult())
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
    print(filePath)
    if not filePath.parent.exists():
        print("tiffExport error: Filepath directory does not exists.")
        return None
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
