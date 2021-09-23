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

function validateLUTStructure(obj,LUTStruct)
%p = inputParser;

% check whether only the required fields are present in LUT
% struct
% checkAllLUTStructFieldsArePresent = @(x) isstruct(x) && isequal(fieldnames(x)',LUT.LUTStructFieldNames) && ...
%     isstruct(x.entries) && ...
%     isequal(ismember(fieldnames(x.entries)',LUT.LUTEntryFieldNames),ones(size(LUT.LUTEntryFieldNames)));
%
% addRequired(p,'LUTStruct', checkAllLUTStructFieldsArePresent);
% parse(p,LUTStruct);

validateattributes(LUTStruct,{'struct'},{'scalar'},'validateLUTStructure','LUTStruct');

% LUT struct must contain 'entries' and 'range' fields
if(~all(ismember(fieldnames(LUTStruct)',LUT.LUTStructFieldNames)))
    error('Input parameter LUTStruct must contain ''entries'' and ''range'' fields');
elseif(~isstruct(LUTStruct.entries))
    error('LUTStruct.entries must be a struct');
elseif(~isequal(ismember(fieldnames(LUTStruct.entries)',LUT.LUTEntryFieldNames),ones(size(LUT.LUTEntryFieldNames))))
    error('LUTStruct.entries struct must have only ''color'' and ''value'' fields');
end


% check whether the LUT structure ranges are valid
%attributes = {'vector','numel',2,'nonnegative','increasing'};
validateattributes(LUTStruct.range,LUT.LUTRangeBoundValueTypes,...
    LUT.LUTRangeBoundValueAttribs,'','LUTStruct.range');

% LUTStruct.entries must be an Nx1 struct
validateattributes(LUTStruct.entries,{'struct'},{'vector'},'','LUTStruct.entries');

% check whether LUT color values are valid
% color : char array with hex numbers, syntax: #AARRGGBB, where A-alpha, R-red, G-green, B-blue components
for i=1:length(LUTStruct.entries)
    [startIdx, endIdx] = regexp(LUTStruct.entries(i).color, LUT.LUTColorAttribs,'start','end');
    
    if(~isequal([startIdx, endIdx],[1 9]))
        error(['The parameter',' LUTStruct.entries',num2str(i,'(%d)'),'.color',' is invalid.']);
    end
end

% check whether the LUT invariant is fulfilled
% validateattributes(LUTStruct.entries(1).value,LUT.LUTRangeBoundValueTypes,{'>=',LUTStruct.range(1)},'','LUTStruct.entries(1).value');
% validateattributes(LUTStruct.entries(end).value,LUT.LUTRangeBoundValueTypes,{'<=',LUTStruct.range(2)},'','LUTStruct.entries(end).value');
% validateattributes(horzcat(LUTStruct.entries(:).value),LUT.LUTRangeBoundValueTypes,{'increasing'},'','LUTStruct.entries(:).value');

validateattributes(horzcat(LUTStruct.entries(:).value),LUT.LUTRangeBoundValueTypes,{'increasing'},'','LUTStruct.entries(:).value');
validateattributes(LUTStruct.entries(1).value,LUT.LUTRangeBoundValueTypes,{'scalar'},'','LUTStruct.entries(1).value');
validateattributes(LUTStruct.entries(end).value,LUT.LUTRangeBoundValueTypes,{'scalar'},'','LUTStruct.entries(end).value');

% % initialize properties
% obj.m_rangeLowerBound = LUTStruct.range(1);
% obj.m_rangeUpperBound = LUTStruct.range(2);
% obj.m_vecBounds = vertcat(LUTStruct.entries.value);
% 
% colors = string(vertcat(LUTStruct.entries.color));
% obj.m_vecColors = repmat(Color,size(colors));
% 
% for i=1:length(obj.m_vecBounds)
%     obj.m_vecColors(i) = Color(colors(i), obj.m_defaultColorOrder);
% end
% 
% % check LUTStruct.entries(1).value >= rangeLowerBound and LUTStruct.entries(end).value <=rangeUpperBound
% % -> if not, clamp values within ranges
% if(obj.m_vecBounds(1) < obj.m_rangeLowerBound || obj.m_vecBounds(end) > obj.m_rangeUpperBound)
%    obj.clampBoundsWithinRanges();
% end

end