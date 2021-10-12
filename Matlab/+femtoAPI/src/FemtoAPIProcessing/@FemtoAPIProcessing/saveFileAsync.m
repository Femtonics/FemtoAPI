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

function [ succeeded ] = saveFileAsync( obj, varargin )
%SAVEFILEASYNC Saves file asynchronously.
% It saves file given by its node descriptor. The parameter nodeDescriptor  
% must be a valid measurement file handle, 
% session handle, or measurement handle, but in the latter case, it must be
% only the last measurement in that session. Otherwise this function 
% throws an error, and the file is not saved. 
% This function returns with true immediately after the save operation has
% been successfully started on the server. 
%
% INPUTS (optional):
%  nodeDescriptor          handle of an opened measurement file, session, or  
%                          the last measurement of a session. If not given,
%                          current measurement file is considered.
% OUTPUT: 
%  succeeded               true, if the save operation has been started
%                          successfully
%                          false otherwise
%
% usage: saveFileAsync(obj) or 
%        saveFileAsync(obj, nodeDescriptor)
%
% Examples: 
%  femtoapiObj.saveFileAsync()  -> saves current file
%  femtoapiObj.saveFileAsync(73)  -> saves file with handle 73
%  
% See also SAVEFILEASASYNC

numArgs = length(varargin);
if numArgs > 1
    error('Too many input arguments! Usage: obj.saveFileAsync() or obj.saveFileAsync(nodeDescriptor)');
end

if numArgs == 1
    nodeDescriptor = varargin{1};
    validateattributes(nodeDescriptor,{'numeric'},{'vector','nonnegative','integer'});
    nodeDescriptor = reshape(nodeDescriptor,1,[]);
    
    nodeString = strcat(num2str(nodeDescriptor(1:end-1),'%d,'),num2str(nodeDescriptor(end)));
    q = char(39); % quote character
    succeeded = femtoAPI('command',strcat('FemtoAPIFile.saveFileAsync(',q,nodeString,q,')'));
    succeeded = jsondecode(succeeded{1});
else
    % call with no parameters
    succeeded = femtoAPI('command',strcat('FemtoAPIFile.saveFileAsync()'));
    succeeded = jsondecode(succeeded{1});
end


end

