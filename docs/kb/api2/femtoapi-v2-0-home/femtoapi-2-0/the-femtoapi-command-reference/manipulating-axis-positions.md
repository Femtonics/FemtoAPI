# Manipulating axis positions
The following operations are described here: 

* getAxisPositions
* getAxisPosition
* doZero
* setAxisPosition
* isAxisMoving

## 

## **var json = FemtoAPIMicroscope.getAxisPositions()**

  


UNSAFE operation.

This command is used to get all configured and adjustable axis position information. The output JSON contains the following information:

  


Every JSON object contains the following axis parameters:

* **space**: space of the axis is configured to
* **Lock**: if true, axis positions cannot be set (solely by the Handwheel, but only in low speed mode)
* **Minimum/Maximum Z position**: min/max absolute position of an axis configured to raw Z
* **Near position**: near position absolute coordinate in µm
* **Mode**: objective mode
* **AxisPositions**: a JSON object that contains 2 objects, one named “StandardAxes” and another named “NonStandardAxes”. Standard axes are usually Slow X,Y,Z, VirtX,Y, Z, Tilt X,Y,Z, and FastZ. Other axes, for example pipette manipulation axes, are found under “NonStandardAxes” in the JSON, if present.

  


The StandardAxes/NonStandardAxes JSON array contains objects with information about the configured axes. These contain the following axis parameters:

* **Axis**: name of the configured axis
* **Absolute**: absolute position of the axis in µm
* **Relative**: relative position of the axis in µm (relative to the current position)
* **AlertThreshold**: axis threshold in µm, the maximum movement of which can be applied with the setAxisPosition() API command
* **AxisLowerLimit**: the minimum absolute position of the axis (varies if the absolute coordinate system is translated/rotated)
* **AxisUpperLimit**: the maximum absolute position of the axis (varies if the absolute coordinate system is translated/rotated)
* **LabelingOriginOffset**: labeling origin offset position

  


Example output:

```js
[{
        "AxisPositions": {
            "NonStandardAxes": [ ],
            "StandardAxes": [
                {
                    "Absolute": 199.21805399270463,
                    "AlertThreshold": 50,
                    "Axis": "FastZ",
                    "AxisLowerLimit": -200,
                    "AxisUpperLimit": 200,
                    "LabelingOriginOffset": 0,
                    "Relative": 199.21805399270463
                }, {
                    "Absolute": -28.18,
                    "AlertThreshold": 9,
                    "Axis": "SlowX",
                    "AxisLowerLimit": -10000,
                    "AxisUpperLimit": 0,
                    "LabelingOriginOffset": 0,
                    "Relative": -28.18
                }, {
                    "Absolute": -174.69,
                    "AlertThreshold": 34,
                    "Axis": "SlowY",
                    "AxisLowerLimit": -10000,
                    "AxisUpperLimit": 0,
                    "LabelingOriginOffset": 0,
                    "Relative": -174.69
                }, {
                    "Absolute": -117.64,
                    "Axis": "SlowZ",
                    "AxisLowerLimit": -24500,
                    "AxisUpperLimit": 0,
                    "LabelingOriginOffset": 0,
                    "Relative": -117.64
                }, {
                    "Absolute": 7.529920000000001,
                    "AlertThreshold": 15,
                    "Axis": "TiltX",
                    "AxisLowerLimit": -55,
                    "AxisUpperLimit": 47,
                    "LabelingOriginOffset": 0,
                    "Relative": 7.529920000000001
                }, {
                    "Absolute": -28.50832,
                    "AlertThreshold": 8,
                    "Axis": "TiltY",
                    "AxisLowerLimit": -44,
                    "AxisUpperLimit": 77,
                    "LabelingOriginOffset": 0,
                    "Relative": -28.50832
                }, {
                    "Absolute": 0,
                    "AlertThreshold": 9,
                    "Axis": "VirtX",
                    "AxisLowerLimit": -10058.559331683451,
                    "AxisUpperLimit": 28.425122191018254,
                    "LabelingOriginOffset": 0,
                    "Relative": 0
                }, {
                    "Absolute": 0,
                    "AlertThreshold": 9,
                    "Axis": "VirtY",
                    "AxisLowerLimit": -244.7146052663152,
                    "AxisUpperLimit": 200.52343632100892,
                    "LabelingOriginOffset": 0,
                    "Relative": 0
                }, {
                    "Absolute": 0,
                    "AlertThreshold": 9,
                    "Axis": "VirtZ",
                    "AxisLowerLimit": -450.55220157968716,
                    "AxisUpperLimit": 133.87231018703233,
                    "LabelingOriginOffset": 199.21805399270463,
                    "Relative": 0
                }
            ]
        },
        "Lock": false,
        "Maximum Z position": 0,
        "Minimum Z position": -24500,
        "Mode": "Standard",
        "Near position": -200,
        "space": "space1" 
}]
```

  


