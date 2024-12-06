classdef CreateTiffResultEventData < EventDataBase
    
    properties
        state
        id
    end

    methods

        function obj = CreateTiffResultEventData(eventStruct)

            obj@EventDataBase(eventStruct);

            if ~isfield(eventStruct, 'values') ...
                || ~isfield(eventStruct.values, 'state') ...
                || ~isfield(eventStruct.values, 'id')

               error('Invalid tiff event data');

            end

            obj.state = eventStruct.values.state;
            obj.id    = eventStruct.values.id;
        end
       
    end

end

