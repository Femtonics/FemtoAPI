# API file events and query functions
### 

### var JSON=**FemtoAPIFile.**getChildTree('handler') -function

*getProcessingState()=GetChildTree(),No associated signal.*

*The handler parameter can be defined on the file/session/unit level. In case of empty parameter the whole tree will be returned. If the handler contain a file id the whole property tree of the file will be returned. Similarly if it contains a session id the properties of the given session will be returned and in case of a unit id the properties of that unit will be returned.*

*The metadata in the JSON can differ from the metadata in the file.*



## File: 

### 

### var JSON=**FemtoAPIFile.**getFileList(\[,'subscribe' | 'unsubscribe']) -function

Returns a simple list of the opened files. The client will subscribe for the file close/open event when given the 'subscribe' argument. 

### 

### var JSON=**FemtoAPIFile**.fileOpened() -event

After opening a file an event is generated on the API. The result JSON contains the file name and id (runtime unique index).

### 

### var JSON=**FemtoAPIFile**.fileClosed() -event

After closing a file an event is generated on the API. The result JSON contains the file name and id (runtime unique index).

### 

### var JSON=**FemtoAPIFile.**getFileMetadata('fileHandler'\[,'subscribe' | 'unsubscribe']) -function

Returns the metadata in JSON format from an open file's 'FILE' section (AccessTime, Vendor, VecMSessionSize...). The client will subscribe for the file's simple metadata changes when given the 'subscribe' argument. 



### var bool=**FemtoAPIFile.**setFileMetadata('fileHandler',JSON) -function

Sets the basic parameters of the file defined by the 'fileHandler'. **Currently only the isModified field can be changed.** The JSON must contain the result of the getFileMetadata() with the appropriate changes.

### 

### var JSON=**FemtoAPIFile.**fileMetadataChanged() -event

Returns the JSON result of the getFileMetadata() function if any of those values have changed.



## Session:

### 

### var JSON=**FemtoAPIFile.**getSessionMetadata('sessionHandler'\[,'subscribe' | 'unsubscribe']) -function

Returns the metadata in JSON format from the session's 'MSESSION' section (MSessionType,Comment, VecMUnitsSize...) defined by the 'sessionHandler'. The client will subscribe for the session's metadata changes when given the 'subscribe' argument. 

### 

### var bool=**FemtoAPIFile.**setSessionMetadata('sessionHandler',JSON) -function

Sets the basic parameters of the session defined by the 'sessionHandler'. **Currently only the 'comment' field can be changed.** The JSON must contain the result of the getSessionMetadata() with the appropriate changes.

### 

### var JSON=**FemtoAPIFile.**sessionMetadataChanged() -esemény

Returns the JSON result of the getSessionMetadata() function if any of those values have changed.



### 

### var JSON=**FemtoAPIFile.**getCurrentSession(\[,'subscribe' | 'unsubscribe']) -function

Returns the current session's handler in JSON format. The client will subscribe for the changes when given the 'subscribe' argument. 

### 

### var bool=**FemtoAPIFile.**setCurrentSession('sessionHandler') -function

Sets the current session according to the 'sessionHandler'.

### 

### var JSON=**FemtoAPIFile.currentS**essionChanged() -event

Returns the JSON result of the getCurrentSession() function if it changed.

## MUnit:

### 

### var JSON=**FemtoAPIFile.**getUnitMetadataJson('unitHandler', 'JsonItemName',\[ ,'subscribe' | 'unsubscribe']) -function

Returns the metadata of the 'JsonItemName' key in JSON format from the MUnit defined by the 'unitHandler'. The client will subscribe for the change events of the defined JsonItem's metadata in the MUnit when given the 'subscribe' argument. 

JsonItemName keys:

* BaseUnitMetadata
* ReferenceViewport
* ChannelInfo
* Roi
* Points
* Device
* AxisControl
* UserData
* AoSettings
* IntensityCompensation
* CoordinateTuning
* Protocol
* MultiRoiProtocol
* RasterScanProtocol
* CurveInfo
* FullFrameParams
* Modality
* CameraSettings
* BreakView
* CoordinateMap
* VersionInfo
* ViewerParams
* TriggeredActions
* TileScan

### 

### var bool=**FemtoAPIFile.**setUnitMetadataJson('unitHandler','JsonItemName', JSON) -function

Sets the parameters of the JsonItem in the MUnit defined by the 'unitHandler'. The JSON must contain the result of the getUnitMetadata() with the appropriate changes.

### 

### var JSON=**FemtoAPIFile.**unitMetadataChanged() -event

Returns the JSON result of the getUnitMetadata() function if it changed.

It also contains the following extra fields:

* 'event' - Name of the event. In this case it will always be unitMetadataChanged
* 'time' - The time when the event was generated
* 'nodeDescriptor' - Descriptor of the unit node which triggered the event
* 'jsonItem' - JsonItemName's value, defines which parameter section changed
* 'values' - Json array which contains the event JSON. Only the first array element is used for now

