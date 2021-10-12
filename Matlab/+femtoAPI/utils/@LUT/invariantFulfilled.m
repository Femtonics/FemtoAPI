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

function invariantFulfilled(obj)
%INVARIANTFULLFILLED Checks whether the LUT invariant is fullfilled. 
%
% Can be used for checking the validity of the LUT object when some member
% values are modified. If the modified LUT object is invalid, then throws
% an appropriate error message, otherwise nothing happens.
% 
% Usage: 
%   lutObject.invariantFullfilled();
%   
% 
% See also setRangeBounds, setRangeLowerBound, setRangeUpperBound
%
validateattributes(obj.m_vecColors,{'Color'},{'vector'},'','obj.m_vecColors');
validateattributes(obj.m_vecBounds,{'double'},{'vector'},'','obj.m_vecBounds');

if(~isequal(size(obj.m_vecColors),size(obj.m_vecBounds)) )
    error('Error: size of color and value matrices are different!');
end
if( obj.m_rangeLowerBound > obj.m_rangeUpperBound )
    error('Error: color data range lower bound should be less than or equal than upper bound!');
end

if(~isempty(obj.m_vecBounds))
    % check whether the LUT invariant is fulfilled
    validateattributes(obj.m_vecBounds(1),{'double'},{'>=',obj.m_rangeLowerBound },'','obj.m_vecBounds(1)');
    validateattributes(obj.m_vecBounds(end),{'double'},{'<=',obj.m_rangeUpperBound},'','obj.m_vecBounds(end)');
    validateattributes(obj.m_vecBounds,{'double'},{'increasing'},'','obj.m_vecBounds');
end

end