### Usage in Matlab

First, a FemtoAPIMicroscopeobject must be created. After it, the usage is the same as described above, only the returned value has a different format: 

result = femtoapiObj.getAxisPositions();

where the returned value is the returned json from server parsed into an array of (nested) Matlab structs. 

In case of any error, it gives an error message as a Matlab error type exception.

### Examples

***C++ code example:***

```cpp
QString command = “FemtoAPIMicroscope.getAxisPositions()” ;
ReplyMessageParser *cmdParser=client->sendJSCommand(command);
```

  


  


 ***Matlab client code example:*** 

```matlab
femtoapiObj = FemtoAPIAcquisition();
result = femtoapiObj.getAxisPositions();
```

  


  


***Python client code example:*** 

```py
command="FemtoAPIMicroscope.getAxisPositions();"
simpleCmdParser=client.sendJSCommand(command)
resultCode=simpleCmdParser.getResultCode()

if resultCode > 0:
    print ("Return code: %d" % resultCode)
    print (simpleCmdParser.getErrorText())
else:	
    print ("getAxisPositions(): %s" % simpleCmdParser.getJSEngineResult())
```

  


  


## 

## **var json = FemtoAPIMicroscope.getAxisPosition(axisName, spaceName = '')**

UNSAFE operation.

This command returns the part of the json returned by getAxisPositions() for the specified axis and space.

  


Input parameters:

* **axisName**: string, name of a valid and configured axis. 
* **spaceName**: string, optional, must be the name of the space for which the axis given by ‘axisName’ is configured. 

  


In case of success, it returns a json object, with the following fields: 

* **Axis**: name of the configured axis
* **Absolute**: absolute position of the axis in µm
* **Relative**: relative position of the axis in µm (relative to the current position)
* **AlertThreshold**: axis threshold in µm, the maximum movement of which can be applied with the setAxisPosition() API command
* **AxisLowerLimit**: the minimum absolute position of the axis (varies if the absolute coordinate system is translated/rotated)
* **AxisUpperLimit**: the maximum absolute position of the axis (varies if the absolute coordinate system is translated/rotated)
* **LabelingOriginOffset**: labeling origin offset position

  


In case of any error (e.g. space name is invalid), it returns an empty json and an error message. 

##### Important notes on usage

* in case the axisName/spaceName is invalid, it returns false, and an error message
* if the axis is not configured with the given space, it returns false, and an error message
* if the ‘spaceName’ parameter is not given, it uses a default space name (currently it is called ‘space1’)

*Note*: List of standard (and non-standard) axes can be obtained by issuing the FemtoAPIMicroscope.getAxisPositions() command.

  


### Usage in Matlab

First, a FemtoAPIMicroscopeobject must be created. After it, usage is the following: 

* if called without parameters, it gets the above json parsed into struct, for default space: 

  **result = femtoapiObj.getAxisPosition(axisName);**

* if called with two parameters, second parameter is char array, position type, which can be 'absolute' or 'relative' or empty char: 

  **relativeOrAbsolutePosition = femtoapiObj.getAxisPosition(axisName, positionType);**

 Returns the requested position, but if positionType is empty char, result is the same as in the first case. 

* if called with three parameters, third parameter is char array, name of the space which the axis is configured for: 

  **result = femtoapiObj.getAxisPosition(axisName, positionType, spaceName);**

 Empty space name produces the same as in the second case. 

In case of any error, it gives an error message as a Matlab error type exception.

### Examples

***C++ code example:***

```cpp
QString command = “FemtoAPIMicroscope.getAxisPosition('SlowZ')” ;
ReplyMessageParser *cmdParser=client->sendJSCommand(command);
```

  


  


 ***Matlab client code example:*** 

```matlab
femtoapiObj = FemtoAPIAcquisition();
% get the axis position struct from server (contains limits, alert threshold, labeling origin offset too) and select position fields: 
result = femtoapiObj.getAxisPosition('SlowX');
relativePos = result.relative;
absolutePos = result.absolute;

% or return directly absolute/reltive position: 
relativePos = femtoapiObj.getAxisPosition('SlowX', 'relative');
absolutePos = femtoapiObj.getAxisPosition('SlowX', 'absolute');

```

  


  


***Python client code example:*** 

