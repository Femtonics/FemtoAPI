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

function [ colorsAsHex ] = colorArrayToHex( colorArray, colorOrder )
%COLORARRAYTOHEX Converts color array to hex char array.
% Converts a color as array of uint8 numbers to hex char array, taking into 
% account the color order (ARGB or RGBA). 
% 
% INPUTS:
%  colorArray (array of uint8)       contains the R,G,B, and optionally A 
%                                    color components
%
%  colorOrder (char array)           must be 'RGBA' or 'ARGB'                      
%
% OUTPUT: 
%  colorAsHex (char array)           color represented as hex:
%                                    #AARRGGBB, #RRGGBBAA, or #RRGGBB 
%

LUTColorValueAttribs = {'nonempty','2d','>=',0,'<=',255};
validateattributes(colorArray,{'uint8'},LUTColorValueAttribs);
if(size(colorArray,2) ~=3 && size(colorArray,2) ~= 4)
    error('Color array must have 3(represent RGB) or 4 (represent ARGB or RGBA) columns');
end
validatestring(colorOrder,{'ARGB','RGBA'},'colorArrayToHex','colorOrder');
isARGB = strcmp(colorOrder,'ARGB');

% if contains only 3 columns (RGB), append/prepend it with default alpha
% value according to color order
if(size(colorArray,2) == 3)
   alpha = repmat(Color.m_defaultAlphaValue,size(colorArray,1),1); 
   if(isARGB)
       colorArray = [alpha colorArray];  
   else
       colorArray = [colorArray alpha];
   end
end

colorsAsHex(:,2:9) = reshape(sprintf('%02X',colorArray.'),8,[]).'; 
colorsAsHex(:,1) = '#';