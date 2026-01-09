# Read-write binary channel data
#### Common parameters of binary read and write commands

* **handle** The unique descriptor string of an open .mesc file, measurement session, measurement, or channel. For example, '52,0,1,1' means the .mesc file with ID 52, its measurement session with ID 0, its measurement unit with ID 1, and its channel number 1. Handles are displayed on the MESc GUI, too.
* **fromDims** A string enumerating the starting indices of a sub-hyperrectangle of a multidimensional data array. For example, in a 3-dimensional data array, '256,0,10' means index 256 in the first dimension, index 0 in the second dimension, and index 10 in the third dimension. Note that all indices are zero-based.
* **countDims** A string enumerating the dimensions of a sub-hyperrectangle of a multidimensional data array. For example, in a three-dimensional data array, '512,512,10' means 512 pixels in the first and second dimensions, and 10 frames in the third dimension.

#### Notes for using binary read and write commands

* All indices in the parameter fromDims are zero-based. 

* The parameters fromDims and countDims must have the same number of dimensions.

* If the parameters fromDims and countDims are not strings containing nonnegative integers separated by single commas, a corresponding error message is generated in the MESc log file with the tag &lt;MEScAPIServer>, and the last error message can be retrieved with the FemtoAPI command 'FemtoAPIFile.getLastCommandError();'.

* In all binary read and write commands, raw data are always transferred using the data type of the channel specified by the handle, and the converted data are always transferred as double precision floating point numbers.

* If you write var before the return value of any FemtoAPI command, the result is not sent to the client as JSON or binary data. E.g.,

  * var result = FemtoAPIFile.getProcessingState() stores the result on the server side, but
  * result = FemtoAPIFile.getProcessingState() and FemtoAPIFile.getProcessingState() send the result to the client.


* The read(Raw)ChannelData commands described in the following section always return null to the client and store their results only on the server side.


* the sub-hyperrectangle described by the parameters fromDims and countDims must always have an intersection with the dimensions of the specified channel, e.g., they must fulfill the following conditions for all dimensions n (Otherwise, no data is transferred, and null is returned to the client):  

  * (0&lt;=) fromDims(n) &lt; dimension(n) ,
  * 1 &lt;= countDims(n) , 
  * countDims(n) can be the string 'Inf' , it means the whole image part after fromDims(n), so it is internally truncated as following: countDims(n) = dimension(n) - fromDims(n),
  * if fromDims(n) + countDims(n) > dimension(n), then countDims(n) is truncated internally so that fromDims(n) + countDims(n) = dimension(n).

* The 'Inf' as countDims(n) parameter is useful when you want to read part of an image, but you don't know the exact dimensions of it. You only have to deal with the fromDims(n) parameter. 

* In case of write functions, the data to write must have the same dimensions as the sub-hyperrectangle specfied by fromDims and (truncated) countDims parameters. Otherwise an error is returned and no data is written.

* readRawChannelDataToClientsBlob transfers raw binary data to the FemtoAPI client as a binary blob. This method is useful for quickly transferring large amounts of binary data from the server to the client. The read data type of raw data is the data type of the channel specified by the parameter handle.

  


#### Differences in Matlab

In the Matlab variant of these commands, the following differences are present: 

* Regarding the read channel data commands, only the read(Raw)ChannelDataToClientsBlob commands are wrapped, because of practical reasons. It returns image data as 3D (or 4D in case of volume scan) matlab array. Similarly, regarding the write channel data command, the write(Raw)ChannelDataFromAttachment command is wrapped. 

* In case of reading converted data, Matlab function readChannelData() actually reads the raw data from server, and uses the channel conversion values from processing state and converts it locally according to the given data type. 

* input parameters are a bit different: 

  * **readSubSlabSpec**: instead of fromDims and countDims as strings, the sub-hyperrectangle of a multidimensional image array in read functions is specified as a cell containing numeric arrays: { \[fromX : stepX : toX], \[fromY : stepY : toY], \[fromZ : stepZ : toZ] } in case of 3D channel data, and { \[fromX : stepX : toX], \[fromY : stepY : toY], \[fromZ : stepZ : toZ], \[fromT : stepT : toT] } in case of 4D channel data. For example: { \[1:3:10], \[2:5:300], \[1:10] } means the image portion in X dimension from pixel 1 to 10, with step 3, in Y dimension from 2 to 300 with step 5, and in Z dimension, from 1 to 10. If it is not specified, the whole channel data is read.
  * **channelHandle**: as described above, a unique id of the requested channel, but given as a numeric array (e.g. \[43 0 1 0] )
  * in case of write functions, the image data is always given as input parameter, so the sub-hyperrectangle can be specified by fromDims and the input image data. (The dimensions of the given image array corresponds to the countDims parameter). 
  * input parameters fromDims and readSubSlabSpec use Matlab indexing (begin with 1)

  


  


