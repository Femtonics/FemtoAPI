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
    succeeded = jsondecode(succeeded{1});
end

