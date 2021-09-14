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
    result{1} = changeEncoding(result{1},obj.m_usedEncoding);
    result = jsondecode(result{1});
    result.deletedMUnitIdx = str2num(result.deletedMUnitIdx);

end
