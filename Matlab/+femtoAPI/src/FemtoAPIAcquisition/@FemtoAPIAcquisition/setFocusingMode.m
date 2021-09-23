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

function [ succeeded ] = setFocusingMode(obj, focusingMode, varargin)
%SETFOCUSINGMODE Sets focusing mode on the server's GUI. 
% The focusingMode must be one of the output of getFocusingModes(). 
%
% INPUTS [required]: 
%  focusingMode            char array, a valid focusing mode returned by
%                          getFocusingModes()
%
% INPUT [optional]:
%  spaceName               char array, space name 
%
% See also GETFOCUSINGMODES
%
    validateattributes(focusingMode, {'char'}, {'row','vector'}, ...
        mfilename, 'focusingMode');
    
    if nargin > 3 
        error('Too many input arguments');
    elseif nargin == 3
        validateattributes(varargin{1},{'char'},{'vector','row'} ...
            ,mfilename,'spaceName');
        spaceName = varargin{1};
    else 
        spaceName = '';
    end
    
    q = char(39); % quote character
    succeeded = femtoAPI('command', ...
        strcat('FemtoAPIMicroscope.setFocusingMode(',q,focusingMode,q,',', ...
        q,spaceName,q,')'));
    succeeded = jsondecode(succeeded{1});
end

