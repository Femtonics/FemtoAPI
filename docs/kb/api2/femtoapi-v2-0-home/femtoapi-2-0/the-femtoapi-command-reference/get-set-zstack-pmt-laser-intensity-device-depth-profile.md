# Get-set ZStack PMT/laser intensity device depth profile
## 

## **var outJson = FemtoAPIMicroscope.getZStackLaserIntensityProfile(measurementType = '', spaceName = '')**

## **or**

## **FemtoAPIMicroscope.getZStackLaserIntensityProfile(measurementType = '', spaceName = '')**

UNSAFE operation.

This command is used to get the Z-stack depth correction profile (the interpolation reference points) of PMT/ laser intensity devices. Its output has the same JSON schema as the setZStackLaserIntensityProfile() command.

Has two filtering input parameters, these are:

* **measurementType**: gets the Z-stack depth correction profile for all spaces, but only for the given measurement type (currently its value can be ‘resonant’ or ‘galvo’)
* **spaceName**: gets the Z-stack depth correction profile for all measurement types (resonant, galvo), but only for the given space

  


Notes:

* if called with no parameters, or an empty string ‘’, no filtering will be applied, so the parameters are get for all available spaces and measurement types (resonant, galvo)
* if the given measurement type or space name is wrong, it returns an empty JSON, and an error message

  


### Usage in Matlab

First, a FemtoAPIMicroscope object must be created. After it, the usage is the same as described above, only the input/output parameter types are a bit different: 

result = femtoapiObj.getZStackLaserIntensityProfile(measurementType, spaceName) 

where measurementType and spaceName must be char arrays, and the retuned value is the retuned json parsed into an array of (nested) Matlab structs. 

In case of any error, it gives the error message as a Matlab error type exception, otherwise it returns true.

### Examples

#### ***C++ code examples***

```cpp
// 1. Getting z-stack depth profile for resonant and galvo measurements, and for all spaces available:
QString command = “FemtoAPIMicroscope.getZStackLaserIntensityProfile() “; // ( or FemtoAPIMicroscope.getZStackLaserIntensityProfile(‘’) or FemtoAPIMicroscope.getZStackLaserIntensityProfile(‘’,’’) )
auto cmdParser=client->sendJSCommand(command);

// 2. Getting z-stack parameters for galvo measurement:
QString command = “FemtoAPIMicroscope.getZStackLaserIntensityProfile(‘galvo’) “ ;
auto cmdParser=client->sendJSCommand(command);

// 3. Getting z-stack depth profile for all measurements, but ‘space1’:
QString command = “FemtoAPIMicroscope.getZStackLaserIntensityProfile(‘’,’space1’) “;
auto cmdParser=client->sendJSCommand(command);

// 4. Getting z-stack depth profile for resonant measurement, and space2:
QString command = “FemtoAPIMicroscope.getZStackLaserIntensityProfile(‘resonant’,’space2’) “;
auto cmdParser=client->sendJSCommand(command);
```

  


  


***Matlab client code example:*** 

```matlab
femtoapiObj = FemtoAPIAcquisition();
femtoapiObj.getZStackLaserIntensityProfile('space1','galvo'); % gets z stack intensity profile for galvo measurement 
```

  


  


***Python client code example:*** 

```py
command="FemtoAPIMicroscope.getZStackLaserIntensityProfile();"
simpleCmdParser=client.sendJSCommand(command)
resultCode=simpleCmdParser.getResultCode()

if resultCode > 0:
    print ("Return code: %d" % resultCode)
    print (simpleCmdParser.getErrorText())
else:	
    print ("getZStackLaserIntensityProfile(): %s" % simpleCmdParser.getJSEngineResult())

```

  


## 

## **var succeed = FemtoAPIMicroscope.setZStackLaserIntensityProfile(json)**

## **or**

## **FemtoAPIMicroscope.setZStackLaserIntensityProfile( json)**

  


UNSAFE operation.

Used to set the Z-stack intensity depth profile of PMT/ laser intensity devices, based on 2 or 3 z-levels and device values at these levels, as interpolation points.

The input JSON is an array, that consists of JSON objects, which contain one or more JSON objects for the different measurement types and/or spaces. These JSON objects consist of the following values:

