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

function [ colorObj ] = convertToColorValue( obj, val )
%CONVERTTOCOLORVALUE Converts value data to color value(s).
%   Converts value to color value(s). 
%   'val' can be:
%     - an uint16 or double value
%     - array of uint16 or double values

%vecBounds = obj.m_vecBounds;
%vecColors = vertcat(obj.m_vecColors.m_colorAsQRGBArray);
%vecColors = obj.m_vecColors;

dataTypes = {'uint16','double'};

if(isempty(obj.m_vecBounds))
    colorObj = Color(uint32(0), obj.m_colorOrder);
    return;
end

validateattributes(val,dataTypes,{'scalar','nonempty'});
%validateattributes(vecColors,{'uint32'},{'vector'} );
%validateattributes(vecBounds,dataTypes,{'size',size(vecColors)} );

% handle the case when size(m_vecBound) == 1 too
if(obj.m_vecBounds(end) <= val)
    colorObj = obj.m_vecColors(end);
    return;
end

if(obj.m_vecBounds(1) >= val)
    colorObj = obj.m_vecColors(1);
    return;
end

if(length(obj.m_vecBounds) == 2)
    idx1 = uint16(1);
    idx2 = uint16(2);
else
    idx2 = uint16(upper_bound(obj.m_vecBounds, val));
    idx1 = uint16(idx2 - 1);
end
    
factor = (val - obj.m_vecBounds(idx1)) / ( obj.m_vecBounds(idx2) - obj.m_vecBounds(idx1) );
colorComponentVec1 = double(obj.m_vecColors(idx1).m_colorAsArray);
colorComponentVec2 = double(obj.m_vecColors(idx2).m_colorAsArray);

%colorObj = vecColors(idx1) + factor * (vecColors(idx2) - vecColors(idx1));
%colorObj = uint8(colorComponentVec1) + uint8(factor * (colorComponentVec2 - colorComponentVec1) );

colorObj = uint8( colorComponentVec1 + round(factor * (colorComponentVec2 - colorComponentVec1)) ) ;
colorObj = Color(colorObj, obj.m_colorOrder);
end


