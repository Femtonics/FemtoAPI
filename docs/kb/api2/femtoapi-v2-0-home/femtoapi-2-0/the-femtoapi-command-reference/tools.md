# Tools
## 

## **var isModified = FemtoAPIFile.modifyConversion(sConversionName, dScale, dOffset, bSave = false)**

  


Modifies conversion in MESc conversion manager to the given value, which can be saved to file if requested.

Conversion is given by its name, and its type can only be identical or linear, otherwise this function returns false. 

Input parameters:

* **sConversionName**: string, name of the conversion, as it can be seen in MESc conversion manager. 
* **dScale**: double, the new scale to set 
* **dOffset**: double, the new offset to set
* **bSave**: boolean, if true, the conversion is saved to disk if it has been modified. Otherwise, the specified conversion modified only in memory. Default value is false.

Returns: true if the named conversion's scale and offset has been successfully modified, 

 false otherwise (e.g. if conversion name is invalid, or failed to save to the disk)

  


### Usage in Matlab

First, a FemtoAPIProcessingobject must be created, as described  here(API2-A-1448161761). Usage is the same as described above: 

isModified = femtoapiObj.modifyConversion(conversionName, scale, offset, bSave)

Input parameters (required): 

* conversionName: char array
* scale: double
* offset: double

Input parameters (optional): 

* bSave: logical value

  


In case of any error, it throws an error type exception containing the error message, otherwise it returns true. 

  


### Examples

**C++ code example:**

```cpp
% set conversion PMT_UG parameters, without saving it 
QString command = “FemtoAPIFile.modifyConversion('PMT_UG',2.0,1.1,false)”; 
auto cmdParser=client->sendJSCommand(command);
```

  


**Matlab client example:** 

```matlab
femtoapiObj = FemtoAPIProcessing;

% set conversion PMT_UG parameters, without saving it 
femtoapiObj.modifyConversion('PMT_UG',2.0,1.1,false); 
```

  


**Python client example:** 

```py
command="FemtoAPIFile.modifyConversion('PMT_UG', '2.0', '1.1', false)” 
simpleCmdParser=client.sendJSCommand(command)  

resultCode=simpleCmdParser.getResultCode() 

if resultCode > 0: 
    print ("Return code: %d" % resultCode) 
    print (simpleCmdParser.getErrorText()) 
else:   
    print ("FemtoAPIFile.modifyConversion(): %s" % simpleCmdParser.getJSEngineResult()) 
```

  


  


## 

## **var result = FemtoAPIFile.getStatus(sCommandID)**

  


Gets status of an asynchronous file operation based on their command ID. You can get the command ID as the returned value of any asynchronous file operation command, if it was successfully initiated.

It returns a json with the following fields: 

* **isPending**: bool value, true if the requested file operation is in progress, false if it has been ended or if no such command ID exists.
* **error**: contains error information. It is empty string if no error has happened.

  


### Usage in Matlab

First create a FemtoAPIProcessingobject as described  here(API2-A-1448161761). You can use it the same way as described above:

result = femtoapiObj.getStatus(commandID) 

where commandID is a Matlab char array, and 'result' is the returned json from server parsed into a Matlab struct.

### Examples

**C++ code example** 

```cpp
QString command = “FemtoAPIFile.saveFileAsync()”; 
auto cmdParser=client->sendJSCommand(command);
if (!cmdParser) {
	qDebug()<<"Can't create result parser!";
	return -1;
}
if (cmdParser->getResultCode()!=0) {
    qDebug()<<cmdParser->getErrorText();
    return -1;
}

QString result=cmdParser->getJSEngineResult().toString();

// parse command result
QJsonParseError error;
QJsonDocument doc = QJsonDocument::fromJson(json.toUtf8(), &error);
if (doc.isNull())
{
	qDebug()<<"Can't parse result!";
	return -1;
}
QJsonObject resObj = doc.object();
QString commandID = resObj.value("id") // get command ID 
QString command = "FemtoAPIFile.getStatus(" + commandID + ")"; 

// get status 
cmdParser=client->sendJSCommand(command); 
result=cmdParser->getJSEngineResult().toString();
```

 

**Matlab client code example:** 

