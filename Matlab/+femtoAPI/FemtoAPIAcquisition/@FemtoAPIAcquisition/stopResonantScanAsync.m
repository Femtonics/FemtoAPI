function isStopped = stopResonantScanAsync(obj)
%STOPRESONANTSCANASYNC Stops Resonant XY scan measurement asynchronously.
%  It returns 'false' if the command has failed to execute and the
%  measurement has not stopped correctly. Due to the asynchron call, 
%  if it returns 'true', it only means that the stop command has been 
%  sent correctly, but it does not check whether the measurement has really
%  stopped. To make certain about this, the microscope state should be
%  polled with the getAcquisitionState() command. 
%
% OUTPUT: 
%  isStopped  - false: failed to stop measurement
%               true:  measurment stop command has been sent correctly, 
%                but does not mean that it has really stopped. 
%
% See also GETMICROSCOPESTATE
%
    isStopped = femtoAPI('command','FemtoAPIMicroscope.stopResonantScanAsync()');
    isStopped{1} = changeEncoding(isStopped{1},obj.m_usedEncoding);
    isStopped = jsondecode(isStopped{1});
end
