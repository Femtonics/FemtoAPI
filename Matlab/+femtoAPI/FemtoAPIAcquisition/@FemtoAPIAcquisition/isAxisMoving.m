function [ isMoving ] = isAxisMoving(obj, axisName, varargin)
%ISAXISMOVING Returns whether axis is moving or not
% Returns whether the objective is moving along the axis given by axisName
% (and optionally space name). If the given axis/space name is invalid, an
% error message is returned from server. Valid axis names can be acquired
% be running obj.getAxisPositions() command.
%
% INPUTS [required]: 
%  axisName                 char array or string, the name of the axis
%
% INPUT [optional]: 
%  spaceName                char array or string, space name. 
%                           Default: default space ('space1') 
%
% OUTPUT: 
%  isMoving                bool, true if objective is moving along the
%                          given axis, false otherwise. 
%
% Usage example:
%  obj.isAxisMoving('StageX')
%
% See also GETAXISPOSITIONS
%
    numVarargs = length(varargin);
    spaceName = obj.m_AcquisitionState.defaultSpaceName;

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

    isMoving = femtoAPI('command',strcat('FemtoAPIMicroscope.isAxisMoving(',axisName,',',spaceName,')'));
    isMoving{1} = changeEncoding(isMoving{1},obj.m_usedEncoding);
    isMoving = jsondecode(isMoving{1});
end

