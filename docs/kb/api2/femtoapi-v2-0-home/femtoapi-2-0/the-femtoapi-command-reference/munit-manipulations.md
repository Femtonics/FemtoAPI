# MUnit manipulations
The following measurement unit manipulations are implemented:

* create (time series or z-stack resonant/galvo/Ao fullframe scan)
* extend
* copy/move
* delete
* setting linked MUnit

### Notes on Matlab usage

In the Matlab FemtoAPI client, regarding the command descriptions and usage, the same applies as in case of C++/Python client, there are some minor differences regarding the input/output arguments. The usage from Matlab is the following:

* You need to create a FemtoAPIProcessing object, as described  here(API2-A-1448161761)
* call the command with the same name as in case of C++/Python, and the input/output parameters have the following format:
  * **measurement unit handle**, in input/output parameters: represented as Matlab array, instead of string, e.g. [43 0 0]
  * **countDims**: represented as Matlab array
  * **result**: the returned value is the json get from server parsed into a Matlab struct (if it contains measurement unit handle (e.g. copiedMUnitIdx, addedMUnitIdx), it is a Matlab array)
* If a command fails, then it throws an error type Matlab exception containing the error message

## 

## **var result = FemtoAPIFile.createTimeSeriesMUnit(xDim, yDim, taskXMLParameters,viewportJson, z0InMs = 0.0, zStepInMs = 1.0, zDimInitial = 1)**



Creates new measurement unit for galvo/resonant/AO fullframe scan time series measurement.

Input parameters:

* **xDim**: measurement image x resolution
* **yDim**: measurement image y resolution
* **taskXMLParameters**: measurementParamsXML for resonant/galvo/AO fullframe scan time series measurement.
* **viewportJson**: viewport for measurement
* **z0InMs**: Measurement start time offset in ms. Double, default value is 0.0
* **zStepInMs**: Frame duration time in ms (1/frame rate). Positive double, default value is 1.0.
* **zDimInitial**<span style="letter-spacing:0.0px;">:</span> <span style="letter-spacing:0.0px;">Number</span><span style="letter-spacing:0.0px;"> of </span><span style="letter-spacing:0.0px;">frames</span> <span style="letter-spacing:0.0px;">to</span> <span style="letter-spacing:0.0px;">create</span><span style="letter-spacing:0.0px;"> in z </span><span style="letter-spacing:0.0px;">dimension</span><span style="letter-spacing:0.0px;">. </span><span style="letter-spacing:0.0px;">Positive</span><span style="letter-spacing:0.0px;"> integer, </span><span style="letter-spacing:0.0px;">default</span> <span style="letter-spacing:0.0px;">value</span><span style="letter-spacing:0.0px;"> is 1.</span>

Returns a json object with the following fields:

* **succeeded**: Returns true if the measurement unit creation was successfully initiated, otherwise it returns false
* **id**: command id, which is used as input to  FemtoAPIFile.getStatus(commandID)(API2-A-1448161797) command, to obtain the current status of the command (the asynchronous part), if succeeded == true.
* **addedMUnitIdx**: In case of the new measurement unit has been successfully created, the unique index of the created measurement unit converted to string, e.g. "34,0,1"

  

### Usage in Matlab

result = femtoapiObj.createTimeSeriesMUnit(xDim, yDim, taskXMLParameters, viewportJson, z0InMs, zStepInMs, zDimInitial)

For more information about usage, see the  and the examples below.

### Examples

The following variables need to be defined:

var viewport='{"referenceViewportFormatVersion": 1, "viewports":[{"geomTransRot": [0,0,0,1], "geomTransTransl": [0,0,0], "height":256, "width": 256}]}'

in API version 2.0 (MESc ver 4.5) : taskXMLParameters is replaced by a single string containing the scaning mode: galvo/resonant/AO

galvo:

var tp='galvo'

resonant:

var tp='resonant'

AO fullframe scan:

var tp='AO'



**C++ code example**