```py
command="FemtoAPIMicroscope.getAxisPosition('Tiltx');"
simpleCmdParser=client.sendJSCommand(command)
resultCode=simpleCmdParser.getResultCode()

if resultCode > 0:
    print ("Return code: %d" % resultCode)
    print (simpleCmdParser.getErrorText())
else:	
    print ("getAxisPosition(): %s" % simpleCmdParser.getJSEngineResult())
```

  


  




**var success = FemtoAPIMicroscope.doZero(axisName, spaceName ='')**

  
UNSAFE operation.

##### Description and usage

This command is used to set the axis relative position to 0.0, and set the labeling origin to the current absolute position.

Input parameters:

* **axisName**: string, name of a valid and configured axis 
* **spaceName**: string, optional, must be the name of the space for which the axis given by ‘axisName’ is configured. 

  


Output: true, when zero was successful, false otherwise

##### Important notes on usage

* in case the axisName/spaceName is invalid, it returns false, and an error message
* if the axis is not configured with the given space, it returns false, and an error message
* if the ‘spaceName’ parameter is not given, it uses a default space name (currently it is called ‘space1’)
* if the Handwheel is locked (Lock is checked in the MESc GUI), axis zero cannot be done
* axis zero currently can only be done on standard axes (Slow(X,Y,Z), Virt(X, Y, Z), Tilt(X, Y, Z), FastZ)

*Note*: List of standard (and non-standard) axes can be obtained by issuing the FemtoAPIMicroscope.getAxisPositions() command.

### Usage in Matlab

First, a FemtoAPIMicroscopeobject must be created. After it, the usage is the same as described above:

succeeded= femtoapiObj.doZero(axisName, spaceName);

where axisName and spaceName must be character arrays, and spaceName can be an empty char or omitted (default space is used in this case).

In case of any error, it gives the error message as a Matlab error type exception. Otherwise, it returns true.

  


### Examples

***C++ code examples***

```cpp
// zero axis ‘TiltX’, which is configured on default space
QString command = “FemtoAPIMicroscope.doZero(‘TiltX’)”;
// (or “FemtoAPIMicroscope.doZero(‘TiltX’,’space1’)”; )
ReplyMessageParser *cmdParser=client->sendJSCommand(command);

// zero axis ‘VirtY’, configured on space2
QString command = “FemtoAPIMicroscope.doZero(‘VirtY’,’space2’)”;
//(or “FemtoAPIMicroscope.doZero(‘VirtY’,’space2’)”; )
ReplyMessageParser *cmdParser=client->sendJSCommand(command);
```

  


  


***Matlab client code example:*** 

```matlab
femtoapiObj = FemtoAPIAcquisition();
axisName = 'SlowZ';
space = 'space1';

femtoapiObj.doZero(axisName,space);
```

  


  


***Python client code example:*** 

```cpp
command="FemtoAPIMicroscope.doZero(‘TiltX’);"
simpleCmdParser=client.sendJSCommand(command)
resultCode=simpleCmdParser.getResultCode()

if resultCode > 0:
    print ("Return code: %d" % resultCode)
    print (simpleCmdParser.getErrorText())
else:	
    print ("doZero(): %s" % simpleCmdParser.getJSEngineResult())
```

  


  


## 

## **var succeed = setAxisPosition(axisName, newPosition, isRelativePosition=true, isRelativeToCurrentPosition=true, spaceName = '')**

  


UNSAFE operation.

This command is used to set an absolute or relative position of a configured axis. Only one axis can be set at once. The given position must be within the axis and threshold limits. The limits with the valid axis names can be get with the command getAxispositions(), which will be described later.

The required input parameters:

* **axisName**: string, it must be a configured axis name.
* **newPosition**: double, the new position that wanted to be set. It can be a relative or an absolute position, depending on the isRelativePosition flag.

  


Optional input parameters:

* **isRelativePosition**: if true, the given position is relative, otherwise it is considered as an absolute position. Default: true
* **isRelativeToCurrentPosition** : bool, if true, the newPosition parameter means a relative position to the current position, otherwise it is relative to the labeling origin offset. Default: true
* **spaceName**: name of the space. default: empty string, which means the default space name

##### Important notes

* only one axis position can be set at a time
* the axisName must be valid (if not, an error message is returned, and the position is not changed)
* every axis has its axis threshold limit, which is the maximum position change that is allowed relative to the current position in one command. If the new position that wanted to be set is out of this limit, the position will not be set, and the objective is not moved (an appropriate error message is returned)
* it is possible, that the new axis position is within the threshold limit of the given axis, but it would be out of the absolute limits of the axis. In this case, the objective is not moved, and an error message is returned.
* if any parameter is invalid, the objective is not moved, and an error message is returned
* the configured axis properties, the axis name, the axis threshold limits and the axis limits in the absolute coordinate system can be get by the getAxisPositions() command
* if a tilted axis is moved, then Z-stack parameters (firstZ, intermediateZ, zStep, zPlanes) will be reset to their default values due to coordinate system change.

  


