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

function [ result ] = closeFileNoSaveAsync( obj, varargin )
%CLOSEFILENOSAVEASYNC Closes an already existing file without closing it.
%
% This function closes the file given by 'nodeDescriptor'.
% if the nodeDescriptor is sysntactically invalid, or no file with this
% node is opened on the server, this method gives an error message.
%
% If called without parameters, then the current file will be closed.
%
% It returns a struct that contains a command id, which can be used to
% monitor the asynchron file operation status (see getStatus() for
% details). The succeeded field is true means that the asynchronous command
% has been initated successfully. Otherwise, an error is returned.
%
% INPUTS [optional]:
%  fileHandle                integer number, unique descriptor (handle)
%                            of an open file in the server program.
%                            Default: current file
%
% OUTPUT:
%  result                struct that contains the following data:
%                          - id: (char array), the command id
%                          - succeeded: bool flag, means whether the synchronous
%                            part of the command ended successfully or not
% usage:
%   closeFileNoSaveAsync( obj, fileHandle ) -> closes with given
%   handle
%   or closeFileNoSaveAsync( obj ) -> closes current file
%
%  Examples:
%   obj.closeFileNoSaveAsync(43) -> closes file with handle 43, or gives
%   an error, if it does not exist
%
%   obj.closeFileNoSaveAsync() -> closes current file
%
%   See also closeFileAndSaveAsAsync()
%

numVarargs = length(varargin);
if numVarargs > 1
    error('Too many input arguments. Usage: obj.closeFileNoSaveAsync(nodeDescriptor)' );
end

% default argument
nodeString = '';

if numVarargs == 1
    validateattributes(varargin{1},{'numeric'},{'vector','nonnegative','integer'});
    nodeDescriptor = varargin{1};
    nodeDescriptor = reshape(nodeDescriptor,1,[]);
    nodeString = strcat(num2str(nodeDescriptor(1:end-1),'%d,'),num2str(nodeDescriptor(end)));
end

q = char(39); % quote character
result = femtoAPI('command',strcat('FemtoAPIFile.closeFileNoSaveAsync(',q,nodeString,q,')'));
result = jsondecode(result{1});

end
