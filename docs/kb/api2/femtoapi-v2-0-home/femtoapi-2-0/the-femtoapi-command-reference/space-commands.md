# Space commands
## 

## **var result = FemtoAPIFile.setPointsToSpace(fileNodeDescriptor, spaceName = 'space1', bAppend = false)**

  


Loades points from given measurement unit to space. 

 Input parameters: 

* **fileNodeDescriptor**: string, descriptor of the file node in the MESc GUI, in which the new background session and unit will be created. If it is not given or empty string, current file is considered. 
* **spaceName**: string, space identifier space1 in most cases 
* **bAppend**: boolean, if true the points are appended to the space, otherwise they will be overwritten

  


Returns a boolean value: 

* **succeeded**: Returns true if the measurement unit creation was successfully initiated, otherwise it returns false  

  


### Usage in Matlab 

result = femtoapiObj.setPointsToSpace(fileNodeDescriptor, spacename, bAppend)

For more information about usage, see the [introduction](https://kb.femtonics.eu/pages/viewpage.action?pageId=39325016) and the examples below.

### Examples

  


**C++ code example** 

| |
| - |
| `QString command = “FemtoAPIFile.setPointsToSpace('1,0,1',``'space1'``,true)”; ` `auto cmdParser=client->sendJSCommand(command); ` |

 

**Matlab client code example:** 

| |
| - |
| `femtoapiObj = FemtoAPIProcessing();``% connect to local server (MESc) ` `result = femtoapiObj.setPointsToSpace(``'1,0,1'``,'space1',true) ` |

 

**Python client code example:** 

| |
| - |
| `command``=``"FemtoAPIFile.setPointsToSpace(``256``,``256``,``'AO'``,'background',viewport);” ` `simpleCmdParser``=``client.sendJSCommand(command) `  `resultCode``=``simpleCmdParser.getResultCode() `  `if` `resultCode >``0``: ` ```print` `(``"Return code: %d"` `%` `resultCode) ` ```print` `(simpleCmdParser.getErrorText()) ` `else``: ` ```print` `(``"setPointsToSpace(): %s"` `%` `simpleCmdParser.getJSEngineResult()) ` |

  


  
