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

function colorsAsFourComponent = colorUint32To4C(colorsAsUint32, colorOrder)
%COLORUINT32TO4C Converts color value as (A)RGB or RGB(A) uint32 to color as 4 components
%   represent uint32 colors as four component

validateattributes(colorsAsUint32,{'uint32'},{'nonempty'},'','colorsAsUint32');
validatestring(colorOrder,{'ARGB','RGBA',},'colorUint32To4C','colorOrder');
isARGB = strcmp(colorOrder,'ARGB');

if(isARGB)
    colorsAsFourComponent = repmat(struct('alpha',0,'red',0,'green',0,'blue',0),...
        size(colorsAsUint32));
else
    colorsAsFourComponent = repmat(struct('red',0,'green',0,'blue',0,'alpha',0),...
        size(colorsAsUint32));
end

[~, ~, endian] = computer;
isLittleEndian = (endian == 'L');

for i=1:length(colorsAsUint32(:))
    if(isLittleEndian)
        colorComponents = typecast(swapbytes(colorsAsUint32(i)),'uint8');
    else
        colorComponents = typecast(colorsAsUint32(i),'uint8');
    end
    
    if(isARGB)
        colorsAsFourComponent(i).alpha = colorComponents(1);    
        colorsAsFourComponent(i).red = colorComponents(2);
        colorsAsFourComponent(i).green = colorComponents(3);
        colorsAsFourComponent(i).blue = colorComponents(4);
    else     
        colorsAsFourComponent(i).red = colorComponents(1);
        colorsAsFourComponent(i).green = colorComponents(2);
        colorsAsFourComponent(i).blue = colorComponents(3);  
        colorsAsFourComponent(i).alpha = colorComponents(4);
    end
end

end
