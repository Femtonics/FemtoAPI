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
    space = 'space1'; % default value 
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

    taskParametersPerSpace = obj.m_mescAcquisitionState.taskParametersPerSpace;
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

