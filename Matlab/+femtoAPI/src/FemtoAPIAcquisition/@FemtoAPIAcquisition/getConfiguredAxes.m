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

nonStandardAxes = obj.m_AcquisitionState.taskParametersPerSpace. ...
    common.focus.axisPositions.nonStandardAxes;
standardAxes = obj.m_AcquisitionState.taskParametersPerSpace. ...
    common.focus.axisPositions.standardAxes;

configuredAxisNames = strings(1,length(nonStandardAxes) + length(standardAxes));
for i=1:length(nonStandardAxes)
    configuredAxisNames(i) = nonStandardAxes{i}.axis;
end

for i=1:length(standardAxes)
    configuredAxisNames(length(nonStandardAxes) + i) = standardAxes{i}.axis;
end

end

