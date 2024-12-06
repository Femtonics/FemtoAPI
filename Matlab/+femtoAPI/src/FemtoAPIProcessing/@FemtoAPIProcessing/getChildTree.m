function childTree = getChildTree(obj,varargin)
%UNTITLED3 Summary of this function goes here
%   Detailed explanation goes here

narginchk(1,2); % check input arguments min, max values

if nargin == 1
    rootItemHandle = [];
else
    validateattributes(varargin{1},{'numeric'},{'vector','nonnegative',...
    'integer'},mfilename,'rootItemHandle');
    rootItemHandle = varargin{1};
end
    
result = obj.femtoAPIMexWrapper('FemtoAPIFile.getChildTree',rootItemHandle);
childTree = jsondecode(result);

end
