function [ hex ] = array2hex(colorAsArray)
% rgb2hex converts rgb color values to hex color format. 
% 
% This function assumes rgb values are in [r g b] format on the 0 to 1
% scale.  If, however, any value r, g, or b exceed 1, the function assumes
% [r g b] are scaled between 0 and 255. 
% 
% * * * * * * * * * * * * * * * * * * * * 
% SYNTAX:
% hex = rgb2hex(rgb) returns the hexadecimal color value of the n x 3 rgb
%                    values. rgb can be an array. 
% 
% * * * * * * * * * * * * * * * * * * * * 
% EXAMPLES: 
% 
% myhexvalue = rgb2hex([0 1 0])
%    = #00FF00
% 
% myhexvalue = rgb2hex([0 255 0])
%    = #00FF00
% 
% myrgbvalues = [.2 .3 .4;
%                .5 .6 .7; 
%                .8 .6 .2;
%                .2 .2 .9];
% myhexvalues = rgb2hex(myrgbvalues) 
%    = #334D66
%      #8099B3
%      #CC9933
%      #3333E6
% 
% * * * * * * * * * * * * * * * * * * * * 
% Chad A. Greene, April 2014
% 
% Updated August 2014: Functionality remains exactly the same, but it's a
% little more efficient and more robust. Thanks to Stephen Cobeldick for
% his suggestions. 
% 
% * * * * * * * * * * * * * * * * * * * * 
% See also hex2rgb, dec2hex, hex2num, and ColorSpec. 

%% Check inputs: 

assert(nargin>0&nargin<3,'This function requires a color array( ARGB, RGB, RGBA) input and optionally a color order') 
assert(isnumeric(colorAsArray)==1,'Function input must be numeric.') 

sizeColorArray = size(colorAsArray); 
assert(sizeColorArray(2)==3 || sizeColorArray(2) == 4,...
['rgb value must have three components in the form [r g b]', ...
' or four components [a r g b] or [r g b a].']);

assert(max(colorAsArray(:))<=255& min(colorAsArray(:))>=0,...
    'rgb(a) values must be on a scale of 0 to 1 or 0 to 255')

%% If no value in RGB exceeds unity, scale from 0 to 255: 
if max(colorAsArray(:))<=1
    colorAsArray = round(colorAsArray*255); 
else
    colorAsArray = round(colorAsArray); 
end

%% Convert (Thanks to Stephen Cobeldick for this clever, efficient solution):
if(sizeColorArray(2) == 3)
    hex(:,2:7) = reshape(sprintf('%02X',colorAsArray.'),6,[]).'; 
else
    hex(:,2:9) = reshape(sprintf('%02X',colorAsArray.'),8,[]).'; 
end

hex(:,1) = '#';


end

  

