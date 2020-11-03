function succeeded = doZero(obj,axisName,varargin)
%DOZERO Zero axis relative position
% This command is used for setting the relative position of the given axis 
% to zero, and sets the labeling origin offset to the current absolute 
% postion. The axis is given by the parameters axisName and space name.
% If space name is not given, default space is considered.
%
% Zero command can be done only on standard axes. Run getAxisPositions() 
% command to obtain configured axis names.
%
% INPUTS [required]: 
%  axisName             char array, name of the axis
%
% INPUTS [optional]: 
%  spaceName            char array, name os space the axis is configured for. 
%                       If not given, default space name ('space1') is
%                       considered.
% 
% OUTPUT: 
%  succeded            - true, if the input parameters are OK, and the zero 
%                        command was successfully issued,
%                      - false when the input parameters are invalid, 
%                        or the 'Lock' checkbox is enabled on the MESc GUI.
%
% Examples: 
%  obj.doZero('SlowZ') -> do zero if 'SlowZ' is configured for default
%   space
%  obj.doZero('TiltX','space2') -> do zero if 'TiltX' is configured for
%   space2
%
% See also SETAXISPOSITION GETAXISPOSITIONS
%
    numVarargs = length(varargin);
    spaceName = obj.m_mescAcquisitionState.defaultSpaceName;

    if(~ischar(axisName) && ~isstring(axisName))
        error('Argument 1, ''axisName'' must be of type character array or string.');
    end
    if numVarargs > 1
        error('Too many input arguments.');
    elseif numVarargs == 1
        if(~ischar(varargin{1}) && ~isstring(varargin{1}))
            error('Argument 2, ''spaceName'' must be of type character array or string.');
        end
        spaceName = varargin{1};
    end
    q = char(39); % quote character
    axisName = [q,char(axisName),q];
    spaceName = [q,char(spaceName),q];

    succeeded = femtoMEScAPI('command',strcat('FemtoAPIMicroscope.doZero(',axisName,',',spaceName,')'));
    succeeded{1} = changeEncoding(succeeded{1},'UTF-8');
    succeeded = jsondecode(succeeded{1});
    
end

