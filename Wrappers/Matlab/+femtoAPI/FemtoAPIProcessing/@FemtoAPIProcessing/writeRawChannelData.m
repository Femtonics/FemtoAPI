function writeRawChannelData( obj, channelHandle, rawData, varargin )
%WRITERAWCHANNELDATA Writes raw channel data
% WRITERAWCHANNELDATA( obj, channelHandle, rawData, varargin ) writes
%   raw channel data from the channel specified by the 1xN(or Nx1) array
%   channelHandle, where the first N-1 element contains the node, and
%   the Nth element is the channel index.
%   One optional input subSlabSpec can be given, in the format
%   subSlabSpec = [min1, min2, ... ,minD]
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
%  rawData              - the raw data to write (no conversion is made on it)
%
%
% INPUTS [optional]:
%  subSlabSpec          - contains the min indices of each dimension
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
    channelHandle = reshape(channelHandle,1,[]);

    measMetaData = obj.getMeasurementMetaDataRef(channelHandle(1:end-1));
    if(~isfield(measMetaData.data,'dimensions'))
        error('The requested handle is not a measurement channel handle.');
    end
    dimensions = horzcat(measMetaData.data.dimensions.size);
    numOfDimensions = length(dimensions);
    if(~isvector(dimensions) || (numOfDimensions ~= 2 && numOfDimensions ~= 3 && numOfDimensions ~= 4))
        error('Currently this function works with 2D (X,Y), 3D (X,Y,Z) and 4D (X,Y,Z,t) data');
    end

    validateattributes(rawData,{'double','uint16'},{'nonempty'});
    validateattributes(ndims(rawData),{'double','uint16'},{'>',1,'<=',numOfDimensions});

    channel = obj.getMeasurementMetaDataRef(channelHandle);
    writeDataType = channel.data.dataType;

    % convert rawdata to the type of the channel to write
    if(strcmp(writeDataType,'double'))
        rawData = double(rawData);
    elseif(strcmp(writeDataType,'uint16'))
        rawData = uint16(rawData);
    else
        error(strcat("Not supported data type. Supported data types are ",...
            "'uint16'"," and ","'double'"));
    end


    q = char(39); % quote character
    sChannelHandle = strcat(q,num2str(channelHandle(1:end-1),'%d,'),num2str(channelHandle(end),'%d'''));
    rawData = rot90(rawData,-1);
    ImageStruct.Image = rawData;

    if numVarargs == 0
        if(numOfDimensions == 2) % extreme case: measurement contains 1 image
            numOfDimensions = 3;
        end
        
        % padding rawdata size to numOfDimensions
        sizeRawData = ones(1,numOfDimensions);
        sizeRawData(1:length(size(rawData))) = size(rawData);
        
        sFromDims = sprintf(strcat(q,repmat('%d,',1,numOfDimensions-1),'%d'''), zeros(1,numOfDimensions));
        sCountDims = sprintf(strcat(q,repmat('%d,',1,numOfDimensions-1),'%d'''), sizeRawData);

        res = femtoAPI('setMImageSlab', ImageStruct, sChannelHandle, sFromDims,...
            sCountDims);

    else
        % when subSlabSpec is present

        subSlabSpec = varargin{1};
        validateattributes(subSlabSpec,{'numeric'},{'nonempty','vector', ...
            'positive','integer'},mfilename, 'subSlabSpec');
        subSlabSpecDim = length(subSlabSpec);

        if(numOfDimensions == 2)
            if(subSlabSpecDim == 2)
                subSlabSpec(3) = 1;
                numOfDimensions = 3;
            elseif(subSlabSpecDim == 3 && subSlabSpec(3) == 1)
                numOfDimensions = 3;
            else
                error(strcat('In case of 2D array input, parameter subSlabSpec ',...
                    'must be 2D or 3D cell array, and in case of 3D array, the 3rd element must be 1.'));
            end
        elseif( numOfDimensions == 3 && subSlabSpecDim ~= 3)
            error(strcat('In case of 3D array input, parameter subSlabSpec must be 3D cell array.'));
        elseif(numOfDimensions == 4 && subSlabSpecDim ~= 4)
            error(strcat('In case of 4D array input, parameter subSlabSpec must be 4D cell array.'));
        end



        % subtract 1 because subSlabSpec follows Matlab's indexing (from 1)
        % but femtoAPI follows C style indexing (from 0)
        subSlabSpec = subSlabSpec - 1;
        sizeRawData = ones(1,numOfDimensions);
        sizeRawData(1:length(size(rawData))) = size(rawData);
        sFromDims = sprintf(strcat(q,repmat('%d,',1,numOfDimensions-1),'%d'''), subSlabSpec);
        sCountDims = sprintf(strcat(q,repmat('%d,',1,numOfDimensions-1),'%d'''), sizeRawData);

        res = femtoAPI('setMImageSlab',ImageStruct, sChannelHandle,...
            sFromDims, sCountDims);
    end

    if(~res)
        error('Error: could not write image data.');
    end

end