## **FemtoAPIFile.readRawChannelDataToClientsBlob(handle, fromDims, countDims)**

  


Transfers raw binary data to the FemtoAPI client as a binary blob. This method is useful for quickly transferring large amounts of binary data from the server to the client. The read data type of raw data is the data type of the channel specified by the parameter handle.

  


Return value: In case of a successful read, the server returns the binary data of the requested sub-hyperrectangle, and the JavaScript engine returns a JSON object with the size of the read data.

Otherwise, no binary data are received and the JS engine returns 0 as the data size.

### Usage in Matlab:

Firstly, you need to create a FemtoAPIProcessing object, as described  here(API2-A-1448161761). After it, you can call this command as following: 

**rawData = readRawChannelData(channelHandle, readSubSlabSpec)**

Input parameters:

Required: 

* channelHandle: numeric array, unique id of the requested channel (e.g. \[43 0 1 0] )

Optional:

* readSubSlabSpec: cell, that contains numeric arrays, which specifies a sub-hyperrectangle of a multidimensional image array. Instead of 'fromDims' and 'countDims', it uses the following format: { \[fromX : stepX : toX], \[fromY : stepY : toY], \[fromZ : stepZ : toZ] } in case of 3D channel data, and { \[fromX : stepX : toX], \[fromY : stepY : toY], \[fromZ : stepZ : toZ], \[fromT : stepT : toT] } in case of 4D channel data. For example: { \[1:3:10], \[2:5:300], \[1:10] } means the image portion in X dimension from pixel 1 to 10, with step 3, in Y dimension from 2 to 300 with step 5, and in Z dimension, from 1 to 10. If not specified, the whole channel data is read.

Notes on readSubSlabSpec parameter: 

* the fromD, stepD, toD parameters have to be positive integers, otherwise an error is returned.
* in case of 3D channel data, the image slab has to be specified in X, Y, Z dimensions, unless the channel contains only 1 frame, in this case, readSubSlabSpec can be { fromX : stepX : toX, fromY : stepY : toY } or { fromX : stepX : toX, fromY : stepY : toY, 1 }, otherwise an error is returned and no data is read.
* in case of 4D channel data (e.g. volume scan), the slab has to be specified in all 4 dimensions, otherwise an error is returned and no data is read.
* other than the cases listed, if the subslab dimension size is less than 3D or greater than 4D, an error is returned 

  


Returns the read raw data as 2D (channel contains only 1 frame), 3D, or 4D (in case of volume scan data) array. The read raw data type is the channel data type (uint16 or double).

### ***Examples***: 

***C++ code example:***

```cpp
QString command = “FemtoAPIFile.readRawChannelDataToClientsBlob('61,0,1,0', '0,0,0', '512,512,10')”;
auto cmdParser=client->sendJSCommand(command);
```

  


***Matlab client code example:*** 

```
femtoapiObj = MEScAPIProcessing(); % connect to local server (MESc) 

% read raw channel data of measurement unit [61,0,1], from channel 0
imRawData = femtoapiObj.readRawChannelData([61,0,1,0]);

% read part of image data: 1:512 pixels in X, 1:512 in Y, and 1:10 in Z dimension
readSubSlabSpec = {[1:512],[1:512],[1:10]}; 
imDataPartRaw = femtoapiObj.readRawChannelData([61,0,1,0],readSubSlabSpec);
```

  


***Python client code example:*** 

```py
command="FemtoAPIFile.readRawChannelDataToClientsBlob('61,0,1,0', '0,0,0', '512,512,10');"
simpleCmdParser=client.sendJSCommand(command)

resultCode=simpleCmdParser.getResultCode()
if resultCode > 0:
    print ("Return code: %d" % resultCode)
    print (simpleCmdParser.getErrorText())
else:	
    print ("Image size %d" % simpleCmdParser.getJSEngineResult())
    if simpleCmdParser.hasBinaryParts() == True:
        for parts in simpleCmdParser.getPartList():
            #print(parts.data())
            print( "Binary part sizes: %d" % parts.size())
```

  


  


  


