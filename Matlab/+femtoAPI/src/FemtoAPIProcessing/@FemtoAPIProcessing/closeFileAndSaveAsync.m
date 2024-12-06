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

function [ result ] = closeFileAndSaveAsync( obj, varargin )
%CLOSEFILEANDSAVEASYNC Saves an already existing file then closes it.
% This function first saves file given by nodeDescriptor, then closes it. 
% If the nodeDescriptor is sysntactically invalid, or no file with this 
% node is opened on the server, this method gives an error message.
% If is not given, current file will be saved and closed. 
%
% If the file with the given node exists, but it is new, it will be not
% be saved, and an error message is returned. 
% It is possible to enable compression in file saving, by setting 
% compressFileIfPossible flag to true. By default, compression is
% disabled. 
%
% It returns a struct that contains a command id, which can be used to
% monitor the asynchron file operation status (see getStatus() for
% details). The succeeded field is true means that the asynchronous command
% has been initated successfully. Otherwise, an error is returned.
%
% INPUTS [OPTIONAL]: 
%  fileHandle                integer number, unique descriptor (handle) 
%                            of an open file in the server program. 
%                            Default: current file
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
% usage: 
%   closeFileAndSaveAsync( obj, nodeDescriptor, compressFileIfPossible )
%   or closeFileAndSaveAsync( obj, nodeDescriptor ) -> no compression
%   or closeFileAndSaveAsync( obj ) -> current file is closed and saved,
%   without compression 
%   
%
% See also CLOSEFILEANDSAVEASASYNC CLOSEFILENOSAVEASYNC GETSTAUS 
%

numVarargs = length(varargin);
if numVarargs > 2
    error('Too many input arguments. Usage: closeFileAndSaveAsync( obj, nodeDescriptor, compressFileIfPossible ) ');
end


% default arguments
fileNodeDescriptor = '';
compressFileIfPossible = false;

if numVarargs >= 1
    validateattributes(varargin{1},{'numeric'},{'vector','nonnegative','integer'});
    fileNodeDescriptor = varargin{1};
end

if numVarargs == 2
    validateattributes(varargin{2},{'logical'},{'scalar'});
    compressFileIfPossible = varargin{2};
end

result = obj.femtoAPIMexWrapper('FemtoAPIFile.closeFileAndSaveAsync', fileNodeDescriptor, ...
    compressFileIfPossible);
result = jsondecode(result{1});

end
