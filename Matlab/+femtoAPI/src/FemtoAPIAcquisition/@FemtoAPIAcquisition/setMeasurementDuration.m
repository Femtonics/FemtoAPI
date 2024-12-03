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

function [ succeeded ] = setMeasurementDuration(obj, duration,varargin)
%SETMEASUREMENTDURATION Sets measurement duration.
% Sets measurement duration in sec, for task type ('resonant' or 'galvo')
% and space.
% If 0 is given for duration, infinite measurement is set.
%
% Duration cannot be set and an error is returned, if input parameters are
% invalid, or Z-stack subtask mode is selected on the server for the given
% task.
%
% INPUTS [required]:
%  duration               numeric, scalar, measurement duration wanted
%                         to set. If 0, infinite duration is set on server.
%
% INPUTS [optional]:
%  taskType               char array, measurement task type, can be
%                         'resonant'   or 'galvo'. If not given, current
%                         task is considered.
%
%  spaceName               char array, space name, if not given, default
%                          space is considered.
%
% OUTPUT:
%  succeeded              bool, if true, duration has been successfully set
%                         on server, false otherwise.
%
% Usage:
%  obj.setMeasurementDuration(duration) or
%  obj.setMeasurementDuration(duration, taskType) or
%  obj.setMeasurementDuration(duration, taskType, spaceName)
%
% Examples:
%  1. obj.setMeasurementDuration(10.1) -> sets duration for the active
%    task, and default space ('space1').
%  2. obj.setMeasurementDuration(10.1,'galvo') -> sets duration for
%  galvo, and space1.
%
%

numVarargs = length(varargin);
if numVarargs > 2
    error('Too many input arguments');
elseif nargin < 2
    error('Too few input arguments');
end

validateattributes(duration,{'numeric'},{'scalar','nonnegative'}, ...
    mfilename, 'duration');

if(numVarargs == 0)
        succeeded = obj.femtoAPIMexWrapper('FemtoAPIMicroscope.setMeasurementDuration', duration);
elseif(numVarargs == 1)
    taskType = validatestring(varargin{1},{'resonant','galvo'}, ...
        mfilename, 'taskType');
    succeeded = obj.femtoAPIMexWrapper('FemtoAPIMicroscope.setMeasurementDuration', ...
        duration, taskType);
else
    taskType = validatestring(varargin{1},{'resonant','galvo'}, ...
        mfilename, 'taskType');
    spaceName = validateattributes(varargin{2},{'char'}, ...
        {'vector','row'},mfilename, 'spaceName');
    succeeded = obj.femtoAPIMexWrapper('FemtoAPIMicroscope.setActiveTaskAndSubTask', ...
        duration, taskType, spaceName);
end
succeeded = jsondecode(succeeded);

end