## **FemtoAPIFile.readChannelDataToClientsBlob(handle, fromDims, countDims)**

  


The converted binary data is transferred from the server to the FemtoAPI client as a binary blob. The data type is double.

Return value: The same as in the 'raw' case, but the converted binary data are returned from the server.

### Usage in Matlab

Firstly, you need to create a FemtoAPIProcessing object, as described  here(API2-A-1448161761). After it, you can call this command as following: 

**convertedData = femtoapiObj.readChannelData(channelHandle, readDataType, readSubSlabSpec)**

Input arguments:

Required: 

* channelHandle: same as described at readRawChannelData command
* readDataType: data type of channel specified by 'channelHandle'. It can be 'uint16' or 'double'. 

Optional: 

* readSubSlabSpec: same as described at readRawChannelData command

Returns the converted image data.

*Note*: This function internally reads the raw channel data from server in the channel data type, then converts it locally according to the given read data type ( 'readDataType' ).

### Examples

***C++ code example:***

```cpp
QString command = “FemtoAPIFile.readChannelDataToClientsBlob('61,0,1,0', '0,0,0', '512,512,10')”;
auto cmdParser=client->sendJSCommand(command);
```

  


***Matlab client code example:*** 

```
femtoapiObj = MEScAPIProcessing(); % connect to local server (MESc) 

% read raw channel data of measurement unit [61,0,1], from channel 0
imRawData = femtoapiObj.readChannelData([61,0,1,0],'uint16');

% read part of image data: 1:512 pixels in X, 1:512 in Y, and 1:10 in Z dimension
readSubSlabSpec = {[1:512],[1:512],[1:10]}; 
readDataType = 'double'; % it can be 'double' or 'uint16'
imDataPartRaw = femtoapiObj.readChannelData([61,0,1,0],readDataType, readSubSlabSpec);

```

  


***Python client code example:*** 

```py
command="FemtoAPIFile.readChannelDataToClientsBlob('61,0,1,0', '0,0,0', '512,512,10');"
simpleCmdParser=client.sendJSCommand(command)

resultCode=simpleCmdParser.getResultCode()
if resultCode > 0:
    print ("Return code: %d" % resultCode)
    print (simpleCmdParser.getErrorText())
else:	
    print ("Image size %d" % simpleCmdParser.getJSEngineResult())
    if simpleCmdParser.hasBinaryParts() == True:
        for parts in simpleCmdParser.getPartList():
            #print(parts.data())
            print( "Binary part sizes: %d" % parts.size())
```

  


## **FemtoAPIFile.readRawChannelDataJSON(handle, fromDims, countDims)**

  


The server sends the requested raw image data as a JSON string to the FemtoAPI client. No binary data are transferred.

Return value: In case of a successful read, the specified raw values are returned to the client as a JSON array. Otherwise, an empty JSON array is returned. No binary data are sent from the server.

  


### Examples

***C++ code example:***

```cpp
QString command = “FemtoAPIFile.readRawChannelDataJSON('61,0,0,0', '0,0,10', '512,512,1')”;
auto cmdParser=client->sendJSCommand(command);
```

  


***Matlab client code example:*** 

This function is not present in the Matlab client. 

  


***Python client code example:*** 

```py
command="FemtoAPIFile.readRawChannelDataJSON('61,0,0,0', '0,0,10', '512,512,1');"
simpleCmdParser=client.sendJSCommand(command)
resultCode=simpleCmdParser.getResultCode()
if resultCode > 0:
    print ("Return code: %d" % resultCode)
    print (simpleCmdParser.getErrorText())
else:	
    print ("readRawChannelDataJSON(): %s" % simpleCmdParser.getJSEngineResult().encode('utf-8'))
```

  


## **FemtoAPIFile.readChannelDataJSON(handle, fromDims, countDims)**

  


The server sends the requested converted image data as a JSON string to the FemtoAPI client. No binary data are transferred.

Return value: In case of a successful read, the specified converted values are returned to the client as a JSON array. Otherwise, an empty JSON array is returned. No binary data are sent from the server.

