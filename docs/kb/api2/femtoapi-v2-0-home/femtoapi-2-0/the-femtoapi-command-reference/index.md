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

* *getProcessingState() ([Get processing state](get-processing-state.md))*

Read/write channel data: 

* *readRawChannelDataToClientsBlob(handle, fromDims, countDims) ([Read-write binary channel data](read-write-binary-channel-data.md))*
* *readChannelDataToClientsBlob(handle, fromDims, countDims) ([Read-write binary channel data](read-write-binary-channel-data.md))*
* *readRawChannelDataJSON(handle, fromDims, countDims) ([Read-write binary channel data](read-write-binary-channel-data.md))*
* *readChannelDataJSON(handle, fromDims, countDims) ([Read-write binary channel data](read-write-binary-channel-data.md))*
* *readRawChannelData(handle, fromDims, countDims) ([Read-write binary channel data](read-write-binary-channel-data.md))*
* *readChannelData(handle, fromDims, countDims) ([Read-write binary channel data](read-write-binary-channel-data.md))*
* *writeRawChannelData(data, handle, fromDims, countDims) ([Read-write binary channel data](read-write-binary-channel-data.md))*
* *writeChannelData(data, handle, fromDims, countDims) ([Read-write binary channel data](read-write-binary-channel-data.md))*
* *writeRawChannelDataFromAttachment(handle, fromDims, countDims) ([Read-write binary channel data](read-write-binary-channel-data.md))*
* *writeChannelDataFromAttachment(handle, fromDims, countDims) ([Read-write binary channel data](read-write-binary-channel-data.md))*
* *addLastFrameToMSession(sDestMSession, SpaceName) ([Read-write binary channel data](read-write-binary-channel-data.md))*

File operations:

* *createNewFile() ([Handling measurement files](handling-measurement-files.md))*
* *setCurrentFile(handle) ([Handling measurement files](handling-measurement-files.md))*
* *saveFileAsync( fileHandle = '') ([Handling measurement files](handling-measurement-files.md))*
* *saveFileAsAsync(newAbsoluteUnicodePath, fileHandle = '', overWriteExistingFile = false) ([Handling measurement files](handling-measurement-files.md))*
* *closeFileNoSaveAsync(fileHandle = '') ([Handling measurement files](handling-measurement-files.md))*
* *closeFileAndSaveAsync(fileHandle = '', compressFileIfPossible = false) ([Handling measurement files](handling-measurement-files.md))*
* *closeFileAndSaveAsAsync(newAbsoluteFilePath, fileHandle = '', overWriteExistingFile = false, compressFileIfPossible = false) ([Handling measurement files](handling-measurement-files.md))*
* *openFilesAsync(filePaths) ([Handling measurement files](handling-measurement-files.md))*

Get/set properties for measurement items:

* getUnitMetadata(nodeDescriptor, jsonItemStr, subscribe = "") ([Get-set properties for measurement items](get-set-properties-for-measurement-items.md))
* setUnitMetadata(nodeDescriptor, jsonItemStr) ([Get-set properties for measurement items](get-set-properties-for-measurement-items.md))
* setUnitMetadata(nodeDescriptor, jsonItemStr, json) ([Get-set properties for measurement items](get-set-properties-for-measurement-items.md))
* getDisplayedProperties(nodeDescriptor, bDetailed) ([Get-set properties for measurement items](get-set-properties-for-measurement-items.md))

Measurement unit operations:

* *createTimeSeriesMUnit(xDim, yDim, taskXMLParameters,viewportJson, z0InMs = 0.0, zStepInMs = 1.0, zDimInitial = 1) ([MUnit manipulations](munit-manipulations.md))*
* *createZStackMUnit(xDim, yDim, zDim, taskXMLParameters,viewportJson, zStepInMicrons = 1.0) ([MUnit manipulations](munit-manipulations.md))*
* *extendMUnit(nodeDescriptor, countDims) ([MUnit manipulations](munit-manipulations.md))*
* *deleteMUnit(nodeDescriptor) ([MUnit manipulations](munit-manipulations.md))*
* *copyMUnit(sSourceMImage, sDestMSession, bCopyChannelContents = true) ([MUnit manipulations](munit-manipulations.md))*
* *moveMUnit(sSourceMImage, sDestMSession) ([MUnit manipulations](munit-manipulations.md))*