```matlab
femtoapiObj = FemtoAPIProcessing(); % connect to local server (MESc)   

result = femtoapiObj.saveFileAsync(); % saves current file
commandID = result.id;
succeed = result.succeeded
currFileHandle = femtoapiObj.getCurrentFileHandle

% polling status while save operation is pending
processing = true;
if(succeed)
    while(processing)
        status = femtoapiObj.getStatus(commandID)
        processing = status.isPending == 1
        pause(0.1)
    end
end

status = femtoapiObj.getStatus(commandID)
if(~isempty(status.error))
	disp(strcat("Error during asynchron save operation: ", status.error)) % in  
```

 

**Python client code example:** 

```py
command="FemtoAPIFile.saveFileAsync()"
simpleCmdParser=ws.sendJSCommand(command)
resultCode=simpleCmdParser.getResultCode()
if resultCode > 0:
    print ("Return code: " + str(resultCode))
    print (simpleCmdParser.getErrorText())
else:
	cmdResult = json.loads(simpleCmdParser.getJSEngineResult())
    print ("Filesave success: " + str(cmdResult["succeeded"]))

commandId = cmdResult["id"]

command="FemtoAPIFile.getStatus('" + str(commandId) + "')
simpleCmdParser=client.sendJSCommand(command)
resultCode=simpleCmdParser.getResultCode()
if resultCode > 0:
    print ("Return code: " + str(resultCode))
    print (simpleCmdParser.getErrorText())
else:
    cmdResult = simpleCmdParser.getJSEngineResult()
    print ("getStatus success:" + str(cmdResult))

```

## **var result = FemtoAPIFile.getStatus()**

Gets the status of currently opened files. 

It returns the following json::

**openedFilesStatus**: json array holding status information of currently opened files. It contains json objects with the following fields:

* **fileIndex**: file index (or file handle)
* **lastCommandID**: id of the last asynchronous command issued on the file
* **fileStatus**: status of the file, equal to one of the following values: "OK", "FileDoesNotExist", "CopyCancelled", "UnspecifiedError"
* **isPendingFileOperation**: true if there is currently a pending operation on the file, false otherwise
* **lastError:** last error on file

**lastFileOpenError**: json object holding error information on the last asynchronous file operation (from GUI and API)

* **commandID**: last file operation command id (if file has been opened from GUI, commandID is empty string)
* **error**: error text or empty string in case of the last file open operation resulted with no error

  


### Usage in Matlab

First create a FemtoAPIProcessingobject as described  here(API2-A-1448161761). You can use it the same way as described above:

result = femtoapiObj.getStatus() 

where 'result' is the returned json from server parsed into a Matlab struct.

### Examples

**C++ code example** 

```cpp
QString command = “FemtoAPIFile.getStatus()”; 
auto cmdParser=client->sendJSCommand(command);
if (!cmdParser) {
	qDebug()<<"Can't create result parser!";
	return -1;
}
if (cmdParser->getResultCode()!=0) {
    qDebug()<<cmdParser->getErrorText();
    return -1;
}

QString result=cmdParser->getJSEngineResult().toString();
```

 

**Matlab client code example:** 

```matlab
femtoapiObj = FemtoAPIProcessing(); % connect to local server (MESc)   
result = femtoapiObj.getStatus(); % get status of all opened .mesc files (json is parsed into struct)
```

  


**Python client code example:** 

```py
command="FemtoAPIFile.getStatus(fullPath)” 
simpleCmdParser=client.sendJSCommand(command)  

resultCode=simpleCmdParser.getResultCode() 

if resultCode > 0: 
    print ("Return code: %d" % resultCode) 
    print (simpleCmdParser.getErrorText()) 
else:   
    print ("FemtoAPIFile.getStatus(): %s" % simpleCmdParser.getJSEngineResult()) 
```

  


Example output json (after two MESc files are opened from GUI successfully): 

```js
{
    "lastFileOpenError": {
        "commandID": "",
        "error": [
        ]
    },
    "openedFilesStatus": [
        {
            "fileIndex": 99,
            "fileStatus": "OK",
            "isPendingFileOperation": false,
            "lastCommandId": "",
            "lastError": ""
        },
        {
            "fileIndex": 100,
            "fileStatus": "OK",
            "isPendingFileOperation": false,
            "lastCommandId": "",
            "lastError": ""
        }
    ]
}

```

  


 

## 

## **var curveXYSize = FemtoAPIFile.curveInfo(mUnitHandle, curveIdx)**

  


