classdef (ConstructOnLoad) ItemAddedDeletedEventData < EventDataBase
    %UNTITLED5 Summary of this class goes here
    %   Detailed explanation goes here
    
    properties
        handle 
        status % status: added or deleted
    end
    
    methods
        
        function obj = ItemAddedDeletedEventData(eventStruct)
            %UNTITLED5 Construct an instance of this class
            %   Detailed explanation goes here
            obj@EventDataBase(eventStruct);
            
            obj.status = eventStruct.status;
            if isfield(eventStruct,'nodeDescriptor')
                obj.handle = str2num(regexprep(eventStruct.nodeDescriptor,'[\(\)]',''));
            else
                error("Event data should contain 'nodeDescriptor'");
            end
        end
        
    end
end


