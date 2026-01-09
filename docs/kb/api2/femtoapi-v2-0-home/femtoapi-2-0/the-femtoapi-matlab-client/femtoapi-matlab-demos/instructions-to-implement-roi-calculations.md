# Instructions to implement ROI calculations
To implement ROI calculations, the following data must be read from server: 

* ROI metadata 
* channel image data
* axis conversions

## Read ROI and channel data 

You can implement your own ROI calculations in Matlab. The following code is just a starting point to this. 

```matlab
mUnitHandle = [54 0 0]; % handle of measurement unit that contains ROI-s
femtoapiObj = FemtoAPIProcessing; % connect to local server
rois = femtoapiObj.getMeasurementMetaDataField(mUnitHandle,'rois'); % get ROI metadata as struct/cell array
```

  


You get all the ROI metadata in json array, and in Matlab this is converted to a struct/cell array. For example, rectangular ROI-s metadata in json:

  


```js
	"rois": [
        {
            "color": "#ffff00ff",
            "firstZPlane": 0,
            "label": "2",
            "lastZPlane": 0,
            "role": "standard",
            "type": "rectangleXY",
            "uniqueID": "{8e1e875a-e586-4555-b90b-dd166f25e294}",
            "vertices": [
                [
                    -89.93968910440431,
                    145.61758404165928
                ],
                [
                    -140.22283243505154,
                    62.742649916250144
                ],
                [
                    -95.26945476637809,
                    35.46785137354358
                ],
                [
                    -44.98631143573071,
                    118.34278549895265
                ],
                [
                    -89.93968910440431,
                    145.61758404165928
                ]
            ]
        },
        {
            "color": "#ffffff00",
            "firstZPlane": 0,
            "label": "3",
            "lastZPlane": 0,
            "role": "standard",
            "type": "rectangleXY",
            "uniqueID": "{450bb5dc-18e5-4b3b-bf89-4e162db9eddb}",
            "vertices": [
                [
                    18.716456070640128,
                    107.4893125709017
                ],
                [
                    -23.780909975208516,
                    37.446626726985805
                ],
                [
                    23.313104122004017,
                    8.873028619718838
                ],
                [
                    65.81047016785303,
                    78.91571446363446
                ],
                [
                    18.716456070640128,
                    107.4893125709017
                ]
            ]
        },
        {
            "color": "#ffff0000",
            "firstZPlane": 0,
            "label": "4",
            "lastZPlane": 0,
            "role": "standard",
            "type": "rectangleXY",
            "uniqueID": "{3b881950-8542-4447-a1ec-88986ae67c13}",
            "vertices": [
                [
                    -8.523654683878924,
                    205.33164893046816
                ],
                [
                    -47.77694698576971,
                    140.63573299830162
                ],
                [
                    1.457704115861958,
                    110.76333497706783
                ],
                [
                    40.71099641775294,
                    175.45925090923424
                ],
                [
                    -8.523654683878924,
                    205.33164893046816
                ]
            ]
        }
    ]

```

  


*Note1*: If there is a json object with regularPolygonXY type the json array, there are additional ROI parameters: regularPolygonRotationPoint, regulaPolygonCenter, regularPolygonSides. 

Because of this, the fields in the returned json array will not be the same in all object, and in this case, the json array is converted to a cell array in Matlab. Otherwise, if all json objects contain the same fields, the resulted array is converted to struct array. 

*<span style="color: rgb(0,51,102);">Note2</span>*: The ROI vertices and the additional parameters in case of regularPolygonXY type are (X,Y) points in μm unit (converted data). 

You can find the description of ROI fields  here(DEV-A-1668703787).

  


After ROI metadata is read, you can read the raw or converted data of the requested channel. You don't have to read all the channel data, just the part where ROI-s are found. This can be done by selecting channel data from the 

\[firstZPlane, lastZPlane] z domain.

  


For example, to read the channel with index 1 where ROI-s are found:

```matlab
channelHandle = [mUnitHandle 1];

% get channel image dimensions
dims = femtoapiObj.getMeasurementMetaDataField(channelHandle, 'dimensions');
dimX= dims(1).size;
dimY = dims(2).size;

% get axis conversions 
convX = dims(1).conversion; % 'x' axis conversion
convY = dims(2).conversion; % 'y' axis conversion


% get converted channel data where ROI-s are found, from channel 1
subslab3D = {1:dimX, 1:dimY, firstZPlane:lastZPlane};
channelData = femtoapiObj.readChannelData(channelHandle, 'double', subslab3D)
```

After ROI metadata, axis conversions and channel data are read:

* from ROI vertices, you can find its area within its boundaries 
* you can find the mean of the image pixels (or other aggregate functions) within the ROI boundaries using axis conversion, that converts pixel (X,Y) coordinates to physical coordinates

  


  


  
