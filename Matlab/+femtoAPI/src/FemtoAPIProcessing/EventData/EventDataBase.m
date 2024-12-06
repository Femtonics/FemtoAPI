classdef (ConstructOnLoad) EventDataBase < event.EventData
    %UNTITLED6 Summary of this class goes here
    %   Detailed explanation goes here
    
    properties
        time
        eventType % type of event, e.g. unitMetadata
    end
    
    methods
        function obj = EventDataBase(eventStruct)
            %UNTITLED6 Construct an instance of this class
            %   Detailed explanation goes here
            
            if ~isfield(eventStruct,'time')
                error("Event should contain 'time'");
            else
                obj.time = eventStruct.time;
            end
            obj.eventType = eventStruct.event;            
        end
    end
end

