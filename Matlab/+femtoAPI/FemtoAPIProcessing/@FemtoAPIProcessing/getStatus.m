function [status] = getStatus(obj,varargin)
%GETSTATUS Gets status of all open files or a specified command
% This function is used to obtain information about open files in the
% server program's GUI, or about the last issued command on a file. 
% 
% If called without parameters, it returns a struct, which contains status 
% information of all opened files in the server program, and file open 
% errors: 
%  - is there a pending operation on a file
%  - handle of the file
%  - file status string ('OK' means no file operation resulted in an error 
%     yet) 
%  - command id of the last file operation on a file
%  - last file operation error message on an opened file
%  - last file open error and command id, if there was any 
% 
% 
% INPUT [optional]: 
%  commandId:        id of an asynchrounous file operation
%
%
% Examples:
%  result = obj.closeFileNoSaveAsync() -> result contains the command id 
%  status = obj.getStatus(result.id) -> get status of all open file, and file
% opening errors
% 
%

q = char(39); % quote character
varargs = length(varargin);
if(varargs == 0)
    status = femtoAPI('command',strcat('FemtoAPIFile.getStatus()'));
elseif(varargs == 1)
    commandID = varargin{1};
    validateattributes(commandID,{'char'},{'row'});
    status = femtoAPI('command',strcat('FemtoAPIFile.getStatus(',q,commandID,q,')'));
else
    error('Too many input arguments.');
end
        
status{1} = changeEncoding(status{1},obj.m_usedEncoding);
status = jsondecode(status{1});
end

