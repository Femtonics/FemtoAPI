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

function [result] = moveMUnit(obj, sourceMImageHandle, destMItemHandle)
%MOVEMUNIT Moves the source measurement image to the requested session/group.
% The destination session/group can be the same where the source image is,
% or in an other file.
% If the source or destination handle is invalid, or there is another
% file operation in progress on the files in question, an error is thrown.
% Channel contents are moved too.
%
% INPUTS [required]:
%  sourceMImageHandle       numeric array, source measurement image handle
%
%  destMItemHandle          numeric array, measurement session or group
%                           handle, where the source image to copy to
%
% OUTPUT:
%   result                  struct, it contains the following values:
%                            - id: (char array), the command id
%                            - succeeded: bool flag, means whether the
%                              synchronous part of the command ended
%                              successfully or not
%                            - movedParameters: struct, contains 
%                              the image role - handle pairs of the moved 
%                              measurement and linked images.
%
% Examples:
%  - move MUnit within the same session:
%    result = obj.moveMUnit([34,0,1], [34,0])
%
%  - move MUnit to another session (which can be in an other file, too):
%    result = obj.moveMUnit([34,0,1], [40,1])
%
% See also COPYMUNIT CREATEMUNIT DELETEMUNIT
%

validateattributes(sourceMImageHandle,{'numeric'},{'vector','nonnegative','integer'},mfilename,'sourceMUnitHandle');
validateattributes(destMItemHandle,{'numeric'},{'vector','nonnegative','integer'},mfilename, 'destMItemHandle');

result = obj.femtoAPIMexWrapper('FemtoAPIFile.moveMUnit',sourceMImageHandle, destMItemHandle);
result = jsondecode(result);

fnames = fieldnames(result.movedParameters);
for i = 1:length(fnames)
    result.movedParameters.(fnames{i}) = str2num(result.movedParameters.(fnames{i}));
end

end

