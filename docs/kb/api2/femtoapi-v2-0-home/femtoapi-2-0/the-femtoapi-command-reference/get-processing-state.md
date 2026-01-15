# Get processing state
The processing state indicates the file structure and the associated metadata in MESc. 

## **var json = FemtoAPIFile.getProcessingState()**

**DEPRECATED**, please use  getChildTree ([API file events and query functions](api-file-events-and-query-functions.md)) as replacement

Gets the list of open files and the trees of all measurement sessions and measurements within them, together with most of the available metadata. The exact JSON format is described at the following link:  DEV-A-1668703787 

  


***C++ code example:***

```cpp
QString command = “FemtoAPIFile.getProcessingState()”;
auto cmdParser=client→sendJSCommand(command);
```

  


***Python client code example:***

```py
command="FemtoAPIFile.getProcessingState();"
simpleCmdParser=client.sendJSCommand(command)

resultCode=simpleCmdParser.getResultCode()
if resultCode > 0:
     print ("Return code: %d" % resultCode)
     print (simpleCmdParser.getErrorText())
else:  
     print ("getProcessingState(): %s" % simpleCmdParser.getJSEngineResult())
```

  


### Matlab client usage: 

command: FemtoAPIProcessingObj.getProcessingState()

In Matlab, this command gets the processing state as json from the server, then converts it to a tree based structure for easier data access and saves into FemtoAPIProcessing object. The tree structure is based on the opened file, session, and measurement unit unique indices (handles).

It does not return the structured json data, but updates the processing state inner data structure of the FemtoAPIProcessing object. 

This command is called when a FemtoAPIProcessing object is created. 

Because of this, you don't have to parse the json returned from server, you can use the following functions to set/get part of the locally stored processing state structure: 

* data = obj.getMeasurementMetaData(handle) : data will contain the metadata of processing state to the given handle 
* dataRef = obj.getMeasurementMetaDataRef(handle) : same as getMeasurementMetaData, but it will the reference to the specified object
* data = getMeasurementMetaDataField(handle, fieldName) : returns the value of the specified field to the given measurement handle 
* setMesurementMetaDataField(handle, fieldName, newValue) : sets the given field in the measurement session/unit/channel denoted by handle to newValue
* etc. 

The full list of helper functions that can be used regarding processing state can be found  here ([Helper classes and functions](../the-femtoapi-matlab-client/helper-classes-and-functions.md)). 

  


***Important note on usage***: it is recommended to run getProcessingState() command after the file structure in the processing view in MESc has changed, to synchronize the processing state metadata stored within the FemtoAPIProcessing object to the actual processing state in MESc. 

Because if you want to set channel LUT/conversion, or comment of measurement session/unit, the helper functions for setting/getting metadata, set(get)MeasurementMetaDataField are using the local structure. And if it is not updated, you may reference to a file/session/unit or channel handle that does not exist anymore.

  


Currently, the following commands change the file structure on server side: 

* file operations: open/close/create 
* measurement unit operations: create/extend/copy/move/delete
* channel operations: add/delete channel 

  


  


***Code example:***

  


```
% connects to local server, and updates processing state
femtoapiObj = FemtoAPIProcessing(); 

mUnitHandle = [23 0 0] % must be an existing measurement unit handle 

% get measurement metadata: uses local structure to get data
mUnitData = femtoapiObj.getMeasurementMetaData(mUnitHandle) 

% add new channel to measurement unit 
result = femtoapiObj.addChannel(mUnitHandle,'Ch1');
channelHandle = result.addedChannelIdx;

% file structure changed in MESc -> call getProcessingState() to update processing state in femtoapiObj
femtoapiObj.getProcessingState();

% get metadata of newly added channel from local structure
channelData = femtoapiObj.getMeasurementMetaData(channelHandle)

% set metadata in local structure 
femtoapiObj.setMeasurementMetaDataField(mUnitHandle,'comment','new comment');

% update processing state on server -> after this, no getProcessingState() command is needed, because file structure has not changed
femtoapiObj.setProcessingState();
```

  
