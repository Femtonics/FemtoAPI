function [ focusingModes ] = getFocusingModes(obj, varargin)
%GETFOCUSINGMODES Gets available focusing modes from server. 
% 
% See also SETFOCUSINGMODE
%
    if nargin > 2 
        error('Too many input arguments');
    elseif nargin == 2
        validateattributes(varargin{1},{'char'},{'vector','row'} ...
            ,mfilename,'spaceName');
        spaceName = varargin{1};
    else 
        spaceName = '';
    end
    
    q = char(39); % quote character
    focusingModes = femtoAPI('command', ...
        strcat('FemtoAPIMicroscope.getFocusingModes(',q,spaceName,q,')'));
    focusingModes{1} = changeEncoding(focusingModes{1},obj.m_usedEncoding);
    focusingModes = jsondecode(focusingModes{1});
end

