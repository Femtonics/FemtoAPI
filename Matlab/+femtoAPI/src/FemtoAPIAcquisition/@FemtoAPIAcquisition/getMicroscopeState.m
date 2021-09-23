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

function result = getMicroscopeState( obj )
%GETMICROSCOPESTATE Gets the microscope state and last measurement error.
% Returns a struct containing the microscope state and the last
% measurement error, if there was any. If no error has happened at the time
% when this command was issued, lastMeasurementError is an empty char. 
%
% Possible values of 'microscopeState': 
%    "Off" - FemtoAPIMicroscope.hardware is turned off 
%    "Initializing" - FemtoAPIMicroscope.hardware initialization is in progress 
%    "Ready" - FemtoAPIMicroscope.hardware is ready for starting measurement 
%    "Working" -  Measurement is in progress  
%    "In an invalid state" - Error condition (e.g. microscope hardware error)  
%
% OUTPUT: 
%  result              struct, containing the following fields: 
%                       - microscopeState: the state of microscope hardware  
%                         as an enumeration
%                       - lastMeasurementError: char array 
%
% See also GETACQUISITIONSTATE
%
    result = femtoAPI('command','FemtoAPIMicroscope.getMicroscopeState()');
    result = jsondecode(result{1});
    microscopeState = MicroscopeState.fromString(result.microscopeState);
    lastMeasurementError = result.lastMeasurementError;
    result = struct('microscopeState', microscopeState, 'lastMeasurementError', ...
        lastMeasurementError);

end

