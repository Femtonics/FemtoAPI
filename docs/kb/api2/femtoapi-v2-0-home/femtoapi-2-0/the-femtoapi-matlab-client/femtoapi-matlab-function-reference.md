# FemtoAPI Matlab function reference
# Command reference

### **FemtoAPIProcessing class**

Get/set processing state: 

* getProcessingState( obj ) ([Get processing state](../the-femtoapi-command-reference/get-processing-state.md))
* setProcessingState( obj, processingState ) ([Get processing state](../the-femtoapi-command-reference/get-processing-state.md))

Read/write channel data: 

* rawChannelData = readRawChannelData( obj, channelHandle, varargin ) ([Read-write binary channel data](../the-femtoapi-command-reference/read-write-binary-channel-data.md))
* channelData = readChannelData( obj, channelHandle, readDataType, varargin ) ([Read-write binary channel data](../the-femtoapi-command-reference/read-write-binary-channel-data.md))
* writeRawChannelData( obj, channelHandle, rawData, varargin ) ([Read-write binary channel data](../the-femtoapi-command-reference/read-write-binary-channel-data.md))
* writeChannelData( obj, channelHandle, data, varargin ) ([Read-write binary channel data](../the-femtoapi-command-reference/read-write-binary-channel-data.md))
* result = addLastFrameToMSession( obj, destMSessionHandle, spaceName ) ([Read-write binary channel data](../the-femtoapi-command-reference/read-write-binary-channel-data.md))

File operations: 

* result = createNewFile(obj) ([Handling measurement files](../the-femtoapi-command-reference/handling-measurement-files.md))
* succeeded = setCurrentFile(obj, handle) ([Handling measurement files](../the-femtoapi-command-reference/handling-measurement-files.md))
* result = openFilesAsync( obj, fileNames ) ([Handling measurement files](../the-femtoapi-command-reference/handling-measurement-files.md))
* result = saveFileAsync( obj, varargin ) ([Handling measurement files](../the-femtoapi-command-reference/handling-measurement-files.md))
* result = saveFileAsAsync( obj, newAbsolutePath, varargin ) ([Handling measurement files](../the-femtoapi-command-reference/handling-measurement-files.md))
* result= closeFileNoSaveAsync( obj, varargin ) ([Handling measurement files](../the-femtoapi-command-reference/handling-measurement-files.md))
* result= closeFileAndSaveAsync( obj, varargin ) ([Handling measurement files](../the-femtoapi-command-reference/handling-measurement-files.md))
* result = closeFileAndSaveAsAsync( obj, varargin ) ([Handling measurement files](../the-femtoapi-command-reference/handling-measurement-files.md))

Measurement unit operations: 

* result = createTimeSeriesMUnit( obj, xDim, yDim, taskXMLParameters, viewportJson, varargin ) ([MUnit manipulations](../the-femtoapi-command-reference/munit-manipulations.md))
* result = createZStackMUnit( obj, xDim, yDim, zDim, taskXMLParameters, viewportJson, varargin ) ([MUnit manipulations](../the-femtoapi-command-reference/munit-manipulations.md))
* result = extendMUnit( obj, mUnitHandle, frameCount ) ([MUnit manipulations](../the-femtoapi-command-reference/munit-manipulations.md))
* result = copyMUnit( obj, sourceMImageHandle, destMItemHandle, varargin ) ([MUnit manipulations](../the-femtoapi-command-reference/munit-manipulations.md))
* result = moveMUnit( obj, sourceMImageHandle, destMItemHandle ) ([MUnit manipulations](../the-femtoapi-command-reference/munit-manipulations.md))
* result = deleteMUnit( obj, mUnitHandle ) ([MUnit manipulations](../the-femtoapi-command-reference/munit-manipulations.md))

Channel operations: 

