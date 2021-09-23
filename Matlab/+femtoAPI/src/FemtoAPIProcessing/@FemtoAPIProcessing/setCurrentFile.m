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
succeeded = jsondecode(succeeded{1});

end

