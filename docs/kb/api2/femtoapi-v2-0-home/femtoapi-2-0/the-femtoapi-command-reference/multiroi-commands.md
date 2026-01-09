# MultiROI commands
## 

## **var result = FemtoAPIFile.createBackgroundFrame(xDim, yDim, technologyType, backgroundImageRole, viewportJson, fileNodeDescriptor = '', t0InMs = 0.0, deltaTInMs = 1.0, tDimInitial = 1, isBessel = false)**

  


Creates new measurement session and a time series measurement unit in it with the specified technology type, and adds one (or optionally more) frame to it. This measurement session is special: it cannot be target of new measurements, and only multiROI images can be created in it. 

 Input parameters: 

* **xDim**: measurement image x resolution 
* **yDim**: measurement image y resolution 
* **technologyType**: string, means the used technology for imaging, it can be 'resonant', 'galvo', or 'AO'. 
* **backgroundImageRole**: string, means the used image role for background images, it can be 'background' and 'motionCorrection'
* **viewportJson**: viewport for measurement. It is a json object in compact string format. See examples below.
* **fileNodeDescriptor**: string, descriptor of the file node in the MESc GUI, in which the new background session and unit will be created. If it is not given or empty string, current file is considered. 
* **t0InMs**: Measurement start time offset in ms. Double, default value is 0.0 
* **deltaTInMs**: Frame duration time in ms (1/frame rate). Positive double, default value is 1.0. 
* **tDimInitial**: Number of frames to create in z (time) dimension. Positive integer, default value is 1. 
* **isBessel**: creates a background frame of a Bessel type

 

Returns a json object with the following fields: 

