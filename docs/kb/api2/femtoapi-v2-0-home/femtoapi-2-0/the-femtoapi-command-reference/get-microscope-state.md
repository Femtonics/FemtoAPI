# Get microscope state
  


## **var json=FemtoAPIMicroscope.getMicroscopeState()**

  


UNSAFE operation.

Gets a json object, which contains the following fields: 

* "microscopeState": current state of the microscope
* "lastMeasurementError":  the <span style="letter-spacing: 0.0px;">cause</span> <span style="letter-spacing: 0.0px;">of</span> <span style="letter-spacing: 0.0px;">the</span> <span style="letter-spacing: 0.0px;">error</span> <span style="letter-spacing: 0.0px;">in</span> <span style="letter-spacing: 0.0px;">the</span> <span style="letter-spacing: 0.0px;">last</span> <span style="letter-spacing: 0.0px;">measurement (JSON string),</span> <span style="letter-spacing: 0.0px;">if</span> <span style="letter-spacing: 0.0px;">there</span> <span style="letter-spacing: 0.0px;">was</span> <span style="letter-spacing: 0.0px;">any,</span> <span style="letter-spacing: 0.0px;">otherwise</span> <span style="letter-spacing: 0.0px;">an</span> <span style="letter-spacing: 0.0px;">empty</span> <span style="letter-spacing: 0.0px;">string.</span>

The microscopeState can be one of the following JSON strings:

* "Off": The microscope hardware is turned off.
* "Initializing": The microscope hardware is being initialized.
* "Ready": The microscope hardware is ready for starting measurements.
* "Working": The microscope is running a measurement.
* "In an invalid state": An error occurred in the operation of the microscope (e.g., microscope hardware error).

  


### Usage in Matlab

command:

result = femtoapiMicroscopeObj.getMicroscopeState()

It returns the json object mentioned above, converted to a Matlab struct: 

* microscopeState: enumeration, microscope state
* lastMeasurementError: character array, the last measurement error, or empty if there was no error

  


  


***C++ code example:***

```
QString command = “FemtoAPIMicroscope.getMicroscopeState()”;
auto cmdParser=client->sendJSCommand(command);
```

  


***Matlab client code example:*** 

```
femtoapiObj = FemtoAPIAcquisition();
result = femtoapiObj.getMicroscopeState(); 
result.microscopeState % 'microscopeState' field as enumeration
result.lastMeasurementError
```

  


***Python client code example:*** 

```py
command="FemtoAPIMicroscope.getMicroscopeState();"
simpleCmdParser=client.sendJSCommand(command)

resultCode=simpleCmdParser.getResultCode()
if resultCode > 0:
     print ("Return code: %d" % resultCode)
     print (simpleCmdParser.getErrorText())
else:	
     print ("getMicroscopeState(): %s" % simpleCmdParser.getJSEngineResult())
```

  


  


  


  