* result = addChannel( obj, mUnitHandle, channelName ) ([Add and remove channels](../the-femtoapi-command-reference/add-and-remove-channels.md))
* result = deleteChannel( obj, channelHandle ) ([Add and remove channels](../the-femtoapi-command-reference/add-and-remove-channels.md))

Tools: 

* curveData = getCurve( obj, measurementHandle, curveIdx ) ([Tools](../the-femtoapi-command-reference/tools.md))
* isModified = modifyConversion( obj, conversionName, scale, offset, varargin ) ([Tools](../the-femtoapi-command-reference/tools.md))
* json = getStatus(obj, varargin) ([Tools](../the-femtoapi-command-reference/tools.md))
* version = getCommandSetVersion() ([Tools](../the-femtoapi-command-reference/tools.md))

  


### FemtoAPIAcquisition class

Getting states: 

* acquisitionState = getAcquisitionState( obj ) ([Get acquisition state](../the-femtoapi-command-reference/get-acquisition-state.md))
* result = getMicroscopeState( obj ) ([Get microscope state](../the-femtoapi-command-reference/get-microscope-state.md))

Start/stop measurements, <span style="color: rgb(23,43,77);">setting duration:</span>

* isStopped = startGalvoScanSnapAsync(obj) ([Starting and stopping measurements](../the-femtoapi-command-reference/starting-and-stopping-measurements.md))
* isStarted = startGalvoScanAsync(obj) ([Starting and stopping measurements](../the-femtoapi-command-reference/starting-and-stopping-measurements.md))
* isStopped = stopGalvoScanAsync(obj) ([Starting and stopping measurements](../the-femtoapi-command-reference/starting-and-stopping-measurements.md))
* isStarted = startResonantScanSnapAsync(obj) ([Starting and stopping measurements](../the-femtoapi-command-reference/starting-and-stopping-measurements.md))
* isStarted = startResonantScanAsync(obj) ([Starting and stopping measurements](../the-femtoapi-command-reference/starting-and-stopping-measurements.md))
* isStoppped = stopResonantScanAsync(obj) ([Starting and stopping measurements](../the-femtoapi-command-reference/starting-and-stopping-measurements.md))
* succeeded = setMeasurementDuration(obj, duration) ([Setting measurement duration](../the-femtoapi-command-reference/setting-measurement-duration.md))

Manipulating axis positions: 

* axisPositions = getAxisPositions(obj) ([Manipulating axis positions](../the-femtoapi-command-reference/manipulating-axis-positions.md))
* axisPosition = getAxisPosition(obj,axisName,varargin) ([Manipulating axis positions](../the-femtoapi-command-reference/manipulating-axis-positions.md))
* succeeded = setAxisPosition(obj, axisName, position,varargin) ([Manipulating axis positions](../the-femtoapi-command-reference/manipulating-axis-positions.md))
* succeeded = doZero(obj, axisName,varargin) ([Manipulating axis positions](../the-femtoapi-command-reference/manipulating-axis-positions.md))
* isMoving = isAxisMoving(obj, axisName, varargin) ([Manipulating axis positions](../the-femtoapi-command-reference/manipulating-axis-positions.md))

Get/set Z-stack device intensity depth profile: 

* zStackLaserIntensityProfile = getZStackLaserIntensityProfile(obj,varargin) ([Get-set ZStack PMT/laser intensity device depth profile](../the-femtoapi-command-reference/get-set-zstack-pmt-laser-intensity-device-depth-profile.md))
* succeeded = setZStackLaserIntensityProfile(obj,zStacklaserIntensities) ([Get-set ZStack PMT/laser intensity device depth profile](../the-femtoapi-command-reference/get-set-zstack-pmt-laser-intensity-device-depth-profile.md))

Get/set imaging window parameters: 

* imagingWindowParameters = getImagingWindowParameters(obj,varargin) ([Get-set imaging window (viewport) parameters](../the-femtoapi-command-reference/get-set-imaging-window-viewport-parameters.md))
* succeeded = setImagingWindowsParameters(obj,imagingParams) ([Get-set imaging window (viewport) parameters](../the-femtoapi-command-reference/get-set-imaging-window-viewport-parameters.md))