```cpp
QString command = “FemtoAPIFile.createTimeSeriesMUnit(256,256,tp,viewport)”; 
auto cmdParser=client->sendJSCommand(command); 
```



## **var result = FemtoAPIFile.createBesselTimeSeriesMUnit(xDim, yDim, viewportJson, z0InMs = 0.0, zStepInMs = 1.0, zDimInitial = 1)**



Creates new measurement unit of Bessel measurement type for AO fullframe scan time series measurement.

Input parameters:

* **xDim**: measurement image x resolution
* **yDim**: measurement image y resolution
* **viewportJson**: viewport for measurement
* **z0InMs**: Measurement start time offset in ms. Double, default value is 0.0
* **zStepInMs**: Frame duration time in ms (1/frame rate). Positive double, default value is 1.0.
* **zDimInitial**: Number of frames to create in z dimension. Positive integer, default value is 1.

Returns a json object with the following fields:

* **succeeded**: Returns true if the measurement unit creation was successfully initiated, otherwise it returns false
* **id**: command id, which is used as input to  FemtoAPIFile.getStatus(commandID)(API2-A-1448161797) command, to obtain the current status of the command (the asynchronous part), if succeeded == true.
* **addedMUnitIdx**: In case of the new measurement unit has been successfully created, the unique index of the created measurement unit converted to string, e.g. "34,0,1"

  

### Usage in Matlab

result = femtoapiObj.createBesselTimeSeriesMUnit(xDim, yDim, viewportJson, z0InMs, zStepInMs, zDimInitial)

For more information about usage, see the  and the examples below.

### Examples

The following variables need to be defined:

var viewport='{"referenceViewportFormatVersion": 1, "viewports":[{"geomTransRot": [0,0,0,1], "geomTransTransl": [0,0,0], "height":256, "width": 256}]}'



**C++ code example**

```cpp
QString command = “FemtoAPIFile.createBesselTimeSeriesMUnit(256,256,viewport)”; 
auto cmdParser=client->sendJSCommand(command); 
```

**Matlab client code example:**

```matlab
viewport = '{"referenceViewportFormatVersion": 1, "viewports":[{"geomTransRot": [0,0,0,1], "geomTransTransl": [0,0,0], "height":256, "width": 256}]}'; 
femtoapiObj = FemtoAPIProcessing(); % connect to local server (MESc)   
result = femtoapiObj.createBesselTimeSeriesMUnit(256,256,viewport) % create measurement unit 
```



**Python client code example:**

```py
command="FemtoAPIFile.createBesselTimeSeriesMUnit(256,256,viewport);” 
simpleCmdParser=client.sendJSCommand(command)  

resultCode=simpleCmdParser.getResultCode() 
if resultCode > 0: 
    print ("Return code: %d" % resultCode) 
    print (simpleCmdParser.getErrorText()) 
else:   
    print ("createBesselTimeSeriesMUnit(): %s" % simpleCmdParser.getJSEngineResult()) 
```



## **var result = FemtoAPIFile.createZStackMUnit(xDim, yDim, zDim, taskXMLParameters,viewportJson, zStepInMicrons = 1.0)**



Creates new measurement unit for galvo/resonant/AO z-stack measurement.

Input parameters:

* **xDim**: measurement image x resolution
* **yDim**: measurement image y resolution
* **zDim**: number of z planes
* **taskXMLParameters**: measurementParamsXML for resonant/galvo/AO fullframe scan z-stack measurement.
* **viewportJson**: viewport for measurement
* **zStepInMicrons**: Step between z planes in um. Double, default value is 0.0

Returns a json object with the following fields:

* **succeeded**: Returns true if the measurement unit creation was successfully initiated, otherwise it returns false
* **id**: command id, which is used as input to  FemtoAPIFile.getStatus(commandID)(API2-A-1448161797) command, to obtain the current status of the command (the asynchronous part), if succeeded == true.
* **addedMUnitIdx**: In case of the new measurement unit has been successfully created, the unique index of the created measurement unit converted to string, e.g. "34,0,1"

  

### Usage in Matlab