Gets measurement unit's curve XY data, and sends it the to client as binary blob. 

Input parameters: 

* **mUnitHandle**: unique index of a measurement unit, converted to a string, e.g. '43,0,0' 
* **curveIdx**: index of the curve within measurement unit. 

Returns the number of curve data ( (X,Y) pairs) in case when curve data has been sent successfully to the client, and an empty string in case of any error. 

Errors occur in the following cases: 

* mUnitHandle is ill formatted
* there is no opened measurement unit with the specified handle
* there is no curve with the given index in the given measurement unit
* the file lock was not successful (because other concurrent file operation was running at that time)
* the file is being closed

*Note*: valid curve indices can be obtained by issuing  FemtoAPIFile.getProcessingState()(API2-A-1448161786) command. Its output contains the curve metadata of the opened measurement units. 

  


### **Matlab usage**

First, you need to create a FemtoAPIProcessing object as described  here(API2-A-1448161761). After it, call the command: 

curveDataXY = femtoapiObj.curveInfo(mUnitHandle, curveIdx)

where mUnitHandle is a matlab array instead of string, e.g. \[45,0,0]. 

It returns the curve data in an Nx2 array, where the first column is the 'X' data, and second column is the 'Y' data of the curve. 

  


### Examples

**C++ code example** 

```cpp
QString command = “FemtoAPIFile.curveInfo('34,0,0',0)”; 
auto cmdParser=client->sendJSCommand(command);
```

 

**Matlab client code example:** 

```matlab
femtoapiObj = FemtoAPIProcessing(); % connect to local server (MESc)   
curveXY = femtoapiObj.curveInfo([34,0,1],0); 
curveXY(1,1) % first X data 
curveXY(1,2) % first Y data 
```

  


**Python client code example:** 

```py
command="FemtoAPIFile.curveInfo('34,2,1','1')” 
simpleCmdParser=client.sendJSCommand(command)  

resultCode=simpleCmdParser.getResultCode() 

if resultCode > 0: 
    print ("Return code: %d" % resultCode) 
    print (simpleCmdParser.getErrorText()) 
else:
    cmdResult = {}
    cmdResult.update({"Result": simpleCmdParser.getJSEngineResult()})
    xData = []
    yData = []
    curveData = {"xData": xData, "yData": yData}

    for parts in simpleCmdParser.getPartList():
        size = int(parts.size() / 2)
        binaryDataX = QByteArray()
        binaryDataY = QByteArray()
        binaryDataX.append(parts[:size])
        binaryDataY.append(parts[size:])
        
        stream = QDataStream(binaryDataX)
        stream.setByteOrder(QDataStream.ByteOrder.LittleEndian)
        while not stream.atEnd():
            floatData = stream.readDouble()
            curveData["xData"].append(floatData) 
        stream = QDataStream(binaryDataY)
        stream.setByteOrder(QDataStream.ByteOrder.LittleEndian)
        while not stream.atEnd():
            floatData = stream.readDouble()
            curveData["yData"].append(floatData)

        print( "Binary part with size: " + str(parts.size()))
    cmdResult.update({"CurveData": curveData})
	# cmdResult["Result"] holds the number of curve data ( (X,Y) pairs) while cmdResult["CurveData"] holds the actual data
    print ("FemtoAPIFile.curveInfo(): %s" % cmdResult["Result"]) 
```

  


## 

## **var success = FemtoAPIMicroscope.setFocusingMode(focusingMode, spaceName = '')**

  


UNSAFE command

Switches to the given focusing mode 'focusingMode', if it is valid. 

Input parameters: 

* **focusingMode**: string, valid values are obtained by the output of getFocusingModes() command
* **spaceName**: string, name of the space, if empty string, default space ("space1") is considered

Returns true if successfully switched to the requested focusing mode, 

 false in case of any errors. 

  


Errors occur in the following cases: 

* input parameters are ill formatted or the given spaceName or focusing mode does not exist
* handwheel is locked 

  


### **Matlab usage**

First, you need to create a FemtoAPIAcquisition object as described  here(API2-A-1448161761). After it, usage is the same as described above.

  


### Examples

First, call getFocusingModes() before this command, to obtain configured and valid focusing modes.

**C++ code example** 

