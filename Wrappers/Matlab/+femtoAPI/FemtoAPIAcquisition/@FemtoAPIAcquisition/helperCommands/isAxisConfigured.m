function isConfigured = isAxisConfigured( obj,axisName )
%ISAXISCONFIGURED Tells whether the input axis name is valid or not. 
% 
% INPUT: 
%  axisName             char array or string, name of the axis to check 
% 
% OUTPUT: 
%  isConfigured         bool, true if axis is configured, false otherwise
%
% See also GETCONFIGUREDAXES
% 
    if(~ischar(axisName) && ~isstring(axisName))
        error('Input argument, ''axisName'' must be char array or string (array)');
    end

    isConfigured = all(ismember(axisName, obj.getConfiguredAxes()));
end