result = femtoapiObj.createZStackMUnit(xDim, yDim, zDim, taskXMLParameters, viewportJson, zStepInMicrons)

For more information about usage, see the  and the examples below.

### Examples

The following variables need to be defined:

var viewport='{"referenceViewportFormatVersion": 1, "viewports":[{"geomTransRot": [0,0,0,1], "geomTransTransl": [0,0,0], "height":256, "width": 256}]}'

in API version 2.0 (MESc ver 4.5) : taskXMLParameters is replaced by a single string containing the scaning mode: galvo/resonant/AO

galvo:

var tp='galvo'

resonant:

var tp='resonant'

AO fullframe scan:

var tp='AO'



**C++ code example**

```cpp
QString command = “FemtoAPIFile.createZStackMUnit(256,256,10,tp,viewport)”; 
auto cmdParser=client->sendJSCommand(command); 
```



**Matlab client code example:**

```matlab
viewport = '{"referenceViewportFormatVersion": 1, "viewports":[{"geomTransRot": [0,0,0,1], "geomTransTransl": [0,0,0], "height":256, "width": 256}]}';
tp = 'galvo' ;

femtoapiObj = FemtoAPIProcessing(); % connect to local server (MESc)   
result = femtoapiObj.createZStackMUnit(256,256,10,tp,viewport) % create measurement unit 
```



**Python client code example:**

```py
command="FemtoAPIFile.createZStackMUnit(256,256,10,tp,viewport);” 
simpleCmdParser=client.sendJSCommand(command)  

resultCode=simpleCmdParser.getResultCode() 

if resultCode > 0: 
    print ("Return code: %d" % resultCode) 
    print (simpleCmdParser.getErrorText()) 
else:   
    print ("createZStackMUnit(): %s" % simpleCmdParser.getJSEngineResult()) 
```







## 

## **var result = FemtoAPIFile.createVolumeScanMUnit(xDim, yDim, zDim, tDim, technologyType, viewportJson)**



Creates new measurement unit for galvo/resonant/AO fullframe volume scan measurement.

Input parameters:

* **xDim**: measurement image x resolution
* **yDim**: measurement image y resolution
* **zDim**: number of Z planes
* **tDim**: number of time frames on each Z plane
* **technologyType**: measurementParamsXML for resonant/galvo/AO fullframe scan time series measurement.
* **viewportJson**: viewport for measurement

Returns a json object with the following fields:

* **succeeded**: Returns true if the measurement unit creation was successfully initiated, otherwise it returns false
* **id**: command id, which is used as input to  FemtoAPIFile.getStatus(commandID)(API2-A-1448161797) command, to obtain the current status of the command (the asynchronous part), if succeeded == true.
* **addedMUnitIdx**: In case of the new measurement unit has been successfully created, the unique index of the created measurement unit converted to string, e.g. "34,0,1"

  

### Usage in Matlab

result = femtoapiObj.createVolumeScanMUnit(xDim, yDim, zDim, tDim, technologyType, viewportJson)

For more information about usage, see the  and the examples below.

### Examples

The following variables need to be defined:

var viewport='{"referenceViewportFormatVersion": 1, "viewports":[{"geomTransRot": [0,0,0,1], "geomTransTransl": [0,0,0], "height":256, "width": 256}]}'

in API version 2.0 (MESc ver 4.5) : taskXMLParameters is replaced by a single string containing the scaning mode: galvo/resonant/AO

galvo:

var tp='galvo'

resonant:

var tp='resonant'

AO fullframe scan:

var tp='AO'



**C++ code example**

```cpp
QString command = “FemtoAPIFile.createVolumeScanMUnit(256,256,10,1,tp,viewport)”; 
auto cmdParser=client->sendJSCommand(command); 
```



**Matlab client code example:**

```matlab
viewport = '{"referenceViewportFormatVersion": 1, "viewports":[{"geomTransRot": [0,0,0,1], "geomTransTransl": [0,0,0], "height":256, "width": 256}]}';
tp = 'galvo' ;

femtoapiObj = FemtoAPIProcessing(); % connect to local server (MESc)   
result = femtoapiObj.createVolumeScanMUnit(256,256,10,1,tp,viewport) % create measurement unit 
```