### Examples

***C++ code example:***

```cpp
QString command = “FemtoAPIFile.readChannelDataJSON('61,0,1,1', '0,0,3', '512,512,10')”;
auto cmdParser=client->sendJSCommand(command);
```

  


***Matlab client code example:*** 

This function is not present in the Matlab client. 

  


***Python client code example:*** 

```py
command="FemtoAPIFile.readChannelDataJSON('61,0,1,1', '0,0,3', '512,512,10');"
simpleCmdParser=client.sendJSCommand(command)
resultCode=simpleCmdParser.getResultCode()
if resultCode > 0:
    print ("Return code: %d" % resultCode)
    print (simpleCmdParser.getErrorText())
else:	
    print ("readChannelDataJSON(): %s" % simpleCmdParser.getJSEngineResult())
```

  


## **var imgData = FemtoAPIFile.readRawChannelData(handle, fromDims, countDims)**

## **or**

## **imgData = FemtoAPIFile.readRawChannelData(handle, fromDims, countDims)**

  


Reads raw channel data on the server side to a JavaScript variable. The read data type of raw data is the data type of the channel specified by the parameter handle.

Return value: Both commands return the JSON result 'null' to the client side, and no binary data. The returned value is stored on the server side.

  


### Examples

***C++ code example:***

```cpp
QString command = “var data = FemtoAPIFile.readRawChannelData('61,0,1,0', '0,0,0', '512,512,10')”;
auto cmdParser=client->sendJSCommand(command);
```

 

***Matlab client code example:*** 

This function is not present in the Matlab client. 

  


***Python client code example:*** 

```py
command="var data = FemtoAPIFile.readRawChannelData('61,0,1,0', '0,0,0', '512,512,10');"
simpleCmdParser=client.sendJSCommand(command)

resultCode=simpleCmdParser.getResultCode()
if resultCode > 0:
    print ("Return code: %d" % resultCode)
    print (simpleCmdParser.getErrorText())
else:	
    print ("readRawChannelData(): %s" % simpleCmdParser.getJSEngineResult())
```

  


## **var imgData = FemtoAPIFile.readChannelData(handle, fromDims, countDims)**

## **or**

## **imgData = FemtoAPIFile.readChannelData(handle, fromDims, countDims)**

  


Reads converted channel data on the server side into a JavaScript variable. The read data type of converted data is double.

Both commands return the JSON result 'null' to the client side, and no binary data.

  


### Examples

***C++ code example:***

```cpp
QString command = “var data = FemtoAPIFile.readChannelData('61,0,1,0', '0,0,0', '512,512,10')”;
auto cmdParser=client->sendJSCommand(command);
```

  


***Matlab client code example:*** 

This function is not present in the Matlab client. 

  


***Python client code example:*** 

```py
command="var data = FemtoAPIFile.readChannelData('61,0,1,0', '0,0,0', '512,512,10');"
simpleCmdParser=client.sendJSCommand(command)

resultCode=simpleCmdParser.getResultCode()
if resultCode > 0:
    print ("Return code: %d" % resultCode)
    print (simpleCmdParser.getErrorText())
else:	
    print ("readChannelData(): %s" % simpleCmdParser.getJSEngineResult())
```

  


## **Var isWritten = FemtoAPIFile.writeRawChannelData(data, handle, fromDims, countDims)**

## **or**

## **isWritten = FemtoAPIFile.writeRawChannelData(data, handle, fromDims, countDims)**

  


Writes raw channel data from the variable to the specified sub-hyperrectangle. The variable should be of the same type as the channel to write specified by handle, and the sub-hyperrectangle specified by fromDims and countDims must fulfill the conditions described in the introduction.

The returned JSON object variable isWritten contains true and a 'Success' message, if the data was written successfully, otherwise it contains false and the error message itself. At the commands, in the former case, when var is before the isWritten variable, it is stored on the server side, and null is sent to the client, while in the latter case, the resulting variable is sent to the client as a JSON object.

  


### Examples

***C++ code example:***

```cpp
QString command = “var image = FemtoAPIFile.readRawChannelData('61,0,1,0', '0,0,0', '512,512,10'); FemtoAPIFile.writeRawChannelData(image,'61,0,1,1', '0,0,0', '512,512,10')”;
auto cmdParser=client->sendJSCommand(command);
```

  


