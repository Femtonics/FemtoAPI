% Copyright Â©2021. Femtonics Kft. (Femtonics). All Rights Reserved. 
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

function channelData = readChannelData( obj, channelHandle, readDataType, varargin )
%READCHANNELDATA Reads converted channel data
%   channelData = READCHANNELDATA( obj, channelHandle, readDataType, varargin )
%   reads converted channel data from the channel specified by the 1xN(or Nx1) array
%   channelHandle, where the first N-1 element contains the node, and
%   the Nth element is the channel index.
%   If no optional inputs are given, it reads and returns all data from the
%   specified channel.
%   One optional input can be given, in D dimensional cell array of vectors 
%   containing the chosen elements from each dimension: 
%   {[fromDim1:n1:toDim1],[fromDim2:n2:toDim2], ÿÿÿ, [fromDimD:nd:toDimD]}
%   where 1 <= fromDimD < toDimD <= number of dimensions of the specified
%   channel.
%   In this case, only the part of the channel data will be read.
%   Currently this function works only with 3D data (D=3).
%
% INPUTS [required]:
%  channelHandle        - N element array which contains channel information
%                         (first N-1 element is the node and the Nth is the
%                         channel index)
%
%  readDataType         - data type of the data to read (can be 'uint16' or
%                         'double')
%
% INPUTS [optional]:
%  subSlabSpec          - contains the min and max indices of each dimension
%                         to read in cell array
%                          { [fromDim0:n0:toDim0],[fromDim1:n1:toDim1], ÿÿÿ, [fromDimD-1:nk:toDimD-1] }
%
% OUTPUT:
%  channelData          - the converted data read from the specified channel
%
% See also writeChannelData
%
usage = strcat(['Usage: obj.readChannelData(channelHandle, readDataType) ',...
    'or obj.readChannelData(channelHandle, readDataType, subSlabSpec)']);
numVarargs = length(varargin);
if nargin > 4
    error(strcat('Too many input arguments. ',usage));
elseif nargin < 3
    error(strcat('Too few input arguments. ',usage));
end

validateattributes(channelHandle,{'numeric'},{'vector','nonnegative','integer'});
channelHandle = reshape(channelHandle,1,[]);

if(strcmp(readDataType,'double'))
    isDouble = 1;
elseif(strcmp(readDataType,'uint16'))
    isDouble = 0;
else
    error(char(strcat("Argument 2, read channel data type must be one of ",...
        "'uint16'"," or ","'double'")));
end

% read conversion data, than convert the read raw channel data
measMetaData = obj.getMeasurementMetaDataRef(channelHandle);
conversion = measMetaData.data.conversion;
limits = conversion.limits;
title = conversion.title;
unitName = conversion.unitName;

if(numVarargs == 1)
    subSlabSpec = varargin{1};
    rawChannelData = obj.readRawChannelData(channelHandle,subSlabSpec);
else
    rawChannelData = obj.readRawChannelData(channelHandle);
end


switch(conversion.type)
    case 'identity'
        conversionObj = ConversionIdentity;
    case 'linear'
        offset = conversion.offset;
        scale = conversion.scale;
        conversionObj = ConversionLinear(scale,offset,title,unitName);
    otherwise
        error('Conversion type is not supported or wrong type.');
end

% set limits and do the conversion depending on the read data type
conversionObj.resetLimitsFromDoubleValues(limits(1),limits(2));
if(isDouble)
    channelData = conversionObj.convertToDouble(rawChannelData);
else
    channelData = conversionObj.convertToUint16(rawChannelData);
end



end

