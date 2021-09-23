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

classdef FemtoAPIAcquisition < FemtoAPIIF
    %FemtoAPIAcquistion Class for handling measurement data acquisition 
    % 
    % The purpose of this class is to provide methods for 
    % easy handling of measurement acquisition related functions, like 
    % set/get device values, start/stop measurements, get acquisition state, etc. 
    
    
    %% public accessible properties 
    properties (SetAccess = private)
        m_zStackLaserIntensities
        m_deviceValues DeviceValues 
    end

    properties(GetAccess = public, SetAccess = private)
        m_AcquisitionState struct  
    end
          
    
    %% methods 
    methods
        function obj = FemtoAPIAcquisition(varargin)
            obj@FemtoAPIIF(varargin);
            obj.getAcquisitionState(); 
        end

        %% Femto API commands
        
        %% Acquisition state getter commands
        % get the acquisition state
        acquisitionState = getAcquisitionState( obj );
        
        % get the microscope state (part of acquisition state)
        microscopeState = getMicroscopeState( obj );  
        
        %% measurement start/stop and set duration commands
        % start resonant scan measurement 
        isStarted = startResonantScanAsync(obj);
     
        % stop resonant scan measurement 
        isStoppped = stopResonantScanAsync(obj);
        
        % start galvo scan measurement
        isStarted = startGalvoScanAsync(obj);
        
        % stop galvo scan measurmeent
        isStopped = stopGalvoScanAsync(obj);
        
        % start resonant scan snapshot measurement
        isStarted = startResonantScanSnapAsync(obj);       
        
        % start galvo scan snapshot measurement
        isStarted = startGalvoScanSnapAsync(obj);
               
        % set measurement duration 
        succeeded = setMeasurementDuration(obj, duration, taskType);
        
        %% Axis manipulation commands
        % get objective axis positions and info (axis limits, thresholds) from server
        axisPositions = getAxisPositions(obj);
        
        % get position of an axis 
        axisPosition = getAxisPosition(obj,axisName,varargin);  
        
        % set axis position (focusing mode, objective positions (only
        % one axis at once)
        setAxisPosition(obj, axisName, position,varargin);
        
        success = doZero(obj, axisName,varargin);
        
        isMoving = isAxisMoving(obj, axisName, varargin);
        %% Z stack depth correction profile set/get commands
        % set Z stack laser intensity
        succeeded = setZStackLaserIntensityProfile(obj,zStacklaserIntensities);
        
        % Get Z Stack depth correction intensities for configured devices
        % in case of resonant/galvo measurements
        zStackLaserIntensityProfile = getZStackLaserIntensityProfile(obj,varargin);

        %% Imaging window parameters (resolution, viewport rectangle) set/get commands
        setImagingWindowsParameters(obj,imagingParams);
        
        % gets imaging parameters (viewport). One optional paramter:
        % 'resonant' or 'galvo' can be given for getting vieport of specific measurement. 
        imagingWindowParameters = getImagingWindowParameters(obj,varargin);
        
        %% set/get PMT and laser intensity device values (e.g. Pockels cell, APT) commands
        deviceValues = getPMTAndLaserIntensityDeviceValues(obj);
        succeeded = setPMTAndLaserIntensityDeviceValues(obj,deviceValues);
        
        %% Tools
        % set active task/subtask
        succeeded = setActiveTaskAndSubTask(obj, taskType, varargin);
        focusingModes = getFocusingModes(obj, varargin);
        succeeded = setFocusingMode(obj, focusingMode, varargin);
        protocol  = getActiveProtocol(obj);
        %% helper functions
        taskParameters = getTaskParameters(obj,taskType,varargin);
        [activeTask, activeSubTask] = getActiveTaskAndSubTask(obj,varargin);
        activeSubTask = getActiveSubTaskForTask(obj,varargin);
        parameters = getActiveSubTaskParameters(obj, taskType);
        
        % get list of configured axes. Should be called after
        % getAxisPositions() or getAcquisitionState() commands
        configuredAxes = getConfiguredAxes(obj);
        
        % check whether the axis with the given axisName is configured or
        % not. It can check an array of axes. In this case, it returns true
        % only if all the axisNames in the array are valid (configured)
        isConfigured = isAxisConfigured(obj,axisName);        
    end
      
end

