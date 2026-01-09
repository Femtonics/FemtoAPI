# The FemtoAPI command reference
This section details the syntax and the semantics of the commands that can be sent from the FemtoAPI client to the FemtoAPI server. As discussed above, these commands are sent with the following C++ method:

virtual ReplyMessageParser::ReleasePtr APIWebSocketClient::sendJSCommand(const QString &message)

FemtoAPIFile namespace contains functions used for processing. These functions can be used on all machines with an installed MESc (ver 4.5) and a valid API license. E.g.: **ATLAS** systems, processing setups with MES8.

FemtoAPIMicroscope namespace contains the functions used for measurement control. These are only used with **Femto Smart** systems.

  


***Warning:*** *UNSAFE commands*

**The commands marked as UNSAFE do not yet properly isolate the GUI and the API from each other. Please do not manipulate the MESc GUI while running one or more of these UNSAFE commands through the FemtoAPI, because this can lead to unwanted parameter settings in the MESc GUI.** 

  


## List of commands:

#### FemtoAPIFile namespace

Get/set processing state: 

* *getProcessingState()(API2-A-1448161786)*

Read/write channel data: 

* *readRawChannelDataToClientsBlob(handle, fromDims, countDims)(API2-A-1448161789)*
* *readChannelDataToClientsBlob(handle, fromDims, countDims)(API2-A-1448161789)*
* *readRawChannelDataJSON(handle, fromDims, countDims)(API2-A-1448161789)*
* *readChannelDataJSON(handle, fromDims, countDims)(API2-A-1448161789)*
* *readRawChannelData(handle, fromDims, countDims)(API2-A-1448161789)*
* *readChannelData(handle, fromDims, countDims)(API2-A-1448161789)*
* *writeRawChannelData(data, handle, fromDims, countDims)(API2-A-1448161789)*
* *writeChannelData(data, handle, fromDims, countDims)(API2-A-1448161789)*
* *writeRawChannelDataFromAttachment(handle, fromDims, countDims)(API2-A-1448161789)*
* *writeChannelDataFromAttachment(handle, fromDims, countDims)(API2-A-1448161789)*
* *addLastFrameToMSession(sDestMSession, SpaceName)(API2-A-1448161789)*

File operations:

* *createNewFile()(API2-A-1448161791)*
* *setCurrentFile(handle)(API2-A-1448161791)*
* *saveFileAsync( fileHandle = '')(API2-A-1448161791)*
* *saveFileAsAsync(newAbsoluteUnicodePath, fileHandle = '', overWriteExistingFile = false)(API2-A-1448161791)*
* *closeFileNoSaveAsync(fileHandle = '')(API2-A-1448161791)*
* *closeFileAndSaveAsync(fileHandle = '', compressFileIfPossible = false)(API2-A-1448161791)*
* *closeFileAndSaveAsAsync(newAbsoluteFilePath, fileHandle = '', overWriteExistingFile = false, compressFileIfPossible = false)(API2-A-1448161791)*
* *openFilesAsync(filePaths)(API2-A-1448161791)*

Get/set properties for measurement items:

* getUnitMetadata(nodeDescriptor, jsonItemStr, subscribe = "")(API2-A-2400223233)
* setUnitMetadata(nodeDescriptor, jsonItemStr)(API2-A-2400223233)
* setUnitMetadata(nodeDescriptor, jsonItemStr, json)(API2-A-2400223233)
* getDisplayedProperties(nodeDescriptor, bDetailed)(API2-A-2400223233)

Measurement unit operations:

* *createTimeSeriesMUnit(xDim, yDim, taskXMLParameters,viewportJson, z0InMs = 0.0, zStepInMs = 1.0, zDimInitial = 1)(API2-A-1448161796)*
* *createZStackMUnit(xDim, yDim, zDim, taskXMLParameters,viewportJson, zStepInMicrons = 1.0)(API2-A-1448161796)*
* *extendMUnit(nodeDescriptor, countDims)(API2-A-1448161796)*
* *deleteMUnit(nodeDescriptor)(API2-A-1448161796)*
* *copyMUnit(sSourceMImage, sDestMSession, bCopyChannelContents = true)(API2-A-1448161796)*
* *moveMUnit(sSourceMImage, sDestMSession)(API2-A-1448161796)*

MultiROI operations:

* *createBackgroundFrame(xDim, yDim, technologyType, backgroundImageRole, viewportJson, fileNodeDescriptor = '', t0InMs = 0.0, deltaTInMs = 1.0, tDimInitial = 1)(API2-A-1448161829)*
* *createBackgroundZStack(xDim, yDim, zDim, technologyType, backgroundImageRole, viewportJson, fileNodeDescriptor = '', zStepInMicrons = 1.0)(API2-A-1448161829)*
* *createMultiROI2DMUnit(xDim, tDim, methodType, backgroundImagePath, deltaTInMs = 1.0, t0InMs= 0.0)(API2-A-1448161829)*
* *createMultiROI3DMUnit(xDim, yDim, tDim, methodType, backgroundImagePath, deltaTInMs = 1.0, t0InMs= 0.0)(API2-A-1448161829)*
* *createMultiROI4DMUnit(xDim, yDim, zDim, tDim, methodType, backgroundImagePath, deltaTInMs = 1.0, t0InMs= 0.0)(API2-A-1448161829)*

