# Tutorial: using the FemtoAPI Matlab client
  


The Matlab client wraps the FemtoAPI library's functionality, and makes it easy to use from Matlab. It uses two main classes: FemtoAPIProcessing and FemtoAPIAcquisition.

**FemtoAPIProcessing class:** used for measurement processing purposes, such as file operations (read, write, create new file, or measurement unit, set current file, etc.), getting the processing state (metadata found on the processing panel of the MESc GUI) or the setting part of the processing state (e.g. comment of measurement session/group/unit, channel conversion and LUT), etc.

You can find the list of callable functions in the  FemtoAPI command reference(API2-A-1448161785), under 'FemtoAPIFile namespace'. 

  


**FemtoAPIAcquisition class**: used for measurement acquisition purposes, such as starting/stopping galvo/resonant measurements, getting/setting values of PMT and Laser intensity devices, objective positions, the viewport, getting the acquisition state (metadata found on the acquisition panel of the MESc GUI), etc. 

You can find the list of callable functions in the  FemtoAPI command reference(API2-A-1448161785), under 'FemtoAPIMicroscope namespace'. 

  


**Important notes**: 

* if you create FemtoAPIProcessing and FemtoAPIAcquisition objects, they will use the same FemtoAPI connection (only one FemtoAPI connection is created). 
* you have to explicitly call *femtoapiObj.disconnect()* in the end of your script, when you ended up using FemtoAPI commands, but before clearing these objects

  


*Note*: Due to practical reasons, not all functions in the command reference are available in the Matlab client. 

# Connecting to the server 

A connection to the server can be established by creating a FemtoAPIProcessing or a FemtoAPIAcquisition object. 

```matlab
% Creating FemtoAPIProcessing object with no parameters, connects to the local MESc server through websocket, logs in with predefined username and password, and gets the processing state
femtoapiObj1 = FemtoAPIProcessing(); % or FemtoAPIProcessing('ws://localhost:8888') 

% Connecting to server with ip 192.168.80.19 and port 8888
femtoapiObj2 = FemtoAPIProcessing('ws://192.168.80.19:8888');

% The above operations, with FemtoAPIAcquisition object, are done with the same syntax:
femtoapiObj3 = FemtoAPIAcquisition(); % or FemtoAPIAcquisition('ws://localhost:8888') 

femtoapiObj4 = FemtoAPIAcquisition('ws://192.168.80.19:8888'); 
```

If an error occurs during connection or login, an error message is thrown, and the object is not created. 

# Command example: get and set channel conversion 

Depending on the command intended to run, the FemtoAPIProcessing or the FemtoAPIAcquisition class must be instantiated. 

```matlab
% Connect to server with ip 192.168.80.10 (FemtoAPI uses port 8888). If connection and login is successful,
% femtoapiObj is created, and processing state is updated. Otherwise an error is thrown. 
femtoapiObj = FemtoAPIProcessing('ws://192.168.80.10:8888');

% if processing state has changed on the server, it can be updated by calling the getProcessingState() command.
femtoapiObj.getProcessingState();

% get the processing state member, it contains the whole processing state structure (should be called after getProcessingState() to get the most recent state)
processingState = femtoapiObj.m_processingState;

% get copy of channel conversion struct, where channel handle (unique id, can be optained from the MESc GUI) of the channel is [52,0,0,0]. 
% This means, that the channel is within the measurement unit with handle [52,0,0], and its index is 0. It must be an id of an already opened measurement unit in the MESc GUI, 
% which must have channel with index 0, otherwise this function will give an error, that no such measurement unit exists. 
channelConv = femtoapiObj.getMeasurementMetaDataField([52,0,0,0],'conversion');

% change conversion
channelConv.offset = 10.0;
channelConv.scale = 2.0;

% set new channel conversion struct locally 
femtoapiObj.setMeasurementMetaDataField([52,0,0,0],'conversion',channelConv);

% send processing state changes to the server by calling setProcessingState() command
succeeded = femtoapiObj.setProcessingState();
```

  


# Disconnecting/reconnecting from/to the server 

```matlab
% connect to local server
femtoapiObj = FemtoAPIProcessing();

% check connection status with isConnected() method. It must be 1, if connected, and 0, if disconnected from server.
isConnected = femtoapiObj.isConnected();

% disconnect - must be called before destroying the object
femtoapiObj.disconnect();

% After disconnect, femtoapiObj is not destroyed, but if calling some command that would communicate to the server, it will give an error
femtoapiObj.getProcessingState(); % will give an error

% But, after reconnect, it works as usual
femtoapiObj.connect();
femtoapiObj.getProcessingState(); % now it works

```

  


  


  
