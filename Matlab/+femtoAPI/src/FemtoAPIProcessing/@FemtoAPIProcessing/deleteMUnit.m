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

function result = deleteMUnit(obj,mUniHandle)
%DELETEMUNIT Deletes a measurement unit from server program's GUI.
% Deletes measurement unit given by 'mUnitHandle'.
% It is an asynchronous operation.
% If the given input is in wrong format, or points to a non-existent
% measurement unit, or another asynchronous operation is pending on the file,
% it gives an error.
%
% INPUT:
%  mUnitHandle       numeric array, the measurement unit uniqe identifier
%                    (handle), e.g. [34,0,0]
%
% OUTPUT:
%   result           struct, it contains the following values:
%                     - id: (char array), the command id
%                     - succeeded: bool flag, means whether the synchronous
%                        part of the command ended successfully or not
%
% Example:
%  obj.deleteMUnit([23,0,0]);
%
% See also CREATEMUNIT
%

validateattributes(mUniHandle,{'numeric'},{'vector','nonnegative','integer'});
mUniHandle = reshape(mUniHandle,1,[]);
channelString = strcat(num2str(mUniHandle(1:end-1),'%d,'),num2str(mUniHandle(end)));

q = char(39); % quote character
result = femtoAPI('command',strcat('FemtoAPIFile.deleteMUnit(',q,channelString,q,')'));
result = jsondecode(result{1});
result.deletedMUnitIdx = str2num(result.deletedMUnitIdx);

end