```cpp
QString command = “FemtoAPIMicroscope.setFocusingMode('Standard')”; // in case if 'Standard' is a valid mode
auto cmdParser=client->sendJSCommand(command);
```

 

**Matlab client code example:** 

```matlab
femtoapiObj = FemtoAPIAcquisition(); % connect to local server (MESc)   
succeeded = femtoapiObj.setFocusingMode('Virtual'); % in case if 'Virtual' is a valid mode 
```

  


**Python client code example:** 

```py
command="FemtoAPIMicroscope.setfocusingMode('Virtual')” // in case if 'Virtual' is a valid mode
simpleCmdParser=client.sendJSCommand(command)  

resultCode=simpleCmdParser.getResultCode() 

if resultCode > 0: 
    print ("Return code: %d" % resultCode) 
    print (simpleCmdParser.getErrorText()) 
else:   
    print ("FemtoAPIMicroscope.setfocusingMode(): %s" % simpleCmdParser.getJSEngineResult()) 
```

  


  


## 

## **var result = FemtoAPIMicroscope.getFocusingModes(spaceName = '')**

UNSAFE command. 

Gets the available (configured) focusing modes for the specified space in json array, as it can be seen in the MESc GUI. If space name is not given, default space ('space1') is considered.

In case of any error, an empty json array and an error message is returned.

### **Matlab usage**

First, you need to create a FemtoAPIAcquisition object as described  here(API2-A-1448161761). After it, call the command: 

focusingModes = femtoapiObj.getFocusingModes()

where the returned value is a string array. 

  


### Examples

**C++ code example** 

```cpp
QString command = “FemtoAPIMicroscope.getFocusingModes()”; 
auto cmdParser=client->sendJSCommand(command);
```

 

**Matlab client code example:** 

```matlab
femtoapiObj = FemtoAPIAcquisition(); % connect to local server (MESc)   
focusingModes = femtoapiObj.getFocusingModes(); 
```

  


**Python client code example:** 

```py
command="FemtoAPIMicroscope.getFocusingModes()” 
simpleCmdParser=client.sendJSCommand(command)  

resultCode=simpleCmdParser.getResultCode() 

if resultCode > 0: 
    print ("Return code: %d" % resultCode) 
    print (simpleCmdParser.getErrorText()) 
else:   
    print ("FemtoAPIMicroscope.getFocusingModes(): %s" % simpleCmdParser.getJSEngineResult()) 
```

  


## 

## **var protocol = FemtoAPIMicroscope.getActiveProtocol()**

Gets the active protocol in json. This json contains information about:

* currently active user waveforms, channels, and patterns
* which waveform is currently set to be displayed on which channels
* display order and timing of the waveforms
* pattern metadata: path description, path order, cycle time, etc. 

  


### **Matlab usage**

First, you need to create a FemtoAPIAcquisition object as described  here(API2-A-1448161761). After it, call the command: 

protocol= femtoapiObj.getActiveProtocol()

where 'protocol' is the returned json from server parsed into a nested struct. 

  


### Examples

**C++ code example** 

```cpp
QString command = “FemtoAPIMicroscope.getActiveProtocol()”; 
auto cmdParser=client->sendJSCommand(command);
```

 

**Matlab client code example:** 

```matlab
femtoapiObj = FemtoAPIAcquisition(); % connect to local server (MESc)   
protocol = femtoapiObj.getActiveProtocol(); 
```

  


**Python client code example:** 

```py
command="FemtoAPIMicroscope.getActiveProtocol()” 
simpleCmdParser=client.sendJSCommand(command)  

resultCode=simpleCmdParser.getResultCode() 

if resultCode > 0: 
    print ("Return code: %d" % resultCode) 
    print (simpleCmdParser.getErrorText()) 
else:   
    print ("FemtoAPIMicroscope.getActiveProtocol(): %s" % simpleCmdParser.getJSEngineResult()) 
```

  


  


Example output: 

  