**Python client code example:**

```py
command="FemtoAPIFile.createVolumeScanMUnit(256,256,10,1,tp,viewport);” 
simpleCmdParser=client.sendJSCommand(command)  

resultCode=simpleCmdParser.getResultCode() 

if resultCode > 0: 
    print ("Return code: %d" % resultCode) 
    print (simpleCmdParser.getErrorText()) 
else:   
    print ("createTimeSeriesMUnit(): %s" % simpleCmdParser.getJSEngineResult()) 
```



## 

## **var result = FemtoAPIFile.createMultiLayerMUnit(xDim, yDim, zDim, technologyType, viewportJson)**



Creates new measurement unit for galvo/resonant/AO fullframe multi layer scan measurement.

Input parameters:

* **xDim**: measurement image x resolution
* **yDim**: measurement image y resolution
* **zDim**: number of layers
* **technologyType**: measurementParamsXML for resonant/galvo/AO fullframe scan time series measurement.
* **viewportJson**: viewport for measurement

Returns a json object with the following fields:

* **succeeded**: Returns true if the measurement unit creation was successfully initiated, otherwise it returns false
* **id**: command id, which is used as input to  FemtoAPIFile.getStatus(commandID)(API2-A-1448161797) command, to obtain the current status of the command (the asynchronous part), if succeeded == true.
* **addedMUnitIdx**: In case of the new measurement unit has been successfully created, the unique index of the created measurement unit converted to string, e.g. "34,0,1"

  

### Usage in Matlab

result = femtoapiObj.createMultiLayerMUnit(xDim, yDim, zDim, technologyType, viewportJson)

For more information about usage, see the  and the examples below.

### Examples

The following variables need to be defined:

each layer has it's own viewport

var viewport='{"referenceViewportFormatVersion": 1, "viewports":[{"geomTransRot": [0,0,0,1], "geomTransTransl": [0,0,0], "height":256, "width": 256}, {"geomTransRot": [0,0,0,1], "geomTransTransl": [0,0,0], "height":256, "width": 256}]}'

technologyType: AO

var tp='AO'



**C++ code example**

```cpp
QString command = “FemtoAPIFile.createMultiLayerMUnit(256,256,2,tp,viewport)”; 
auto cmdParser=client->sendJSCommand(command); 
```



**Matlab client code example:**

```matlab
viewport = '{"referenceViewportFormatVersion": 1, "viewports":[{"geomTransRot": [0,0,0,1], "geomTransTransl": [0,0,0], "height":256, "width": 256}, {"geomTransRot": [0,0,0,1], "geomTransTransl": [0,0,0], "height":256, "width": 256}]}';
tp = 'galvo' ;

femtoapiObj = FemtoAPIProcessing(); % connect to local server (MESc)   
result = femtoapiObj.createMultiLayerMUnit(256,256,2,tp,viewport) % create measurement unit 
```



**Python client code example:**

```py
command="FemtoAPIFile.createMultiLayerMUnit(256,256,2,tp,viewport);” 
simpleCmdParser=client.sendJSCommand(command)  

resultCode=simpleCmdParser.getResultCode() 

if resultCode > 0: 
    print ("Return code: %d" % resultCode) 
    print (simpleCmdParser.getErrorText()) 
else:   
    print ("createMultiLayerMUnit(): %s" % simpleCmdParser.getJSEngineResult()) 
```



## 

## **var result = FemtoAPIFile.extendMUnit(mUnitHandle, countDims)**



Extends a measurement unit given by 'mUnitHandle' with the number of frames 'countDims'.

Input parameters:

* **mUnitHandle:** unique index of a measurement unit converted to string, e.g. '23,0,1'.
* **countDims:** number of frames to extend the measurement unit with

Returns a json object containing the following fields:

