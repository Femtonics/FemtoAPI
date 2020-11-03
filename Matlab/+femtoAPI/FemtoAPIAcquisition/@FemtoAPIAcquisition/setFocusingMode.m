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
    succeeded{1} = changeEncoding(succeeded{1},obj.m_usedEncoding);
    succeeded = jsondecode(succeeded{1});
end

