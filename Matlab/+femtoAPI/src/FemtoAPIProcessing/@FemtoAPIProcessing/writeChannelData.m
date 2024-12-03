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

function writeChannelData( obj, channelHandle, data, varargin )
%WRITECHANNELDATA Writes converted channel data
% WRITECHANNELDATA( obj, channelHandle, data, varargin ) writes
%   converted channel data from the channel specified by the 1xN(or Nx1) array
%   channelHandle, where the first N-1 element contains the node, and
%   the Nth element is the channel index.
%   One optional input fromDims can be given, in the format 
%   fromDims = [min1, min2, �, minD], 
%   which are the starting indices for each dimension of the given channel.
%   In this case, the part of the specified channel is written with the
%   input parameter data. If data begin at min indices specified by subSlabSpec
%   is out of a channel dimension, an error is thrown, and no data will be 
%   written.
%   If the optional fromDims is not given, then fromDims = [1, 1, ...,1] 
%   is used (according to Matlab indexing).
%   Currently this function works with 2D, 3D and 4D data. 
%
% INPUTS [required]:
%  channelHandle        - N element array which contains channel information
%                         (first N-1 element is the node and the Nth is the
%                         channel index)
%
%  data                 - the converted data to write
%
%
% INPUTS [optional]:
%  fromDims             - contains the min indices of each dimension
%                         from start to write data in format 
%                         [min1, min2, �, minD]
%
%
% See also WRITERAWCHANNELDATA, READCHANNELDATA, READRAWCHANNELDATA
%
numVarargs = length(varargin);
if numVarargs > 1
    error('Too many input arguments');
end
validateattributes(channelHandle,{'numeric'},{'vector','nonnegative','integer'});
validateattributes(data,{'double','uint16'},{'nonempty'});

% read conversion data
channelInfo = obj.getUnitMetadata(channelHandle(1:end-1),'ChannelInfo');
channelIdx = channelHandle(end)+1; % +1 because of matlab indexing 
channel = channelInfo.channels(channelIdx);
conversion = channel.conversion;

%conversion = channel.data.conversion;
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

% reset limits, convert data according to conversion
conversionObj.resetLimitsFromDoubleValues(limits(1),limits(2));
if(strcmp(channel.dataType,'double'))
    rawData = conversionObj.invConvertToDouble(data);
else
    rawData = conversionObj.invConvertToUint16(data);
end

% write data
if(numVarargs == 1)
    fromDims = varargin{1};
    writeRawChannelData( obj, channelHandle, rawData, fromDims );
else
    writeRawChannelData( obj, channelHandle, rawData );
end

end

