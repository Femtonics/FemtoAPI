% Copyright ©2021. Femtonics Kft. (Femtonics). All Rights Reserved. 
% Permission to use, copy, modify this software and its documentation for educational,
% research, and not-for-profit purposes, without fee and without a signed licensing agreement, is 
% hereby granted, provided that the above copyright notice, this paragraph and the following two 
% paragraphs appear in all copies, modifications, and distributions. Contact info@femtonics.eu
% for commercial licensing opportunities.
% 
% IN NO EVENT SHALL FEMTONICS BE LIABLE TO ANY PARTY FOR DIRECT, INDIRECT, SPECIAL, 
% INCIDENTAL, OR CONSEQUENTIAL DAMAGES, INCLUDING LOST PROFITS, ARISING OUT OF 
% THE USE OF THIS SOFTWARE AND ITS DOCUMENTATION, EVEN IF FEMTONICS HAS BEEN 
% ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
% 
% FEMTONICS SPECIFICALLY DISCLAIMS ANY WARRANTIES, INCLUDING, BUT NOT LIMITED TO, 
% THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR 
% PURPOSE. THE SOFTWARE AND ACCOMPANYING DOCUMENTATION, IF ANY, PROVIDED 
% HEREUNDER IS PROVIDED "AS IS". FEMTONICS HAS NO OBLIGATION TO PROVIDE 
% MAINTENANCE, SUPPORT, UPDATES, ENHANCEMENTS, OR MODIFICATIONS.

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

