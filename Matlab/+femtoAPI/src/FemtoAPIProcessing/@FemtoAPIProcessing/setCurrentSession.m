function [ succeeded ] = setCurrentSession(obj, nodeDescriptor)
%SETCURRENTFILE Sets the current file in the MESc GUI.
% Sets current file based on the file or measurement session handle. 
% The input parameter 'nodeDescriptor' must be a handle of an opened .mesc
% file or the last measurement session within a file. 
% 
%
% INPUT: 
%  nodeDescriptor      row/column numeric array, handle of an opened .mesc 
%                      file, or the last measurement session within a file,
%                      which is not a background session
% 
% OUTPUT: 
%  succeeded           true, if current file was successfully set
%                      false if the input is incorrect, or the file is 
%                            being closed 
% Examples: 
%  obj.setCurrentSession(34)
%  obj.setCurrentSession([23,2]) -> [23,2] must be the last session in the
%                                file
%
% See also GETCURRENTSESSION CREATENEWFILE
%

validateattributes(nodeDescriptor,{'numeric'},{'vector','nonnegative','integer'});
succeeded = obj.femtoAPIMexWrapper('FemtoAPIFile.setCurrentSession',nodeDescriptor);
succeeded = jsondecode(succeeded);

end

