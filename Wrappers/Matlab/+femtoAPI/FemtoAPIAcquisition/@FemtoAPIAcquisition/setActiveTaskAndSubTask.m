function succeeded = setActiveTaskAndSubTask(obj, taskType, varargin)
%SETACTIVETASKANDSUBTASK Sets active task and sub task in the server's GUI.
% Sets the active task (resonant or galvo), and/or measurement mode 
% (subtask, time series, Z-Stack, or volume scan) for the task.
% If subtask type is not given, it will not be changed, so the currently 
% active subtask of the task is considered.
%
% INPUT [required]: 
%  taskType                    char array, type of measurement task, can be 
%                              'resonant' or 'galvo' 
% 
% INPUT [optional]:
%  subTaskType                  char array, type of measurement mode
%                               (subtask). Its value can be 'timeseries', 
%                               'zStack' or 'volumeScan'. 
%
% OUTPUT: 
%  succeeded:                   true if task and subtask has been set
%                               successfully on the MESc GUI, false otherwise.
%
% Examples: 
%  obj.setActiveTaskAndSubTask('resonant','zStack')
%  obj.setActiveTaskAndSubTask('galvo') -> won't change currently selected
%                                          subtask
%
% See also GETACTIVETASKANDSUBTASK 
%
    if nargin > 3
        error('Too many input arguments');
    elseif nargin < 2
        error('Too few input arguments');
    end
    
    taskType = validatestring(taskType,{'resonant','galvo'},mfilename, 'taskType');
    q = char(39); % quote character
    
    if length(varargin) == 1
        subTaskType = validatestring(varargin{1},{'timeSeries','zStack', ...
            'volumeScan'},mfilename, 'subTaskType');
        succeeded = femtoAPI('command', ...
        strcat('FemtoAPIMicroscope.setActiveTaskAndSubTask(',q,taskType,q,',',q,subTaskType,q,')'));
    else
        succeeded = femtoAPI('command', ...
            strcat('FemtoAPIMicroscope.setActiveTaskAndSubTask(',q,taskType,q,')'));
    end
    succeeded{1} = changeEncoding(succeeded{1},obj.m_usedEncoding);
    succeeded = jsondecode(succeeded{1});
end

