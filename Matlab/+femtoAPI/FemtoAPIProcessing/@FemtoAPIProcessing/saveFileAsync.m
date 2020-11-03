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
%  mescapiObj.saveFileAsync()  -> saves current file
%  mescapiObj.saveFileAsync(73)  -> saves file with handle 73
%  
%  TODO remove these? 
%  mescapiObj.saveFileAsync([73 1]) -> saves file with handle 73
%  mescapiObj.saveFileAsync([73,1,10]) -> saves file with handle 73, if 
%  10 is the last measurement handle of session [73,1], otherwise throws an
%  error

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
    succeeded{1} = changeEncoding(succeeded{1},obj.m_usedEncoding);
    succeeded = jsondecode(succeeded{1});
else
    % call with no parameters
    succeeded = femtoAPI('command',strcat('FemtoAPIFile.saveFileAsync()'));
    succeeded{1} = changeEncoding(succeeded{1},obj.m_usedEncoding);
    succeeded = jsondecode(succeeded{1});
end


end

