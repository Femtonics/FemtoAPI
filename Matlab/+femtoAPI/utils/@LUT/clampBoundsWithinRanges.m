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

function clampBoundsWithinRanges( obj )
%CLAMPBOUNDSWITHINRANGES Summary of this function goes here
%   Detailed explanation goes here

rangeLowerBound = obj.m_rangeLowerBound ;
rangeUpperBound = obj.m_rangeUpperBound ;
vecBounds = obj.m_vecBounds ;
vecColors = obj.m_vecColors ;

if(~isempty(vecBounds))
    if( rangeUpperBound <= vecBounds(1) )
        obj.reset(obj.m_vecColors(1));
        return;
    elseif( vecBounds(end) <=  rangeLowerBound )
        obj.reset(obj.m_vecColors(end));
        return;
    else
        % rangeBounds and vecBounds intersect:
        if( vecBounds(1) < rangeLowerBound )
            firstRemainingIdx = upper_bound(vecBounds, rangeLowerBound) - 1;
            %firstRemainingIdx = lower_bound(vecBounds, rangeLowerBound);
            
            if(vecBounds(firstRemainingIdx) ~= rangeLowerBound)
                vecColors(firstRemainingIdx) = obj.convertToColorValue(rangeLowerBound);
                vecBounds(firstRemainingIdx) = rangeLowerBound;
            end
            
            if(firstRemainingIdx > 1)
                vecColors(1:firstRemainingIdx-1) = [];
                vecBounds(1:firstRemainingIdx-1) = [];
            end

        end
        
        if( rangeUpperBound < vecBounds(end) )        
            lastRemainingIdx = lower_bound(vecBounds, rangeUpperBound) ;
            
            if(vecBounds(lastRemainingIdx) ~= rangeUpperBound)
                vecColors(lastRemainingIdx) = obj.convertToColorValue(rangeUpperBound);
                vecBounds(lastRemainingIdx) = rangeUpperBound;
            end
            
            if( lastRemainingIdx < length(vecBounds) )
                vecColors(lastRemainingIdx+1:end) = [];
                vecBounds(lastRemainingIdx+1:end) = [];
            end            
        end
    end
end

obj.m_vecBounds = vecBounds;
obj.m_vecColors = vecColors;

end

