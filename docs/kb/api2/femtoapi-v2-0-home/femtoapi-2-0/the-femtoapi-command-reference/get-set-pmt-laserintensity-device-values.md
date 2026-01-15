# Get-set PMT/Laserintensity device values


## **var json = FemtoAPIMicroscope.getPMTAndLaserIntensityDeviceValues()**

## **or**

## **FemtoAPIMicroscope.getPMTAndLaserIntensityDeviceValues()**

  


UNSAFE operation.

This command is used to get PMT/Laser intensity device values.

It uses the same JSON schema as the set() method, so this command results in a JSON array that contains objects, with the following fields:

* **name**: device name
* **value**: device intensity value
* **min**: device value lower limit
* **max**: device value upper limit
* **space**: space which the device is configured for

  


Example output:

```js
[
    {
        "max": 5,
        "min": 0,
        "name": "PMT_UG",
        "space": "space1",
        "value": 4
    },
    {
        "max": 5,
        "min": 0,
        "name": "PMT_GALVO",
        "space": "space1",
        "value": 2.50
    },
    {
        "max": 5,
        "min": 0,
        "name": "PMT_UR",
        "space": "space1",
        "value": 2
    },
    {
        "max": 100,
        "min": 0,
        "name": "ResonantPockelsCell",
        "space": "space1",
        "value": 27.70
    }
]
```

  


### Usage in Matlab

First, you need to create a FemtoAPIAcquisition object, as described  here ([Tutorial: using the FemtoAPI Matlab client](../the-femtoapi-matlab-client/tutorial-using-the-femtoapi-matlab-client.md)). Otherwise, the usage is the same as described above, the only change that the returned value has different format: 

result = femtoapiObj.getPMTAndLaserIntensityDeviceValues();

where the returned value is a  DeviceValues ([Helper classes and functions](../the-femtoapi-matlab-client/helper-classes-and-functions.md)) object, that contains the json result returned from server parsed into an array of Matlab structs.

### Examples

***C++ example***

```cpp
QString command = “FemtoAPIMicroscope.getPMTAndLaserIntensityDeviceValues()”;
auto cmdParser=client->sendJSCommand(command);
```

  


  


***Matlab client code example:*** 

```matlab
femtoapiObj = FemtoAPIAcquisition();
deviceValues = femtoapiObj.getPMTAndLaserIntensityDeviceValues();
```

  


  


***Python client code example:*** 

```py
command="FemtoAPIMicroscope.getPMTAndLaserIntensityDeviceValues();"
simpleCmdParser=client.sendJSCommand(command)
resultCode=simpleCmdParser.getResultCode()

if resultCode > 0:
    print ("Return code: %d" % resultCode)
    print (simpleCmdParser.getErrorText())
else:	
    print ("getPMTAndLaserIntensityDeviceValues(): %s" % simpleCmdParser.getJSEngineResult())
```

  


## **var succeed = FemtoAPIMicroscope.setPMTAndLaserIntensityDeviceValues(json)** 

## **or**

##  **FemtoAPIMicroscope.setPMTAndLaserIntensityDeviceValues (json)** 

  


UNSAFE operation.

This command is used to set PMT/Laserintensity device intensity values.

The input is a JSON array, which contains JSON objects, with the following fields:

* **space**: string, name of the space for which the device is configured, optional, if not given, default space is considered
* **name**: string, device name, it must be a valid, configured PMT/Laser intensity device
* **value**: double, the new intensity value of the device specified by ’name’, if it is smaller/greater than the lower/upper limit value of the specified device, the function returns with false, and an error message

  


Output: true, if the device position set command has been sent successfully, false otherwise.

  


The input JSON is validated against the following JSON schema:

```js
{
    "$schema": "http://json-schema.org/draft-04/schema#",
    "title": "PMT and laser intensity device parametes schema",
    "description": "Json array that contains the PMT/laser intensity device parameters",
    "type": "array",
    "items": {
        "type": "object",
        "properties" : {
            "name" : {"type" : "string" },
            "value" : {"type": "number"},
            "min" : {"type": "number"},
            "max" : {"type": "number"},
            "space": {"type": "string"}
        },
        "required": ["name","value"],
        "additionalProperties": false
    }
}
```

#### Important notes

* In case an invalid device/space name is given, or if the device/space names are valid, but the device is not configured for that space, this command returns false, and an error message
* If the value that wanted to be set is out of the \[min, max] range of a device, this command returns false, and an error message
* This function checks the JSON validity, and the device name/value/space before setting any value, so in case of any error, the device values currently set on the server stay unchanged.
* The min/max values are not required in the set method, and if given, it sets nothing, because of its compatibility with the getter method, which uses the same JSON schema.

  


### Usage in Matlab

First, you need to create a FemtoAPIAcquisition object as described  here ([Tutorial: using the FemtoAPI Matlab client](../the-femtoapi-matlab-client/tutorial-using-the-femtoapi-matlab-client.md)). After it, you need to give the input as a DeviceValues object:

succeeded = femtoapiObj.setPMTAndLaserIntensityDevices(deviceValues) 

In case of success, it returns true, otherwise, a Matlab error type exception is thrown containing the error message. 

### Examples

#### ***C++ code example***

```cpp
QString command = “FemtoAPIMicroscope.setPMTAndLaserIntensityDeviceValues('[{"name":"PMT_UR","value":42.0},{"name":"PMT_UG","value":110.0},{"name":"rPockelsCell","value":10.0},{"name":"dummyY","value":11.0,"space":"space2"}]')”;
auto cmdParser=client→sendJSCommand(command);
```

  


  


***Matlab client code example:*** 

```matlab
femtoapiObj = FemtoAPIAcquisition();
deviceValues = struct();
deviceValues(1).name = 'PMT_UR';
deviceValues(1).value= 42; 
deviceValues(2).name = 'PMT_UG';
deviceValues(2).value= 12.3;
 
% and so on, set other device values in the struct array, and create a deviceValues object from it
deviceValuesObj = DeviceValues(deviceValues);
% set device values on server
femtoapiObj.setPMTAndLaserIntensityDeviceValues(deviceValuesObj);


% You can use DeviceValues object to easily get/set values of devices 
devicevaluesObj = femtoapiObj.getPMTAndLaserIntensityDeviceValues()

% get device names as cell array, to inspect available devices 
deviceNames = deviceValuesObj.getDeviceNames(); 

% set device values by name -> only sets locally 
deviceValuesObj.setDeviceValueByName('PMT_UR',42);
deviceValuesObj.setDeviceValueByName('PMT_UG',23);

% set device values on server 
femtoapiObj.setPMTAndLaserIntensityDeviceValues(deviceValuesObj);

```

  


  


***Python client code example:*** 

```py
command="FemtoAPIMicroscope.setPMTAndLaserIntensityDeviceValues('[{"name":"PMT_UR","value":42.0},{"name":"PMT_UG","value":110.0},{"name":"rPockelsCell","value":10.0},{"name":"dummyY","value":11.0,"space":"space2"}]');"
simpleCmdParser=client.sendJSCommand(command)
resultCode=simpleCmdParser.getResultCode()

if resultCode > 0:
    print ("Return code: %d" % resultCode)
    print (simpleCmdParser.getErrorText())
else:	
    print ("setPMTAndLaserIntensityDeviceValues(): %s" % simpleCmdParser.getJSEngineResult())
```

  
