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

space = obj.m_AcquisitionState.defaultSpaceName;
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

