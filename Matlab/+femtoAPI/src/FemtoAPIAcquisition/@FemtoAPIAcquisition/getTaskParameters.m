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

function taskParameters = getTaskParameters(obj, taskType, varargin)
%GETTASKPARAMETERS Helper for filtering acquistion state task parameters
% Filters acquisition state for task type('resonant' or 'galvo') and space.
%
% This function uses the locally stored acquisition state, so it must be
% updated before calling this function.
%
% INPUTS[required]:
%  taskType               string or char array, can be 'resonant' or
%                         'galvo'
%
% INPUTS[optional]:
%  space                  space name
%
% OUTPUT:
%  taskParameters         struct, resonant or galvo parameters from
%                         acquisition state
%
% See also GETACQUISITIONSTATE
%

validatestring(taskType,{'resonant','galvo'}, mfilename, 'taskType');
space = obj.m_AcquisitionState.defaultSpaceName; 

if(nargin >3)
    error('Usage: obj.getTaskParameters(taskType) or obj.getTaskParameters(taskType, space) ');
end

if(nargin == 3)
    space = varargin{1};
    if(isstring(space))
        space = char(space);
    else
        validateattributes(varargin{1},{'char'},{'row'},mfilename, 'space');
        space = varargin{1};
    end
end

taskParametersPerSpace = obj.m_AcquisitionState.taskParametersPerSpace;
taskParameters = [];
for taskParameterPerSpace = taskParametersPerSpace
    if( strcmp(taskParameterPerSpace.space,space) )
        if(strcmp(taskType, 'resonant'))
            taskParameters =  taskParameterPerSpace.resonant;
        else
            taskParameters =  taskParameterPerSpace.galvo;
        end
    end
end

end