*Note*: if an absolute position is set, the value of the parameter isRelativeToCurrentPosition is irrelevant

### Usage in Matlab

First, a FemtoAPIMicroscopeobject must be created. After it, the usage is the same as described above: 

succeeded = femtoapiObj.setAxisPosition(axisName, newPosition, isRelativePosition, isRelativeToCurrentPosition, spaceName);

Input arguments (required): 

* axisName: char array
* newPosition: double

Input arguments (optional): 

* isRelativePosition: bool, default value is true
* isRelativeToCurrentPosition: bool, default value is true
* spaceName: character array, default value is the default space (space1) 

In case of any error, it gives the error message as a Matlab error type exception, otherwise it returns true.

  


### Examples

***C++ code examples***

```cpp
// Moving TiltX axis relative to the current position by 4.5:
QString command = “FemtoAPIMicroscope.setAxisPosition(‘TiltX’, 4.5, true, true) “
ReplyMessageParser *cmdParser=client->sendJSCommand(command);

// Moving axis ‘SlowX’ relative to the labeling origin offset by 8.0 :
QString command = “FemtoAPIMicroscope.setAxisPosition(‘SlowX’, 8.0, true, false) “;
ReplyMessageParser *cmdParser=client->sendJSCommand(command);

// Moving axis ‘VirtZ’ to absolute position 25.0 :
QString command = “FemtoAPIMicroscope.setAxisPosition(‘SlowZ’, 25.0, false) “
ReplyMessageParser *cmdParser=client->sendJSCommand(command);

// Moving axis “TiltY” to absolute position 10.0 on space2:
QString command = “FemtoAPIMicroscope.setAxisPosition(‘TiltY’, 10.0, false, false, ”space2”)“;
ReplyMessageParser *cmdParser=client->sendJSCommand(command);
```

  


  


 ***Matlab client code example:*** 

```matlab
femtoapiObj = FemtoAPIAcquisition();

% set relative position to current position
space = "space1";
axisName = "SlowX";
position = 5;
isRelativePosition = true;
isRelativeToCurrentPosition = true;

femtoapiObj.setAxisPosition(axisName,position,isRelativePosition,...
                isRelativeToCurrentPosition,space)
```

  


  


***Python client code example:*** 

```py
command="FemtoAPIMicroscope.setAxisPosition(‘SlowZ’, 25.0, false) ;"
simpleCmdParser=client.sendJSCommand(command)
resultCode=simpleCmdParser.getResultCode()

if resultCode > 0:
    print ("Return code: %d" % resultCode)
    print (simpleCmdParser.getErrorText())
else:	
    print ("setAxisPosition(): %s" % simpleCmdParser.getJSEngineResult())
```

  


## 

## **var succeed = isAxisMoving(axisName, spaceName = '')**

UNSAFE operation.

Returns whether the objective is moving along the given axis or not. The axisName must be configured to the given space. 

If emtpy char or no space name is given, default space ('space1') is considered. 

The required input parameter:

* **axisName**: string, it must be a configured axis name.

Optional input parameter:

* **spaceName**: name of the space. default: empty string, which means the default space name

  


### Usage in Matlab

First, a FemtoAPIMicroscope object must be created. After it, the usage is the same as described above: 

succeeded = femtoapiObj.isAxisMoving(axisName, spaceName);

Input arguments (required): 

* axisName: char array

Input arguments (optional): 

* spaceName: character array, if not given, default value is the default space (space1) 

In case of any error, it gives the error message as a Matlab error type exception, otherwise it returns true.

### Examples

***C++ code examples***

```cpp
QString command = “FemtoAPIMicroscope.isAxisMoving('StageX') “
ReplyMessageParser *cmdParser=client->sendJSCommand(command);
```

  


  


 ***Matlab client code example:*** 

```matlab
femtoapiObj = FemtoAPIAcquisition();
isMoving = femtoapiObj.isAxisMoving(axisName);
```

  


  


***Python client code example:*** 

```py
command="FemtoAPIMicroscope.isAxisMoving(‘SlowZ’) ;"
simpleCmdParser=client.sendJSCommand(command)
resultCode=simpleCmdParser.getResultCode()

if resultCode > 0:
    print ("Return code: %d" % resultCode)
    print (simpleCmdParser.getErrorText())
else:	
    print ("isAxisMoving(): %s" % simpleCmdParser.getJSEngineResult())
```

  


  


  