* **space**: string, optional, the space which is used, if omitted, the default space is used.
* **measurementType**: string, which is the type of Z-stack measurement to apply the depth correction to, currently it can be “resonant” or “galvo”.
* **firstZ:** a double value of the first Z relative position in a Z-stack measurement, the first reference Z interpolation point.
* **intermediateZ:** optional, an intermediate Z relative position, used as an interpolation reference point. If given, its value must be between ‘firstZ’ and ‘lastZ’.
* **lastZ:** double value of the last Z relative position in µm, until the Z-stack measurement is performed. The last reference Z interpolation point.
* **zStep:** double value of the Z step in a Z-stack measurement. It assigns the Z-planes to interpolate device values, based on ‘DepthCorrection’
* **DepthCorrection:** a JSON object that consists of a JSON array, which contains JSON object items with intensity values of PMT/laser intensity devices at given Z-planes (which is defined by the ‘firstZ’, ‘intermediateZ’ and ‘lastZ’ parameters). These device values assign the reference values for interpolation.

The input JSON is validated against the following schema:

  


```js
{
    "$schema": "http://json-schema.org/draft-04/schema#",
    "title": "Z-stack depth correction schema",
    "description": "Json array that contains the Z-Stack depth correction laser intensity values for all spaces and measurement types (galvo, resonant)",
    "type": "array",
    "minItems": 1,
    "items": {
        "description": "Json object that contains the Z-Stack depth correction laser intensity values for a specific space and measurement type (galvo or resonant)",
        "type": "object",
        "properties" :{
            "space": {
                "description": "Name of the space",
                "type": "string"
            },
            "measurementType": {
                "type": "string",
                "enum":["resonant","galvo"],
                "description": "Type of measurement, its value can only be 'resonant' or 'galvo'."
            },
            "firstZ": {
                "description": "first Z relative coordinate (to labeling origin)",
                "type" : "number"
            },
            "intermediateZ": {
                "description": "intermediate Z relative coordinate (to labeling origin)",
                "type" : "number"
            },
            "lastZ": {
                "description": "last Z relative coordinate (to labeling origin)",
                "type" : "number"
            },
            "zStep": {
                "description" : "z step in um",
                "type" : "number"
            },
            "DepthCorrection" : {
                "description": "z-stack laser intensities for the specified devices at z positions firstZ, (optionally intermediateZ), lastZ",
                "type":"array",
                "items" :  {
                    "type" : "object",
                    "properties" : {
                        "name" : {
                            "description" : "name of the PMT/Pockels device",
                            "type" : "string"
                        },
                        "values" : {
                            "type" : "array",
                            "items": {
                                "type": "number",
                                "minimum" : 0
                            },
                            "minItems" : 2,
                            "maxItems" : 3
                        }
                    },
                    "required":["name","values"],
                    "additionalProperties": false
                }
            }
        },
        "required": [ "measurementType","firstZ","lastZ","zStep","DepthCorrection" ],
        "additionalProperties": false
    }
} 
```

#### Important notes and restrictions on parameters

There are some restrictions on Z-stack parameters:

* the minimum value of the ‘zStep’ parameter is currently 0.1 µm
* if firstZ = intermediateZ = lastZ results in an error
* otherwise, if intermediateZ = firstZ or intermediateZ =lastZ, the difference between lastZ and firstZ must be greater than or equal to the minimum Z step value
* In case 3 Z reference points are given (firstZ &lt; intermediateZ &lt; lastZ), the difference between reference points must be greater than or equal to the minimum Z step value

  


Device values:

* all device intensity values must be positive double numbers
* in a “DepthCorrection” object, each “values” field must contain the same number of elements as the number of Z reference values
* in a ‘DepthCorrection’ JSON object, if the “values” parameter for a given device is below/above its lower/upper limit, it will be clamped to the given device’s lower/upper limit accordingly
* the lower/upper limits of devices can be get by the command FemtoAPIMicroscope.getPMTAndLaserIntensityDeviceValues()

  


Interpolation of reference points:

* in case of 2 reference points, the device values are interpolated linearly
* in case of 3 reference points, the pchip interpolation method is used
* if abs(lastZ – firstZ) / zStep is not an integer, the last Z plane position can be beyond the lastZ value, for example, If firstZ = 0.0, lastZ = 2.0, zStep = 0.6, the device values are interpolated at 5 Z-planes: 0.0, 0.6, 1.2, 1.8, 2.4

  


