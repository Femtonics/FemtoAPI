function [unitMetadata, fromCache] = getUnitMetadata(obj, unitHandle, itemTypeStr, varargin)
%UNTITLED6 Summary of this function goes here
%   Detailed explanation goes here

narginchk(3,4);
% validate unitHandle
validateattributes(unitHandle,{'numeric'},{'vector','nonnegative',...
    'integer'},mfilename,'unitHandle');

% validate itemType
validateattributes(itemTypeStr,{'char'},{'row'},mfilename,'itemTypeStr');

if nargin == 3 
    subscribeOrUnSubscribe = "";
else
    validatestring(varargin{1},{'subscribe', 'unsubscribe'},mfilename,...
        'subscribeOrUnSubsrcibe');
    subscribeOrUnSubscribe = string(varargin{1});
end

if subscribeOrUnSubscribe ~= "unsubscribe" && ...
        obj.m_metadataCache.containsKey(unitHandle,itemTypeStr)
    
    unitMetadata = obj.m_metadataCache.getMetadata(unitHandle,itemTypeStr);
    debug('Unit metadata get from cache');
    fromCache = true;
    return;
    
else 
    
    unitMetadata = obj.femtoAPIMexWrapper('FemtoAPIFile.getUnitMetadata',unitHandle, ...
        itemTypeStr,subscribeOrUnSubscribe);
    unitMetadata = jsondecode(unitMetadata);    
    fromCache = false;
    debug('Unit metadata get from server');

    if subscribeOrUnSubscribe == "subscribe"
        obj.m_metadataCache.setMetadata(unitHandle, itemTypeStr, unitMetadata);
    elseif subscribeOrUnSubscribe == "unsubscribe"
        obj.m_metadataCache.removeKey(unitHandle, itemTypeStr);
    end
    
end

end

