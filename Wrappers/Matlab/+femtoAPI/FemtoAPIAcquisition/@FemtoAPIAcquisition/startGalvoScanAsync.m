function isStarted = startGalvoScanAsync(obj)
%STARTGALVOSCANASYNC Starts Galvo XY scan measurement asynchronously.
% This function only sends the start measurement command to the server 
% but does not check whether the measurement has really started on the
% server. This function returns a boolean value, if it is 'false', then the
% measurement start has failed, but 'true' just means that the command 
% was successfully sent to the server, but does not mean that the 
% measurement start was successful. If the user wants to know this, then
% the microscope state should be polled, with the method 
% getMicroscopeState().
%    
%
% OUTPUT: 
%  isStarted  -  false: error during measurement start
%                true: start measurement command was sent, but it does not
%                mean that the measurement has really started
%
% See GETMICROSCOPESTATE
%
    isStarted = femtoAPI('command','FemtoAPIMicroscope.startGalvoScanAsync()');
    isStarted{1} = changeEncoding(isStarted{1},obj.m_usedEncoding);
    isStarted = jsondecode(isStarted{1});
end