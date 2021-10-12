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

function colorMapAsHex = colorMapToHex(colormap,colorOrder)
%COLORMAPTOHEX Converts colormap with 3 (RGB) or 4 (RGBA or ARGB) columns
% to hex. In the colormap, every row represents a new color.
% If it contains only 3 columns, then all color in it will be appended 
% with alpha = 255.
% Values in colormap must be between 0 and 1. 
% colorOrder must be 'RGBA' or 'ARGB'. If only 3 components (RGB) is used
% in 
% 
% Example: 
%  colorMap = [1 1 0;1 0 0;0 1 0] % yellow, red and green colors
%  colorMapAsHex = colorMapToHex(colormap,'RGB')
%
%
validateattributes(colormap,{'numeric'},{'nonempty','nonempty','2d','>=',0,'<=',1});
if(size(colormap,2) ~=3 && size(colormap,2) ~= 4)
    error('color map must have 3(represent RGB) or 4 (represent ARGB or RGBA) columns');
end

% colormap values are in [0,1] -> coinvert them to 0..255 
colorValueMap = uint8(colormap*255);
colorMapAsHex = Color.colorArrayToHex(colorValueMap,colorOrder);

end

