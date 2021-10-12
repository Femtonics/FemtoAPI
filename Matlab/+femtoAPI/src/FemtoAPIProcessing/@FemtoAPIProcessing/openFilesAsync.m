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

function result = openFilesAsync(obj,fileNames)
%OPENFILESASYNC Open files in the server program's GUI. 
% Open one or more files asynchronously in the server program.
% The full file path must be given as char array, separated with semicolon, 
% if more than one file wanted to be open.
%
% INPUT: 
%  fileNames          char array, full path to files to open, separated
%                     with ';'
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
%  obj.openFilesAsync({'C:/file1.mesc', 'C:/file2.mesc'});
%  
%  obj.openFilesAsync(["C:/file1.mesc"; "C:/file2.mesc"]);
%
%
% See also GETSTATUS  
fileNames = strrep(string(fileNames),'\','/');
fileNames = strjoin(fileNames,';');
q = char(39); % quote character 
result = femtoAPI('command',strcat('FemtoAPIFile.openFilesAsync(',q,char(fileNames),q,')'));
result = jsondecode(result{1});

end