Channel operations: 

* *addChannel(nodeDescriptor, channelName(API2-A-1448161798) , c(API2-A-1448161798) ompressionPreset = 0)(API2-A-1448161798)*
* *deleteChannel(nodeDescriptor)(API2-A-1448161798)*

Curve operations: 

* *deleteCurve(nodeDescriptor, idxCurve)(API2-A-1448161813)*
* *addCurve(nodeDescriptor, name, xType, xDataType, yType, yDataType)(API2-A-1448161813)*
* *curveInfo(nodeDescriptor, idxCurve)(API2-A-1448161813)*
* *appendToCurveRaw(nodeDescriptor, idxCurve, size, xType, xDataType, yType, yDataType)(API2-A-1448161813)*
* *appendToCurve(nodeDescriptor, idxCurve, size, xType, xDataType, yType, yDataType)(API2-A-1448161813)*
* *readCurveRaw(nodeDescriptor, idxCurve, vectorFormat, forceDouble)(API2-A-1448161813)*
* *readCurve(nodeDescriptor, idxCurve, vectorFormat, forceDouble)(API2-A-1448161813)*

Tools:

* *modifyConversion(conversionName, scale, offset, bSave = false)(API2-A-1448161797)*
* *getStatus(commandID)(API2-A-1448161797)*
* *getStatus()(API2-A-1448161797)*
* *getCommandSetVersion()(API2-A-1448161797)*
* *getLastCommandError()(API2-A-1448161797)*

Export:

* *createTmpTiff('identifier', nodeDescriptor, applyLUT\[, channels, compress, breakView, exportRawData, startTimeSlice, endTimeSlice]);(API2-A-2392000945)*
* *getTmpTiff('identifier')(API2-A-2392000945)*
* *cancelTiff('identifier')(API2-A-2392000945)*

Metadata and event related functions:

* *getChildTree('handler')(API2-A-1448161811)*
* *getFileList(\[,'subscribe' | 'unsubscribe'])(API2-A-1448161811)*
* *getFileMetadata('fileHandler'\[,'subscribe' | 'unsubscribe'])(API2-A-1448161811)*
* *getSessionMetadata('sessionHandler'\[,'subscribe' | 'unsubscribe'])(API2-A-1448161811)*
* *setSessionMetadata('sessionHandler',JSON)(API2-A-1448161811)*
* *getUnitMetadataJson('unitHandler', 'JsonItemName',\[ ,'subscribe' | 'unsubscribe'])(API2-A-1448161811)*
* *setUnitMetadataJson('unitHandler','JsonItemName', JSON)(API2-A-1448161811)*

Events:

* *fileListChanged()(API2-A-1448161811)*
* *fileMetadataChanged()(API2-A-1448161811)*
* *sessionMetadataChanged()(API2-A-1448161811)*
* *unitMetadataChanged()(API2-A-1448161811)*

Space commands:

* *setPointsToSpace('nodeDescriptor', 'spaceName', bAppend=false)*

#### FemtoAPIMicroscope namespace

Getting states: 

* *getMicroscopeState()(API2-A-1448161787)*
* *getAcquisitionState()(API2-A-1448161788)*

Start/stop measurements, setting duration: 

* *startGalvoScanSnapAsync()(API2-A-1448161790)*
* *startGalvoScanAsync()(API2-A-1448161790)*
* *stopGalvoScanAsync()(API2-A-1448161790)*
* *startResonantScanSnapAsync()(API2-A-1448161790)*
* *startResonantScanAsync()(API2-A-1448161790)*
* *stopResonantScanAsync()(API2-A-1448161790)*
* *setMeasurementDuration(duration, taskName = '', spaceName = '')(API2-A-1448161799)*

Manipulating axis positions:

* *getAxisPositions()(API2-A-1448161794)*
* *getAxisPosition(axisName, spaceName = '')(API2-A-1448161794)*
* *setAxisPosition(axisName, newPosition, isRelativePosition=true, isRelativeToCurrentPosition=true, spaceName = '')(API2-A-1448161794)*
* doZero(axisName, spaceName = '')(API2-A-1448161794)
* isAxisMoving(axisName, spaceName = '')(API2-A-1448161794)

Get/set Z-stack device intensity depth profile: 

* *getZStackLaserIntensityProfile(measurementType = '', spaceName = '')(API2-A-1448161793)*
* *setZStackLaserIntensityProfile(json)(API2-A-1448161793)*

Get/set imaging window parameters: 

* *getImagingWindowParameters(measurementType = '', spaceName = '')(API2-A-1448161792)*
* *setImagingWindowParameters(json)(API2-A-1448161792)*

Get/set device values: 

* *getPMTAndLaserIntensityDeviceValues()(API2-A-1448161795)*
* *setPMTAndLaserIntensityDeviceValues(json)(API2-A-1448161795)*

Tools: 

* *setFocusingMode(focusingMode, spaceName = '')(API2-A-1448161797)*
* *getFocusingModes(spaceName = '')(API2-A-1448161797)*
* *getActiveProtocol()(API2-A-1448161797)*
* *setActiveTaskAndSubTask(taskName, subTaskName = '')(API2-A-1448161797)*
* *getCommandSetVersion()(API2-A-1448161797)*
* *getLastCommandError()(API2-A-1448161797)*

  


  


  
