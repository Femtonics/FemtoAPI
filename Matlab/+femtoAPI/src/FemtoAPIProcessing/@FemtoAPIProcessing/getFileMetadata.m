function [fileMetadata, fromCache] = getFileMetadata(obj, fileHandle, varargin)
%UNTITLED6 Summary of this function goes here
%   Detailed explanation goes here

narginchk(2,3);

% validate sessionHandle
validateattributes(fileHandle,{'numeric'},{'scalar','nonnegative',...
    'integer'},mfilename,'fileHandle');

if nargin == 2
    subscribeOrUnSubscribe = "";
else
    validatestring(varargin{1},{'subscribe', 'unsubscribe'},mfilename,...
        'subscribeOrUnSubsrcibe');
    subscribeOrUnSubscribe = string(varargin{1});
end

[fileMetadata, fromCache] = obj.getMetadataHelper('FemtoAPIFile.getFileMetadata', ...
    fileHandle, subscribeOrUnSubscribe);

end



