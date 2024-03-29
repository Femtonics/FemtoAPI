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

function colorArray = color4CToArray( colorAs4C, colorOrder )
%COLOR4CTOARRAY Converts color as 4 components to array. 
%   Detailed explanation goes here
Color.validate4CStruct(colorAs4C);
validateattributes(colorAs4C,{'struct'},{'vector'});
if isrow(colorAs4C)
    colorAs4C = colorAs4C';
end

colorArray = zeros(length(colorAs4C),4);
for i=1:length(colorAs4C)
    if(strcmp(colorOrder,'ARGB'))
        colorArray(i,:) = [colorAs4C(i).alpha colorAs4C(i).red colorAs4C(i).green colorAs4C(i).blue];
    else
        colorArray(i,:) = [colorAs4C(i).red colorAs4C(i).green colorAs4C(i).blue colorAs4C(i).alpha];
    end
end

end

