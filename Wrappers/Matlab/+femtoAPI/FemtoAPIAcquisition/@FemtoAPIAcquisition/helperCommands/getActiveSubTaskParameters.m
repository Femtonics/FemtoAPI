function parameters = getActiveSubTaskParameters(obj, taskType)
%GETACTIVESUBTASKPARAMETERS Gets parameters to active subtask for a task.
% Gets active measurement mode (time series, Z-stack, volume scan) for the
% given task type (resonant or galvo), and returns its parameters 
% as struct. 
% This function uses the locally stored acquisition state, so it must be
% updated before calling this function. 
%
% INPUT: 
%  taskType                      char array, can be 'resonant' or 'galvo'
% 
% OUTPUT: 
%  parameters                    struct, contains the parmeters for the 
%                                active measurement mode
%
% See also GETACTIVETASKANDSUBTASK GETACQUISITIONSTATE
% GETACTIVESUBTASKFORTASK
% 
    subTaskType = obj.getActiveSubTaskForTask(taskType);

    taskParameters = obj.getTaskParameters(taskType);
    if(strcmp(subTaskType,'zStack'))
        if(~isfield(taskParameters,'zStackParameters'))
            error('There are no z stack parameters in the acquisition struct. This should not happen.');
        end
        parameters = taskParameters.zStackParameters;
    elseif(strcmp(subTaskType,'volumeScan'))
        if(~isfield(taskParameters,'volumeScan'))
            error('There are no volume scan parameters in the acquisition struct. This should not happen. ');
        end
        parameters = taskParameters.volumeScan;    
    else
        % for time series type, there are no additional parameters
        parameters = [];
    end
end

