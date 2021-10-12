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

function [ succeeded ] = setComment( obj, handle, newComment )
%SETCOMMENT Sets comment of the given measurement session/unit/group
% Sets comment on the server, if the given handle is valid.
%
% INPUTS:
%  handle        numeric array, must be a session/unit/group unique descriptor
%
%  newComment    char array, the new comment wanted to be set
%
% OUTPUT:
%  succeeded     true if comment was successfully set,
%                false otherwise
%
% Examples:
%  obj.setComment([55,0],'session comment')
%  obj.setComment([55,0,1],'measurement unit comment')
%

validateattributes(handle,{'numeric'},{'nonempty','vector','integer','nonnegative'},...
    mfilename, 'handle');
validateattributes(newComment,{'char'},{'row'},...
    mfilename, 'comment');

handle = reshape(handle,1,[]);
handleStr = strcat(num2str(handle(1:end-1),'%d,'),num2str(handle(end)));
dataToSend = char(strcat('{"handle"',' : ','"',handleStr,'", ','"comment"',' : ','"',string(newComment),'"}'));
try
    succeeded = obj.setProcessingState(dataToSend);
catch ME
    disp(ME.message)
    succeeded = false;
end

end

