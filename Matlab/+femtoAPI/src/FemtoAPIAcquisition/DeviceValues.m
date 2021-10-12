% Copyright ©2021. Femtonics Ltd. (Femtonics). All Rights Reserved.
% Permission to use, copy, modify this software and its documentation for
% educational, research, and not-for-profit purposes, without fee and
% without a signed licensing agreement, is hereby granted, provided that
% the above copyright notice, this paragraph and the following two
% paragraphs appear in all copies, modifications, and distributions.
% Contact info@femtonics.eu for commercial licensing opportunities.
% 
% IN NO EVENT SHALL FEMTONICS BE LIABLE TO ANY PARTY FOR DIRECT, INDIRECT,
% SPECIAL, INCIDENTAL, OR CONSEQUENTIAL DAMAGES, INCLUDING LOST PROFITS,
% ARISING OUT OF THE USE OF THIS SOFTWARE AND ITS DOCUMENTATION, EVEN IF
% FEMTONICS HAS BEEN ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
% 
% FEMTONICS SPECIFICALLY DISCLAIMS ANY WARRANTIES, INCLUDING, BUT NOT
% LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A
% PARTICULAR PURPOSE. THE SOFTWARE AND ACCOMPANYING DOCUMENTATION, IF ANY,
% PROVIDED HEREUNDER IS PROVIDED "AS IS". FEMTONICS HAS NO OBLIGATION TO
% PROVIDE MAINTENANCE, SUPPORT, UPDATES, ENHANCEMENTS, OR MODIFICATIONS.

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
                deviceValues = obj.validateDeviceValuesStruct(deviceValues);
            end
            
            deviceNames = horzcat(deviceValues(:).name);
            obj.m_deviceValueMap = containers.Map(deviceNames, num2cell(deviceValues));
        end
        
        
        function deviceNames = getDeviceNames(obj)
            %GETDEVICENAMES Gets device names as cell array
            deviceNames = obj.m_deviceValueMap.keys;
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
            
            deviceName = convertCharsToStrings(deviceName);
            validateattributes(deviceName,{'string'},{'scalar'}, ...
                'setDeviceValueByName', ...
                'deviceName');
            
            validateattributes(deviceValue,{'double'},{'scalar'}, ...
                'setDeviceValueByName',...
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
            
            deviceName = convertCharsToStrings(deviceName);
            
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
            deviceName  = deviceNames{index};
            deviceValue = obj.getDevicePropertyByName(deviceName,propertyName);
        end

        
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
            
            if ~obj.m_deviceValueMap.isKey( deviceName )
                error('Invalid device name.');
            end
            
        end
        
        
        function deviceValues = validateDeviceValuesStruct(~,deviceValues)
            % VALIDATEDEVICEVALUESSTRUCT Validates device values struct
            % It must contain min, max, value, space fields
            validateattributes(deviceValues,{'struct'},{'vector'},...
                'validateDeviceValuesStruct','deviceValuesStruct');
            
            for i=1:length(deviceValues)
                % deviceValues struct must contain 'name', 'min', 'max',
                % 'value' fields
                if ~isequal(sort(fieldnames(deviceValues(i)))', ... 
                        sort(DeviceValues.deviceValuesStructFieldNames)) 
                    
                    error(strcat('Input parameter ''deviceValuesStruct'' must contain ''min'',',...
                        ' ''max'', ''name'', ''value'' and ''space'' fields'));
                    
                end
                [ deviceValues(i).name, deviceValues(i).space ]  = ...
                    convertCharsToStrings(deviceValues(i).name, ...
                                          deviceValues(i).space);
                
                validateattributes(deviceValues(i).name,{'string'},{'scalar'},...
                    'validateDeviceValuesStruct','name');
                
                validateattributes(deviceValues(i).space,{'string'},{'scalar'},...
                    'validateDeviceValuesStruct','space');
                
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
        
        % obj.m_deviceValueMap.values(indices) = val -> obj(indices) = val
        % obj.m_deviceValueMap.values(indices).propertyName = val ->
        % obj(indices).propertyName = val
        function obj = subsasgn(obj,s, val)
            switch s(1).type
                case '.'
                    obj = builtin('subsasgn',obj,s,val);
                case '()'
                    if length(s) == 1
                        % Implement obj(indices) = val
                        if(numel(s(1).subs) ~= 1)
                            error('Not a valid indexing expression');
                        end
                        
                        validateattributes(s(1).subs, 'numeric', {'scalar', ...
                            'positive','integer'});                        
                        val = obj.validateDeviceValuesStruct(val);
                        obj.m_deviceValueMap(s(1).subs) = val;
         
                    elseif length(s) == 2 && strcmp(s(2).type,'.')
                    % Implement obj(ind).PropertyName
                       deviceName = obj.getDevicePropertyByIndex('name', ...
                           cell2mat(s(1).subs));
                       deviceNameAsCell{1} = deviceName; 
                       deviceStruct = cell2mat(obj.m_deviceValueMap.values(deviceNameAsCell));
                       deviceStruct.(s(2).subs) = convertCharsToStrings(val);
                       obj.m_deviceValueMap(deviceName) = deviceStruct;
                    else
                    % Use built-in for any other expression
                        obj = builtin('subsasgn', obj, s, val);
                    end
                otherwise
                    error('Not a valid indexing expression')
            end
        end        
    end
end
    
