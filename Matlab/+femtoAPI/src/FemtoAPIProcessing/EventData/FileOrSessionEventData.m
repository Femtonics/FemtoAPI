classdef (ConstructOnLoad) FileOrSessionEventData < EventDataBase
    %UNTITLED5 Summary of this class goes here
    %   Detailed explanation goes here
    
    properties
        handle
    end
    
    methods
        function obj = FileOrSessionEventData(eventStruct)
            %UNTITLED5 Construct an instance of this class
            %   Detailed explanation goes here
            obj@EventDataBase(eventStruct);
            
            if isfield(eventStruct,'nodeDescriptor')
                obj.handle = str2num(regexprep(eventStruct.nodeDescriptor,'[\(\)]',''));
            else
                error("Session event data should contain 'nodeDescriptor'");
            end

        end
       
    end
end

