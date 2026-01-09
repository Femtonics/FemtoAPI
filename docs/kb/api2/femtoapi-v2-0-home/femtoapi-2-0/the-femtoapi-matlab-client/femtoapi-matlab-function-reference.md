# FemtoAPI Matlab function reference
# Command reference

### **FemtoAPIProcessing class**

Get/set processing state: 

* getProcessingState( obj )(API2-A-1448161786)
* setProcessingState( obj, processingState )(API2-A-1448161786)

Read/write channel data: 

* rawChannelData = readRawChannelData( obj, channelHandle, varargin )(API2-A-1448161789)
* channelData = readChannelData( obj, channelHandle, readDataType, varargin )(API2-A-1448161789)
* writeRawChannelData( obj, channelHandle, rawData, varargin )(API2-A-1448161789)
* writeChannelData( obj, channelHandle, data, varargin )(API2-A-1448161789)
* result = addLastFrameToMSession( obj, destMSessionHandle, spaceName )(API2-A-1448161789)

File operations: 

* result = createNewFile(obj)(API2-A-1448161791)
* succeeded = setCurrentFile(obj, handle)(API2-A-1448161791)
* result = openFilesAsync( obj, fileNames )(API2-A-1448161791)
* result = saveFileAsync( obj, varargin )(API2-A-1448161791)
* result = saveFileAsAsync( obj, newAbsolutePath, varargin )(API2-A-1448161791)
* result= closeFileNoSaveAsync( obj, varargin )(API2-A-1448161791)
* result= closeFileAndSaveAsync( obj, varargin )(API2-A-1448161791)
* result = closeFileAndSaveAsAsync( obj, varargin )(API2-A-1448161791)

Measurement unit operations: 

* result = createTimeSeriesMUnit( obj, xDim, yDim, taskXMLParameters, viewportJson, varargin )(API2-A-1448161796)
* result = createZStackMUnit( obj, xDim, yDim, zDim, taskXMLParameters, viewportJson, varargin )(API2-A-1448161796)
* result = extendMUnit( obj, mUnitHandle, frameCount )(API2-A-1448161796)
* result = copyMUnit( obj, sourceMImageHandle, destMItemHandle, varargin )(API2-A-1448161796)
* result = moveMUnit( obj, sourceMImageHandle, destMItemHandle )(API2-A-1448161796)
* result = deleteMUnit( obj, mUnitHandle )(API2-A-1448161796)

Channel operations: 

* result = addChannel( obj, mUnitHandle, channelName )(API2-A-1448161798)
* result = deleteChannel( obj, channelHandle )(API2-A-1448161798)

Tools: 

* curveData = getCurve( obj, measurementHandle, curveIdx )(API2-A-1448161797)
* isModified = modifyConversion( obj, conversionName, scale, offset, varargin )(API2-A-1448161797)
* json = getStatus(obj, varargin)(API2-A-1448161797)
* version = getCommandSetVersion()(API2-A-1448161797)

  


### FemtoAPIAcquisition class

Getting states: 

* acquisitionState = getAcquisitionState( obj )(API2-A-1448161788)
* result = getMicroscopeState( obj )(API2-A-1448161787)

Start/stop measurements, <span style="color: rgb(23,43,77);">setting duration:</span>

* isStopped = startGalvoScanSnapAsync(obj)(API2-A-1448161790)
* isStarted = startGalvoScanAsync(obj)(API2-A-1448161790)
* isStopped = stopGalvoScanAsync(obj)(API2-A-1448161790)
* isStarted = startResonantScanSnapAsync(obj)(API2-A-1448161790)
* isStarted = startResonantScanAsync(obj)(API2-A-1448161790)
* isStoppped = stopResonantScanAsync(obj)(API2-A-1448161790)
* succeeded = setMeasurementDuration(obj, duration)(API2-A-1448161799)

Manipulating axis positions: 

* axisPositions = getAxisPositions(obj)(API2-A-1448161794)
* axisPosition = getAxisPosition(obj,axisName,varargin)(API2-A-1448161794)
* succeeded = setAxisPosition(obj, axisName, position,varargin)(API2-A-1448161794)
* succeeded = doZero(obj, axisName,varargin)(API2-A-1448161794)
* isMoving = isAxisMoving(obj, axisName, varargin)(API2-A-1448161794)

Get/set Z-stack device intensity depth profile: 

* zStackLaserIntensityProfile = getZStackLaserIntensityProfile(obj,varargin)(API2-A-1448161793)
* succeeded = setZStackLaserIntensityProfile(obj,zStacklaserIntensities)(API2-A-1448161793)

Get/set imaging window parameters: 

* imagingWindowParameters = getImagingWindowParameters(obj,varargin)(API2-A-1448161792)
* succeeded = setImagingWindowsParameters(obj,imagingParams)(API2-A-1448161792)

Get/set device values: 

* deviceValues = getPMTAndLaserIntensityDeviceValues(obj)(API2-A-1448161795)
* succeeded = setPMTAndLaserIntensityDeviceValues(obj,deviceValues)(API2-A-1448161795)

Tools: 

