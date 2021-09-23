% Copyright ©2021. Femtonics Kft. (Femtonics). All Rights Reserved. 
% Permission to use, copy, modify this software and its documentation for educational,
% research, and not-for-profit purposes, without fee and without a signed licensing agreement, is 
% hereby granted, provided that the above copyright notice, this paragraph and the following two 
% paragraphs appear in all copies, modifications, and distributions. Contact info@femtonics.eu
% for commercial licensing opportunities.
% 
% IN NO EVENT SHALL FEMTONICS BE LIABLE TO ANY PARTY FOR DIRECT, INDIRECT, SPECIAL, 
% INCIDENTAL, OR CONSEQUENTIAL DAMAGES, INCLUDING LOST PROFITS, ARISING OUT OF 
% THE USE OF THIS SOFTWARE AND ITS DOCUMENTATION, EVEN IF FEMTONICS HAS BEEN 
% ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
% 
% FEMTONICS SPECIFICALLY DISCLAIMS ANY WARRANTIES, INCLUDING, BUT NOT LIMITED TO, 
% THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR 
% PURPOSE. THE SOFTWARE AND ACCOMPANYING DOCUMENTATION, IF ANY, PROVIDED 
% HEREUNDER IS PROVIDED "AS IS". FEMTONICS HAS NO OBLIGATION TO PROVIDE 
% MAINTENANCE, SUPPORT, UPDATES, ENHANCEMENTS, OR MODIFICATIONS.

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
    deviceValues = jsondecode(deviceValues{1});
    if(isempty(deviceValues))
        warning('No devices get from server');
        return;
    end

    deviceValues = DeviceValues(deviceValues);
end



