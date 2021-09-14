function succeeded = setPMTAndLaserIntensityDeviceValues(obj,deviceValues)
%SETPMTANDLASERINTENSITYDEVICEVALUES Sets PMT/Laser intensity device values
% Sets PMT and LaserIntensity device values (Imageing devices sliders in 
% the server's GUI) according to the given values. 
% 
% You can inspect the minimum/maximum values before setting a value of a
% device with 
% INPUT: 
%  deviceValues          DeviceValues object, which contains the values  
%                        of devices wanted to set
%
% Usage: 
%  get device values from server: 
%   deviceValuesObj = obj.getPMTAndLaserIntesityDeviceValues(); 
%  
%  set device values locally 
%   deviceNames = deviceValuesObj.getDeviceNames() 
%
%  inspect min/max values to get know the lower/upper limits that can be
%  set for that device
%   lowerLimit = deviceValuesObj.getDevicePropertyByName(deviceNames{1},'min');
%   upperLimit = deviceValuesObj.getDevicePropertyByName(deviceNames{1},'max');
%
%   deviceValuesObj.setDeviceValueByName(deviceNames{1},10);
%   
%  send data to server and set device values: 
%  obj.setPMTAndLaserIntensityDeviceValues(deviceValuesObj);
%  
% See also DEVICEVALUES GETPMTANDLASERINTENSITYDEVICEVALUES
%
    validateattributes(deviceValues,{'DeviceValues'},{'scalar'});
    deviceValues = jsonencode(deviceValues.getDeviceValuesCellArray());
    q = char(39); % quote character

    succeeded = femtoAPI('command', ...
        strcat('FemtoAPIMicroscope.setPMTAndLaserIntensityDeviceValues(',q, ...
        deviceValues,q,')'));
    succeeded{1} = changeEncoding(succeeded{1},'UTF-8');
    succeeded = jsondecode(succeeded{1});
end

