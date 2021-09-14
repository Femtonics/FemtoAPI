function result = openFilesAsync(obj,fileNames)
%OPENFILESASYNC Open files in the server program's GUI. 
% Open one or more files asynchronously in the server program.
% The full file path must be given as char array, separated with semicolon, 
% if more than one file wanted to be open.
%
% INPUT: 
%  fileNames          char array, full path to files to open
%
% OUTPUT: 
%  result                struct that contains the following data:
%                          - id: (char array), the command id 
%                          - succeeded: bool flag, means whether the synchronous 
%                            part of the command ended successfully or not 
%
% Examples: 
%  obj.openFilesAsync('C:/file1.mesc;C:/file2.mesc');
%
% See also GETSTATUS

q = char(39); % quote character 
result = femtoAPI('command',strcat('FemtoAPIFile.openFilesAsync(',q,fileNames,q,')'));
result{1} = changeEncoding(result{1},obj.m_usedEncoding);
result = jsondecode(result{1});
end

