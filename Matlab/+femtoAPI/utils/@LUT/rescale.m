% Copyright ©2021. Femtonics Kft. (Femtonics). All Rights Reserved. 
% Permission to use, copy, modify this software and its documentation for educational,
% research, and not-for-profit purposes, without fee and without a signed licensing agreement, is 
% hereby granted, provided that the above copyright notice, this paragraph and the following two 
% paragraphs appear in all copies, modifications, and distributions. Contact info@femtonics.eu
% for commercial licensing opportunities.
% 
% IN NO EVENT SHALL FEMTONICS BE LIABLE TO ANY PARTY FOR DIRECT, INDIRECT, SPECIAL, 
% INCIDENTAL, OR CONSEQUENTIAL DAMAGES, INCLUDING LOST PROFITS, ARISING OUT OF 
% THE USE OF THIS SOFTWARE AND ITS DOCUMENTATION, EVEN IF FEMTONICS HAS BEEN 
% ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
% 
% FEMTONICS SPECIFICALLY DISCLAIMS ANY WARRANTIES, INCLUDING, BUT NOT LIMITED TO, 
% THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR 
% PURPOSE. THE SOFTWARE AND ACCOMPANYING DOCUMENTATION, IF ANY, PROVIDED 
% HEREUNDER IS PROVIDED "AS IS". FEMTONICS HAS NO OBLIGATION TO PROVIDE 
% MAINTENANCE, SUPPORT, UPDATES, ENHANCEMENTS, OR MODIFICATIONS.

function obj = rescale( obj,newLowerBound, newUpperBound )
%RESCALE Rescales LUT based on the given lower/upper bounds.
%   Detailed explanation goes here

validateattributes(length(obj.m_vecBounds),{'numeric'},{'>',1})
validateattributes(newLowerBound,{'double'},{'scalar','>=',obj.m_rangeLowerBound});
validateattributes(newUpperBound,{'double'},{'scalar','<=',obj.m_rangeUpperBound});

if(newLowerBound >= newUpperBound)
    error('MATLAB:notGreater','Range upper bound must be greater than range lower bound');
end

oldLowerBound = obj.m_vecBounds(1);
oldUpperBound = obj.m_vecBounds(end);

if(oldLowerBound == newLowerBound && oldUpperBound == newUpperBound)
    return;
end
 
stretch = (newUpperBound - newLowerBound) / (oldUpperBound - oldLowerBound);
obj.m_vecBounds = clamp(obj.m_rangeLowerBound,...
    newLowerBound + stretch * (obj.m_vecBounds - oldLowerBound), ...
    obj.m_rangeUpperBound);

% eliminate duplicate elements
obj.m_vecBounds = unique(obj.m_vecBounds);


end

