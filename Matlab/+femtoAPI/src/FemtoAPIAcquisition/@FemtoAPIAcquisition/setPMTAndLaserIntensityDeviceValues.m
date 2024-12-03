% Copyright ©2021. Femtonics Ltd. (Femtonics). All Rights Reserved.
% Permission to use, copy, modify this software and its documentation for
% educational, research, and not-for-profit purposes, without fee and
% without a signed licensing agreement, is hereby granted, provided that
% the above copyright notice, this paragraph and the following two
% paragraphs appear in all copies, modifications, and distributions.
% Contact info@femtonics.eu for commercial licensing opportunities.
% 
% IN NO EVENT SHALL FEMTONICS BE LIABLE TO ANY PARTY FOR DIRECT, INDIRECT,
% SPECIAL, INCIDENTAL, OR CONSEQUENTIAL DAMAGES, INCLUDING LOST PROFITS,
% ARISING OUT OF THE USE OF THIS SOFTWARE AND ITS DOCUMENTATION, EVEN IF
% FEMTONICS HAS BEEN ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
% 
% FEMTONICS SPECIFICALLY DISCLAIMS ANY WARRANTIES, INCLUDING, BUT NOT
% LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A
% PARTICULAR PURPOSE. THE SOFTWARE AND ACCOMPANYING DOCUMENTATION, IF ANY,
% PROVIDED HEREUNDER IS PROVIDED "AS IS". FEMTONICS HAS NO OBLIGATION TO
% PROVIDE MAINTENANCE, SUPPORT, UPDATES, ENHANCEMENTS, OR MODIFICATIONS.

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
succeeded = obj.femtoAPIMexWrapper('FemtoAPIMicroscope.setPMTAndLaserIntensityDeviceValues', ...
    deviceValues);
succeeded = jsondecode(succeeded);

end