```js
{
    "beginCut": 0,
    "lastModified": "2020-04-15T14:01:42",
    "measurementLength": 0.2,
    "modifiedBy": "szalnor",
    "name": "Default protocol",
    "protocolId": "{bfa51e87-5084-4815-a8fa-88c84635ce12}",
    "runtimeUniqueIndex": "",
    "timelines": [
        {
            "channel": {
                "channelID": "{94a61449-e21f-4aaa-bc6b-5878a9a1dafd}",
                "channelType": 2,
                "color": "#008b8b",
                "dataType": 0,
                "deviceName": "PatternSwitch",
                "direction": 2,
                "displayName": "Pattern switch",
                "enabled": 1,
                "hideInputCurve": 1,
                "hint": 0,
                "hostName": "FEMTO-0212",
                "identifier": "PATTERN_SWITCH_VIRTUAL_CHANNEL",
                "lastModified": "2020-02-06T16:48:46",
                "maximumValue": 1,
                "minimumValue": 0,
                "modifiedBy": "szalnor",
                "sampleRate": 0,
                "sourceType": 0,
                "unitName": "On/off"
            },
            "curveColor": "#008b8b",
            "curveHide": 0,
            "enabled": true,
            "lastModified": "2020-02-11T15:57:25",
            "modifiedBy": "szalnor",
            "timelineID": "{42eac861-cad0-4d4f-bbe1-5c3e5b59dbde}",
            "timelineObjects": [
                {
                    "lastModified": "2020-02-11T15:57:25",
                    "modifiedBy": "szalnor",
                    "objectType": 1,
                    "parameters": "",
                    "pattern": {
                        "cyclePeriod": 100,
                        "lastModified": "2020-02-11T15:57:25",
                        "modifiedBy": "szalnor",
                        "name": "Default immediate pattern space1",
                        "paths": [
                            {
                                "label": "3",
                                "lastModified": "2020-02-11T15:57:25",
                                "modifiedBy": "szalnor",
                                "pathID": "{2848cb00-faca-49c8-b9c2-7149eeb095b1}",
                                "pathOrder": 1,
                                "pathType": 3,
                                "spiralAngleInRad": 0,
                                "spiralEnd": "[0,0,0]",
                                "spiralNormalVector": "[0,0,0]",
                                "spiralRadius": 1,
                                "spiralScale": 1,
                                "spiralStart": "[0,0,0]",
                                "spiralStepInRad": 1,
                                "spiralZeroAngleVector": "[0,0,0]",
                                "splineStepSize": 1,
                                "transformMatrix": "[[1,0,0,43.2584],[0,1,0,-43.2489],[0,0,1,0],[0,0,0,1]]",
                                "veritces3D": "[[-259.55,-27.288,0],[-216.292,298.108,0],[177.154,302.227,0]]"
                            }
                        ],
                        "patternID": "{3d932c00-a391-4de7-99fa-0787a0ceeafd}",
                        "space": {
                            "lastModified": "2020-02-06T16:48:47",
                            "modifiedBy": "szalnor",
                            "name": "space1",
                            "spaceID": "space1"
                        },
                        "sumOfPathLength": 0
                    },
                    "startAtMs": 0,
                    "timelineObjectID": "{e267f1f0-932c-4300-8adb-ec66d6b70fca}"
                }
            ]
        },
        {
            "channel": {
                "channelID": "{1fb91880-983f-4523-b77a-30d4ea3fbdfe}",
                "channelType": 1,
                "color": "#8b008b",
                "dataType": 0,
                "deviceName": "GearOutputCmdX",
                "direction": 2,
                "displayName": "Galvo cmd X",
                "enabled": 1,
                "hideInputCurve": 0,
                "hint": 6,
                "hostName": "FEMTO-0212",
                "identifier": "ch_galvo_cmdx",
                "lastModified": "2020-02-06T16:48:47",
                "maximumValue": 400,
                "minimumValue": -400,
                "modifiedBy": "szalnor",
                "sampleRate": 1000,
                "sourceType": 1,
                "unitName": ""
            },
            "curveColor": "#ffd700",
            "curveHide": 0,
            "enabled": true,
            "lastModified": "2020-02-11T15:57:25",
            "modifiedBy": "szalnor",
            "timelineID": "{34a2dd2b-c8f6-4cb5-ad01-cd1d9067f659}",
            "timelineObjects": [
            ]
        },
        {
            "channel": {
                "channelID": "{beff7f4d-1fbf-4414-b66a-c35a04cef70e}",
                "channelType": 1,
                "color": "#ffd700",
                "dataType": 0,
                "deviceName": "GearOutputCmdY",
                "direction": 2,
                "displayName": "Galvo cmd Y",
                "enabled": 1,
                "hideInputCurve": 0,
                "hint": 6,
                "hostName": "FEMTO-0212",
                "identifier": "ch_galvo_cmdy",
                "lastModified": "2020-02-06T16:48:47",
                "maximumValue": 400,
                "minimumValue": -400,
                "modifiedBy": "szalnor",
                "sampleRate": 1000,
                "sourceType": 1,
                "unitName": ""
            },
            "curveColor": "#8b0000",
            "curveHide": 0,
            "enabled": true,
            "lastModified": "2020-02-11T15:57:25",
            "modifiedBy": "szalnor",
            "timelineID": "{a5aedc71-dc9c-4129-9b38-556ac3686c60}",
            "timelineObjects": [
            ]
        },
        {
            "channel": {
                "channelID": "{90f2c483-580b-4f79-b7e1-618690281165}",
                "channelType": 1,
                "color": "#8b0000",
                "dataType": 0,
                "deviceName": "Laser473",
                "direction": 2,
                "displayName": "Laser 473",
                "enabled": 1,
                "hideInputCurve": 0,
                "hint": 6,
                "hostName": "FEMTO-0212",
                "identifier": "ch_laser_473",
                "lastModified": "2020-02-06T16:48:46",
                "maximumValue": 100,
                "minimumValue": 0,
                "modifiedBy": "szalnor",
                "sampleRate": 1000,
                "sourceType": 0,
                "unitName": ""
            },
            "curveColor": "#8fbc8f",
            "curveHide": 0,
            "enabled": true,
            "lastModified": "2020-02-11T15:57:25",
            "modifiedBy": "szalnor",
            "timelineID": "{46523ef5-0334-47c4-a483-6ff9a2eaf1d7}",
            "timelineObjects": [
                {
                    "lastModified": "2020-02-11T15:57:25",
                    "modifiedBy": "szalnor",
                    "objectType": 0,
                    "parameters": "{\"duration\":1500,\"waveformLoop\":true}",
                    "startAtMs": 0,
                    "timelineObjectID": "{514f0faa-030a-436f-8da9-c095eae601be}",
                    "wave": {
                        "amplitude": 1,
                        "duration": 1500,
                        "dutyCycle": 50,
                        "frequency": 100,
                        "lastModified": "2020-02-11T15:57:26",
                        "modifiedBy": "szalnor",
                        "name": "1111",
                        "phase": 0,
                        "samplesPerSecond": 1000,
                        "waveCurves": [
                            {
                                "curve": "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",
                                "lastModified": "2020-02-11T15:57:25",
                                "modifiedBy": "szalnor",
                                "partIndex": 0,
                                "waveCurveID": 180
                            }
                        ],
                        "waveID": "{bb39da8a-bb9d-480b-9f30-395eea24c168}",
                        "waveMaxValue": 1,
                        "waveMinValue": 0,
                        "waveType": 4,
                        "yOffset": 0
                    }
                }
            ]
        },
        {
            "channel": {
                "channelID": "{08aec2ac-c292-4882-b8f8-0abffea6b2bb}",
                "channelType": 1,
                "color": "#008b8b",
                "dataType": 0,
                "deviceName": "PMTGatingUG",
                "direction": 2,
                "displayName": "PMT Gating UG",
                "enabled": 1,
                "hideInputCurve": 0,
                "hint": 6,
                "hostName": "FEMTO-0212",
                "identifier": "ch_PMT_Gating_UG",
                "lastModified": "2020-02-06T16:48:47",
                "maximumValue": 5,
                "minimumValue": 0,
                "modifiedBy": "szalnor",
                "sampleRate": 1000,
                "sourceType": 0,
                "unitName": ""
            },
            "curveColor": "#008b8b",
            "curveHide": 0,
            "enabled": true,
            "lastModified": "2020-02-11T15:57:28",
            "modifiedBy": "szalnor",
            "timelineID": "{91eb7a0f-b7c4-4575-9348-bf41a6d88fda}",
            "timelineObjects": [
            ]
        },
        {
            "channel": {
                "channelID": "{afc1edab-6581-4af0-affb-772b9c580102}",
                "channelType": 1,
                "color": "#00008b",
                "dataType": 0,
                "deviceName": "DummyOutput",
                "direction": 2,
                "displayName": "Shutter",
                "enabled": 1,
                "hideInputCurve": 0,
                "hint": 4,
                "hostName": "FEMTO-0212",
                "identifier": "ch_shutter",
                "lastModified": "2020-02-06T16:48:46",
                "maximumValue": 1.7976931348623157e+308,
                "minimumValue": -1.7976931348623157e+308,
                "modifiedBy": "szalnor",
                "sampleRate": 1000,
                "sourceType": 0,
                "unitName": ""
            },
            "curveColor": "#00008b",
            "curveHide": 0,
            "enabled": true,
            "lastModified": "2020-02-11T15:57:28",
            "modifiedBy": "szalnor",
            "timelineID": "{7c56b739-e5e2-4e64-a3b0-dece1d306d34}",
            "timelineObjects": [
            ]
        },
        {
            "channel": {
                "channelID": "{8991c9c0-ba31-4663-8584-6de7974f71ca}",
                "channelType": 1,
                "color": "#ff8c00",
                "dataType": 0,
                "deviceName": "Sh3",
                "direction": 2,
                "displayName": "Shutter473",
                "enabled": 1,
                "hideInputCurve": 0,
                "hint": 4,
                "hostName": "FEMTO-0212",
                "identifier": "ch_shutter473",
                "lastModified": "2020-02-06T16:48:46",
                "maximumValue": 1.79769e+308,
                "minimumValue": -1.79769e+308,
                "modifiedBy": "szalnor",
                "sampleRate": 1000,
                "sourceType": 0,
                "unitName": ""
            },
            "curveColor": "#ff8c00",
            "curveHide": 0,
            "enabled": true,
            "lastModified": "2020-02-11T15:57:28",
            "modifiedBy": "szalnor",
            "timelineID": "{f23b1a3e-21d8-4f47-a577-7304e1c3202d}",
            "timelineObjects": [
            ]
        },
        {
            "channel": {
                "channelID": "{31fc61f4-9b3e-4b5f-bd70-41338d125204}",
                "channelType": 1,
                "color": "#8fbc8f",
                "dataType": 0,
                "deviceName": "DummyOutput2",
                "direction": 2,
                "displayName": "CH CMDY",
                "enabled": 1,
                "hideInputCurve": 0,
                "hint": 4,
                "hostName": "FEMTO-0212",
                "identifier": "dummyOutput2",
                "lastModified": "2020-02-06T16:48:46",
                "maximumValue": 1.7976931348623157e+308,
                "minimumValue": -1.7976931348623157e+308,
                "modifiedBy": "szalnor",
                "sampleRate": 1000,
                "sourceType": 0,
                "unitName": ""
            },
            "curveColor": "#8fbc8f",
            "curveHide": 0,
            "enabled": true,
            "lastModified": "2020-02-11T15:57:28",
            "modifiedBy": "szalnor",
            "timelineID": "{0ec4007b-341c-41ee-b2a9-9e4e0cae7a0a}",
            "timelineObjects": [
            ]
        },
        {
            "channel": {
                "channelID": "{641288d0-49d8-4150-b9cf-43ae973c44fd}",
                "channelType": 1,
                "color": "#8a2be2",
                "dataType": 0,
                "deviceName": "DummyOutput3",
                "direction": 2,
                "displayName": "CH CmdY",
                "enabled": 1,
                "hideInputCurve": 0,
                "hint": 4,
                "hostName": "FEMTO-0212",
                "identifier": "dummyOutput3",
                "lastModified": "2020-02-06T16:48:46",
                "maximumValue": 1.7976931348623157e+308,
                "minimumValue": -1.7976931348623157e+308,
                "modifiedBy": "szalnor",
                "sampleRate": 1000,
                "sourceType": 0,
                "unitName": ""
            },
            "curveColor": "#8a2be2",
            "curveHide": 0,
            "enabled": true,
            "lastModified": "2020-02-11T15:57:28",
            "modifiedBy": "szalnor",
            "timelineID": "{34955e58-5b4a-480d-8863-f2df320965de}",
            "timelineObjects": [
            ]
        }
    ],
    "version": "1.0"
}

```

  


