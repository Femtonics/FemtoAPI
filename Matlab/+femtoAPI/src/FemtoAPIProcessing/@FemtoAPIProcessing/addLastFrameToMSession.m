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

function result = addLastFrameToMSession(obj, destMSessionHandle, spaceName)
%ADDLASTFRAMETOMSESSION Adds measurement snap image to the given session.
% Creates a new measurement unit in the given measurement session, and adds
% the frame on the immediate window (last frame of a measurement/live or 
% snap) to it. Last frame is considered as the frame of immediate window 
% of the space given by 'spaceName', or from the default space if 
% 'spaceName' is empty. 
% 
% Note that this is a synchronous operation, which means that it waits until 
% the new measurement unit is created and the immediate image is added to
% it. 
% 
% INPUTS: 
%  destMSessionHandle           - vector, handle of the measurement session
%                                 which will contain the snap image in the 
%                                 added MUnit. If empty, current session is
%                                 considered. 
%
%  spaceName                    - char array, name of the space to add 
%                                 immediate image from. If empty, default 
%                                 space is considered.  
%
% OUTPUT: 
%  result                       - vector, handle of the created MUnit 
%                                 containing the immediate image.         
%

 
validateattributes(destMSessionHandle,{'numeric'},{'vector','nonnegative', ...
    'integer'});
validateattributes(spaceName,{'char'},{'row'});

destMSessionHandle = reshape(destMSessionHandle,1,[]);
strDestMSessionHandle = strcat(num2str(destMSessionHandle(1:end-1),'%d,'), ...
    num2str(destMSessionHandle(end)));

q = char(39); % quote character
result = femtoAPI('command',strcat('FemtoAPIFile.addLastFrameToMSession(',...
    q,strDestMSessionHandle,q,',',q,spaceName,q,')'));
result = jsondecode(result{1});

end

