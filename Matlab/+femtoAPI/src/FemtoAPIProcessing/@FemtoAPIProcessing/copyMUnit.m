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

function [result] = copyMUnit(obj, sourceMImageHandle, destMItemHandle, varargin)
%COPYMUNIT Copies the source measurement image to the requested session/group.
% The destination session/group can be the same where the source image is,
% or in an other file.
% If the source or destination handle is invalid, or there is another
% file operation in progress on the files in question, an error is thrown.
%
% INPUTS [required]:
%  sourceMImageHandle       numeric array, source measurement image handle
%
%  destMItemHandle          numeric array, measurement session or group
%                           handle, where the source image to copy to
%
% INPUTS [optional]:
%  bCopyChannelContents     if true, the contents of channels in the
%                           source measurement image will be copied too.
%                           Default: false
%
% OUTPUT:
%   result                  struct, it contains the following values:
%                            - id: (char array), the command id
%                            - succeeded: bool flag, means whether the
%                              synchronous part of the command ended
%                              successfully or not
%                            - copiedMUnitIdx: handle of the new MUnit,
%                              where the soure image is copied to
% Examples:
%  - copy MUnit with channel contents to the same session:
%    result = obj.copyMUnit([34,0,1], [34,0], true)
%
%  - copy MUnit without channel contents,
%    result = obj.copyMUnit([97,0,0],[98,0])
%
% See also MOVEMUNIT CREATEMUNIT DELETEMUNIT
%
if nargin > 4
    error('Too many input arguments.');
elseif nargin == 4
    validateattributes(varargin{1},{'logical'},{'scalar'}, mfilename, 'bCopyChannelContents');
    bCopyChannelContents = varargin{1};
elseif nargin == 3
    bCopyChannelContents = false;
else
    error('Too few input arguments');
end

validateattributes(sourceMImageHandle,{'numeric'},{'vector','nonnegative','integer'},mfilename,'sourceMImageHandle');
validateattributes(destMItemHandle,{'numeric'},{'vector','nonnegative','integer'},mfilename, 'destMItemHandle');

sourceMImageHandle = reshape(sourceMImageHandle,1,[]);
destMItemHandle = reshape(destMItemHandle,1,[]);

q = char(39); % quote character
sSourceMImageHandle = strcat(q,num2str(sourceMImageHandle(1:end-1),'%d,'),num2str(sourceMImageHandle(end),'%d'''));
sDestMItemHandle = strcat(q,num2str(destMItemHandle(1:end-1),'%d,'),num2str(destMItemHandle(end),'%d'''));

result = femtoAPI('command',strcat('FemtoAPIFile.copyMUnit(', ...
    sSourceMImageHandle,',', sDestMItemHandle,',', ...
    num2str(bCopyChannelContents),')'));
result = jsondecode(result{1});
result.copiedMUnitIdx = str2num(result.copiedMUnitIdx);

end