Get/set device values: 

* deviceValues = getPMTAndLaserIntensityDeviceValues(obj) ([Get-set PMT/Laserintensity device values](../the-femtoapi-command-reference/get-set-pmt-laserintensity-device-values.md))
* succeeded = setPMTAndLaserIntensityDeviceValues(obj,deviceValues) ([Get-set PMT/Laserintensity device values](../the-femtoapi-command-reference/get-set-pmt-laserintensity-device-values.md))

Tools: 

* succeeded = setFocusingMode(obj, focusingMode, varargin) ([Tools](../the-femtoapi-command-reference/tools.md))
* focusingModes = getFocusingModes(obj, varargin) ([Tools](../the-femtoapi-command-reference/tools.md))
* protocol = getActiveProtocol(obj) ([Tools](../the-femtoapi-command-reference/tools.md))
* succeeded = setActiveTaskAndSubTask(obj, taskName, subTaskName = 'timeSeries') ([Tools](../the-femtoapi-command-reference/tools.md))
* version = getCommandSetVersion() ([Tools](../the-femtoapi-command-reference/tools.md))

  


## Helper functions

### FemtoAPIProcessing class

* commonCurvesMetaDataTable = getCommonCurvesMetaDataTable( obj, measurementHandleArray, channelType ) ([Helper classes and functions](helper-classes-and-functions.md))
* exportedFileNames = batchExportCurvesTxt( obj, commonCurveMetaDataTable, measurementHandleArray, selectedChannels, absoluteFilePath ) ([Helper classes and functions](helper-classes-and-functions.md))
* exportedFileNames = batchExportCurvesMat( obj, commonCurveMetaDataTable, measurementHandleArray, selectedChannels, absoluteFilePath ) ([Helper classes and functions](helper-classes-and-functions.md))
* exportedFileNames = batchExportMeasurementMetaData(obj, measurementHandleArray, fileName) ([Helper classes and functions](helper-classes-and-functions.md))
* data = getMeasurementMetaData(obj, handle) ([Helper classes and functions](helper-classes-and-functions.md))
* dataRef  = getMeasurementMetaDataRef(obj, handle) ([Helper classes and functions](helper-classes-and-functions.md))
* data  = getMeasurementMetaDataField(obj, handle, fieldName) ([Helper classes and functions](helper-classes-and-functions.md))
* setMeasurementMetaDataField(obj, handle, fieldName, value) ([Helper classes and functions](helper-classes-and-functions.md))
* val = getMeasurementMetaDataFieldRecursive(obj,rootHandle,fieldName,doWarning) ([Helper classes and functions](helper-classes-and-functions.md))
* val = getMeasurementMetaDataFieldSelective(obj,rootHandle,fieldName) ([Helper classes and functions](helper-classes-and-functions.md))
* setMeasurementMetaDataFieldSelective(obj,rootHandle, fieldName, value) ([Helper classes and functions](helper-classes-and-functions.md))
* val = getChildHandles(obj, handle) ([Helper classes and functions](helper-classes-and-functions.md))
* val = getNumOfChildHandles(obj,handle) ([Helper classes and functions](helper-classes-and-functions.md))
* val = getOpenedFileHandles(obj) ([Helper classes and functions](helper-classes-and-functions.md))
* val = getCurrentFileHandle(obj) ([Helper classes and functions](helper-classes-and-functions.md))
* val = getCurrentSessionHandle(obj) ([Helper classes and functions](helper-classes-and-functions.md))
* val = getFileName(obj, handle) ([Helper classes and functions](helper-classes-and-functions.md))
* waitForCompletion( obj, result ) ([Helper classes and functions](helper-classes-and-functions.md))

###  HStruct class ([Helper classes and functions](helper-classes-and-functions.md))

