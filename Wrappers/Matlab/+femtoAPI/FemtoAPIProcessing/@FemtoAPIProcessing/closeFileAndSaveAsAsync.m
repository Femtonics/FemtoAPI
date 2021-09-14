function [ result ] = closeFileAndSaveAsAsync( obj, newAbsolutePath, varargin )
%CLOSEFILEANDSAVEASASYNC Close file and save as asynchronously.
% This function closes file and saves it to the given path, if possible. 
% If overwriteExistingfile
% 
% It returns a struct that contains a command id, which can be used to
% monitor the asynchron file operation status (see getStatus() for
% details). The succeeded field is true means that the asynchronous command
% has been initated successfully. Otherwise, an error is returned.
%   
% INPUTS [required]: 
%  newAbsolutePath       char array, the new absolute path where the file
%                        is saved on the server before closing it 
%
% INPUTS [optional]: 
%  fileHandle                integer number, handle of an open file in
%                            the server program. Default: current file
% 
%  overWriteExistingFile     bool, if true, then if a file on given path 
%                            exists, it will be overwritten. Default: false
%
%  compressFileIfPossible    bool, if true, server tries to compress the  
%                            file when saving if possible. Default: false
% 
% OUTPUT: 
%  result                struct that contains the following data:
%                          - id: (char array), the command id 
%                          - succeeded: bool flag, means whether the synchronous 
%                            part of the command ended successfully or not 
%
% Usage: 
%     closeFileAndSaveAsync( obj, newAbsolutePath )
%          -> current file is saved and closed, overwriting existing file 
%             is not allowed, no compression
%
%     or closeFileAndSaveAsync( obj, newAbsolutePath, fileHandle)
%          -> file with handle is saved and closed, overwriting 
%             existing file is not allowed, no compression
%
%     or closeFileAndSaveAsync( obj, newAbsolutePath, fileHandle, 
%         overWriteExistingFile )  
%           -> file with handle is saved and closed, may overwrite existing
%              file, no compression
%
%     or closeFileAndSaveAsync( obj, newAbsolutePath, 
%         nodeDescriptor, overWriteExistingFile, compressFileIfPossible )
%          -> overwrite existing file and compressIfPossible can be set
%
%
%
% See also CLOSEFILENOSAVEASYNC CLOSEFILEANDSAVEASYNC GETSTATUS

numVarargs = length(varargin);
if numVarargs > 3
    error(['Too many input arguments. ',... 
        'Usage: obj.closeFileAndSaveAsync( newAbsolutePath, nodeDescriptor',... 
         'overWriteExistingFile, compressFileIfPossible )']);
end

validateattributes(newAbsolutePath,{'char'},{'nonempty','row'});

% default arguments
overWriteExistingFile = false;
nodeString = '';
compressFileIfPossible = false;

if numVarargs >= 1    
    validateattributes(varargin{1},{'numeric'},{'vector','nonnegative','integer'});
    nodeDescriptor = varargin{1};
    nodeDescriptor = reshape(nodeDescriptor,1,[]);
    nodeString = strcat(num2str(nodeDescriptor(1:end-1),'%d,'),num2str(nodeDescriptor(end)));    
end

if numVarargs >= 2
   validateattributes(varargin{2},{'logical'},{'scalar'});
   overWriteExistingFile = varargin{2};
end

if numVarargs == 3
    validateattributes(varargin{3},{'logical'},{'scalar'});
    compressFileIfPossible = varargin{3};
end


q = char(39); % quote character
result = femtoAPI('command',strcat('FemtoAPIFile.closeFileAndSaveAsAsync(',q,newAbsolutePath,q,',',...
    ',',q,nodeString,q,',',num2str(overWriteExistingFile),num2str(compressFileIfPossible),')'));

result{1} = changeEncoding(result{1},obj.m_usedEncoding);
result = jsondecode(result{1});


end
