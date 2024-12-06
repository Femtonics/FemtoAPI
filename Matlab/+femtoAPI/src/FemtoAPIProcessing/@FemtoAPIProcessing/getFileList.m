function fileList = getFileList(obj, varargin)
%UNTITLED5 Summary of this function goes here
%   Detailed explanation goes here
narginchk(1,2);

if nargin == 1
    subscribeOrUnSubscribe = "";
else
    validatestring(varargin{1},{'subscribe', 'unsubscribe'},mfilename,...
        'subscribeOrUnSubsrcibe');
    subscribeOrUnSubscribe = varargin{1};
end

fileList = obj.femtoAPIMexWrapper('FemtoAPIFile.getFileList',subscribeOrUnSubscribe);
fileList = reshape(jsondecode(fileList), 1, []);
end

