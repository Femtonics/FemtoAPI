function [activeTask, activeSubTask] = getActiveTaskAndSubTask(obj,varargin)
%GETACTIVETASKANDSUBTASK Gets the active task and sub task. 
% 
% This function uses the locally stored acquisition state, so it must be
% updated before calling this function.
%
% INPUTS [optional]: 
%  spaceName                   char array, name of the space. Default
%                              value: 'space1'
% OUTPUTS: 
%  activeTask                  the active measurement task, it can be
%                              'resonant' or 'galvo'
% 
%  activeSubTask               the selected measurement mode to the 
%                              active task, it can be 'timeSeries',
%                              'zStack' or 'volumeScan' 
%                              
% See also GETACTIVETASKANDSUBTASK GETACQUISITIONSTATE
% GETACTIVESUBTASKFORTASK
%
    space = 'space1';
    if(nargin > 2)
        error('Too many input parameters.');
    elseif(nargin == 2)
        space = varargin{1};
    end

    activeTask = obj.m_AcquisitionState.taskIndependentParameters.activeTask;
    if(strcmp(activeTask,'TaskResonantCommon'))
        activeTask = 'resonant';
    elseif(strcmp(activeTask,'TaskFastXYGalvo'))
        activeTask = 'galvo';
    else
        error('Unknown active task type.');
    end

    activeSubTask = obj.getActiveSubTaskForTask(activeTask,space);
end

