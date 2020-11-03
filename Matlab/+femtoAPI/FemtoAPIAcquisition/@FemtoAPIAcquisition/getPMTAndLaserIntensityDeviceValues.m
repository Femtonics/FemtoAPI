function [ deviceValues ] = getPMTAndLaserIntensityDeviceValues( obj )
%GETPMTANDLASERINTENSITYDEVICEVALUES Gets PMT/Laser device parameters.
% Gets PMT and LaserIntensity device values (Imaging devices sliders in 
% the MESc GUI) from server, parses into a DeviceValues object. 
%
% Device values struct array can be acquired by DeviceValues object, and
% contains the following: 
%  - min: the lower limit of device value  
%  - max: the upper limit of device value 
%  - name: char array, name of the device
%  - value: current value of the device 
%  - space: space for the device is configured 
%
% OUTPUT: 
%  deviceValues          DeviceValues object, which contains the values  
%                        of devices wanted to set
%
% Usage: 
%  get device values from server: 
%   deviceValuesObj = obj.getPMTAndLaserIntesityDeviceValues(); 
%  
%  set device values locally 
%   deviceNames = deviceValuesObj.getDeviceNames() 
%   deviceValuesObj.setDeviceValueByName(deviceNames{1},10);
%   
%  send data to server and set device values: 
%  obj.setPMTAndLaserIntensityDeviceValues(deviceValuesObj);
%  
% See also DEVICEVALUES GETPMTANDLASERINTENSITYDEVICEVALUES
%
    deviceValues = femtoAPI('command',strcat('FemtoAPIMicroscope.getPMTAndLaserIntensityDeviceValues()'));
    deviceValues{1} = changeEncoding(deviceValues{1},obj.m_usedEncoding);
    deviceValues = jsondecode(deviceValues{1});
    if(isempty(deviceValues))
        warning('No devices get from server');
        return;
    end

    deviceValues = DeviceValues(deviceValues);
end



