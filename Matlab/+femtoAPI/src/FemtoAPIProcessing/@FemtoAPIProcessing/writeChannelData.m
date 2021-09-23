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

function writeChannelData( obj, channelHandle, data, varargin )
%WRITECHANNELDATA Writes converted channel data
% WRITECHANNELDATA( obj, channelHandle, data, varargin ) writes
%   converted channel data from the channel specified by the 1xN(or Nx1) array
%   channelHandle, where the first N-1 element contains the node, and
%   the Nth element is the channel index.
%   One optional input subSlabSpec can be given, in the format 
%   subSlabSpec = [min1, min2, ÿ, minD]
%   which are the starting indices for each dimension of the given channel.
%   In this case, the part of the specified channel is written with the
%   input parameter data. If data begin at min indices specified by subSlabSpec
%   is out of a channel dimension, an error is thrown, and no data will be 
%   written.
%   If the optional subSlabSpec is not given, then subSlabSpec = [1, 1, ...,1] 
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
%  subSlabSpec          - contains the min indices of each dimension
%                         from start to write data in format 
%                         [min1, min2, ÿ, minD]
%
%
% See also WRITERAWCHANNELDATA, READCHANNELDATA, READRAWCHANNELDATA
%
numVarargs = length(varargin);
if numVarargs > 1
    error('Too many input arguments');
end
validateattributes(channelHandle,{'numeric'},{'vector','nonnegative','integer'});
channelHandle = reshape(channelHandle,1,[]);

measMetaData = obj.getMeasurementMetaDataRef(channelHandle(1:end-1));
dimensions = horzcat(measMetaData.data.dimensions.size);
numOfDimensions = length(dimensions);
if(~isvector(dimensions) || (numOfDimensions ~= 2 && numOfDimensions ~= 3))
    error('Currently this function works only with 2D (X,Y) and 3D data (X,Y,Z)');
end

validateattributes(data,{'double','uint16'},{'nonempty'});
validateattributes(ndims(data),{'double','uint16'},{'>',1,'<=',numOfDimensions});

% read conversion data
channel = obj.getMeasurementMetaDataRef(channelHandle);
conversion = channel.data.conversion;
limits = conversion.limits;
title = conversion.title;
unitName = conversion.unitName;

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

% reset limits, convert data according to conversion
conversionObj.resetLimitsFromDoubleValues(limits(1),limits(2));
if(strcmp(channel.data.dataType,'double'))
    rawData = conversionObj.invConvertToDouble(data);
else
    rawData = conversionObj.invConvertToUint16(data);
end

% write data
if(numVarargs == 1)
    subSlabSpec = varargin{1};
    writeRawChannelData( obj, channelHandle, rawData, subSlabSpec );
else
    writeRawChannelData( obj, channelHandle, rawData );
end

end

