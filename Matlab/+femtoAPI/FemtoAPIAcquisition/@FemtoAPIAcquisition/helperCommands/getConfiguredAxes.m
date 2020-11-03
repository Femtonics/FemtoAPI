function configuredAxisNames = getConfiguredAxes(obj)
%GETCONFIGUREDAXES Gets the configured axis names
% Returns the configured axis names, based on locally stored acquisition
% struct. Run getAcquisitionState() command before this. 
% 
% OUTPUT: 
%  configuredAxisNames           string array, contains configured (valid)
%                                axis names 
%
% See also GETACQUISITIONSTATE
%

    nonStandardAxes = obj.m_mescAcquisitionState.taskParametersPerSpace. ...
        Common.Focus.AxisPositions.NonStandardAxes;
    standardAxes = obj.m_mescAcquisitionState.taskParametersPerSpace. ...
        Common.Focus.AxisPositions.StandardAxes;

    configuredAxisNames = strings(1,length(nonStandardAxes) + length(StandardAxes));
    for i=1:length(nonStandardAxes)
        configuredAxisNames(i) = ...
            obj.m_mescAcquisitionState.taskParametersPerSpace.Common. ...
            Focus.AxisPositions.NonStandardAxes(i).Axis;
    end

    for i=1:length(standardAxes)
        configuredAxisNames(length(nonStandardAxes) + i) = ...
            obj.m_mescAcquisitionState.taskParametersPerSpace.Common. ...
            Focus.AxisPositions.StandardAxes(i).Axis;
    end

end