* **succeeded**: bool, true if the extend measurement unit command has been successfully initiated, false otherwise.
* **id**: command id, which is used as input to  FemtoAPIFile.getStatus(commandID)(API2-A-1448161797) command, to obtain the current status of the command (the asynchronous part), if succeeded == true.

It fails when:

* the parameter mUnitHandle is syntactically invalid, or there is no opened measurement unit with this index is present, or
* the given measurement unit is not accessible because another asynchronous operation is running or the file is being closed, or
* this image type cannot be extended

  

### Usage in Matlab

result = femtoapiObj.extendMUnit(mUnitHandle, countDims)

For more information about usage, see the  and the examples below.



### Examples

**C++ code example:**

```cpp
QString command = “FemtoAPIFile.extendMUnit('43,0,2',10)”; 
auto cmdParser=client->sendJSCommand(command); 
```



**Matlab client code example:**

```matlab
femtoapiObj = FemtoAPIProcessing(); % connect to local server (MESc)   
result = femtoapiObj.extendMUnit([43,0,2],10) % extends measurement unit with 10 frames, result is the returned json object  from server converted to struct
```



**Python client code example:**

```py
command="FemtoAPIFile.extendMUnit('43,0,2',10);” 
simpleCmdParser=client.sendJSCommand(command)  

resultCode=simpleCmdParser.getResultCode() 

if resultCode > 0: 
    print ("Return code: %d" % resultCode) 
    print (simpleCmdParser.getErrorText()) 
else:   
    print ("FemtoAPIFile.extendMUnit(): %s" % simpleCmdParser.getJSEngineResult()) 
```



## 

## **var result = FemtoAPIFile.deleteMUnit(mUnitHandle)**



Deletes a measurement unit from a .mesc file given by 'mUnitHandle' .

Input parameters:

* **mUnitHandle:** unique index of a measurement unit converted to string, e.g. '23,0,1'.

Returns a json object containing the following fields:

* **succeeded**: bool, true if the synchronous part of the command has been successfully run, false otherwise.
* **id**: command id, which is used as input to  FemtoAPIFile.getStatus(commandID)(API2-A-1448161797) command, to obtain the current status of the command (the asynchronous part), if succeeded == true.
* **deletedMUnitIdx:** the measurement unit index that has been deleted

It fails when:

* the parameter 'mUnitHandle' is syntactically invalid, or there is no opened measurement unit with this index is present, or
* the given measurement unit is not accessible because another asynchronous operation is running or the file is being closed

  

### Usage in Matlab

result = femtoapiObj.deleteMUnit(mUnitHandle)

For more information about usage, see the  and the examples below.



### Examples

**C++ code example:**

```cpp
QString command = “FemtoAPIFile.deleteMUnit('43,0,2')”; 
auto cmdParser=client->sendJSCommand(command); 
```



**Matlab client code example:**

```matlab
femtoapiObj = FemtoAPIProcessing(); % connect to local server (MESc)   
result = femtoapiObj.deleteMUnit([43,0,2]) % delete measurement unit, result is the returned json object from server converted to struct
```



**Python client code example:**

```py
command="FemtoAPIFile.deleteMUnit('43,0,2');” 
simpleCmdParser=client.sendJSCommand(command)  

resultCode=simpleCmdParser.getResultCode() 

if resultCode > 0: 
    print ("Return code: %d" % resultCode) 
    print (simpleCmdParser.getErrorText()) 
else:   
    print ("FemtoAPIFile.deleteMUnit(): %s" % simpleCmdParser.getJSEngineResult()) 
```



## 

## **var result = FemtoAPIFile.copyMUnit(sourceMUnitHandle, destMHandle, bCopyChannelContents = true)**



Copies the source measurement unit to the requested measurement session (or group). Channels with contents and metadata are copied by default. If 'bCopyChannelContents' is set to false, channels are copied almost the same way, except that channel data values will not be copied, and it will be created with zero values.

Input parameters:

