# Get-set imaging window (viewport) parameters
  


## **var json = FemtoAPIMicroscope.getImagingWindowParameters(measurementType = '', spaceName = '')**

  


UNSAFE operation.

Gets imaging window parameters. 

It has two optional parameters to filter the imaging parameters by measurement type and space (the examples illustrate their use):

* **measurementType**: measurement type as string, currently it can be 'resonant' or 'galvo', or empty string, in the latter case, both types are considered.
* **spaceName**: space name as string, if empty string is given, default space ('space1') is considered. 

The ‘json’ variable returned by the get command contains the same JSON parameters and uses the same JSON schema as the set command, and the following extra parameters:

* **rotationQuaternion**: rotation quaternion, as a JSON array with 4 values in the format \[w, x,y,z]. For identity rotation, it is \[1,0,0,0].
* **resolutionXLimits**: a JSON array, contains the current lower/upper resolution limits in the format \[lowerXLimit, upperXLimits]
* **resolutionYLimits**: a JSON array, contains the current lower/upper resolution limits in the format \[lowerYLimit, upperYLimits]

  


These parameters appear only when the get command is issued, and cannot be set.

### Usage in Matlab

First, instantiate the FemtoAPIAcquisition class as described in the  tutorial(API2-A-1448161761). 

The syntax of the call is almost the same, only the resulted json is parsed into a Matlab (nested) struct. Otherwise the usage is the same as with the C++/Python client commands:

result = femtoapiObj.getImagingWindowParameters(measurementType, spaceName)

In case of any error, a Matlab error type exception is thrown.

  


### Examples

#### ***C++ code examples:***

```cpp
// 1. No optional parameters are given: get imaging window parameters for all the measurement types and spaces. The result is the same when one or two empty string is given.
QString command = "FemtoAPIMicroscope.getImagingWindowParameters()" ;
// or QString command = "FemtoAPIMicroscope.getImagingWindowParameters(’’)"
// or QString command = "FemtoAPIMicroscope.getImagingWindowParameters(’’,’’)"

auto cmdParser=client->sendJSCommand(command);


// 2. If the first parameter is given, it is the measurement type, and currently it must be ‘resonant’ or ‘galvo’ (case sensitive). It results imaging parameters for the specified measurement in case of all //available spaces.  
QString command =  "FemtoAPIMicroscope.getImagingWindowParameters(’resonant’)" ;
// or if the second parameter is empty string (default), results are the same: 
// QString command = //"FemtoAPIMicroscope.getImagingWindowParameters(’resonant’,’’)"

auto cmdParser=client->sendJSCommand(command);


// 3. If the second parameters is given, the space name, and the first is empty string (default), imaging parameters for all measurements, but only with the specified space are returned.
QString command = "FemtoAPIMicroscope.getImagingWindowParameters(’’,’space1’)" ;


// imaging window values for measurements resonant and galvo, with space1, are returned
auto cmdParser=client->sendJSCommand(command);
```

  


  


***Matlab client code example:*** 

```matlab
femtoapiObj = MEScAPIAcquisition();

% get imaging parameters for 'galvo' measurement in case of all (available) spaces  
imagingParametersGalvo = femtoapiObj.getImagingWindowParameters('galvo'); 

% get imaging parameters for 'resonant' measurement in case of all (available) spaces
imagingParametersResonant = femtoapiObj.getImagingWindowParameters('resonant');

% get imaging parameters for all available type of measurements ('resonant' and 'galvo', currently), for the specified space
imagingWindowParamtersForSpace1 = femtoapiObj.getImagingWindowParameters('','space1');

% get imaging window parameters for all the measurement types and spaces. The result is the same when one or two empty string is given
imagingWindowParametersAll = femtoapiObj.getImagingWindowParameters();
```

  


  


***Python client code example:*** 

