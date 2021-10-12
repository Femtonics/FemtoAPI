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
    
    
    %% FemtoAPIProcessing methods
    methods
        %% FemtoAPI object construction and update
        function obj = FemtoAPIProcessing(varargin)
            obj = obj@FemtoAPIIF(varargin);
            obj.getProcessingState();
        end
        
        %% Public get/set processing state local data
        function processingState = get.m_processingState(obj)
            processingState = obj.m_processingState;
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
        result = deleteMUnit(obj, nodeDescriptor);
        result = extendMUnit(obj, mUnitHandle, frameCount);
        result = copyMUnit(obj, sourceMImageHandle, destMItemHandle, varargin);
        result = moveMUnit(obj, sourceMImageHandle, destMItemHandle);
        
        % channel operations
        result = addChannel(obj,nodeDescriptor,channelName);
        result = deleteChannel(obj, nodeDescriptor);
        
        
        
        % tools
        curveData = getCurve( obj, measurementHandle, idxChannel );
        json = getStatus(obj,varargin);
        isModified = modifyConversion(conversionName, scale, offset, varargin);
        result = addLastFrameToMSession(obj, destMSessionHandle, spaceName);
        waitForCompletion(obj,result);
        
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
            end
            
            childHandles = obj.getChildHandles(rootHandle);
            if(~isempty(childHandles))
                for i = 1:length(childHandles)
                    childVal =  obj.getMeasurementMetaDataFieldRecursive(childHandles{i},fieldName,doWarning);
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
            val = cell2mat(obj.m_processingStateTreeObj.getChildHandles(-1));
        end
        
        function val = getChildHandles(obj,handle)
            val = cell2mat(obj.m_processingStateTreeObj.getChildHandles(handle));
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
    
    
    methods(Static, Access = private)
        % helper function for setProcessignState jsonencode to correctly
        % convert 'NaN' and 'Inf' values (behaviour has changed in R2017b)
        function jsonStr = jsonEncode_helper(data)
            % convert 'Inf' to Inf and 'NaN' to NaN
            if(verLessThan('matlab', '9.3'))
                % before R2017b, Inf is converted to 'Inf', and -Inf to
                % '-Inf'
                jsonStr = jsonencode(data);
            else
                % convert Inf -> 'Infinity', -Inf -> '-Infinity'
                jsonStr = jsonencode(data,'ConvertInfAndNaN',false);
            end
            % convert 'Inf(inity)' and '-Inf(inity)' to double max/min
            % (with 6 digit precision, larger precision may results in null
            % value on server  
            
            % match strings in json like ',Inf(inity)]'
            jsonStr = regexprep(jsonStr,',(\s*)Inf(inity)?(\s*)\]',...
                strcat(',',strrep(num2str(realmax,6),'e','E'),']'));
            % match strings in json like '[-Inf(inity),'
            jsonStr = regexprep(jsonStr,'\[(\s*)-Inf(inity)?(\s*),',...
                strcat('[',strrep(num2str(realmin,6),'e','E'),','));
        end
    end
    
    methods(Access = private)
        changeDateTimeToLocal(obj);
        
        % build processing state handle objects-> exchange structs with HStructs
        buildFemtoStateHandle(obj,handlesStruct);
    end
    
    
end