If any of the above conditions are not met, or a device with an invalid name is present, or a JSON is given that does not meet the conditions of the given JSON schema, an error message is returned, and nothing is set on the server.

  


The ‘measurementType’ and ‘space’ pairs are unique, so if the outer JSON array contains more than one object with the same measurement type and space, an error message is returned, and no parameter is set.

  


### Usage in Matlab

First, a FemtoAPIMicroscope object must be created. After it, the usage is the same as described above, only the input/output parameter types are a bit different: 

succeeded = femtoapiObj.setZStackLaserIntensityProfile(jsonAsStruct) 

where the input parameter json is parsed into an array of (nested) Matlab structs.

In case of any error, it gives the error message as a Matlab error type exception, otherwise it returns true.

  


### Examples

#### ***C++ code examples:***

  


```cpp
// 1. Setting parameters for galvo measurement, with 3 reference points, on default space:
QString command = “FemtoAPIMicroscope.setZStackLaserIntensityProfile('[{"measurementType":"galvo","firstZ":10.0,"intermediateZ": 13.0,"lastZ": 13.0,"zStep":0.5, "DepthCorrection":[{"name":"PMT_UG","values":[0,2,5]},{"name":"ResonantPockelsCell","values":[0,50,60]}]}]') “;
auto cmdParser=client->sendJSCommand(command);

// This command creates 11 z planes, from firstZ = 10.0 to lastZ = 13.0, with zStep = 0.5. 

// 2. Setting parameters for resonant and galvo measurement in one command, for space1, with 3 reference values:
QString command = “FemtoAPIMicroscope.setZStackLaserIntensityProfile('[{"measurementType":"galvo","firstZ":10.0,"intermediateZ": 12.0,"lastZ": 13.0,"zStep":0.9, "DepthCorrection":[{"name":"PMT_UG","values":[0,2,5]},{"name":"PMT_UR","values":[2,3,5]}]}, {"measurementType":"resonant","firstZ":2.0,"intermediateZ": 5.0,"lastZ": 7.0,"zStep":0.5, "DepthCorrection":[{"name":"PMT_UG","values":[0,2,5]},{"name":"PMT_UR","values":[0,50,60]}]}]') “;
auto cmdParser=client->sendJSCommand(command);

```

  


***Matlab client code example:*** 

```matlab
femtoapiObj = FemtoAPIAcquisition();

zStackParameters.space = 'space1';
zStackParameters.measurementType = 'galvo';
zStackParameters.firstZ = 0.0;
zStackParameters.zStep = 10.0;
zStackParameters.zPlanes = 2;

deviceNames = {'PMT_UG','PMT_UR','PMT_GALVO','ResonantPockelsCell','Apt1'};
deviceValues = {[0.4;2.5],[3.5;1.6],[4.1;3.5],[2.3;10],[3.1;14.1]}; % sets 2 reference values for devices
depthCorrStruct = repmat(struct('name',[],'values',[]),length(deviceNames),1);

for i=1:length(deviceNames)
    depthCorrStruct(i).name = deviceNames{i};
    depthCorrStruct(i).values = deviceValues{i};
end

zStackParameters.DepthCorrection = depthCorrStruct;
femtoapiObj.setZStackLaserIntensityProfile(zStackParameters)
```

  


  


***Python client code example:*** 

```py
command="FemtoAPIMicroscope.setZStackLaserIntensityProfile('[{"measurementType":"galvo","firstZ":10.0,"intermediateZ": 13.0,"lastZ": 13.0,"zStep":0.5, "DepthCorrection":[{"name":"PMT_UG","values":[0,2,5]},{"name":"ResonantPockelsCell","values":[0,50,60]}]}]');"
simpleCmdParser=client.sendJSCommand(command)
resultCode=simpleCmdParser.getResultCode()

if resultCode > 0:
    print ("Return code: %d" % resultCode)
    print (simpleCmdParser.getErrorText())
else:	
    print ("setZStackLaserIntensityProfile(): %s" % simpleCmdParser.getJSEngineResult())
```

  