* **sourceMUnitHandle**: the unique index of the measurement unit to copy in string format, e.g. '34,0,0'
* **destMHandle**: the unique index of the destination measurement session (or group) to copy the source MUnit to, in string format, e.g. '43,0'.
* **bCopyChannelContents**: if true, channel contents of measurement unit will be copied too. Otherwise, channel data values are 0.

Returns a json with the following fields:

* **succeeded**: Returns true if the copy of the unit was successfully initiated, otherwise it returns false
* **id**: command id, which is used as input to  FemtoAPIFile.getStatus(commandID)(API2-A-1448161797) command, to obtain the current status of the command (the asynchronous part), if succeeded == true.
* **copiedParameters**: Contains a **measurement** element and and other linked element if the copied MUnit has one. Unique index(es) of the newly created (copied) measurement unit(s) as string, e.g. '45,0,0'

  *"copiedParameters": {"background": "11,1,0", "measurement": "11,0,2"}*

*Note 1*: If measurement MUnit is copied, then its linked MUnit(s) is/are copied as well.

*Note 2*: the source and the MSession where the source measurement unit is located and the destination MSession can be different within the same file, or they can be in different measurement files.



### Usage in Matlab

result = femtoapiObj.copyMUnit(sourceMUnitHandle, destMHandle, bCopyChannelContents)

For more information about usage, see the  and the examples below.

### Examples

**C++ code example:**

```cpp
QString command = “FemtoAPIFile.copyMUnit ('61,0,1', '62,0', true)”; 
auto cmdParser=client->sendJSCommand(command); 
```



**Matlab client code example:**

```matlab
femtoapiObj = FemtoAPIProcessing(); % connect to local server (MESc)  

% copy source measurement unit [61,0,1], to the requested measurement session  [62,0,1], including channel contents
result = femtoapiObj.copyMUnit([61,0,1], [62,0,1], true); % result is json converted to struct
newresult.copiedMUnitIdx % the copied measurement unit index as Matlab array, in this case [62,0,1]
```



**<span style="letter-spacing:0.0px;">Python </span><span style="letter-spacing:0.0px;">client</span> <span style="letter-spacing:0.0px;">code</span> <span style="letter-spacing:0.0px;">example</span><span style="letter-spacing:0.0px;">: </span>**

```py
command="FemtoAPIFile.copyMUnit ('61,0,1', '62,0', true);” 
simpleCmdParser=client.sendJSCommand(command)  
resultCode=simpleCmdParser.getResultCode() 

if resultCode > 0: 
    print ("Return code: %d" % resultCode) 
    print (simpleCmdParser.getErrorText()) 
else:   
    print ("copyMUnit (): %s" % simpleCmdParser.getJSEngineResult()) 
```



## 

## **var result = FemtoAPIFile.moveMUnit(sourceMUnitHandle, destMSessionHandle)**



Moves the source measurement unit to the requested measurement session (or group).  The content of the channels are always moved.



Input parameters:

* **sourceMUnitHandle**: the index of the measurement unit to move
* **destMSessionHandle**: the index of the destination measurement session to move the source MUnit

Returns a json with the following fields:

* **succeeded**: Returns true if the move of the unit was successfully initiated, otherwise it returns false
* **id**: command id, which is used as input to  FemtoAPIFile.getStatus(commandID)(API2-A-1448161797) command, to obtain the current status of the command (the asynchronous part), if succeeded == true.
* **movedParameters**<span style="letter-spacing:0.0px;">:</span> <span style="letter-spacing:0.0px;">Contains a **measurement** element and other linked element of the moved MUnit (if any). Unique index(es) of the newly created (copied) measurement unit(s) as string, e.g. '45,0,0'</span>

  *"movedParameters": {"background": "11,1,1", "measurement": "11,0,3"}*

*Note 1*: the MSession where the source measurement unit is located and the destination MSession can be different within the same file, or they can be in different measurement files.

*Note 2*: if the source measurement unit has linked MUnits, they are also moved, if moving is possible. (If the linked MUnit(s) is/are linked to another MUnit(s), then moving is not possible).

