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

function colorAsUint32 = color4CToUint32(colorsAs4C, colorOrder)
%COLOR4CTOUINT32 Converts color as 4 components to uint32 
% colorsAs4C is a struct array, where every row is made of 4 components: 
% [red green blue alpha]
%

Color.validate4CStruct(colorsAs4C);
validatestring(colorOrder,{'ARGB','RGBA'},'color4CToUint32','colorOrder');
isARGB = strcmp(colorOrder,'ARGB');

colorAsUint32 = uint32(zeros(size(colorsAs4C)));
[~, ~, endian] = computer;
isLittleEndian = (endian == 'L');

for i=1:length(colorsAs4C(:))
    if(isARGB)
        colorValues = [colorsAs4C(i).alpha colorsAs4C(i).red colorsAs4C(i).green colorsAs4C(i).blue];
    else
        colorValues = [colorsAs4C(i).red colorsAs4C(i).green colorsAs4C(i).blue colorsAs4C(i).alpha];
    end
    
    if(isLittleEndian)
        colorAsUint32(i) = swapbytes(typecast(colorValues,'uint32'));
    else
        colorAsUint32(i) = typecast(colorValues,'uint32');
    end
end


end
