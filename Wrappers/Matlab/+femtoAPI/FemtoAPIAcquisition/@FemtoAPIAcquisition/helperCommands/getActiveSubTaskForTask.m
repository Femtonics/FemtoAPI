function [activeSubTask] = getActiveSubTaskForTask(obj,taskType,varargin)
%GETACTIVESUBTASKFORTASK Gets the active subtask for the given task
% 
% This function uses the locally stored acquisition state, so it must be
% updated before calling this function.
%
% INPUTS [required]:
%  taskType              char array, can be 'resonant' or 'galvo'
%  
% INPUTS [optional]:
%  spaceName             char array, space name. Defaul value: 'space1'.
%
% See also GETACQUISITIONSTATE GETTASKPARAMETERS
%
    if nargin > 3 
        error('Too many input arguments.');
    elseif nargin == 3
        taskParameters = obj.getTaskParameters(taskType,varargin{1});
    else
        taskParameters = obj.getTaskParameters(taskType);
    end

    if(contains(taskParameters.measurementMode,'time series','IgnoreCase',true))
        activeSubTask = 'timeSeries';
    elseif(contains(taskParameters.measurementMode,'z stack','IgnoreCase',true))
        activeSubTask = 'zStack';
    elseif(contains(taskParameters.measurementMode,'volume scan','IgnoreCase',true))
        activeSubTask = 'volumeScan';
    else
        error('Unknown active subTask type');
    end
end

