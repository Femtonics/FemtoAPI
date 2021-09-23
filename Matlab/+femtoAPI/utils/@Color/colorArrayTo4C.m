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

function [ colorAs4C ] = colorArrayTo4C( colorArray, colorOrder )
%COLORARRAYTO4C Converts color array to 4 components struct
%   

    LUTColorValueAttribs = {'nonempty','2d','ncols',4,'>=',0,'<=',255};
    validateattributes(colorArray,{'uint8'},LUTColorValueAttribs);
    validatestring(colorOrder,{'ARGB','RGBA'},'colorArrayTo4C','colorOrder');
    isARGB = strcmp(colorOrder,'ARGB');

    numOfColors = size(colorArray,1);
    colorAs4C(1:numOfColors,1) = struct('alpha',0,'red',0,'green',0,'blue',0);

    for i=1:numOfColors
        colorArray(i,:) = uint8(colorArray(i,:));
        if(isARGB)
            colorAs4C(i).alpha = colorArray(i,1);
            colorAs4C(i).red = colorArray(i,2);
            colorAs4C(i).green = colorArray(i,3);
            colorAs4C(i).blue = colorArray(i,4);
        else 
            colorAs4C(i).red = colorArray(i,1);
            colorAs4C(i).green = colorArray(i,2);
            colorAs4C(i).blue = colorArray(i,3);  
            colorAs4C(i).alpha = colorArray(i,4);
        end
    end

end

