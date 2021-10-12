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
result = jsondecode(result{1});


end
