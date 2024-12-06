classdef (ConstructOnLoad) FileOpenedClosedEventData < EventDataBase
    %UNTITLED5 Summary of this class goes here
    %   Detailed explanation goes here
    
    properties
        handle
        fileName
    end
    
    methods
        function obj = FileOpenedClosedEventData(eventStruct)
            %UNTITLED5 Construct an instance of this class
            %   Detailed explanation goes here
            obj@EventDataBase(eventStruct);

            if ~isfield(eventStruct,'values') ...
                || ~ isfield(eventStruct.values,'fileName') ...
                || ~ isfield(eventStruct.values,'nodeDescriptor')  
               error(["Event data should contain 'values' and ", ...
               "'values.fileName', and 'values.nodeDescriptor'"]);
            end 
            
            obj.handle = eventStruct.values.nodeDescriptor;
            obj.fileName = eventStruct.values.fileName;
        end
    end
    
end