*Note 3*: when moving is not possible, the main and the linked MUnit(s) will be copied intead of move.



### Usage in Matlab

result = femtoapiObj.moveMUnit(sourceMUnitHandle, destMSessionHandle, bCopyChannelContents)

For more information about usage, see the  and the examples below.

### Examples

**C++ code example:**

```cpp
QString command = “FemtoAPIFile.moveMUnit('61,0,1', '62,0')”; 
auto cmdParser=client->sendJSCommand(command); 
```







**Matlab client code example:**

```matlab
femtoapiObj = FemtoAPIProcessing(); % connect to local server (MESc)  

% move source measurement unit [61,0,1], to the requested measurement session  [62,0,1] 
result = femtoapiObj.moveMUnit ([61,0,1], [62,0,1]); 
```





**Python client code example:**

```py
command="FemtoAPIFile.moveMUnit ('61,0,1', '62,0');” 
simpleCmdParser=client.sendJSCommand(command)  
resultCode=simpleCmdParser.getResultCode() 

if resultCode > 0: 
    print ("Return code: %d" % resultCode) 
    print (simpleCmdParser.getErrorText()) 
else:   
    print ("moveMUnit (): %s" % simpleCmdParser.getJSEngineResult()) 
```



## **var result = FemtoAPIFile.setLinkedMUnit(sourceMUnitHandle, linkedMUnitHandle)**

Links MUnit specified by 'linkedMUnitHandle' to the main MUnit with 'sourceUnitHandle'. The main MUnit must be in a measurement MSession and the linked MUnit must be within a background MSession within the same file as the main MUnit.

Linking means that the linked MUnit is always copied/moved/deleted along with the main MUnit. Linking has the following properties:

* One background MUnit can be linked to several measurement MUnits
* Only one background image can be linked to a main MUnit with a specified image role
* The main and its linked MUnit(s) must be within the same file.
* When copying the main MUnit, the linked MUnit(s) is/are also copied.
* When moving the main MUnit, the linked MUnit(s) is/are only moved if it is not linked to another measurement MUnit(s). Otherwise the linked MUnit(s) is/are copied
  with the main MUnit.
* Linked MUnit can't be copied/moved/deleted, only with the main MUnit.
* The linked MUnit is deleted automatically when the main MUnit is deleted, if and only if it is not linked to other MUnit(s).
* After an MUnit is linked to its main MUnit, it can't be deleted manually.
* An MUnit in the background MSession can be linked to more than one main MUnit. In this case, it is deleted when the last main MUnit
  pointing to it is deleted.

  

**Input parameters:**

* **sourceMUnitHandle**: the index of the main measurement unit. It must be an MUnit with measurement role.
* **linkedMUnitHandle**: the index of the destination measurement unit to link to the the mainMUnit . It must point to an MUnit in the background session.

Returns true if linking was successful, false otherwise.

### Usage in Matlab

result = femtoapiObj.setLinkedMUnit(sourceMUnitHandle, linkedMUnitHandle)

For more information about usage, see the  and the examples below.



### Examples:

Link MUnit with handle '61,1,0' from the background session to the main MUnit with handle '61,0,1':



**C++ code example:**

```cpp
QString command = “FemtoAPIFile.setLinkedMUnit('61,0,1', '61,1,0')”; 
auto cmdParser=client->sendJSCommand(command); 
```



**Matlab client code example:**

```matlab
femtoapiObj = FemtoAPIProcessing(); % connect to local server (MESc)  
result = femtoapiObj.setLinkedMUnit([61,0,1], [61,1,0]); 
```



**Python client code example:**

```py
command="FemtoAPIFile.setLinkedMUnit('61,0,1', '61,1,0');” 
simpleCmdParser=client.sendJSCommand(command)  
resultCode=simpleCmdParser.getResultCode() 

if resultCode > 0: 
    print ("Return code: %d" % resultCode) 
    print (simpleCmdParser.getErrorText()) 
else:   
    print ("setLinkedMUnit(): %s" % simpleCmdParser.getJSEngineResult()) 
```