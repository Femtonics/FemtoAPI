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

function writeRawChannelData( obj, channelHandle, rawData, varargin )
%WRITERAWCHANNELDATA Writes raw channel data
% WRITERAWCHANNELDATA( obj, channelHandle, rawData, varargin ) writes
%   raw channel data from the channel specified by the 1xN(or Nx1) array
%   channelHandle, where the first N-1 element contains the node, and
%   the Nth element is the channel index.
%   One optional input fromDims can be given, in the format
%   fromDims = [min1, min2, ... ,minD]
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
%  rawData              - the raw data to write (no conversion is made on it)
%
%
% INPUTS [optional]:
%  fromDims             - contains the min indices of each dimension
%                         from start to write data in format
%                         [min1, min2, ... , minD]
%
%
% See also WRITECHANNELDATA, READCHANNELDATA, READRAWCHANNELDATA
%

numVarargs = length(varargin);
if numVarargs > 1
    error('Too many input arguments');
end

validateattributes(channelHandle,{'numeric'},{'vector','nonnegative','integer'});
measMetadata = obj.getUnitMetadata(channelHandle(1:end-1),'BaseUnitMetadata');
numLogicalDims = length(measMetadata.logicalDimSizes);

validateattributes(rawData,{'double','uint16'},{'nonempty'});

channelInfo = obj.getUnitMetadata(channelHandle(1:end-1),'ChannelInfo');
channelIdx = channelHandle(end)+1; % +1 because of matlab indexing 
channel = channelInfo.channels(channelIdx);
writeDataType = channel.dataType;


% convert rawdata to the type of the channel to write
if(strcmp(writeDataType,'double') && ~isequal(class(rawData),'double'))
    rawData = double(rawData);
elseif(strcmp(writeDataType,'uint16') && ~isequal(class(rawData),'uint16'))
    rawData = uint16(rawData);
end


if numVarargs == 0
    % padding rawdata size to numOfDimensions
    sizeRawData = ones(1,numLogicalDims);
    sizeRawData(1:length(size(rawData))) = size(rawData);
    fromDims = zeros(1,numLogicalDims);
    countDims = sizeRawData;
    
    obj.femtoAPIMexWrapper('uploadAttachment',rawData);
    res = obj.femtoAPIMexWrapper('FemtoAPIFile.writeRawChannelDataFromAttachment', channelHandle, fromDims, countDims);
else
    % when fromDims is given
    fromDims = varargin{1};
    validateattributes(fromDims,{'numeric'},{'nonempty','vector', ...
        'positive','integer'},mfilename, 'fromDims');
  
    
    % subtract 1 because subSlabSpec follows Matlab's indexing (from 1)
    % but obj.femtoAPIMexWrapper follows C style indexing (from 0)
    fromDims = fromDims - 1;
    sizeRawData = ones(1,numLogicalDims);
    sizeRawData(1:length(size(rawData))) = size(rawData);

    countDims = sizeRawData;
    if( size(fromDims) ~= size(countDims) )
        error(strcat('Dimension of data to send and measurement unit ', ...
            'dimensions are different.'));
    end
    
    obj.femtoAPIMexWrapper('uploadAttachment',rawData);
    res = obj.femtoAPIMexWrapper('FemtoAPIFile.writeRawChannelDataFromAttachment', channelHandle, fromDims, countDims);    
end

if(~res)
    error('Error: could not write image data.');
end

end

