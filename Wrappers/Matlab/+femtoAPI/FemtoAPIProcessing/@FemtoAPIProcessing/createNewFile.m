function [ result ] = createNewFile(obj)
%CREATENEWFILE Cretes a new MESc File in the MESc GUI
% 
% OUTPUT: 
%   result     struct, it contains the following values: 
%                - id: (char array), the command id 
%                - succeeded: bool flag, means whether the synchronous 
%                   part of the command ended successfully or not
% 
% Usage: 
%   obj.createNewFile()
% 
% See also getStatus
% 
result = femtoAPI('command','FemtoAPIFile.createNewFile()');
result{1} = changeEncoding(result{1},obj.m_usedEncoding);
result = jsondecode(result{1});
end