MultiROI operations:

* *createBackgroundFrame(xDim, yDim, technologyType, backgroundImageRole, viewportJson, fileNodeDescriptor = '', t0InMs = 0.0, deltaTInMs = 1.0, tDimInitial = 1) ([MultiROI commands](multiroi-commands.md))*
* *createBackgroundZStack(xDim, yDim, zDim, technologyType, backgroundImageRole, viewportJson, fileNodeDescriptor = '', zStepInMicrons = 1.0) ([MultiROI commands](multiroi-commands.md))*
* *createMultiROI2DMUnit(xDim, tDim, methodType, backgroundImagePath, deltaTInMs = 1.0, t0InMs= 0.0) ([MultiROI commands](multiroi-commands.md))*
* *createMultiROI3DMUnit(xDim, yDim, tDim, methodType, backgroundImagePath, deltaTInMs = 1.0, t0InMs= 0.0) ([MultiROI commands](multiroi-commands.md))*
* *createMultiROI4DMUnit(xDim, yDim, zDim, tDim, methodType, backgroundImagePath, deltaTInMs = 1.0, t0InMs= 0.0) ([MultiROI commands](multiroi-commands.md))*

Channel operations: 

* *addChannel(nodeDescriptor, channelName ([Add and remove channels](add-and-remove-channels.md)) , c ([Add and remove channels](add-and-remove-channels.md)) ompressionPreset = 0) ([Add and remove channels](add-and-remove-channels.md))*
* *deleteChannel(nodeDescriptor) ([Add and remove channels](add-and-remove-channels.md))*

Curve operations: 

* *deleteCurve(nodeDescriptor, idxCurve) ([Curve operations](curve-operations.md))*
* *addCurve(nodeDescriptor, name, xType, xDataType, yType, yDataType) ([Curve operations](curve-operations.md))*
* *curveInfo(nodeDescriptor, idxCurve) ([Curve operations](curve-operations.md))*
* *appendToCurveRaw(nodeDescriptor, idxCurve, size, xType, xDataType, yType, yDataType) ([Curve operations](curve-operations.md))*
* *appendToCurve(nodeDescriptor, idxCurve, size, xType, xDataType, yType, yDataType) ([Curve operations](curve-operations.md))*
* *readCurveRaw(nodeDescriptor, idxCurve, vectorFormat, forceDouble) ([Curve operations](curve-operations.md))*
* *readCurve(nodeDescriptor, idxCurve, vectorFormat, forceDouble) ([Curve operations](curve-operations.md))*

Tools:

* *modifyConversion(conversionName, scale, offset, bSave = false) ([Tools](tools.md))*
* *getStatus(commandID) ([Tools](tools.md))*
* *getStatus() ([Tools](tools.md))*
* *getCommandSetVersion() ([Tools](tools.md))*
* *getLastCommandError() ([Tools](tools.md))*

Export:

* *createTmpTiff('identifier', nodeDescriptor, applyLUT\[, channels, compress, breakView, exportRawData, startTimeSlice, endTimeSlice]); ([Image Export](image-export.md))*
* *getTmpTiff('identifier') ([Image Export](image-export.md))*
* *cancelTiff('identifier') ([Image Export](image-export.md))*

Metadata and event related functions:

* *getChildTree('handler') ([API file events and query functions](api-file-events-and-query-functions.md))*
* *getFileList(\[,'subscribe' | 'unsubscribe']) ([API file events and query functions](api-file-events-and-query-functions.md))*
* *getFileMetadata('fileHandler'\[,'subscribe' | 'unsubscribe']) ([API file events and query functions](api-file-events-and-query-functions.md))*
* *getSessionMetadata('sessionHandler'\[,'subscribe' | 'unsubscribe']) ([API file events and query functions](api-file-events-and-query-functions.md))*
* *setSessionMetadata('sessionHandler',JSON) ([API file events and query functions](api-file-events-and-query-functions.md))*
* *getUnitMetadataJson('unitHandler', 'JsonItemName',\[ ,'subscribe' | 'unsubscribe']) ([API file events and query functions](api-file-events-and-query-functions.md))*
* *setUnitMetadataJson('unitHandler','JsonItemName', JSON) ([API file events and query functions](api-file-events-and-query-functions.md))*

