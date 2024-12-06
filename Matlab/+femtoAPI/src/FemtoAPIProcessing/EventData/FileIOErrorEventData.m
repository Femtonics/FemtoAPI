classdef (ConstructOnLoad) FileIOErrorEventData < EventDataBase
    %FILEIOERROREVENTDATA Summary of this class goes here
    %   Detailed explanation goes here
    
    properties
        commandID
        errorMessage
        errorType
    end
    
    methods
        function obj = FileIOErrorEventData(eventStruct)
            %FILEIOERROREVENTDATA Construct an instance of this class
            %   Detailed explanation goes here
            obj@EventDataBase(eventStruct);
            
            obj.commandID = eventStruct.values.commandID;
            obj.errorMessage = eventStruct.values.errorMessage;
            obj.errorType = eventStruct.values.errorType;
            if isfield(eventStruct.values, 'nodeDescriptor')
                obj.addprop('handle');
                obj.handle = eventStruct.values.nodeDescriptor;
            end
        end
        
    end
end

