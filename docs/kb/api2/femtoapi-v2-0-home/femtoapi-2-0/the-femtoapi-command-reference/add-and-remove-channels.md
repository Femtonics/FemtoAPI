# Add and remove channels
## 

## **var result = FemtoAPIFile.addChannel(mUnitHandle, channelName, compressionPreset=0)**

  


Adds a new channel to the unit of measure with the specified channel name if there is no channel with that name, otherwise the json returned is set to "false".

Input parameters:

* mUnitHandle: unique index of an open unit of measurement converted to a string, e.g. "55,0,1"
* channelName: The name of the channel you want to add
  * 0=No compression
  * 1=Preset1: ZLib, compression level=2
  * 2=Preset2: ZLib, compression level=9
  * ~~3=Preset3: BLOSC - Currently disabled~~
  * ~~4=Preset4: IP~~ – Currently disabled~~~~

  


Returns a JSON object that contains the following fields:

* **Success: True** if the synchronized portion of the command completed successfully and the channel add command was issued successfully, otherwise false
* **id**: Command ID that can be used to retrieve command status information
* added **ChannelIdx**: unique index of the input unit appended by the newly added channel index, converted to a string, e.g. "55,0,1,2".

  


### Use in Matlab

First, create a FemtoApiProcessing object as described  here ([Tutorial: using the FemtoAPI Matlab client](../the-femtoapi-matlab-client/tutorial-using-the-femtoapi-matlab-client.md)). The use is the same as described above,

result = femtoapiObj.addChannel(mUnitHandle, channelName) 

where mUnitHandle is as a Matlab array, channelName is char as an array, and "result" is the JSON returned by the server in a Matlab structure.

### Examples

**C++ code example:**

```cpp
QString command = “FemtoAPIFile.addChannel('43,0,1','PMT_UR')”;
auto cmdParser=client->sendJSCommand(command);
```

  


**Example Matlab client code:** 

```matlab
femtoapiObj = FemtoApiProcessing;
result = femtoapiObj.addChannel ([43,0,1],'PMT_UR');
addedChannelHandle = result.addedChannelIdx; % vector of added channel handle
```

**Python client code example:** 

```py
command="FemtoAPIFile.addChannel('43,0,1','PMT_UG');"
simpleCmdParser=client.sendJSCommand(command)
resultCode=simpleCmdParser.getResultCode()

if resultCode > 0:
    print ("Return code: %d" % resultCode)
    print (simpleCmdParser.getErrorText())
else:	
    print ("addChannel(): %s" % simpleCmdParser.getJSEngineResult())
```

## 

## **var result = FemtoAPIFile.deleteChannel(channelHandle)**

  


Removes the specified channel. If there is no channel with that channel handle, "false" is set in the json returned.

Input parameter:

* channelHandle: unique index of the unit of measurement, including channel index, in string format, e.g. "65,0,1,2"

Returns a JSON object that contains the following fields:

* **Success: True** if the synchronized portion of the command completed successfully and the channel add command was issued successfully, otherwise false
* **id**: Command ID that can be used to retrieve command status information

  


### Use in Matlab

First, create a FemtoApiProcessing object as described  here ([Tutorial: using the FemtoAPI Matlab client](../the-femtoapi-matlab-client/tutorial-using-the-femtoapi-matlab-client.md)). The use is the same as described above,

result = femtoapiObj.deleteChannel(channelHandle) 

where channelHandle is specified as a Matlab array, and "result" is the JSON returned by the server into a Matlab structure.

  


### Examples

**C++ code example:**

```cpp
QString command = “FemtoAPIFile.deleteChannel('43,0,1,1')”;
auto cmdParser=client->sendJSCommand(command);
```

  


**Matlab client code example:** 

```matlab
femtoapiObj = FemtoApiProcessing;
result = femtoapiObj.deleteChannel ([43,0,1,1]);
```

  


**Python client code example:** 

```py
command="FemtoAPIFile.deleteChannel('43,0,1,1');"
simpleCmdParser=client.sendJSCommand(command)
resultCode=simpleCmdParser.getResultCode()

if resultCode > 0:
    print ("Return code: %d" % resultCode)
    print (simpleCmdParser.getErrorText())
else:	
    print ("deleteChannel(): %s" % simpleCmdParser.getJSEngineResult())
```

  