## 

## **var succeeded = FemtoAPIMicroscope.setActiveTaskAndSubTask(taskName, subTaskName = 'timeSeries')**

UNSAFE command

Sets the given measurement task and subtask. Task means the type of measurement, it can be resonant or galvo, and subtask is the measurement mode, it can be timeseries, Z-stack or volume scan. 

It does the same if you would select these tabs and sub tabs on the MESc GUI. 

  


Input parameters: 

**taskName**: string, name of the task to set. It can be 'resonant' or 'galvo', the MESc GUI changes to these tabs accordingly. 

**subTaskName**: string, optional parameter, name of the sub task to set. Its value can be on of the strings 'timeSeries', 'zStack' or 'volumeScan'. If not given, timeseries measurement will be selected on the MESc GUI by default. 

In case of success, it returns true, otherwise false. 

### Matlab usage

You must create a FemtoAPIAcquisition object, after it, usage is the same as described above.

### Examples

**C++ code example:**

```cpp
QString command = “FemtoAPIMicroscope.setActiveTaskAndSubTask('resonant','zStack')”; 
auto cmdParser=client->sendJSCommand(command);
```

  


**Matlab client example:** 

```matlab
femtoapiObj = FemtoAPIAcquisition;
succeeded = femtoapiObj.setActiveTaskAndSubTask('galvo','zStack'); 
```

  


