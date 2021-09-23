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

function validate4CStruct( colorsAs4C )
%VALIDATE4CSTRUCT Validates color as 4 components
%   Detailed explanation goes here

p = inputParser;
color4Components = {'alpha','red','green','blue'};
LUTColorValueAttribs = {'integer','>=',0,'<=',255};
LUTColorValueTypes = {'numeric'};

% check whether only the required fields are present in LUT
% struct
checkAllColorComponentFieldsArePresent = @(x) isstruct(x) && ...
    isequal(ismember(fieldnames(colorsAs4C)',color4Components), ones(size(color4Components)));

addRequired(p,'colorsAs4C', checkAllColorComponentFieldsArePresent);
parse(p,colorsAs4C);

for i=1:length(colorsAs4C(:))
    validateattributes(colorsAs4C(i).alpha,LUTColorValueTypes,LUTColorValueAttribs,'','colorsAs4C.alpha');
    validateattributes(colorsAs4C(i).red,LUTColorValueTypes,LUTColorValueAttribs,'','colorsAs4C.red');
    validateattributes(colorsAs4C(i).green,LUTColorValueTypes,LUTColorValueAttribs,'','colorsAs4C.green');
    validateattributes(colorsAs4C(i).blue,LUTColorValueTypes,LUTColorValueAttribs,'','colorsAs4C.blue');
end

end

