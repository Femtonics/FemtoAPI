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

function [ colorAsUint32 ] = colorArrayToUint32( colorArray )
%COLORARRAYTOUINT32 Converts color array to uint32 format
%

colorValueAttribs = {'nonempty','2d','ncols',4,'>=',0,'<=',255};
validateattributes(colorArray,{'uint8'},colorValueAttribs);
    

colorAsUint32 = uint32(zeros(size(colorArray,1),1));

[~, ~, endian] = computer;
isLittleEndian = (endian == 'L');

if(isLittleEndian)
    for i=1:size(colorAsUint32,1)
        colorAsUint32(i) = swapbytes(typecast(colorArray(i,:),'uint32'));
    end
else
    for i=1:size(colorAsUint32,1)
        colorAsUint32(i) = typecast(colorArray(i,:),'uint32');
    end
end

end

