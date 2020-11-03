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
    result{1} = changeEncoding(result{1},'UTF-8');
    result = jsondecode(result{1});
    microscopeState = FemtoAPIMicroscope.tate.fromString(result.microscopeState);
    lastMeasurementError = result.lastMeasurementError;
    result = struct('microscopeState', microscopeState, 'lastMeasurementError', ...
        lastMeasurementError);

end

