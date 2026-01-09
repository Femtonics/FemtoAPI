# Get acquisition state
  


## **var json = FemtoAPIMicroscope.getAcquisitionState()**

  


UNSAFE operation.

Gets the MESc GUI acquisition state. Currently it contains most of the measurement parameters and metadata information that can be seen on the MESc GUI acquisition panel, but only for resonant and galvo tabs. For example checkbox states, PMT/laser intensity device values, measurement specific parameters (for resonant and galvo measurements). 

*Note*: Only input channels metadata information are get with this command, the output channel informations and much more regarding used waveforms, patterns, etc. can be get with the  getActiveProtocol()(API2-A-1448161797) command.

  


***C++ code example:***

```
QString command = “FemtoAPIMicroscope.getAcquisitionState()”;
auto cmdParser=client->sendJSCommand(command);
```

  


***Python client code example:***

```py
command="FemtoAPIMicroscope.getAcquisitionState();"
simpleCmdParser=client.sendJSCommand(command)
resultCode=simpleCmdParser.getResultCode()

if resultCode > 0:
    print ("Return code: %d" % resultCode)
    print (simpleCmdParser.getErrorText())
else:	
    print ("getAcquisitionState(): %s" % simpleCmdParser.getJSEngineResult())
```

  


### Usage in Matlab

command: 

acquisitionState = femtoapiAcquisitionObj.getAcquisitionState();

Returns the acquisition state JSON as a nested Matlab struct.

  


***Code example:*** 

```
femtoapiObj= FemtoAPIAcquisition();
acquisitionState = femtoapiObj.getAcquisitionState();
```

  


  