***Matlab client code example:*** 

This function is not present in the Matlab client. 

  


***Python client code example:*** 

```py
command="var image = FemtoAPIFile.readRawChannelData('61,0,1,0', '0,0,0', '512,512,10'); FemtoAPIFile.writeRawChannelData(image,'61,0,1,1', '0,0,0', '512,512,10');"
simpleCmdParser=client.sendJSCommand(command)

resultCode=simpleCmdParser.getResultCode()
if resultCode > 0:
    print ("Return code: %d" % resultCode)
    print (simpleCmdParser.getErrorText())
else:	
    print ("read/write commands result: %s" % simpleCmdParser.getJSEngineResult())
```

  


## **var isWritten = FemtoAPIFile.writeChannelData(data, handle, fromDims, countDims)**

## **or**

## **isWritten = FemtoAPIFile.writeChannelData(data, handle, fromDims, countDims)**

  


Writes the converted data from a variable. Otherwise the same is true as for the writeRawChannelData command. 

### Examples

***C++ code example:***

```cpp
QString command = “var image = FemtoAPIFile.readChannelData('61,0,1,0', '0,0,0', '512,512,10'); FemtoAPIFile.writeChannelData(image,'61,0,1,1', '0,0,0', '512,512,10')”;
auto cmdParser=client->sendJSCommand(command);
```

### **Usage examples:**

#### Read and write raw data:

*imgData = FemtoAPIFile.readRawChannelData('61,0,1,0', '0,0,0', '64,64,1');*

// reads data to a variable on the server side

*isWritten = FemtoAPIFile.writeRawChannelData(imgData, '62,0,0,0', '0,0,0', '64,64,1');*

 // writes the imgData variable and the value of the isWritten variable (write success/failed) is returned to the client

#### Read and write converted data:

*imgData = FemtoAPIFile.readChannelData('61,0,1,0', '0,0,0', '64,64,1');*

// reads data to a variable on the server side

*isWritten = FemtoAPIFile.writeChannelData(imgData, '62,0,0,0', '0,0,0', '64,64,1');*

 // writes the imgData variable and the value of the isWritten variable (write success/failed) is returned to the client

  


***Matlab client code example:*** 

This function is not present in the Matlab client. 

  


***Python client code example:*** 

```py
command="var image = FemtoAPIFile.readChannelData('61,0,1,0', '0,0,0', '512,512,10'); FemtoAPIFile.writeChannelData(image,'61,0,1,1', '0,0,0', '512,512,10');"
simpleCmdParser=client.sendJSCommand(command)

resultCode=simpleCmdParser.getResultCode()
if resultCode > 0:
    print ("Return code: %d" % resultCode)
    print (simpleCmdParser.getErrorText())
else:	
    print ("read/write commands result: %s" % simpleCmdParser.getJSEngineResult())
```

## 

## **Var isWritten = FemtoAPIFile.writeRawChannelDataFromAttachment(handle, fromDims, countDims)**

## **or**

## **isWritten = FemtoAPIFile.writeRawChannelDataFromAttachment(handle, fromDims, countDims)**

  


Writes the specified raw data from an attached binary data file. The attached binary data type must be the same as the channel data type of the specified data, and the fromDims and countDims parameters must fulfill the conditions described in the introduction.

Return value: the same as for the write(Raw)ChannelData command.

  


### Usage in Matlab

Firstly, you need to create a FemtoAPIProcessing object, as described  here(API2-A-1448161761). After it, you can call this command as following: 

**femtoapiObj.writeRawChannelData(channelHandle, rawData, fromDims)**

Input arguments:

Required: 

* channelHandle: specifies the channel where to write 'rawData'. It must be a vector, e.g. \[43,0,1,0] is the channel with index 0 in the measurement unit \[43,0,1] 
* rawData: specifies the image data to write as matlab array. 

Optional: 

* fromDims: vector, specifies from which pixel the input rawData is written into the given channel, e.g. \[0,0,0]. Details are in the introduction.

  


*Note*: the written sub-hyperrectangle is specified by fromDims and rawData (the dimensions of rawData corresponds to the countDims parameter). 

  


### Examples

***C++ code example:***

```cpp
client->uploadAttachment(buffer);

QString command = “result= FemtoAPIFile.writeRawChannelDataFromAttachment('61,0,1,1', '0,0,0', '512,512,10')”;
auto cmdParser=client->sendJSCommand(command);
```

  


