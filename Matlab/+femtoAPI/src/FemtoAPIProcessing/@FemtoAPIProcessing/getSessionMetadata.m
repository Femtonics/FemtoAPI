function [sessionMetadata, fromCache] = getSessionMetadata(obj, sessionHandle, varargin)
%UNTITLED6 Summary of this function goes here
%   Detailed explanation goes here

narginchk(2,3);

% validate sessionHandle
validateattributes(sessionHandle,{'numeric'},{'vector','nonnegative',...
    'integer'},mfilename,'unitHandle');

if nargin == 2
    subscribeOrUnSubscribe = "";
else
    validatestring(varargin{1},{'subscribe', 'unsubscribe'},mfilename,...
        'subscribeOrUnSubsrcibe');
    subscribeOrUnSubscribe = varargin{1};
end

[sessionMetadata, fromCache] = obj.getMetadataHelper('FemtoAPIFile.getSessionMetadata', ...
    sessionHandle, subscribeOrUnSubscribe);

end


