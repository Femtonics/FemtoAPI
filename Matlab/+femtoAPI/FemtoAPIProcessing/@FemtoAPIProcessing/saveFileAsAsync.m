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

validateattributes(newAbsolutePath,{'char'},{'row'});

% default arguments
overWriteExistingFile = 0;
nodeString = '';

if numVarargs >= 1
    validateattributes(varargin{2},{'numeric'},{'vector','nonnegative','integer'});
    nodeDescriptor = varargin{2};
    nodeDescriptor = reshape(nodeDescriptor,1,[]);
    nodeString = strcat(num2str(nodeDescriptor(1:end-1),'%d,'),num2str(nodeDescriptor(end)));
end
if numVarargs == 2    
    validateattributes(varargin{1},{'logical'},{'scalar'});
    overWriteExistingFile = varargin{1};
end

q = char(39); % quote character
succeeded = femtoAPI('command',strcat('FemtoAPIFile.saveFileAsAsync(',q,newAbsolutePath,q,',',...
    ',',q,nodeString,q,num2str(overWriteExistingFile),')'));
succeeded{1} = changeEncoding(succeeded{1},obj.m_usedEncoding);
succeeded = jsondecode(succeeded{1});


end
