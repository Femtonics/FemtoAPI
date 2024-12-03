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

isMoving = obj.femtoAPIMexWrapper('FemtoAPIMicroscope.isAxisMoving',axisName,spaceName);
isMoving = jsondecode(isMoving);

end

