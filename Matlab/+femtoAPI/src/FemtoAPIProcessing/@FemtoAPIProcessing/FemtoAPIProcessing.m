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
    
    
    %% private properties, for internal use  only
    %properties (Hidden,SetAccess = private)
    properties (Access = public)
        m_metadataCache MetadataCache % key: {handle, eventType}, value: metadata
        listenerObj
    end
    
    properties (Hidden)
        testListenerObj % for testing purpose
        dummyCounter double % for testing purpose
    end
    
    %% events from server
    events
        MexEvent
        
        % file related changes
        FileOpened
        FileClosed
        FileMetadataChanged
        AsyncSaveFinished
        
        % session related changes
        SessionMetadataChanged
        CurrentSessionChanged
        
        % unit related change events
        BaseUnitMetadataChanged
        ReferenceViewportChanged
        ChannelInfoChanged
        RoiChanged
        PointsChanged
        DeviceChanged
        AxisControlChanged
        UserDataChanged
        AoSettingsChanged
        IntensityCompensationChanged
        CoordinateTuningChanged
        ProtocolChanged
        MultiRoiProtocolChanged
        RasterScanProtocolChanged
        CurveInfoChanged
        FullFrameParamsChanged
        ModalityChanged
        CameraSettingsChanged
        BreakViewChanged
        CoordinateMapChanged
        
        % added/deleted signals
        ItemAddedDeleted % for session/unit add/delete
        CurveAddedDeleted
        ChannelAddedDeleted
        
        % other signals
        Heartbeat
        WebSocketStateChanged
        TiffExportChanged
        CreateTiffResult
        % error signals
        FileIOError
    end
    
    %% FemtoAPIProcessing methods
    methods
        %% FemtoAPI object construction and update
        function obj = FemtoAPIProcessing(varargin)
            obj = obj@FemtoAPIIF(varargin);
            obj.m_metadataCache = MetadataCache();
            %obj.testListenerObj = addlistener(obj, 'Heartbeat', @obj.heartbeatEventCallback);
            %obj.testListenerObj = addlistener(obj, 'CreateTiffResult', @obj.testEventCallback);
            
            obj.dummyCounter = 0;
            
            % enable events
            if obj.enableSignals()
                disp("Signalling enabled.");
            end
            
        end
        
        
        function delete(obj)
            
            debug("FemtoAPIProcessing destructor");
            
        end
        
        
        function heartbeatEventCallback(obj,~,eventData)
            %HEARTBEATEVENTCALLBACK Used only for testing
            %
            disp('heartbeatEventCallback called...');
            obj.dummyCounter = obj.dummyCounter + 1;
            disp(['dummyCounter: ', num2str(obj.dummyCounter)]);
        end
        
        
        function testEventCallback(obj,~,eventData)
            disp('testEventCallback called...');
            eventData
        end
        
        
        function eventHandler(obj, newValueJson)
            debug('eventHandler called...');
            try
                eventStruct = jsondecode(newValueJson);
                if iscell(eventStruct.values)
                    eventStruct.values = jsondecode(eventStruct.values{1});
                end
                eventStruct = convertCharsToStrings(eventStruct);
                eventStruct.values = obj.convertHandlesInMetadataToCellArray(eventStruct.values);
                eventType   = eventStruct.event;
                
                switch eventType
                    case {'channelMetadataChanged','curveMetadataChanged'}
                        eventData = UnitEventData(eventStruct);
                        newValue = eventStruct.values;
                        obj.updateChannelOrCurveInfo(eventData, newValue);
                        notify(obj,eventData.eventSubType, eventData);
                        debug([eventData.eventSubType,' has been sent']);
                        
                    case 'unitMetadataChanged'
                        % update cache
                        eventData = UnitEventData(eventStruct);
                        debug('Updating unit metadata with new value in cache');
                        obj.m_metadataCache.setMetadata(eventData.handle, ...
                            eventData.unitPart, eventStruct.values);
                        notify(obj,eventData.eventSubType, eventData);
                        debug('UnitMetadataChanged has been sent');
                        
                    case 'sessionMetadataChanged'
                        % update cache
                        eventData = FileOrSessionEventData(eventStruct);
                        obj.m_metadataCache.setMetadata(eventData.handle, ...
                            eventStruct.values);
                        notify(obj,'SessionMetadataChanged', eventData);
                        debug('SessionMetadataChanged has been sent');
                        
                    case 'fileMetadataChanged'
                        % update cache
                        eventData = FileOrSessionEventData(eventStruct);
                        obj.m_metadataCache.setMetadata(eventData.handle, ...
                            eventStruct.values);
                        notify(obj,'FileMetadataChanged', eventData);
                        debug('FileMetadataChanged has been sent');
                        
                    case 'fileOpened'
                        eventData = FileOpenedClosedEventData(eventStruct);
                        notify(obj,'FileOpened', eventData);
                        debug('FileOpened has been sent');
                        
                    case 'fileClosed'
                        eventData = FileOpenedClosedEventData(eventStruct);
                        obj.cleanupMetadataCache(eventData.handle);
                        notify(obj,'FileClosed', eventData);
                        debug('FileClosed has been sent');
                        
                    case 'fileIOError'
                        eventData = FileIOErrorEventData(eventStruct);
                        if isfield(eventData, 'handle')
                            obj.cleanupMetadataCache(eventData.handle);
                        end
                        notify(obj,'FileIOError', eventData);
                        debug('FileIOError has been sent');
                        
                    case 'asyncSaveFinished'
                        eventData = FileOpenedClosedEventData(eventStruct);
                        notify(obj,'AsyncSaveFinished', eventData);
                        debug('AsyncSaveFinished has been sent');
                        
                    case 'webSocketStateChanged'
                        eventData = StateChangedEventData(eventStruct);
                        notify(obj,'WebSocketStateChanged',eventData);
                        debug('WebSocketStateChanged has been sent');
                        
                    case 'itemAddedDeleted'
                        eventData = ItemAddedDeletedEventData(eventStruct);
                        if strcmp(eventData.status,'deleted')
                            obj.cleanupMetadataCache(eventData.handle);
                        end
                        notify(obj,'ItemAddedDeleted',eventData);
                        debug('ItemAddedDeleted has been sent');
                        
                    case 'curveAddedDeleted'
                        eventData = ChannelOrCurveAddedDeletedEventData( ...
                            eventStruct);
                        obj.channelOrCurveAddedDeleted(eventData, ...
                            eventStruct.values);
                        notify(obj,'CurveAddedDeleted',eventData);
                        debug('CurveAddedDeleted has been sent');
                        
                    case 'channelAddedDeleted'
                        eventData = ChannelOrCurveAddedDeletedEventData( ...
                            eventStruct);
                        obj.channelOrCurveAddedDeleted(eventData, ...
                            eventStruct.values);
                        notify(obj,'ChannelAddedDeleted',eventData);
                        debug('ChannelAddedDeleted has been sent');
                        
                    case 'currentSessionChanged'
                        eventData = FileOrSessionEventData(eventStruct);
                        notify(obj,'CurrentSessionChanged', eventData);
                        debug('CurrentSessionChanged has been sent');
                        
                    case 'heartbeat'
                        disp('Heartbeat signal received');
                        notify(obj,'Heartbeat');
                        debug('Heartbeat has been sent');
                        
                    case 'tiffExportChanged'
                        eventData = TiffExportEventData(eventStruct);
                        notify(obj,'TiffExportChanged',eventData);
                        debug('TiffExportChanged has been sent');
                        
                    case 'createTiffResult'
                        eventData = CreateTiffResultEventData(eventStruct);
                        notify(obj,'CreateTiffResult',eventData);
                        debug('CreateTiffResult has been sent');
                        
                    otherwise
                        eventData = MexEventData(eventStruct);
                        notify(obj,'MexEvent',eventData);
                        debug('MexEvent has been sent');
                        
                end
            catch ME
                % only disp error message, because throwing error would
                % break event sending
                warning(['Exception in FemtoAPIProcessing.eventHandler(): ', ME.message]);
            end
            debug('eventHandler ended...');
        end
        
        
        function ret = enableSignals(obj)
            obj.femtoAPIMexWrapper('registerMatlabObject',obj);
            ret = jsondecode( obj.femtoAPIMexWrapper('FemtoAPITools.enableSignals',true) );
            % subscribe to fileListChaged event -> needed for removing
            % old elements to cache
            obj.getFileList('subscribe');
        end
        
        
        function ret = disableSignals(obj)
            obj.getFileList('unsubscribe');
            ret = jsondecode(obj.femtoAPIMexWrapper('FemtoAPITools.enableSignals',false));
        end
        
        
        
        %% Femto API commands
        
        %% get/set file/session/unit metadata
        getProcessingState(obj);
        childTree = getChildTree(obj,varargin);
        succeeded = setUnitMetadata(obj, unitHandle, unitFieldName, value);
        [unitMetadata, fromCache] = getUnitMetadata(obj, unitHandle, unitItemStr, varargin);
        [fileMetadata, fromCache] = getFileMetadata(obj, fileHandle, varargin);
        fileList = getFileList(obj, varargin);
        currentSessionHandle = getCurrentSession(obj, subscribe);
        succeeded = setCurrentSession(obj, nodeDescriptor);
        
        succeeded = setSessionMetadata(obj, sessionHandle, value);
        sessionMetaData = getSessionMetadata(obj, sessionHandle, varargin);
        
        %% File operations
        result = createNewFile(obj);
        result = openFilesAsync(obj,fileNames);
        result = saveFileAsync(obj,varargin);
        result = saveFileAsAsync(obj,newAbsolutePath, varargin);
        result = closeFileNoSaveAsync(obj,varargin);
        result = closeFileAndSaveAsync(obj,varargin);
        result = closeFileAndSaveAsAsync(obj,varargin);
        
        %% MUnit operations
        % create munits
        result = createTimeSeriesMUnit(obj, xDim, yDim, technologyType, ...
            referenceViewport, varargin);
        
        result = createZStackMUnit(obj ,xDim, yDim, zDim, technologyType, ...
            referenceViewport, varargin);
        
        result = createVolumeScanMUnit(obj, xDim, yDim, zDim, tDim, ...
            technologyType, referenceViewport);
        
        result = createMultiLayerMUnit(obj, xDim, yDim, tDim, ...
            technologyType, referenceViewport);
        
        result = createMultiROI2DMUnit( obj, xDim, tDim,...
            methodType, backgroundImagePath, deltaTInMs, varargin );
        
        result = createMultiROI3DMUnit( obj, xDim, yDim, tDim,...
            methodType, backgroundImagePath, deltaTInMs, varargin );
        
        result = createMultiROI4DMUnit( obj, xDim, yDim, zDim, tDim,...
            methodType, backgroundImagePath, deltaTInMs, varargin );
        
        result = createBackgroundFrame( obj, xDim, yDim,...
            technologyType, imageRole, viewportJson, varargin);
        
        result = createBackgroundZStack( obj, xDim, yDim, zDim,...
            technologyType, imageRole, viewportJson, varargin);
        
        result = setLinkedMUnit(obj, mainMUnitHandle, linkedMUnitHandle); 
        
        result = createTiff( obj, tiffUniqueId, handle, varargin );
        % delete
        result = deleteMUnit(obj, nodeDescriptor);
        
        %% Channel operations
        result = addChannel( obj, nodeDescriptor, channelName, varargin);
        result = deleteChannel(obj, nodeDescriptor);
        
        % R/W channel data functions
        rawChannelData = readRawChannelData( obj, channelHandle, varargin );
        channelData = readChannelData( obj, channelHandle, readDataType, varargin );
        writeRawChannelData( obj, channelHandle, rawData, varargin );
        writeChannelData( obj, channelHandle, data, varargin );
        
        %% Curve operations
        [curveData, curveInfo] = readCurve( obj, measurementHandle, idxChannel, varargin );
        
        curveInfo = writeCurve( obj, measurementHandle, size, name, ...
            xType, xDataType, yType, yDataType, optimize );
        
        curveInfo = appendToCurve( obj, measurementHandle, curveIdx, ...
            curveData, xType, xDataType, yType, yDataType );
        
        succeded = deleteCurve( obj, measurementHandle, curveIdx);
        
        %% Tools
        json = getStatus(obj,varargin);
        isModified = modifyConversion(conversionName, scale, offset, varargin);
        waitForCompletion(obj,result);
        prop = getDisplayedProperties(obj, handle, detailed);
        
        %% Helper functions: getter/setter methods for measurement data structure based on measurement ID (handle)
        
        [commonCurvesMetaDataTable] = getCommonCurvesMetaDataTable( obj, measurementHandleArray, channelType );
        exportedFileNames = batchExportCurvesTxt( obj, commonCurveMetaDataTable, measurementHandleArray, selectedChannels, absoluteFilePath );
        exportedFileNames = batchExportCurvesMat( obj, commonCurveMetaDataTable, measurementHandleArray, selectedChannels, absoluteFilePath );
        exportedFileNames = batchExportMeasurementMetaData(obj, measurementHandleArray, fileName);
        
        function val = getFileName(obj,handle)
            path = obj.getMeasurementMetaDataField(handle,'path');
            idxs = find(ismember(path,'./\:'),2,'last');
            val = path(idxs(1)+1:idxs(2)-1);
        end
        
    end
    
    
    methods (Access = private)
        
        function channelOrCurveAddedDeleted(obj,eventData,values)
            
            if eventData.eventType == "channelAddedDeleted"
                
                obj.m_metadataCache.setMetadata(eventData.handle, ...
                    "ChannelInfo", values);
                
            elseif eventData.eventType == "curveAddedDeleted"
                
                obj.m_metadataCache.setMetadata(eventData.handle, ...
                    "CurveInfo",  values);
                
            else
                
                error(["Event type should be 'channelAddedDeleted' or ", ...
                    "'curveAddedDeleted'"]);
                
            end
            
        end
        
        
        function updateChannelOrCurveInfo(obj,eventData, newValue)
            
            if eventData.unitPart ~= "ChannelInfo" && ...
                    eventData.unitPart ~= "CurveInfo"
                
                error(["UnitPart can only be 'ChannelInfo' or ", ...
                    "'CurveInfo'"]);
            end
            
            obj.updateChannelOrCurveMetadataInCache(eventData.handle, ...
                eventData.unitPart, ...
                eventData.index, ...
                newValue);
            
        end
        
        
        function updateChannelOrCurveMetadataInCache(obj, unitHandle, ...
                unitPart, indexToChange, newValue)
            
            metadata = obj.m_metadataCache.getMetadata(unitHandle, ...
                unitPart);
            
            if unitPart == "ChannelInfo"
                metadata.channels(indexToChange) = newValue;
            elseif unitPart == "CurveInfo"
                metadata.curves(indexToChange) = newValue;
            end
            
            obj.m_metadataCache.setMetadata(unitHandle, ...
                unitPart, metadata);
            
        end
        
        
        % Helper for get(...)Metadata methods
        function [metadata, fromCache] = getMetadataHelper(obj, commandName, handle, ...
                subscribeOrUnsubscribe )
            
            %cache will contain key only if subscribed to that change
            if subscribeOrUnsubscribe ~= "unsubscribe" && ...
                    obj.m_metadataCache.containsKey(handle)
                
                metadata = obj.m_metadataCache.getMetadata(handle);
                fromCache = true;
                return;
                
            else
                
                metadata = obj.femtoAPIMexWrapper(commandName, handle, subscribeOrUnsubscribe);
                metadata = jsondecode(metadata);
                
                % hack because jsondecode converts json numeric array of
                % arrays to matrix, but we want cell array
                metadata = obj.convertHandlesInMetadataToCellArray(metadata);
                
                fromCache = false;
                
                if subscribeOrUnsubscribe == "subscribe"
                    obj.m_metadataCache.setMetadata(handle, metadata);
                elseif subscribeOrUnsubscribe == "unsubscribe"
                    obj.m_metadataCache.removeKey(handle);
                end
                
            end
            
        end
        
        
        
        
        
        function cleanupMetadataCache(obj,handle)
            obj.m_metadataCache.removeKeyWithChildren(handle);
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
        
        
        function metadata = convertHandlesInMetadataToCellArray(metadata)
            
            if isfield(metadata,'sessionHandles')
                metadata.sessionHandles = num2cell(metadata.sessionHandles,2);
            elseif isfield(metadata,'unitHandles')
                metadata.unitHandles = num2cell(metadata.unitHandles,2);
            end
            
        end
        
    end
    
    methods(Access = private)
        changeDateTimeToLocal(obj);
    end
    
    
end