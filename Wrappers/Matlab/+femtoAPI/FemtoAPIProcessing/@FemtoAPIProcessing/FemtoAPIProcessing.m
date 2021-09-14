classdef FemtoAPIProcessing < FemtoAPIIF
    %FEMTOAPIProcessing This class is for handling measurement processing data 
    %
    %   The purpose of this class is to provide methods for easy handling of 
    %   measurement processing data, like file operations (read/write, save, 
    %   close, create new file), getting metadata info of the currently 
    %   opened files on the server (processing state), and setting some 
    %   measurement properties, like channel conversion, LUT, or comment of 
    %   measurement file, session, group or unit.
    
    %% public accessible properties
    properties (Access = public)
        m_processingState     
    end
    
    
    %% private properties, for internal use  only
    properties (Hidden,SetAccess = private)
        m_processingStateTreeObj
    end
    
%    methods (Access = protected)
%       function cp = copyElement(obj)
%          % Shallow copy object
%          cp = copyElement@matlab.mixin.Copyable(obj);
%          % Get handle from Prop2
%          procStateObj = obj.m_processingState;
%          treeWrapperObj = obj.m_processingStateTreeObj;
%          
%          % Create default object
%          new_procStateObj = eval(class(procStateObj));
%          new_treeWrapperObj = eval(TreeWrapper(new_procStateObj));
%          % Add public property values from orig object
%          HandleCopy.propValues(new_procStateObj,procStateObj);
%          HandleCopy.propValues(new_treeWrapperObj,treeWrapperObj);
%          % Assign the new object to property
%          cp.procStateObj  = new_procStateObj;
%          cp.treeWrapperObj = new_treeWrapperObj;
%       end
%    end  
   
    %% FemtoAPIProcessing methods
    methods
        %% FemtoAPI object construction and update
        function obj = FemtoAPIProcessing(varargin)
            obj = obj@FemtoAPIIF(varargin);
            obj.getProcessingState();
        end
        
        %% Public get/set processing state local data
        function processingState = get.m_processingState(obj)
            processingState = obj.m_mescProcessingState;
        end
        
        function set.m_processingState(obj,val)
            obj.m_processingState = val;
        end
        
        
        %% Femto API commands
        
        % get/set processing state
        setProcessingState(obj,varargin);     
        getProcessingState(obj);
        
        % R/W functions 
        rawChannelData = readRawChannelData( obj, channelHandle, varargin );
        channelData = readChannelData( obj, channelHandle, readDataType, varargin );
        
        writeRawChannelData( obj, channelHandle, rawData, varargin );
        writeChannelData( obj, channelHandle, data, varargin );
        
        % file operations
        result = createNewFile(obj);
        succeeded = setCurrentFile(obj, nodeDescriptor);
        result = openFilesAsync(obj,fileNames);
        result = saveFileAsync(obj,varargin);
        result = saveFileAsAsync(obj,newAbsolutePath, varargin);
        result = closeFileNoSaveAsync(obj,varargin);
        result = closeFileAndSaveAsync(obj,varargin);
        result = closeFileAndSaveAsAsync(obj,varargin);
        % MUnit operations
        result = createTimeSeriesMUnit(obj,xDim,yDim,taskXMLParameters, ...
            viewportJson,varargin);
        result = createZStackMUnit(obj,xDim,yDim,zDim,taskXMLParameters, ...
            viewportJson, varargin);
        %result = createAOFullFrameScanSeriesMUnit(obj,xDim,yDim,...
        %    taskXMLParameters,viewportJson,varargin);
        result = deleteMUnit(obj, nodeDescriptor);
        % channel operations 
        result = addChannel(obj,nodeDescriptor,channelName);
        result = deleteChannel(obj, nodeDescriptor);


        
        % tools 
        curveData = getCurve( obj, measurementHandle, idxChannel );
        json = getStatus(obj,varargin);
        isModified = modifyConversion(conversionName, scale, offset, varargin);
        
        %% Helper functions: getter/setter methods for measurement data structure based on measurement ID (handle)
        
        [commonCurvesMetaDataTable] = getCommonCurvesMetaDataTable( obj, measurementHandleArray, channelType );
        exportedFileNames = batchExportCurvesTxt( obj, commonCurveMetaDataTable, measurementHandleArray, selectedChannels, absoluteFilePath );   
        exportedFileNames = batchExportCurvesMat( obj, commonCurveMetaDataTable, measurementHandleArray, selectedChannels, absoluteFilePath );
        exportedFileNames = batchExportMeasurementMetaData(obj, measurementHandleArray, fileName);
        succeed = setComment(obj,handle,newComment);         
        
        
        % get measurement metadata by reference (changing this will affect
        % the inner structure of FemtoAPIProcessing object)
        function measMetaData = getMeasurementMetaDataRef(obj, measDataHandle)
            measMetaData = obj.m_processingStateTreeObj.getHStructByHandle(measDataHandle);
        end
        
        % get measurement metadata by copy (if modified, this will not affect the inner
        % structure of FemtoAPIProcessing object)
        function measMetaDataCopy = getMeasurementMetaData(obj, measDataHandle)
            measMetaDataCopy = obj.m_processingStateTreeObj.getStructByHandle(measDataHandle);
        end
        
        % sets a measurement metadata field (changes not affect server side)
        function setMeasurementMetaDataField(obj,measDataHandle, fieldName, value)
            obj.m_processingStateTreeObj.setStructFieldByHandle(measDataHandle, fieldName, value);
        end
        
        % gets measurement metadata field based on measurement metadata
        % handle
        function val = getMeasurementMetaDataField(obj,measDataHandle,fieldName)
            val = obj.m_processingStateTreeObj.getStructFieldByHandle(measDataHandle,fieldName);
        end
        
        % gets measurement metadata field of root, and all of its child handles
        % returns a cell array containing the measurement handle-field pairs
        % Only those measurement handles are in the returned value, which have the field
        % specified by 'fieldName'
        function val = getMeasurementMetaDataFieldRecursive(obj,rootHandle,fieldName,doWarning)
            
            val{1,1} = rootHandle;
            try
                val{1,2} = obj.getMeasurementMetaDataField(rootHandle,fieldName);
            catch ME
                if doWarning
                    warning(ME.message);
                end
                val = [];
                %val{1,1} = [];
                %val{1,2} = [];
            end    
            
            childHandles = obj.getChildHandles(rootHandle);
            if(~isempty(childHandles))
                for i = 1:length(childHandles)
