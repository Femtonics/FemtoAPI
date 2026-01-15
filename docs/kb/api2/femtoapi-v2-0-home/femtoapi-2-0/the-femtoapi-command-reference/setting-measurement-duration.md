# Setting measurement duration
## 

## **var succeeded = FemtoAPIMicroscope.setMeasurementDuration(duration, taskName = '', spaceName = '')**

Sets measurement duration for the given task and space. If taskName is empty, the current active task is considered. If spaceName is empty, default space ('space1') is considered. 

Input parameters: 

**duration**: double, the requested measurement duration 

**taskName**: optional, string, name of the measurement task to set the duration to. It must be 'resonant' or 'galvo'. If not given, the duration of the currently selected measurement will be set.

**spaceName**: optional, string, name of the space. If not given, default space will be used.

  


*Note*: the real measurement duration will be a bit greater than this value due to hardware delay. By calling the  getAcquisitionState() ([Get acquisition state](get-acquisition-state.md)) command, you can inspect the 'durationEntered' and 'durationEstimated' json fields. The former is what you have given by setMeasurementDuration() command, and the latter will be the estimated duration, which is always greater than the entered duration. 

  


### Matlab usage

First, you need to create a FemtoAPIAcquisition object as described  here ([Tutorial: using the FemtoAPI Matlab client](../the-femtoapi-matlab-client/tutorial-using-the-femtoapi-matlab-client.md)). After it, usage is the same.

### Examples

***C++ code example:***

```cpp
QString command = “FemtoAPIMicroscope.setMeasurementDuration(10.1,'galvo')” ;
auto cmdParser=client->sendJSCommand(command);
```

  


  


 ***Matlab client code example:*** 

```
femtoapiObj = FemtoAPIAcquisition();
% set duration of resonant measurement
succeeded = femtoapiObj.setMeasurementDuration(10,'resonant');

% set duration of galvo measurement
succeeded = femtoapiObj.setMeasurementDuration(30,'galvo');

% set duration of active measurement task
succeeded = femtoapiObj.setMeasurementDuration(20);

% set active task's duration to infinite 
succeeded = femtoapiObj.setMeasurementDuration(0);
```

  


  


***Python client code example:*** 

```py
command="FemtoAPIMicroscope.setMeasurementDuration(10, 'resonant');"
simpleCmdParser=client.sendJSCommand(command)
resultCode=simpleCmdParser.getResultCode()

if resultCode > 0:
    print ("Return code: %d" % resultCode)
    print (simpleCmdParser.getErrorText())
else:	
    print ("setMeasurementDuration(): %s" % simpleCmdParser.getJSEngineResult())
```

  
