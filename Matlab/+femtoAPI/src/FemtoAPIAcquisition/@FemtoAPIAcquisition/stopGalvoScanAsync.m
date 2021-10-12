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

function isStopped = stopGalvoScanAsync(obj)
%STOPGALVOSCANASYNC Stops Galvo XY scan measurement asynchronously.
%  It returns 'false' if the command has failed to execute and the
%  measurement has not stopped correctly. Due to the asynchron call, 
%  if it returns 'true', it only means that the stop command has been 
%  sent correctly, but it does not check whether the measurement has really
%  stopped. To make certain about this, the microscope state should be
%  polled with the getMicroscopeState() command. 
%
% OUTPUT: 
%  isStopped  - false: failed to stop measurement
%               true:  measurment stop command has been sent correctly, 
%                but does not mean that it has really stopped. 
%
% See also GETMICROSCOPESTATE
%
    isStopped = femtoAPI('command','FemtoAPIMicroscope.stopGalvoScanAsync()');
    isStopped = jsondecode(isStopped{1});
end
