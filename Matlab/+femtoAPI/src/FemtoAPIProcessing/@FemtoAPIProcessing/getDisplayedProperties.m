function props = getDisplayedProperties(obj, handle, detailed)
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here
validateattributes(handle,{'numeric'},{'vector','nonnegative',...
    'integer'},mfilename,'handle');

validateattributes(detailed,{'logical'},{'scalar'},mfilename,'detailed');

props = jsondecode(obj.femtoAPIMexWrapper('FemtoAPIFile.getDisplayedProperties', ...
    handle, detailed));

end