* **succeeded**: Returns true if the measurement unit creation was successfully initiated, otherwise it returns false  
* **id**: command id, which is used as input to [FemtoAPIFile.getStatus(commandID)](https://kb.femtonics.eu/display/MAN/Tools#Tools-getStatus) command, to obtain the current status of the command (the asynchronous part), if succeeded == true.
* **addedMUnitIdx**: In case of the new measurement unit has been successfully created, the unique index of the created measurement unit converted to string, e.g. "34,0,1"
* **backgroundImagePath**: string, path of the created background image in the hdf file, e.g. in file with node descriptor '55', if backgound image path is /MSession_0/MUnit_0, it is the MUnit '55,0,0' . 

  


### Usage in Matlab 

result = femtoapiObj.createBackgroundFrame(xDim, yDim, technologyType, backgroundImageRole, viewportJson, fileNodeDescriptor, t0InMs, deltaTInMs, tDimInitial, isBessel)

For more information about usage, see the [introduction](https://kb.femtonics.eu/pages/viewpage.action?pageId=39325016) and the examples below.

### Examples

The following variables need to be defined: 

var viewport='{"referenceViewportFormatVersion": 1, "viewports":\[{"geomTransRot": \[0,0,0,1], "geomTransTransl": \[0,0,0], "height":256, "width": 256}]}'

  


**C++ code example** 

| |
| - |
| `QString command = “FemtoAPIFile.createBackgroundFrame(256,256,``'AO'``,'background',viewport)”; ` `auto cmdParser=client->sendJSCommand(command); ` |

 

**Matlab client code example:** 

| |
| - |
| `viewport ='{"referenceViewportFormatVersion": 1, "viewports":[{"geomTransRot": [0,0,0,1], "geomTransTransl": [0,0,0], "height":256, "width": 256}]}'``; `  `femtoapiObj = FemtoAPIProcessing();``% connect to local server (MESc) ` `result = femtoapiObj.createBackgroundFrame(256,256,``'AO'``,'background',viewport) ` |

 

**Python client code example:** 

| |
| - |
| `command``=``"FemtoAPIFile.createBackgroundFrame(``256``,``256``,``'AO'``,'background',viewport);” ` `simpleCmdParser``=``client.sendJSCommand(command) `  `resultCode``=``simpleCmdParser.getResultCode() `  `if` `resultCode >``0``: ` ```print` `(``"Return code: %d"` `%` `resultCode) ` ```print` `(simpleCmdParser.getErrorText()) ` `else``: ` ```print` `(``"createBackgroundFrame(): %s"` `%` `simpleCmdParser.getJSEngineResult()) ` |

  


## **var result = FemtoAPIFile.createBackgroundZStack(xDim, yDim, zDim, technologyType, backgroundImageRole, viewportJson, fileNodeDescriptor = '', zStepInMicrons = 1.0)**

  


Creates new measurement session and a z-stack series measurement unit in it with the specified technology type, This measurement session is special: it cannot be target of new measurements, and only multiROI images can be created in it. 

 Input parameters: 

* **xDim**: measurement image x resolution 
* **yDim**: measurement image y resolution 
* **zDim**: number of z planes 
* **technologyType**: string, means the used technology for imaging, it can be 'resonant', 'galvo', 'AO' . 
* **backgroundImageRole**: string, means the used image role for background images, it can be 'background' and 'motionCorrection'
* **viewportJson**: viewport for measurement. It is a json object in compact string format. See examples below.
* **fileNodeDescriptor**: string, descriptor of the file node in the MESc GUI, in which the new background session and unit will be created. If it is not given or empty string, current file is considered. 
* **zStepInMicrons**: Step between z planes in um. Double, default value is 1.0 

 

Returns a json object with the following fields: 

* **succeeded**: Returns true if the measurement unit creation was successfully initiated, otherwise it returns false  
* **id**: command id, which is used as input to [FemtoAPIFile.getStatus(commandID)](https://kb.femtonics.eu/display/MAN/Tools#Tools-getStatus) command, to obtain the current status of the command (the asynchronous part), if succeeded == true.
* **addedMUnitIdx**: In case of the new measurement unit has been successfully created, the unique index of the created measurement unit converted to string, e.g. "34,0,1"
* **backgroundImagePath**: string, path of the created background image in the hdf file, e.g. in file with node descriptor '55', if backgound image path is /MSession_0/MUnit_0, it is the MUnit '55,0,0' . 

  


### Usage in Matlab 

result = femtoapiObj.createBackgroundZStack(xDim, yDim, zDim, technologyType, backgroundImageRole, viewportJson, zStepInMicrons)

For more information about usage, see the [introduction](https://kb.femtonics.eu/pages/viewpage.action?pageId=39325016) and the examples below.

### Examples

The following variables need to be defined: 

var viewport='{"transformation": {"translation": \[0,0,0],"rotationQuaternion": \[0,0,0,1]},"size": \[256,256]}'; 

  


**C++ code example** 

| |
| - |
| `QString command = “FemtoAPIFile.createBackgroundZStack(256,256,10,``'AO'``,'background',viewport)”; ` `auto cmdParser=client->sendJSCommand(command); ` |

 

**Matlab client code example:** 

| |
| - |
| `viewport ='{"referenceViewportFormatVersion": 1, "viewports":[{"geomTransRot": [0,0,0,1], "geomTransTransl": [0,0,0], "height":256, "width": 256}]}'``; `  `femtoapiObj = FemtoAPIProcessing();``% connect to local server (MESc) ` `result = femtoapiObj.createBackgroundZStack(256,256,10,``'AO'``,'background',viewport) ` |

 

**Python client code example:** 

| |
| - |
| `command``=``"FemtoAPIFile.createBackgroundZStack(``256``,``256``,``10``,``'AO'``,'background',viewport);” ` `simpleCmdParser``=``client.sendJSCommand(command) `  `resultCode``=``simpleCmdParser.getResultCode() `  `if` `resultCode >``0``: ` ```print` `(``"Return code: %d"` `%` `resultCode) ` ```print` `(simpleCmdParser.getErrorText()) ` `else``: ` ```print` `(``"createBackgroundZStack(): %s"` `%` `simpleCmdParser.getJSEngineResult()) ` |

  


## **var result = FemtoAPIFile.createMultiROI2DMUnit(xDim, tDim, methodType, backgroundImagePath, deltaTInMs = 1.0, t0InMs= 0.0)**

Creates new measurement unit  scan time series measurement. 

 Input parameters: 

* **xDim**: measurement image x resolution 
* **tDim**: number of timestamps 
* **methodType**: 2D multiROI type, it can be 'multiROIPointScan', 'multiROILineScan', or 'multiROIMultiLine' 
* **backgroundImagePath**: handle of background image in the file (e.g. 10,1,0 )
* **deltaTInMs**: Frame duration time in ms (1/frame rate). Positive double, default value is 1.0.
* **t0InMs**: Measurement start time offset in ms. Double, default value is 0.0 

 

Returns a json object with the following fields: 

* **succeeded**: Returns true if the measurement unit creation was successfully initiated, otherwise it returns false  
* **id**: command id, which is used as input to [FemtoAPIFile.getStatus(commandID)](https://kb.femtonics.eu/display/MAN/Tools#Tools-getStatus) command, to obtain the current status of the command (the asynchronous part), if succeeded == true.
* **addedMUnitIdx**: In case of the new measurement unit has been successfully created, the unique index of the created measurement unit converted to string, e.g. "34,0,1"

  


**Note**: Background image must be created with commands createBackgroundFrame() or createBackgroundZStack() before creating multiROI image. These commands return the path of the background image too, which can be used as input parameter for creating multiROI image. 

### Usage in Matlab 

result = femtoapiObj.createMultiROIMUnit(xDim, tDim, methodType, backgroundImagePath, deltaTInMs, t0InMs)

For more information about usage, see the [introduction](https://kb.femtonics.eu/pages/viewpage.action?pageId=39325016) and the examples below.

### Examples

  


**C++ code example** 

| |
| - |
| `QString command = “FemtoAPIFile.createMultiROI2DMUnit(256,10,'multiROILineScan','10,1,0')”; ` `auto cmdParser=client->sendJSCommand(command); ` |

  


**Matlab client code example:** 

| |
| - |
| `femtoapiObj = FemtoAPIProcessing();``% connect to local server (MESc) ` `result = femtoapiObj.createMultiROI2DMUnit(256,10,'multiROILineScan','10,1,0')` |

 

**Python client code example:** 

| |
| - |
| `command``=``"FemtoAPIFile.createMultiROI2DMUnit(256,10,'multiROILineScan','10,1,0')``;” ` `simpleCmdParser``=``client.sendJSCommand(command) `  `resultCode``=``simpleCmdParser.getResultCode() `  `if` `resultCode >``0``: ` ```print` `(``"Return code: %d"` `%` `resultCode) ` ```print` `(simpleCmdParser.getErrorText()) ` `else``: ` ```print` `(``"createMultiROI2DMUnit(): %s"` `%` `simpleCmdParser.getJSEngineResult()) ` |

  


## **var result = FemtoAPIFile.createMultiROI3DMUnit(xDim, yDim, tDim, methodType, backgroundImagePath, deltaTInMs = 1.0, t0InMs= 0.0)**

Creates new measurement unit  scan time series measurement. 

 Input parameters: 

* **xDim**: measurement image x resolution 
* **yDim**: measurement image y resolution 
* **tDim**: number of timestamps 
* **methodType**: 3D multiROI type, it can be 'multiROIChessBoard', 'multiROITransverseRibbonScan', 'multiROILongitudinalRibbonScan'
* **backgroundImagePath**: handle of background image in the file (e.g. 10,1,0)
* **deltaTInMs**: Frame duration time in ms (1/frame rate). Positive double, default value is 1.0
* **t0InMs**: Measurement start time offset in ms. Double, default value is 0.0 .

 

Returns a json object with the following fields: 

* **succeeded**: Returns true if the measurement unit creation was successfully initiated, otherwise it returns false  
* **id**: command id, which is used as input to [FemtoAPIFile.getStatus(commandID)](https://kb.femtonics.eu/display/MAN/Tools#Tools-getStatus) command, to obtain the current status of the command (the asynchronous part), if succeeded == true.
* **addedMUnitIdx**: In case of the new measurement unit has been successfully created, the unique index of the created measurement unit converted to string, e.g. "34,0,1"

  


**Note**: Background image must be created with commands createBackgroundFrame() or createBackgroundZStack() before creating multiROI image. These commands return the path of the background image too, which can be used as input parameter for creating multiROI image. 

  


### Usage in Matlab 

result = femtoapiObj.createMultiROI3DMUnit(xDim, yDim, tDim, methodType, backgroundImagePath, deltaTInMs, t0InMs)

For more information about usage, see the examples below.

### Examples

  


**C++ code example** 

| |
| - |
| `QString command = “FemtoAPIFile.createMultiROI3DMUnit(256,300,10,'multiROIChessBoard','10,1,0')”; ` `auto cmdParser=client->sendJSCommand(command); ` |

  


**Matlab client code example:** 

| |
| - |
| `femtoapiObj = FemtoAPIProcessing();``% connect to local server (MESc) ` `result = femtoapiObj.createMultiROI3DMUnit(256,10,'multiROIChessBoard','10,1,0')` |

 

**Python client code example:** 

| |
| - |
| `command``=``"FemtoAPIFile.createMultiROI3DMUnit(256,10,'multiROIChessBoard','10,1,0')``;” ` `simpleCmdParser``=``client.sendJSCommand(command) `  `resultCode``=``simpleCmdParser.getResultCode() `  `if` `resultCode >``0``: ` ```print` `(``"Return code: %d"` `%` `resultCode) ` ```print` `(simpleCmdParser.getErrorText()) ` `else``: ` ```print` `(``"createMultiROI3DMUnit(): %s"` `%` `simpleCmdParser.getJSEngineResult()) ` |

  


## **var result = FemtoAPIFile.createMultiROI4DMUnit(xDim, yDim, zDim, tDim, methodType, backgroundImagePath, deltaTInMs = 1.0, t0InMs= 0.0)**

Creates new measurement unit  scan time series measurement. 

 Input parameters: 

* **xDim**: measurement image x resolution 
* **yDim**: measurement image y resolution 
* **zDim**: measurement image z resolution
* **tDim**: number of timestamps 
* **methodType**: 4D multiROI type, it can be 'multiROIMultiCube', 'multiROISnake'
* **backgroundImagePath**: handle of background image in the file (e.g. `10,1,0` )
* **deltaTInMs**: Frame duration time in ms (1/frame rate). Positive double, default value is 1.0
* **t0InMs**: Measurement start time offset in ms. Double, default value is 0.0 .

 

Returns a json object with the following fields: 

* **succeeded**: Returns true if the measurement unit creation was successfully initiated, otherwise it returns false  
* **id**: command id, which is used as input to [FemtoAPIFile.getStatus(commandID)](https://kb.femtonics.eu/display/MAN/Tools#Tools-getStatus) command, to obtain the current status of the command (the asynchronous part), if succeeded == true.
* **addedMUnitIdx**: In case of the new measurement unit has been successfully created, the unique index of the created measurement unit converted to string, e.g. "34,0,1"

  


**Note**: Background image must be created with commands createNackgroundFrame() or createBackgroundZStack() before creating multiROI image. These commands return the path of the background image too, which can be used as input parameter for creating multiROI image. 

### Usage in Matlab 

result = femtoapiObj.createMultiROI4DMUnit(xDim, yDim, zDim, tDim, methodType, backgroundImagePath, deltaTInMs, t0InMs)

For more information about usage, see the examples below.

### Examples

  


**C++ code example** 

| |
| - |
| `QString command = “FemtoAPIFile.createMultiROI4DMUnit(256,300,10,20,'multiROIMultiCube','10,1,0')”; ` `auto cmdParser=client->sendJSCommand(command); ` |

  


**Matlab client code example:** 

| |
| - |
| `femtoapiObj = FemtoAPIProcessing();``% connect to local server (MESc) ` `result = femtoapiObj.createMultiROI4DMUnit(256,300,10,20,'multiROIMultiCube','10,1,0')` |

 

**Python client code example:** 

| |
| - |
| `command``=``"FemtoAPIFile.createMultiROI4DMUnit(256,300,10,20,'multiROIMultiCube','10,1,0')``;” ` `simpleCmdParser``=``client.sendJSCommand(command) `  `resultCode``=``simpleCmdParser.getResultCode() `  `if` `resultCode >``0``: ` ```print` `(``"Return code: %d"` `%` `resultCode) ` ```print` `(simpleCmdParser.getErrorText()) ` `else``: ` ```print` `(``"createMultiROI4DMUnit(): %s"` `%` `simpleCmdParser.getJSEngineResult()) ` |

  


  
