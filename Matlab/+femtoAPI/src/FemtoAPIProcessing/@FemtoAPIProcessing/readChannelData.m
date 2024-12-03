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

function channelData = readChannelData( obj, channelHandle, readDataType, varargin )
%READCHANNELDATA Reads converted channel data
%   channelData = READCHANNELDATA( obj, channelHandle, readDataType, varargin )
%   reads converted channel data from the channel specified by the 1xN(or Nx1) array
%   channelHandle, where the first N-1 element is the unit handle, and
%   the Nth element is the channel index.
%   If no optional inputs are given, it reads and returns all data from the
%   specified channel.
%   To read part of channel data, two optional array inputs can be given:
%   'fromDims' contains the begin indices to read from in each dimension, 
%   and 'countDims' contains the number of pixels to read in each dimnesion. 
%
%   Each element of 'fromDims' must be smaller than the corresponding dimension
%   of the image, otherwise an error is thrown.
%   If 'fromDims' + 'countDims' >= [dim1,dim2,..dimN] (N is the dimension 
%   of the image), then 'countDims' will be croppped on server side to met 
%   the condition: 'fromDims' + 'countDims' = [dim1,dim2,..dimN].
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
%  fromDims             - array that contains indices in each dimension to 
%                         start read data from. If not given, it reads data 
%                         from the beginning in each dimensions.  
%
%  countDims            - array that contains the number of pixels to read
%                         in each image dimension
%
% OUTPUT:
%  channelData          - the converted data read from the specified channel
%
% See also readRawChannelData writeChannelData
%

narginchk(3,5);

validateattributes(channelHandle,{'numeric'},{'vector','nonnegative','integer'});
channelHandle = reshape(channelHandle,1,[]);

validatestring(readDataType,["uint16","double"],mfilename,"readDataType");
readDataType = string(readDataType);
if readDataType == "double"
    isDouble = 1;
else
    isDouble = 0;
end

fromDims = [];
countDims = [];

numVarargs = length(varargin);
if numVarargs >= 1
    fromDims = varargin{1};
end
if numVarargs == 2 
    countDims = varargin{2};
end

rawChannelData = obj.readRawChannelData(channelHandle,fromDims, countDims);

% read conversion data, than convert the read raw channel data
channelInfo = obj.getUnitMetadata(channelHandle(1:end-1),'ChannelInfo');
channelIdx = channelHandle(end)+1; % +1 because of matlab indexing 
conversion = channelInfo.channels(channelIdx).conversion;
limits = conversion.limits;
title = conversion.title;
unitName = conversion.unitName;

switch(conversion.type)
    case 'Identity'
        conversionObj = ConversionIdentity;
    case 'LinearMapping'
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

