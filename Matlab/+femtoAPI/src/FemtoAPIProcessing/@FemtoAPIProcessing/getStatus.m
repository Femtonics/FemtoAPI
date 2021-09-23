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
% OUTPUT: 
%  status:           struct, if method called with commandID, then it 
%                     contains the following fields: 
%                     
% 
% Examples:
%  result = obj.closeFileNoSaveAsync() -> result contains the command id 
%  status = obj.getStatus(result.id) -> get status of all open file, and file
%                                       opening errors
% 
%  status = obj.getStatus() -> get status of all open files 
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
        
status = jsondecode(status{1});

end

