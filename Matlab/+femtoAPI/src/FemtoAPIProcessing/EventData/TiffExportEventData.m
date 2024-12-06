classdef TiffExportEventData < EventDataBase

    properties
        handle   % runtime unique handle of measurement unit
        name     % tiff unique id
        expected % number of frames to export
        percent  % progress of tiff export in percent
        current  % index of the currently exported frame
    end

    methods

        function obj = TiffExportEventData(eventStruct)

            obj@EventDataBase(eventStruct);

            if ~isfield(eventStruct, 'values') ...
                || ~isfield(eventStruct.values, 'name') ...
                || ~isfield(eventStruct.values, 'expected') ...
                || ~isfield(eventStruct.values, 'percent') ...
                || ~isfield(eventStruct.values, 'current') ...
                || ~isfield(eventStruct, 'nodeDescriptor')

               error('Invalid tiff event data');

            end

            obj.name     = eventStruct.values.name;
            obj.expected = eventStruct.values.expected;
            obj.percent  = eventStruct.values.percent;
            obj.current  = eventStruct.values.current;
            obj.handle   = str2num(regexprep(eventStruct.nodeDescriptor, '[\(\)]', ''));

        end

    end

end