***Matlab client code example:*** 

```
femtoapiObj = MEScAPIProcessing() % connect to local server


writeFromDims = [1,1,1];
femtoapiObj.writeRawChannelData([61,0,1,1], imDataRaw, writeFromDims);
```

  


***Python client code example:*** 

```py
client.uploadAttachment(buffer);
command="result= FemtoAPIFile.writeRawChannelDataFromAttachment('61,0,1,1', '0,0,0', '512,512,10');"
simpleCmdParser=client.sendJSCommand(command)

resultCode=simpleCmdParser.getResultCode()
if resultCode > 0:
    print ("Return code: %d" % resultCode)
    print (simpleCmdParser.getErrorText())
else:	
    print ("writeRawChannelDataFromAttachment(): %s" % simpleCmdParser.getJSEngineResult())
```

  


## 

## **var isWritten = FemtoAPIFile.writeChannelDataFromAttachment(handle, fromDims, countDims)**

## **or**

## **isWritten = FemtoAPIFile.writeChannelDataFromAttachment(handle, fromDims, countDims)**

  


Writes the specified converted data from an attached binary data file. The attached binary data type must be the same as the channel data type of the specified data, and the fromDims and countDims parameters must fulfill the conditions described above.

Return value: the same as for the write(Raw)ChannelData command.

  


### Usage in Matlab

Firstly, you need to create a FemtoAPIProcessing object, as described  here(API2-A-1448161761). After it, you can call this command as following: 

**femtoapiObj.writeChannelData(channelHandle, data, fromDims)**

  


The data parameter is the converted data to write. Otherwise, the same applies as in case of writeRawChannelData.

*Note*: Internally, converted data is converted back to raw data first according to channel data type, then this raw data is sent to the server.

  


### Examples

***C++ code example:***

```cpp
client->uploadAttachment(buffer);

QString command = “result= FemtoAPIFile.writeChannelDataFromAttachment('61,0,1,1', '0,0,0', '512,512,10')”;
auto cmdParser=client->sendJSCommand(command);
```

  


Notes:

* It is possible to read converted data and then write it back as raw data and vice versa.
* The data type of the written raw data must be the same as the channel data type (double or uint16), otherwise the writing operation fails.
* Converted data are always read and written in the data type double, while raw data are always read and written in the data type of the specified channel.

  


## **var result = FemtoAPIFile.addLastFrameToMSession(sDestMSession, SpaceName)**

## **or**

## **result = FemtoAPIFile.addLastFrameToMSession(sDestMSession, SpaceName)**

  


Creates a new MUnit in the given MSession, and adds the frame on the immediate window (last frame of a measurement/live or snap) to it. If sDestMSession parameter is empty string, the current MSession is considered. Last frame is considered as the frame of immediate window of the space given by SpaceName, or from the default space if SpaceName is empty.  
Note: This is a synchronous operation, it waits until the new measurement unit is created and the immediate image is added to it, then returns the MUnit the node descriptor.

Input parameters:

* **sDestMSession:** The index of the destination measurement session
* **SpaceName:** Space name

Result:

The node descriptor of the created measurement unit containing the immediate image.

  


### Usage in Matlab

result = femtoapiObj.addLastFrameToMSession(destMSessionHandle, spaceName)

For more information about usage, see the introduction and the examples below.

### Examples

**C++ code example:**

  


```
QString command = “FemtoAPIFile.addLastFrameToMSession('62,0', 'space1')”; 
auto cmdParser=client->sendJSCommand(command); 
```

  


*****Matlab client code example:***** 

```
femtoapiObj = FemtoAPIProcessing(); % connect to local server (MESc)  
result = femtoapiObj.addLastFrameToMSession ([62,0], 'space1'); 
```

  


***Python client code example:*** 

  


```
command="FemtoAPIFile.addLastFrameToMSession ('62,0', 'space1');” 
simpleCmdParser=client.sendJSCommand(command)  
resultCode=simpleCmdParser.getResultCode() 
 
if resultCode > 0: 
    print ("Return code: %d" % resultCode) 
    print (simpleCmdParser.getErrorText()) 
else:   
    print ("moveMUnit (): %s" % simpleCmdParser.getJSEngineResult()) 
```

  
