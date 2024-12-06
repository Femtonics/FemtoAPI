classdef (ConstructOnLoad) ChannelOrCurveAddedDeletedEventData < EventDataBase
    %UNTITLED5 Summary of this class goes here
    %   Detailed explanation goes here
    
    properties
        handle % handle of unit which contains the curve
        status % status: added or deleed
        index
    end
    
    methods
        
        function obj = ChannelOrCurveAddedDeletedEventData(eventStruct)
            %UNTITLED5 Construct an instance of this class
            %   Detailed explanation goes here
            obj@EventDataBase(eventStruct);

            obj.status    = eventStruct.status;
            
            if isfield(eventStruct,'nodeDescriptor')
                obj.handle = str2num(regexprep(eventStruct.nodeDescriptor,'[\(\)]',''));
            else
                error("Unit event data should contain 'nodeDescriptor'");
            end
            
            if isfield(eventStruct,'index')
                obj.index = eventStruct.index;
            else 
                error("Unit event data should contain 'index'"); 
            end
        end
        
    end
end


