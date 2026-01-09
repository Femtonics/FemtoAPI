# Tutorial: use cases
Below are some practical usage examples and instructions given on how to implement these using the FemtoAPI command set. 

# Starting measurement (or snap) and get the measured images

Needed FemtoAPI commands: 

* setActiveTaskAndSubTask()(API2-A-1448161797)
* setMeasurementDuration()(API2-A-1448161799) (optionally) 
* getAcquisitionState()(API2-A-1448161788)
* start/stop measurement commands (API2-A-1448161790)
* set measurement duration(API2-A-1448161799)
* getMicroscopeState()(API2-A-1448161787)
* getProcessingState()(API2-A-1448161786)
* read channel data commands, e.g.  readRawChannelDataToClientsBlob()(API2-A-1448161789) or  readChannelDataToClientsBlob()(API2-A-1448161789)

  


Instructions on implementation: 

1. Use the setActiveTaskAndSubTask() command to set the type of measurement you want to start (e.g. for resonant zStack, use 'resonant' and 'zStack' parameters) 
2. Optionally, you can set measurement duration for the selected task and sub task by calling setMesurementDuration() command. (In case of Z-stack, measurement duration can't be set, it is calculated)
3. Use getAcquisitionState() command and check the 'activeTask' and 'measurementMode' fields in the appropriate json object
4. You can set the measurement duration with the setMeasurementDuration() command. 
5. call the appropriate start measurement (or measurement snap) command
6. poll the microscope state by calling getMicroscopeState() , if it has 'Working' state, the measurement is running properly.
7. In case of snap or finite duration measurement, it will stop automatically, otherwise, you must call the stop command. When it has stopped, microscope state will show 'Ready'.
8. After the measurement is done, you will need the runtime unique index of current measurement unit. You can get this information by calling the getProcessingState() command. The returned json will tell you the current measurement session's runtime index, and meta informations about measurements. The measurement unit with the greatest index is the last measurement's unit. 
9. By composing measurement unit runtime unique index and channel index, you can pass this as input to read channel data commands.

# Tile scan measurement

This type of measurement can be implemented by doing 9 measurements in different stage positions. Every "tile" will be in a measurement unit and could be commented as 1x1, 1x2, 1x3 and so on. They can be packed in a measurement group.

You will need the following input parameters: 

* resonant/galvo scanner parameters
* type of measurement: z-Stack or time series frame 
* number of tiles
* size of the viewport
* overlapping between tiles

  


Needed FemtoAPI commands: 

* API2-A-1448161794 
* API2-A-1448161792 
* API2-A-1448161790 
* API2-A-1448161795 
* API2-A-1448161786 
* setActiveTaskAndSubTask()(API2-A-1448161797) (optionally) 
* setMeasurementDuration()(API2-A-1448161799) (optionally) 

  


Instructions on implementation: 

1. Setup the measurement: set imaging window parameters, measurement type with setActiveTaskAndSubTask() command,   
   set device intensities, measurement duration, etc. 
2. As described above, start the measurement
3. when measurement has ended, move the stage(s) with setAxisPosition() command,   
   and check whether the axis movement is done by calling isAxisMoving() in a loop.
4. If axis has moved to the requested position, repeat 2-3 until the number of tiles 
