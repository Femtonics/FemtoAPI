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
%                          space ('space1') is considered. 
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
    
    q = char(39); % quote character
    
    if(numVarargs == 0)
        succeeded = femtoAPI('command', ...
        strcat('FemtoAPIMicroscope.setMeasurementDuration(',num2str(duration),')'));        
    elseif(numVarargs == 1)
        taskType = validatestring(varargin{1},{'resonant','galvo'}, ...
            mfilename, 'taskType');
        
        succeeded = femtoAPI('command', ...
        strcat('FemtoAPIMicroscope.setMeasurementDuration(',num2str(duration), ...
        ',',q,taskType,q,')'));        
    else 
        taskType = validatestring(varargin{1},{'resonant','galvo'}, ...
            mfilename, 'taskType');        
        spaceName = validateattributes(varargin{2},{'char'}, ...
            {'vector','row'},mfilename, 'spaceName');
        
        succeeded = femtoAPI('command', ...
        strcat('FemtoAPIMicroscope.setActiveTaskAndSubTask(',num2str(duration), ...
       ',', q,taskType,q,',',q,spaceName,q,')'));        
    end
    
    succeeded{1} = changeEncoding(succeeded{1},obj.m_usedEncoding);
    succeeded = jsondecode(succeeded{1});
end