```py
command="FemtoAPIMicroscope.getImagingWindowParameters();"
simpleCmdParser=client.sendJSCommand(command)
resultCode=simpleCmdParser.getResultCode()

if resultCode > 0:
    print ("Return code: %d" % resultCode)
    print (simpleCmdParser.getErrorText())
else:	
    print ("getImagingWindowParameters(): %s" % simpleCmdParser.getJSEngineResult())
```

  


  


## **var succeed = FemtoAPIMicroscope.setImagingWindowParameters(json)**

## **or**

## **FemtoAPIMicroscope.setImagingWindowParameters(json)**

This command is used to set the imaging window (viewport) parameters of a selected measurement type and space in a JSON format.

In case of the set command, the input is a JSON array, which contains one or more JSON objects for the different measurement types and/or spaces. This JSON object consists of the following values:

* **space**: string, optional, the space used for imaging, if omitted, the default space is used
* **measurementType**: the type of measurement to apply the settings of the imaging window to. Currently the value of this can only be one of the strings “resonant” or “galvo”. The set values have some restrictions based on the measurement type. These will be described later.
* **resolution**: a JSON array of two elements containing the imaging window resolution in the X and Y directions, e.g \[pixelsX, pixelsY].
* **size**: a JSON array of two elements containing the size of the imaging window in µm, e.g. \[widthX,widthY].
* **transformation**: a JSON object, which describes the translational and rotational transformations, and consists of two JSON objects according to "translation" and "rotationQuaternion". Translation means the lower left position of the viewport rectangle given in the (x,y) (or (x,y,z)) JSON array. Currently, only translation in the X and Y directions can be set, translation in the Z direction and rotationQuaternion are omitted, if given. 

  


It returns true if the input json and its values were valid and parameters are successfully set, otherwise false.

  


The input parameter ‘json’ is validated against the following JSON schema:

```js
{
    "$schema": "http://json-schema.org/draft-04/schema#",
    "title": "Imaging window parametes schema",
    "description": "Json array that contains the imaging window (viewport) parameters for all spaces and measurement types",
    "type": "array",
    "minItems": 1,
    "items": {
        "description": "Json object that contains the imaging window parameters for a specific space and measurement type (galvo or resonant)",
        "type": "object",
        "properties" :{
            "space": {
                "description": "Name of the space",
                "type": "string"},
            "measurementType": {
                "type": "string",
                "enum":["resonant","galvo"],
                "description": "Type of measurement, its value can only be 'resonant' or 'galvo'."  },
            "resolution": {
                "description": "Image X and Y resolution in pixels",
                "type": "array",
                "items": {
                    "type": "integer",
                    "minimum": 1
                },
                "minItems": 2,
                "maxItems": 2
            },
            "resolutionXLimits": {
                "description": "Json array that contains the limits of X resolution [lowerXLimit, upperXLimit]",
                "type": "array",
                "items": {
                    "type": "integer",
                    "minimum": 1
                },
                "minItems": 2,
                "maxItems": 2
            },
            "resolutionYLimits": {
                "description": "Json array that contains the limits of Y resolution [lowerYLimit, upperYLimit]",
                "type": "array",
                "items": {
                    "type": "integer",
                    "minimum": 1
                },
                "minItems": 2,
                "maxItems": 2
            },
            "transformation" : {
                "description": "Json object that describes viewport translation in order (x,y,z) and rotation quaternion (w,x,y,z)",
                "type" : "object",
                "properties" : {
                    "translation" : {
                        "type" : "array",
                        "items": { "type": "number"  },
                        "minItems" : 2,
                        "maxItems" : 3
                    },
                    "rotationQuaternion" : {
                        "type" : "array",
                        "items": {  "type": "number"  },
                        "minItems" : 4,
                        "maxItems" : 4
                    }
                },
                "required":["translation"],
                "additionalProperties": false
            },
            "size": {
                "description": "Json array containing the size of viewport in format [width,height]",
                "type": "array",
                "items" : {
                    "type": "number",
                    "minimum" : 0,
                    "exclusiveMinimum" : true
                },
                "minItems":2,
                "maxItems":2
            }
        },
        "required": [ "measurementType","resolution","size","transformation" ],
        "additionalProperties": false
    }
}
```