### FemtoAPIAcquisition class

* taskParameters = getTaskParameters(taskType,spaceName) ([Helper classes and functions](helper-classes-and-functions.md))
* \[activeTask, activeSubTask] = getActiveTaskAndSubTask(obj,varargin) ([Helper classes and functions](helper-classes-and-functions.md))
* activeSubTask = getActiveSubTaskForTask(obj,taskType,varargin) ([Helper classes and functions](helper-classes-and-functions.md))
* parameters = getActiveSubTaskParameters(obj, taskType) ([Helper classes and functions](helper-classes-and-functions.md))
* configuredAxes = getConfiguredAxes(obj) ([Helper classes and functions](helper-classes-and-functions.md))
* isConfigured = isAxisConfigured(obj,axisName) ([Helper classes and functions](helper-classes-and-functions.md))

### Common methods of FemtoAPIProcessing and FemtoAPIAcquisition classes:

* connect( obj, varargin ) ([Helper classes and functions](helper-classes-and-functions.md))
* disconnect( obj ) ([Helper classes and functions](helper-classes-and-functions.md))
* isConnected( obj ) ([Helper classes and functions](helper-classes-and-functions.md))
* getUrlAddress( obj ) ([Helper classes and functions](helper-classes-and-functions.md))

### DeviceValues class 

* deviceNames = getDeviceNames(obj) ([Helper classes and functions](helper-classes-and-functions.md))
* index = getDeviceIndexByName(obj, deviceName) ([Helper classes and functions](helper-classes-and-functions.md))
* deviceValuesStructArray = getDeviceValuesStructArray(obj) ([Helper classes and functions](helper-classes-and-functions.md))
* deviceValuesStructArray = getDeviceValuesCellArray(obj) ([Helper classes and functions](helper-classes-and-functions.md))
* obj = setDeviceValueByName(obj,deviceName,deviceValue) ([Helper classes and functions](helper-classes-and-functions.md))
* deviceValue = getDevicePropertyByName(obj,deviceName,propertyName) ([Helper classes and functions](helper-classes-and-functions.md))
* deviceValue = getDevicePropertyByIndex(obj,propertyName,index) ([Helper classes and functions](helper-classes-and-functions.md))

### LUT class

* obj = LUT(varargin) ([Helper classes and functions](helper-classes-and-functions.md))
* lutStruct = getLUTStruct(obj) ([Helper classes and functions](helper-classes-and-functions.md))
* colorObj = convertToColorValue( obj, val ); ([Helper classes and functions](helper-classes-and-functions.md))
* channelData_converted = convertChannelToARGB(obj, channelData ); ([Helper classes and functions](helper-classes-and-functions.md))
* channelData_converted = convertChannelToRGBA(obj, channelData ) ([Helper classes and functions](helper-classes-and-functions.md))
* rescale(obj,newLowerBound, newUpperBound) ([Helper classes and functions](helper-classes-and-functions.md))
* obj = setRangeBounds(obj, lower, upper) ([Helper classes and functions](helper-classes-and-functions.md))
* obj = setRangeLowerBound(obj, lower) ([Helper classes and functions](helper-classes-and-functions.md))
* obj = setRangeUpperBound(obj, upper) ([Helper classes and functions](helper-classes-and-functions.md))
* obj = fullReset(obj) ([Helper classes and functions](helper-classes-and-functions.md))
* reset(obj,varargin) ([Helper classes and functions](helper-classes-and-functions.md))
* valid = validateLUTStructure( obj, LUTStruct ) ([Helper classes and functions](helper-classes-and-functions.md))
* size = getSize(obj) ([Helper classes and functions](helper-classes-and-functions.md))
* colorMap ([Helper classes and functions](helper-classes-and-functions.md))

###  Color class ([Helper classes and functions](helper-classes-and-functions.md))

###  Conversion classes ([Helper classes and functions](helper-classes-and-functions.md))

  
