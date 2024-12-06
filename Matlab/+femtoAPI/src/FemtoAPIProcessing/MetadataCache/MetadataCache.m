classdef MetadataCache < handle
    %UNTITLED2 Summary of this class goes here
    %   Detailed explanation goes here
    
    properties (Access = public)
        innerMap containers.Map
    end
    
    properties ( Constant)
        jsonItemTypes = {'BaseUnitMetadata', 'ReferenceViewport', ...
            'ChannelInfo', 'Roi', 'Points', 'Device', 'AxisControl', ...
            'UserData', 'AoSettings', 'IntensityCompensation', ...
            'CoordinateTuning', 'Protocol', 'MultiRoiProtocol', ...
            'CurveInfo', 'FullFrameParams', 'Modality', 'CameraSettings' };
    end
    
    methods
        function obj = MetadataCache()
            %UNTITLED2 Construct an instance of this class
            %   Detailed explanation goes here
            obj.innerMap = MapNested();
        end
        
        function metadata = getMetadata(obj, handle, varargin)
            %METHOD1 Summary of this method goes here
            %   Detailed explanation goes here
            handle = reshape(handle,1,[]);
            key = [obj.handleToKey(handle),varargin(:)];
            metadata = getValueNested(obj.innerMap, key);         
        end
        
        function setMetadata(obj, handle, varargin)
            validateattributes(handle,{'numeric'},{'vector','nonnegative','integer'});
            handle = reshape(handle,1,[]);
            newKey = [obj.handleToKey(handle),varargin(1:end-1)];
            debug("MetadataCache::setMetadata(): with key: ");
            debug(newKey); 
            obj.innerMap = setValueNested(obj.innerMap, ...
                    newKey, varargin{end});            
        end
        
        
        function ret = containsKey(obj, handle, varargin)            
            key = [obj.handleToKey(reshape(handle,1,[])),varargin(:)];
            ret = isKey(obj.innerMap,key);
        end
        
        function removeKey(obj, handle, varargin)
            key = [obj.handleToKey(reshape(handle,1,[])),varargin(:)];
            obj.innerMap(key) = [];
        end
        

        function removeKeyWithChildren(obj,rootHandle)
            rootKey = obj.handleToKey(rootHandle);
            for key = obj.innerMap.keys
                if startsWith(key,strcat(rootKey,' '))
                    obj.innerMap(key) = [];
                end
            end
        end
        
        function ret = keys(obj)
            ret = cellfun(@(x) obj.keyToHandle(x), obj.innerMap.keys, ...
                'UniformOutput', false);            
        end
        
        function ret = isEmpty(obj)
            ret = obj.innerMap.isempty;
        end
        
        function ret = size(obj)
            ret = obj.innerMap.length;
        end
    end
    
         
    methods( Static )
        function key = handleToKey(handle)
            key = num2str(handle);
        end
        
        function handle = keyToHandle(key)
           handle = str2num(key); 
        end
    end
end

