# Helper classes and functions
These functions provide easier usage to the FemtoAPI Matlab client. Here only the most relevant informations are described, you can find the full documentation to these functions in the code. 

# 

# FemtoAPIProcessing class

## Manipulating channel curve data

**commonCurvesMetaDataTable = getCommonCurvesMetaDataTable( obj, measurementHandleArray, channelType )**

Gets metadata of common curves of the specified measurements and channel type (input or output) in a table.

**exportedFileNames = batchExportCurvesTxt( obj, commonCurveMetaDataTable, selectedMeasurementHandles, selectedChannels, absoluteFilePath )**

Filters the common curve metadata table by selected handles and channel names (the must be present in common metadata table), then gets the curves from the server, and saves curve data to the given absolute path in .txt file.

**exportedFileNames = batchExportCurvesMat( obj, commonCurveMetaDataTable, measurementHandleArray, selectedChannels, absoluteFilePath )**

The same as batchExportCurveTxt, but saves curve data to mat file.

**exportedFileNames = batchExportMeasurementMetaData(obj, measurementHandleArray, fileName)**

Exports 'measurementInfo' and 'measurementParams' fields of the specified measurement units to JSON.

  


## Get/set measurement metadata

**data = getMeasurementMetaData(obj, handle)**

Gets part of processing state metadata, based on the given handle. It retrieves data from locally stored processing state.

**dataRef = getMeasurementMetaDataRef(obj, handle)**

Same as getMeasurementMetaData, but it returns reference (HStruct handle object).

**data = getMeasurementMetaDataField(obj, handle, fieldName)**

Gets the value of a given field of processing state metadata, based on the given handle. It retrieves data from locally stored processing state.

**setMeasurementMetaDataField(obj, handle, fieldName, value)**

Sets the value of a given metadata field based the given handle. It sets value in the locally stored processing state structure. You have to call the  setProcessingState()(API2-A-1448161786) command to send changes to the server.

**val = getMeasurementMetaDataFieldRecursive(obj,rootHandle,fieldName,doWarning)**

Gets the values of the given metadata field of the sub-tree which root is rootHandle. If doWarning = true, then it only prints warning message if the given field is not found in a part-structure. Otherwise it throws an error.

It returns an Nx2 cell array containing the pairs of handle and the corresponding field value. It retrieves data from locally stored processing state.

**val = getMeasurementMetaDataFieldSelective(obj,rootHandle,fieldName)**  


It is a special case of getMeasurementMetaDataFieldRecursive(), it only gets the metadata field values of the children of rootHandle.

It returns an Nx2 cell array containing the pairs of child handle and the corresponding field value. It retrieves data from locally stored processing state.

**setMeasurementMetaDataFieldSelective(obj,rootHandle, fieldName, value)**  


Sets the given value to field in all metadata structure which handles are child handles of rootHandle. It sets value in the locally stored processing state structure. You have to call the  setProcessingState()(API2-A-1448161786) command to send changes to the server.

**val = getChildHandles(obj, handle)**

Returns the child handles of handle. It retrieves data from locally stored processing state.

**val = getNumOfChildHandles(obj,handle)**

Returns the number of child handles of handle.

**val = getOpenedFileHandles(obj)**

Gets the handles of currently opened files. It retrieves data from locally stored processing state.

**val = getCurrentFileHandle(obj)**

Gets the handle of the current measurement file. It retrieves data from locally stored processing state.

**val = getCurrentSessionHandle(obj)**

Gets the handle of the current measurement session. It retrieves data from locally stored processing state.

**val = getFileName(obj, handle)** 

Gets name of the file which handle is the given file handle. It retrieves data from locally stored processing state.

**waitForCompletion( result )**

Waits for completion of an asynchronous command. Input parameter 'result' is the return value of the asynchronous command, a struct which contains the command id. 

  


# HStruct class

Wraps data passed in the constructor in a handle object. This is used by FemtoAPIProcessing class to store references to measurement item metadata (file, session, unit, channel) in a tree based structure, for faster data access.

Data access is based on the unique identifier of measurement items (named as measurement item handle).

## FemtoAPIAcquisition class

**configuredAxes = getConfiguredAxes(obj);**

Gets the name of currently configured axes as string array. It uses local data, so must be called after  getAcquisitionState()(API2-A-1448161788) or  getAxisPositions()(API2-A-1448161794) command.

**isConfigured = isAxisConfigured(obj,axisName)**

Returns whether the given axis name is valid or not. It uses local data, so must be called after  getAcquisitionState()(API2-A-1448161788) or  getAxisPositions()(API2-A-1448161794) command.

 **taskParameters = getTaskParameters(obj,taskType,spaceName)**

Gets the parameters for the specified task and space. Task type can be 'resonant' or 'galvo', and if space name is not given, default space is considered. It uses local data, so to get up-to-date information,  getAcquisitionState()(API2-A-1448161788) command must be called before this. 

**activeSubTask = getActiveSubTaskForTask(obj,taskType,varargin)**

Gets the active sub task (measurement mode, e.g. timeseries, Z-Stack, volume scan) for the given task (which can be resonant or galvo). It uses local data, so to get up-to-date information,  getAcquisitionState()(API2-A-1448161788) command must be called before this. 



**parameters = getActiveSubTaskParameters(obj, taskType)**

Gets the parameters of the active sub task (measurement mode, e.g. timeseries, Z-Stack, volume scan) for the given task (which can be resonant or galvo). It uses local data, so to get up-to-date information,  getAcquisitionState()(API2-A-1448161788) command must be called before this. 

**\[activeTask, activeSubTask] = getActiveTaskAndSubTask(obj,varargin)**

