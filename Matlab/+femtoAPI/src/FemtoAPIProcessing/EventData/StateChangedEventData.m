classdef (ConstructOnLoad) StateChangedEventData < EventDataBase
    %UNTITLED5 Summary of this class goes here
    %   Detailed explanation goes here
    
    properties
        state
    end
    
    methods
        
        function obj = StateChangedEventData(eventStruct)
            %UNTITLED5 Construct an instance of this class
            %   Detailed explanation goes here
            obj@EventDataBase(eventStruct);
            obj.state     = WebSocketState.(eventStruct.values.state);
        end
       
    end
end

