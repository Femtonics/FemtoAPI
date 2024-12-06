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

function [ succeeded ] = saveFileAsAsync( obj, newAbsolutePath, varargin )
%SAVEFILEASASYNC Saves file to the path given by newAbsolutePath
%   Saves file to the given path 'newAbsolutePath'. Other parameters are
%   optional. The default behaviour, that it tries to save current file, 
%   and if a file exists on the given path, it does not overwirte it,
%   throws an error.
% 
% INPUTS [required]: 
%  newAbsolutePath         Char array, the absolute path (unicode) to save the file to
%  
% INPUTS [optional]: 
%  nodeDescriptor          Array of nonnegative integers, the unique index 
%                          (handle) of the file to save. 
%                          It can be an index of a file, or the last measurement
%                          session index in a file. Default is the current
%                          file index.
%
%  overwriteExistingFile   Bool, if set to true, file will be overwritten, 
%                          if it exists on the given absolute path.
%                          Default: false
%                       
% OUTPUT: 
%  succeeded               True if saving the file has started successfully,
%                          False if there has been error during save  
%
% Usage: 
%  saveFileAsAsync( obj, newAbsolutePath, nodeDescriptor, overWriteExistingFile )
%
% 
numVarargs = length(varargin);
if numVarargs > 2
    error(strcat('Too many input arguments! Usage: saveAsFileAsync(newAbsoluteFilePath',... 
    ',nodeString,overWriteExistingFile'));
end
if(isstring(newAbsolutePath))
    newAbsolutePath = char(newAbsolutePath);
else
    validateattributes(newAbsolutePath,{'char'},{'row'});
end

% default arguments
overWriteExistingFile = 0;
nodeDescriptor = [];

if numVarargs >= 1
    validateattributes(varargin{1},{'numeric'},{'vector','nonnegative','integer'});
    nodeDescriptor = varargin{1};
end
if numVarargs == 2    
    validateattributes(varargin{2},{'logical'},{'scalar'});
    overWriteExistingFile = varargin{2};
end

succeeded = obj.femtoAPIMexWrapper('FemtoAPIFile.saveFileAsAsync',newAbsolutePath, ...
    nodeDescriptor, overWriteExistingFile);
succeeded = jsondecode(succeeded);


end
