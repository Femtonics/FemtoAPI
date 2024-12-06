classdef (ConstructOnLoad) UnitEventData < EventDataBase
    %UNTITLED5 Summary of this class goes here
    %   Detailed explanation goes here
    
    properties
        handle % runtime unique handle of measurement unit
        eventSubType % in case of unit events, BaseUnitMetadataChanged, etc
        unitPart % type of unitMetadata, e.g. BaseUnitMetadata, CurveInfo, etc.
        index % index of curve/channel in case of 'CurveInfo', 'ChannelInfo'
    end
    
    methods
        function obj = UnitEventData(eventStruct)
            %UNTITLED5 Construct an instance of this class
            %   Detailed explanation goes here
            obj@EventDataBase(eventStruct);

            if isfield(eventStruct,'nodeDescriptor')
                obj.handle = str2num(regexprep(eventStruct.nodeDescriptor,'[\(\)]',''));
            else
                error("Unit event data should contain 'nodeDescriptor'");
            end

            if isfield(eventStruct,'jsonItem')
                obj.eventSubType = eventStruct.jsonItem ;
                obj.eventSubType = strcat(upper(obj.eventSubType(1)),obj.eventSubType(2:end),"Changed");
                obj.unitPart = strcat(upper(eventStruct.jsonItem(1)),eventStruct.jsonItem(2:end));
            elseif obj.eventType == "unitMetadataChanged"
                error("Unit metadata change event should contain 'jsonItem' field");
            else
                obj.eventSubType = "";
                obj.unitPart = "";
            end
            
            if isfield(eventStruct,'index')
                obj.index = str2double(eventStruct.index) + 1; % because Matlab starts indexing from 1
            end
            
        end
        
    end
end