Gets the active task (can be resonant or galvo) and sub task (measurement mode, e.g. timeseries, Z-Stack, volume scan). It uses local data, so to get up-to-date information,  getAcquisitionState()(API2-A-1448161788) command must be called before this. 

# Common helpers of FemtoAPIProcessing and FemtoAPIAcquisition classes

**connect(obj,varargin)**

Connects to the server specified by parameter varargin{1}, in the format [ws://ip_address:port](<>). If called without parameters, it tries to connect to localhost (equivalent to <span style="color: rgb(0,130,0);">[ws://localhost:8888](<>) )</span>. Note that currently port 8888 is used. 

**disconnect(obj)**

Closes the active connection. 

**connected = isConnected(obj)**

Returns true if connected to the server, otherwise it returns false. 

**urlAddress = getUrlAddress(obj)**

Returns the URL address of the active connection in format [ws://ip_address:port](<>). 

# 

# DeviceValues class 

Wrapper class for device value struct get from server, for easier data handling. It is used to get and and device values by device name locally, and after it, 

**deviceNames = getDeviceNames(obj)**

Gets device names.

**index = getDeviceIndexByName(obj, deviceName)**

Gets device index. 

**deviceValuesStructArray = getDeviceValuesStructArray(obj)**

Converts DeviceValues object to struct array. 

**deviceValuesCellArray = getDeviceValuesCellArray(obj)**

Converts DeviceValues object to cell array of struct. 

**obj = setDeviceValueByName(obj,deviceName,deviceValue)**

Sets value of the requested device given by its name. 

**deviceValue = getDevicePropertyByName(obj,deviceName,propertyName)**

Gets the named property of the device specified by deviceName.

**deviceValue = getDevicePropertyByIndex(obj,propertyName,index)**

Gets the named property of the device specified by index. 

# LUT class

Basic lookup table class.

**obj = LUT(varargin)**

Constructs a LUT object from the input LUT struct , or a default LUT, if no input parameter is specified. 

**lutStruct = getLUTStruct(obj)**

Gets the LUT structure. 

**colorObj = convertToColorValue( obj, val )**

Converts an uint16 or double value (or array of values) to color(s) and returns a Color object (or an array of objects).

**channelData_converted = convertChannelToARGB(obj, channelData )**

Converts 2D channel image data into an ARGB image, based on color LUT. 

**channelData_converted = convertChannelToRGBA(obj, channelData )**

Converts 2D channel image data into an RGBA image, based on color LUT. 

**rescale(obj,newLowerBound, newUpperBound)**

Rescales LUT based on the given lower/upper bounds.

**obj = setRangeBounds(obj, lower, upper)**

Sets the given lower and upper bounds to LUT. If the given range does not intersect with the current range, LUT will be reset.

Otherwise, LUT colors and values will be clamped according to the new bounds.

**obj = setRangeLowerBound(obj, lower)**

Sets the given lower bound to LUT. If the given range does not intersect with the current range, LUT will be reset.

Otherwise, LUT colors and values will be clamped according to the new bounds.

**obj = setRangeUpperBound(obj, upper)**

Sets the given upper bound to LUT. If the given range does not intersect with the current range, LUT will be reset.

Otherwise, LUT colors and values will be clamped according to the new bounds.

**obj = fullReset(obj)**

Resets the LUT ranges, colors and corresponding values to default.

**reset(obj,varargin)**

Resets LUT colors and corresponding values to to given values, or if just color value (or object is given), to constant color with lower range value. 

It will not change the lower/upper LUT ranges. 

**isValid = validateLUTStructure( obj, LUTStruct )**

Check whether the given LUT structure is valid or not

**size = getSize(obj)**

Gets the number if color-value pairs in the lookup table. 

**lutObj.m_colorMap**

Gets the color map as rows of R,G,B values.

  


# Color class

It is a utility class and is useful for converting between different color representations, such as uint32, struct (contains uint8 type R, G, B, A components), hex string, and uint8 array. It can handle ARGB or RGBA color order.

# 

# Conversion classes

Two main classes are ConversionIdentity and ConversionLinear. These have common methods for converting between raw and converted data vice versa, for uint16 and double type data.

These classes are used by read(Raw)ChannelData and write(Raw)ChannelData functions to convert image data. 

The classes have common functions for the forward and inverse conversions, for uint16 and double types: 

  


Forward conversion functions: 

**res = convertToDouble(obj,val)**  
**res = convertToUint16(obj,val)**

  


Inverse conversion functions: 

**res = invConvertToDouble(obj,val)**  
**res = invConvertToUint16(obj,val)**

  


Check whether value is within conversion ranges (both in raw and converted space): 

 **val = isLimitedDouble(obj)**  
**val = isLimitedUint16(obj)**  
**val = isLimited(obj)**  
**val = isWithinLimitsUint16(obj,num)**  
**val = isWithinLimitsDouble(obj,num)**  
**res = isWithinConvertedMinMaxValuesUint16(obj,value)**  
**res = isWithinConvertedMinMaxValuesDouble(obj,value)**  
  


Setting offset and scale (for linear conversion): 

**val = offsetBy(obj,add);**  
**val = scaleBy(obj,scale);**  
  
  
Reset conversion lower and upper limits:

**resetLowerLimitsFromUint16Value(obj, varargin)**  
**resetUpperLimitsFromUint16Value(obj, varargin)**  
**resetLowerLimitsFromDoubleValue(obj, varargin)**  
**resetUpperLimitsFromDoubleValue(obj, varargin)**

**resetLimitsFromDoubleValues(obj, varargin)**  
**resetLimitsFromUint16Values(obj,varargin)**

  


  


  
