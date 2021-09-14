classdef DeviceValues
    %DEVICEVALUES Class for managing PMT/Laserintensity device values
    % This is a helper class for easier handling of setting/getting 
    % device values. 
    
    properties (Constant, Hidden)
        deviceValuesStructFieldNames = {'min','max','name','value','space'};
    end
    
    properties (SetAccess = private)
        m_deviceValueMap containers.Map % Map of device name - value pairs
    end
    
    methods
        function obj = DeviceValues(deviceValues)
            %DEVICEVALUES Construct an instance of DeviceValues
            % Validates the input struct array, which have to contain structs 
            % with fields: 
            %  - min: minimum device value 
            %  - max: maximum device value 
            %  - value: current device value
            %  - name: device name 
            %  - space: space name, which the device configured for 
            % 
            % If validity check was successful, stores device name - value 
            % pairs in a map, and contructs a DeviceValues object.
            %
            if(isempty(deviceValues))
                warning('Device values struct is empty');
                obj.m_deviceValueMap = containers.Map;
            else
                obj.validateDeviceValuesStruct(deviceValues);
            end
            
            deviceNames = cell(size(deviceValues));
            for i=1:length(deviceValues)
                deviceNames{i} = deviceValues(i).name;
            end
            
            obj.m_deviceValueMap = containers.Map(deviceNames, num2cell(deviceValues));
        end
        
        function deviceNames = getDeviceNames(obj)
            %GETDEVICENAMES Gets device names as cell array
            deviceNames = obj.m_deviceValueMap.keys;
            deviceNames = deviceNames(:);
        end
        
        function index = getDeviceIndexByName(obj, deviceName)
            %GETDEVICEINDEXBYNAME Gets device indexes by name
            obj.validateDeviceName(deviceName);
            index = cellfun(@(x)isequal(x,deviceName),obj.m_deviceValueMap.keys);
            index = find(index);
        end
        
        function deviceValuesStructArray = getDeviceValuesStructArray(obj)
            %GETDEVICEVALUESSTRUCTARRAY Gets device values as struct array
            deviceValuesStructArray = cell2mat(obj.m_deviceValueMap.values);
            deviceValuesStructArray = deviceValuesStructArray(:);
        end
        
        function deviceValuesCellArray = getDeviceValuesCellArray(obj)
            deviceValuesCellArray = obj.m_deviceValueMap.values;
        end
        
        function obj = setDeviceValueByName(obj,deviceName,deviceValue)
            %SETDEVICEVALUEBYNAME Sets a device value based on its name
            validateattributes(deviceName,{'char'},{'row'},'setDeviceValueByName',...
                'deviceName');
            validateattributes(deviceValue,{'double'},{'scalar'},'setDeviceValueByName',...
                'deviceValue');
            if(~obj.m_deviceValueMap.isKey(deviceName))
                error('Device name is not valid');
            end
            if(~obj.m_deviceValueMap.isKey(deviceName))
                error('Invalid device name');
            end
            deviceValuesStruct = obj.m_deviceValueMap(deviceName);
            deviceValuesStruct.value = deviceValue;
            obj.m_deviceValueMap(deviceName) = deviceValuesStruct;
        end
        
        function deviceValue = getDevicePropertyByName(obj,deviceName,propertyName)
            %GETDEVICEPROPERTYBYNAME Gets the requested property of named
            % device
            if(~obj.m_deviceValueMap.isKey(deviceName))
                error('Invalid device name');
            end
            deviceValueStruct = obj.m_deviceValueMap(deviceName);
            if(~isfield(deviceValueStruct,propertyName))
                error('Invalid property name');
            end
            deviceValue = deviceValueStruct.(propertyName);
        end
        
        function deviceValue = getDevicePropertyByIndex(obj,propertyName,index)
            %GETDEVICEPROPERTYBYINDEX Gets requested property by index
            deviceNames = obj.getDeviceNames;
            deviceName = deviceNames{index};
            deviceValue = obj.getDevicePropertyByName(deviceName,propertyName);
        end
        %        % TODO implement if needed
        %        function setDevicePropertyByName(obj,deviceName,propertyName, newValue)
        %
        %        end
        %% Property setters and validators
        function obj = set.m_deviceValueMap( obj, deviceValuesMap )
            obj.validateDeviceValueMap(deviceValuesMap);
            obj.m_deviceValueMap = deviceValuesMap;
        end
        
        function validateDeviceValueMap(obj,deviceValuesMap)
            %VALIDATEDEVICEVALUEMAP Validates device value map
            
            % validate values
            deviceValuesStruct = cell2mat(deviceValuesMap.values);
            validateDeviceValuesStruct( obj, deviceValuesStruct );
            % validate keys
            keys = deviceValuesMap.keys;
            validateattributes(keys,{'cell'},{'vector'});
            for i=1:length(keys)
                validateattributes(keys{i},{'char'},{'row'});
            end
        end
        
        function validateDeviceName(obj,deviceName)
            %VALIDATEDEVICENAME Validates device name
            validatestring(deviceName,obj.m_deviceValueMap.keys);
        end
        
        
        function validateDeviceValuesStruct(~,deviceValues)
            % VALIDATEDEVICEVALUESSTRUCT Validates device values struct
            % It must contain min, max, value, space fields
            validateattributes(deviceValues,{'struct'},{'vector'},...
                'validateDeviceValuesStruct','deviceValuesStruct');
            
            for i=1:length(deviceValues)
                % deviceValues struct must contain 'name', 'min', 'max',
                % 'value' fields
                if(~isequal(sort(fieldnames(deviceValues(i)))',sort(DeviceValues.deviceValuesStructFieldNames)))
                    error(strcat('Input parameter ''deviceValuesStruct'' must contain ''min'',',...
                        ' ''max'', ''name'', ''value'' and ''space'' fields'));
                end
                validateattributes(deviceValues(i).name,{'char'},{'row'},...
                    'validateDeviceValuesStruct','name');
                validateattributes(deviceValues(i).value,{'double'},{'scalar'},...
                    'validateDeviceValuesStruct','value');
                validateattributes(deviceValues(i).min,{'double'},{'scalar'},...
                    'validateDeviceValuesStruct','min');
                validateattributes(deviceValues(i).max,{'double'},{'scalar'},...
                    'validateDeviceValuesStruct','max');
            end
        end
        
        % obj.m_deviceValueMap.values(indices) -> obj(indices)
        % obj.m_deviceValueMap.values(indices).(propertyName) ->  obj(indices).(propertyName)
        function varargout = subsref(obj,s)
            switch s(1).type
                case '.'
                    [varargout{1:nargout}] = builtin('subsref',obj,s);
                case '()'
                    if length(s) == 1
                        % Implement obj(indices)
                        if(numel(s(1).subs) ~= 1)
                            error('Not a valid indexing expression');
                        end
                       deviceName = obj.getDevicePropertyByIndex('name',cell2mat(s(1).subs));
                       deviceName1{1} = deviceName;
                       varargout = obj.m_deviceValueMap.values(deviceName1);
         
                    elseif length(s) == 2 && strcmp(s(2).type,'.')
                    % Implement obj(ind).PropertyName
                        if(obj.m_deviceValueMap.isempty)
                            varargout = [];
                        end
                       deviceName = obj.getDevicePropertyByIndex('name',cell2mat(s(1).subs));
                       deviceName1{1} = deviceName; 
                       deviceStruct = cell2mat(obj.m_deviceValueMap.values(deviceName1));
                       varargout{1} = deviceStruct.(s(2).subs);
                    else
                    % Use built-in for any other expression
                    [varargout{1:nargout}] = builtin('subsref',obj,s);
                    end
                otherwise
                    error('Not a valid indexing expression')
            end
        end
    end
end
    