**Python client example:** 

```py
command="FemtoAPIFile.setActiveTaskAndSubTask('galvo','zStack')” 
simpleCmdParser=client.sendJSCommand(command)  

resultCode=simpleCmdParser.getResultCode() 

if resultCode > 0: 
    print ("Return code: %d" % resultCode) 
    print (simpleCmdParser.getErrorText()) 
else:   
    print ("FemtoAPIFile.setActiveTaskAndSubTask(): %s" % simpleCmdParser.getJSEngineResult()) 
```

  


## 

## **var version = FemtoAPIMicroscope.getCommandSetVersion() or**

## **var version = FemtoAPIFile.getCommandSetVersion()**

  


Gets the version of the FemtoAPI command set in string. Example output: "v.1.0". 

### Examples

**C++ code example:**

```cpp
QString command = “FemtoAPIMicroscope.getCommandSetVersion()”; 
// or QString command = “FemtoAPIFile.getCommandSetVersion()”; 
auto cmdParser=client->sendJSCommand(command);
```

  


**Matlab client example:** 

```matlab
femtoapiObj = FemtoAPIAcquisition; % or femtoapiObj = FemtoAPIProcessing
succeeded = femtoapiObj.getCommandSetVersion(); 
```

  


**Python client example:** 

```py
command="FemtoAPIFile.getCommandSetVersion()” 
simpleCmdParser=client.sendJSCommand(command)  

resultCode=simpleCmdParser.getResultCode() 

if resultCode > 0: 
    print ("Return code: %d" % resultCode) 
    print (simpleCmdParser.getErrorText()) 
else:   
    print ("FemtoAPIFile.getCommandSetVersion(): %s" % simpleCmdParser.getJSEngineResult()) 
```

  