* succeeded = setFocusingMode(obj, focusingMode, varargin)(API2-A-1448161797)
* focusingModes = getFocusingModes(obj, varargin)(API2-A-1448161797)
* protocol = getActiveProtocol(obj)(API2-A-1448161797)
* succeeded = setActiveTaskAndSubTask(obj, taskName, subTaskName = 'timeSeries')(API2-A-1448161797)
* version = getCommandSetVersion()(API2-A-1448161797)

  


## Helper functions

### FemtoAPIProcessing class

* commonCurvesMetaDataTable = getCommonCurvesMetaDataTable( obj, measurementHandleArray, channelType )(API2-A-1448161777)
* exportedFileNames = batchExportCurvesTxt( obj, commonCurveMetaDataTable, measurementHandleArray, selectedChannels, absoluteFilePath )(API2-A-1448161777)
* exportedFileNames = batchExportCurvesMat( obj, commonCurveMetaDataTable, measurementHandleArray, selectedChannels, absoluteFilePath )(API2-A-1448161777)
* exportedFileNames = batchExportMeasurementMetaData(obj, measurementHandleArray, fileName)(API2-A-1448161777)
* data = getMeasurementMetaData(obj, handle)(API2-A-1448161777)
* dataRef  = getMeasurementMetaDataRef(obj, handle)(API2-A-1448161777)
* data  = getMeasurementMetaDataField(obj, handle, fieldName)(API2-A-1448161777)
* setMeasurementMetaDataField(obj, handle, fieldName, value)(API2-A-1448161777)
* val = getMeasurementMetaDataFieldRecursive(obj,rootHandle,fieldName,doWarning)(API2-A-1448161777)
* val = getMeasurementMetaDataFieldSelective(obj,rootHandle,fieldName)(API2-A-1448161777)
* setMeasurementMetaDataFieldSelective(obj,rootHandle, fieldName, value)(API2-A-1448161777)
* val = getChildHandles(obj, handle)(API2-A-1448161777)
* val = getNumOfChildHandles(obj,handle)(API2-A-1448161777)
* val = getOpenedFileHandles(obj)(API2-A-1448161777)
* val = getCurrentFileHandle(obj)(API2-A-1448161777)
* val = getCurrentSessionHandle(obj)(API2-A-1448161777)
* val = getFileName(obj, handle) (API2-A-1448161777)
* waitForCompletion( obj, result )(API2-A-1448161777)

###  HStruct class(API2-A-1448161777)

### FemtoAPIAcquisition class

* taskParameters = getTaskParameters(taskType,spaceName)(API2-A-1448161777)
* \[activeTask, activeSubTask] = getActiveTaskAndSubTask(obj,varargin)(API2-A-1448161777)
* activeSubTask = getActiveSubTaskForTask(obj,taskType,varargin)(API2-A-1448161777)
* parameters = getActiveSubTaskParameters(obj, taskType)(API2-A-1448161777)
* configuredAxes = getConfiguredAxes(obj)(API2-A-1448161777)
* isConfigured = isAxisConfigured(obj,axisName)(API2-A-1448161777)

### Common methods of FemtoAPIProcessing and FemtoAPIAcquisition classes:

* connect( obj, varargin )(API2-A-1448161777)
* disconnect( obj )(API2-A-1448161777)
* isConnected( obj )(API2-A-1448161777)
* getUrlAddress( obj )(API2-A-1448161777)

### DeviceValues class 

* deviceNames = getDeviceNames(obj)(API2-A-1448161777)
* index = getDeviceIndexByName(obj, deviceName)(API2-A-1448161777)
* deviceValuesStructArray = getDeviceValuesStructArray(obj)(API2-A-1448161777)
* deviceValuesStructArray = getDeviceValuesCellArray(obj)(API2-A-1448161777)
* obj = setDeviceValueByName(obj,deviceName,deviceValue)(API2-A-1448161777)
* deviceValue = getDevicePropertyByName(obj,deviceName,propertyName)(API2-A-1448161777)
* deviceValue = getDevicePropertyByIndex(obj,propertyName,index)(API2-A-1448161777)

### LUT class

* obj = LUT(varargin)(API2-A-1448161777)
* lutStruct = getLUTStruct(obj)(API2-A-1448161777)
* colorObj = convertToColorValue( obj, val );(API2-A-1448161777)
* channelData_converted = convertChannelToARGB(obj, channelData );(API2-A-1448161777)
* channelData_converted = convertChannelToRGBA(obj, channelData )(API2-A-1448161777)
* rescale(obj,newLowerBound, newUpperBound)(API2-A-1448161777)
* obj = setRangeBounds(obj, lower, upper)(API2-A-1448161777)
* obj = setRangeLowerBound(obj, lower)(API2-A-1448161777)
* obj = setRangeUpperBound(obj, upper)(API2-A-1448161777)
* obj = fullReset(obj)(API2-A-1448161777)
* reset(obj,varargin)(API2-A-1448161777)
* valid = validateLUTStructure( obj, LUTStruct )(API2-A-1448161777)
* size = getSize(obj)(API2-A-1448161777)
* colorMap(API2-A-1448161777)

###  Color class(API2-A-1448161777)

###  Conversion classes(API2-A-1448161777)

  