%                   isError = false; 
%                   try
                    childVal =  obj.getMeasurementMetaDataFieldRecursive(childHandles{i},fieldName,doWarning);
%                    catch ME
%                        if doWarning
%                             warning(ME.message);
%                        end
%                        isError = true;
%                    end
%                    
                   %if(isError || isempty(childVal))
                   if(isempty(childVal))
                       continue;
                    else
                        val = [val; childVal];
                   end
                end
            end
                      
        end
        
        % gets Nx2 cell array containing handle and measurement metadata of child handles of rootHandle. 
        function val = getMeasurementMetaDataFieldSelective(obj,rootHandle,fieldName)
            childHandles = obj.getChildHandles(rootHandle);
            val{1,1} = [];
            val{1,2} = [];
            if(~isempty(childHandles))
                for i = 1:length(childHandles)
                        val{i,1} = childHandles{i};
                        try 
                            val{i,2} = obj.getMeasurementMetaDataField(childHandles{i},fieldName);
                        catch ME 
                            warning(ME.message);
                            val{i,2} = [];
                            continue;
                        end
                end
            else
                warning('The root handle item has no child handles.');                
            end
        end
        
        % sets measuremenet metadata field of child handles of rootHandle.
        % If field is not found, a warning message is shown, and nothing is
        % set.
        function setMeasurementMetaDataFieldSelective(obj,rootHandle, fieldName, value)
            childHandles = obj.getChildHandles(rootHandle);
            if(~isempty(childHandles))
                for i = 1:length(childHandles)
                   if(~isempty(childHandles{i}))
                       try
                            obj.setMeasurementMetaDataField(childHandles{i},fieldName,value);
                       catch ME
                           warning(ME.message);
                           continue;
                       end
                   end
                end
            else
                warning('The root handle has no child handles.');
            end
        end
 
        
        
        % sets measurement metadata field of root, and its child handles
        function val = getOpenedFileHandles(obj)
            val = obj.m_processingStateTreeObj.getChildHandles(-1);
        end
        
        function val = getChildHandles(obj,handle)
            val = obj.m_processingStateTreeObj.getChildHandles(handle);
        end
        
        function val = getNumOfChildHandles(obj,handle)
           val = obj.m_processingStateTreeObj.getNumOfChildHandles(handle);
        end
        
        function val = getCurrentFileHandle(obj)
            val = obj.m_processingState.data.currentFileHandle;
        end
        
        function val = getCurrentSessionHandle(obj)
            val = obj.m_processingState.data.currentMeasurementSessionHandle;
        end
        
        function val = getFileName(obj,handle)
             path = obj.getMeasurementMetaDataField(handle,'path');
             idxs = find(ismember(path,'./\:'),2,'last');
             val = path(idxs(1)+1:idxs(2)-1); 
        end
      
    end
    
    
    
    
    methods(Access = private)
        changeDateTimeToLocal(obj);
        
        % build processing state handle objects-> exchange structs with HStructs
        buildFemtoStateHandle(obj,handlesStruct);
    end
    
    
end