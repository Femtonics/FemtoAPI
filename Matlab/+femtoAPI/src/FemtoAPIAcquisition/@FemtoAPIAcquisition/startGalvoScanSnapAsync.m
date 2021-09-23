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

function isStarted = startGalvoScanSnapAsync(obj)
%STARTGALVOSCANSNAPASYNC Starts Galvo XY scan snap.
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
    isStarted = femtoAPI('command','FemtoAPIMicroscope.startGalvoScanSnapAsync()');
    isStarted = jsondecode(isStarted{1});
end