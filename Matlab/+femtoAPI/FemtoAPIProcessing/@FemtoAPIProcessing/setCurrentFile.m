function [ succeeded ] = setCurrentFile(obj, nodeDescriptor)
%SETCURRENTFILE Sets the current file in the MESc GUI.
% Sets current file based on the file or measurement session handle. 
% The input parameter 'nodeDescriptor' must be a handle of an opened .mesc
% file or the last measurement session within a file. 
% 
%
% INPUT: 
%  nodeDescriptor      row/column numeric array, handle of an opened .mesc 
%                      file, or the last measurement session within a file
% 
% OUTPUT: 
%  succeeded           true, if current file was successfully set
%                      false if the input is incorrect, or the file is 
%                            being closed 
% Examples: 
%  obj.setCurrentFile(34)
%  obj.setCurrentFile([23,2]) -> [23,2] must be the last session in the
%                                file
%
% See also CREATENEWFILE
%
validateattributes(nodeDescriptor,{'numeric'},{'vector','nonnegative','integer'});

nodeDescriptor = reshape(nodeDescriptor,1,[]);
nodeString = strcat(num2str(nodeDescriptor(1:end-1),'%d,'),num2str(nodeDescriptor(end)));

succeeded = femtoAPI('command',strcat('FemtoAPIFile.setCurrentFile(',nodeString,')'));
succeeded{1} = changeEncoding(succeeded{1},obj.m_usedEncoding);
succeeded = jsondecode(succeeded{1});
end