Events:

* *fileListChanged() ([API file events and query functions](api-file-events-and-query-functions.md))*
* *fileMetadataChanged() ([API file events and query functions](api-file-events-and-query-functions.md))*
* *sessionMetadataChanged() ([API file events and query functions](api-file-events-and-query-functions.md))*
* *unitMetadataChanged() ([API file events and query functions](api-file-events-and-query-functions.md))*

Space commands:

* *setPointsToSpace('nodeDescriptor', 'spaceName', bAppend=false)*

#### FemtoAPIMicroscope namespace

Getting states: 

* *getMicroscopeState() ([Get microscope state](get-microscope-state.md))*
* *getAcquisitionState() ([Get acquisition state](get-acquisition-state.md))*

Start/stop measurements, setting duration: 

* *startGalvoScanSnapAsync() ([Starting and stopping measurements](starting-and-stopping-measurements.md))*
* *startGalvoScanAsync() ([Starting and stopping measurements](starting-and-stopping-measurements.md))*
* *stopGalvoScanAsync() ([Starting and stopping measurements](starting-and-stopping-measurements.md))*
* *startResonantScanSnapAsync() ([Starting and stopping measurements](starting-and-stopping-measurements.md))*
* *startResonantScanAsync() ([Starting and stopping measurements](starting-and-stopping-measurements.md))*
* *stopResonantScanAsync() ([Starting and stopping measurements](starting-and-stopping-measurements.md))*
* *setMeasurementDuration(duration, taskName = '', spaceName = '') ([Setting measurement duration](setting-measurement-duration.md))*

Manipulating axis positions:

* *getAxisPositions() ([Manipulating axis positions](manipulating-axis-positions.md))*
* *getAxisPosition(axisName, spaceName = '') ([Manipulating axis positions](manipulating-axis-positions.md))*
* *setAxisPosition(axisName, newPosition, isRelativePosition=true, isRelativeToCurrentPosition=true, spaceName = '') ([Manipulating axis positions](manipulating-axis-positions.md))*
* doZero(axisName, spaceName = '') ([Manipulating axis positions](manipulating-axis-positions.md))
* isAxisMoving(axisName, spaceName = '') ([Manipulating axis positions](manipulating-axis-positions.md))

Get/set Z-stack device intensity depth profile: 

* *getZStackLaserIntensityProfile(measurementType = '', spaceName = '') ([Get-set ZStack PMT/laser intensity device depth profile](get-set-zstack-pmt-laser-intensity-device-depth-profile.md))*
* *setZStackLaserIntensityProfile(json) ([Get-set ZStack PMT/laser intensity device depth profile](get-set-zstack-pmt-laser-intensity-device-depth-profile.md))*

Get/set imaging window parameters: 

* *getImagingWindowParameters(measurementType = '', spaceName = '') ([Get-set imaging window (viewport) parameters](get-set-imaging-window-viewport-parameters.md))*
* *setImagingWindowParameters(json) ([Get-set imaging window (viewport) parameters](get-set-imaging-window-viewport-parameters.md))*

Get/set device values: 

* *getPMTAndLaserIntensityDeviceValues() ([Get-set PMT/Laserintensity device values](get-set-pmt-laserintensity-device-values.md))*
* *setPMTAndLaserIntensityDeviceValues(json) ([Get-set PMT/Laserintensity device values](get-set-pmt-laserintensity-device-values.md))*

Tools: 

* *setFocusingMode(focusingMode, spaceName = '') ([Tools](tools.md))*
* *getFocusingModes(spaceName = '') ([Tools](tools.md))*
* *getActiveProtocol() ([Tools](tools.md))*
* *setActiveTaskAndSubTask(taskName, subTaskName = '') ([Tools](tools.md))*
* *getCommandSetVersion() ([Tools](tools.md))*
* *getLastCommandError() ([Tools](tools.md))*

  


  


  
