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

