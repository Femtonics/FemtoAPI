# Starting and stopping measurements
  


The measurement types that can be started and stopped through the FemtoAPI are as follows:

* Galvo XY scan
* Resonant XY scan

The measurement start/stop functions are all asynchronous and have no input parameters.

In case of these commands, the return value is true when the start/stop measurement task was successfully initiated, otherwise returns false and an error message.

Start measurement commands fails when: 

* a measurement has been started and is running yet
* the hardware is not ready for measure (because it is switched off, or a hardware error occurred)

Stop measurement commands fails when: 

* the hardware is not ready for measure (because it is switched off, or a hardware error occurred)
* no measurement has been started 
* a measurement has been started, but there was a hardware error during it (in this case, measurement stops automatically in MESc)

  


*Notes*:

* <span style="letter-spacing: 0.0px;">It is advisable to check the microscope state right after a start measurement command has been successfully initiated, and returned true. If it shows "Working" state, the measurement is running properly.</span>
* You can check the state of the microscope hardware with the  getMicroscopeState()(API2-A-1448161787) command, whether it is running properly or not, and in the latter case, the cause of the error. 

  


### Usage in Matlab

The Matlab variants of these commands use the same syntax. 

  


  


## **var success = FemtoAPIMicroscope.startGalvoScanSnapAsync()**

  


UNSAFE operation.

Starts a galvo XY scan snap asynchronously

Return value: boolean, true when the measurement start command was successfully initiated, false otherwise.

  


## **var success = FemtoAPIMicroscope.startGalvoScanAsync()**

  


UNSAFE operation.

Starts a galvo XY scan asynchronously

Return value: boolean, true when successful, otherwise false.

  


## 

## **var success = FemtoAPIMicroscope.stopGalvoScanAsync()**

  


UNSAFE operation.

Stops a galvo XY scan asynchronously.

Return value: boolean, true when successful, otherwise false.

  


  


## **var success = FemtoAPIMicroscope.startResonantScanSnapAsync()**

  


UNSAFE operation.

Starts a resonant scan snap asynchronously.

Return value: boolean, true when successful, otherwise false.

  


## 

## **var success = FemtoAPIMicroscope.startResonantScanAsync()**

  


UNSAFE operation.

Starts a resonant scan asynchronously

Return value: boolean, true when successful, otherwise false.

  


## 

## **var success = FemtoAPIMicroscope.stopResonantScanAsync()**

  


UNSAFE operation.

Stops a resonant scan asynchronously

Return value: boolean, true when successful, otherwise false.

  


### Examples

These examples are 

***C++ code example:*** 

```cpp
QString command = “FemtoAPIMicroscope.startGalvoScanAsync()”;
auto cmdParser=client->sendJSCommand(command);
```

  


***Matlab client code example:*** 

```
femtoapiObj = FemtoAPIAcquisition(); % connects to local server
mescapiObj.startGalvoScanAsync(); % starts galvo measurement 

% poll microscope state to check whether measurement has started successfully or not -> state should change to Workint state
t = 0;
measurementStarted = false;
while(t < 10)
    % wait (max. around 10s) until microscope gets into Measure state    
    if(mescapiObj.getMicroscopeState().microscopeState == MicroscopeState.Working)
        measurementStarted = true;
        break;
    end
    pause(1);
    t = t + 1;
end

% if not in working state, some error happened
if(~measurementStarted)
    if(~isempty(microscopeState.lastMeasurementError)
        error(strcat('Start measurement failed. Reason: ', ...
            microscopeState.lastMeasurementError));
    else
        error('Start measurement failed.');
    end
end
```

  


***Python client code example:***

```py
command="FemtoAPIMicroscope.startGalvoScanAsync();"
simpleCmdParser=client.sendJSCommand(command)
resultCode=simpleCmdParser.getResultCode()

if resultCode > 0:
    print ("Return code: %d" % resultCode)
    print (simpleCmdParser.getErrorText())
else:	
    print ("startGalvoScanAsync(): %s" % simpleCmdParser.getJSEngineResult())
```

  


  