#### Important notes

* If some of the parameters are invalid, an error message is returned, which gives information on the valid domain of the parameters.


* The ‘measurementType’ and ‘space’ pairs are unique, so if the outer JSON array contains more than one object with the same measurementType and space, an error message is returned, and no parameter is set.


* There are some parameters in the JSON schema, which cannot be set, and has no impact when given, these parameters only appear in the result JSON of the getter command:  
   - ‘rotationQuaternion’  
   - ‘resolutionXLimits’  
   - ‘resolutionYLimits’

#### Restrictions on parameters

There are some rules applied to the imaging parameters, and some of them depend on the measurement types. If at least one condition is not met, an error message is returned, and nothing is changed.

The following rules are applied:

For both (resonant and galvo):

* aspect ratio calculated from the X and Y resolutions and the imaging window size must be equal (resolution / resolution = width / height)
* the imaging window must be within its boundaries, which depends on the channel conversion

for galvo:

* valid resolution domain: 64x16 – 1024x1024 (These are the absolute limits, but the actual limits depend on the GUI parameter pixel dwell time in case of galvo measurements. Run the FemtoAPIMicroscope.getImagingWindowParameters() to get the exact values)

for resonant:

* valid resolution domain: 64x16 – 512x1024
* the imaging window must be symmetric on the Y axis, so the translation in the X direction must be negative, and its absolute value must be half of the imaging window width (translX = -width/2)

  


### Usage in Matlab

First, instantiate the FemtoAPIAcquisition class as described in the  tutorial(API2-A-1448161761). 

The syntax of the call is almost the same, only the input json must be parsed into a Matlab (nested) struct. Otherwise the usage is the same as with the C++/Python client commands:

succeeded = femtoapiObj.setImagingWindowParameters(imagingWindowParameters)

In case of any error, a Matlab error type exception is thrown, otherwise true is returned.

### Examples

#### ***C++ code example:***

```cpp
QString command =  "FemtoAPIMicroscope.setImagingWindowParameters('[{"space": "space1", "measurementType": "resonant", "size": [200, 400],"transformation": {"translation": [-175.0,0.0]},"resolution": [100, 200]}]') ";
auto cmdParser=client->sendJSCommand(command);
```

  


This command will set the viewport parameters for the space named ‘space1’ and the ‘resonant’ measurement type. The imaging window will be 200 µm in the X, and 400 µm in the Y direction, it has a translational transformation, translated by -175.0 µm in the X, 0.0 µm in the Y direction. The imaging window resolution in the X direction is 100 pixels, and in the Y direction is 200 pixels.

  


***Matlab client code example:*** 

```matlab
femtoapiObj = MEScAPIAcquisition();

imagingWindowParameters = struct();
imagingWindowParameters.measurementType = 'galvo';
imagingWindowParameters.space = 'space1';
imagingWindowParameters.resolution = [280; 280];
imagingWindowParameters.size = [140; 140];
imagingWindowParameters.transformation = struct();
imagingWindowParameters.transformation.translation = [-70;0;0]; 
imagingWindowParameters.transformation.rotationQuaternion = [0,0,0,1]; % default value, it will not be set by this method

femtoapiObj.setImagingWindowParameters(imagingWindowParameters);
```

  


***Python client code example:*** 

```py
command="FemtoAPIMicroscope.setImagingWindowParameters('[{"space": "space1", "measurementType": "resonant", "size": [200, 400],"transformation": {"translation": [-175.0,0.0]},"resolution": [100, 200]}]');"
simpleCmdParser=client.sendJSCommand(command)
resultCode=simpleCmdParser.getResultCode()
if resultCode > 0:
    print ("Return code: %d" % resultCode)
    print (simpleCmdParser.getErrorText())
else:	
    print ("setImagingWindowParameters(): %s" % simpleCmdParser.getJSEngineResult())
```

  


  
