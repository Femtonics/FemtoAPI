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

function [ channelData_converted ] = convertChannelToRGBA(obj, channelData )
%CONVERTCHANNELTOARGB Converts channel data based on the color LUT
%   Converts 2D channel data array into an RGBA image, based on
%   the color LUT. 

vecBounds = obj.m_vecBounds;

%dataTypes = {'uint16','double'};
dataTypes = {'numeric'};
validateattributes(channelData,dataTypes,{'2d','nonempty'});
channelData = double(channelData);

% converted data contains 4 components: alpha(A), red(R), green(G), blue(B)
channelData_converted = zeros(size(channelData,1),size(channelData,2),4);

if(isempty(vecBounds))
    return;
end

vecColors = vertcat(obj.m_vecColors);

%channelData_converted = zeros(size(A,1),size(A,2),4);


% mask = vecBounds(end) <= img;
% channelData_converted(mask(:,:,[1,1,1,1])) = vecColors(end).m_colorAsARGBArray;
% 
% mask = vecBounds(1) >= img;
% channelData_converted(mask(:,:,[1,1,1,1])) = vecColors(1).m_colorAsARGBArray;

% handle the case when size(m_vecBound) == 1 too
% set values that are out of bounds to boundaries
channelData(channelData >= vecBounds(end)) = vecBounds(end);
channelData(channelData <= vecBounds(1)) = vecBounds(1);

[lutSize,~] = size(vecColors);
colorArray = double(vertcat(vecColors.m_colorAsRGBAArray));

% interpolate color by channels
%channelData = double(channelData);
% red channel
channelData_converted(:,:,1) = interp1(vecBounds,colorArray(:,1),channelData);
% green channel
channelData_converted(:,:,2) = interp1(vecBounds,colorArray(:,2),channelData);
% blue channel
channelData_converted(:,:,3) = interp1(vecBounds,colorArray(:,3),channelData);
% alpha channel
channelData_converted(:,:,4) = interp1(vecBounds,colorArray(:,4),channelData);

% scale values between 0 and 1
channelData_converted = channelData_converted ./ 255;


end