## 

## **var lastError= FemtoAPIMicroscope.getLastCommandError() or**

## **var lastError = FemtoAPIFile.getLastCommandError()**

  


Gets the error information of the last issued command. It returns a json object with the following fields: 

* **ErrorCode**: integer, code of the error. In case of no error, it is 0. 
* **ErrorText**: string, the cause of the error
* **ErrorType**: string, type of the error, for example ParameterError, FileError, SystemError, NoError. 

  


Example output (in case of no error): 

```js
{
	"ErrorCode": 0,
	"ErrorText": "",
	"ErrorType": "eNoError"
}
```

  


### Examples

**C++ code example:**

```cpp
QString command = “FemtoAPIMicroscope.getLastCommandError()”; 
// or QString command = “FemtoAPIFile.getLastCommandError()”; 
auto cmdParser=client->sendJSCommand(command);
```

  


**Matlab client example:** 

```matlab
femtoapiObj = FemtoAPIAcquisition; % or femtoapiObj = FemtoAPIProcessing
succeeded = femtoapiObj.getLastCommandError(); 
```

  


**Python client example:** 

```py
command="FemtoAPIFile.getLastCommandError()” 
simpleCmdParser=client.sendJSCommand(command)  

resultCode=simpleCmdParser.getResultCode() 

if resultCode > 0: 
    print ("Return code: %d" % resultCode) 
    print (simpleCmdParser.getErrorText()) 
else:   
    print ("FemtoAPIFile.getLastCommandError(): %s" % simpleCmdParser.getJSEngineResult())) 
```

  


  
