function rawChannelData = readRawChannelData( obj, channelHandle, varargin )
%READRAWCHANNELDATA Reads raw channel data
%   rawChannelData = READRAWCHANNELDATA( obj, channelHandle, varargin )
%   reads raw channel data from the channel specified by the 1xN(or Nx1) array
%   channelHandle, where the first N-1 element contains the node, and
%   the Nth element is the channel index.
%   If no optional inputs are given, it reads and returns all data from the
%   specified channel.
%   One optional input can be given, in D dimensional cell array of vectors 
%   containing the chosen elements from each dimension, for example 
%   {[fromDim0:2:toDim0],[fromDim1:toDim1], ... ,[fromDimD-1:toDimD-1]}
%   where 1 <= fromDimD < toDimD <= number of dimensions of the specified
%   channel. 
%   In this case, only the part of the channel data will be read.
%   Currently this function works with 3D and 4D data (D=3 or D=4).
%
%
% INPUTS [required]:
%  channelHandle        - N element array which contains channel information
%                         (first N-1 element is the node and the Nth is the
%                         channel index)
%
% INPUTS [optional]:
%  subSlabSpec          - contains the min and max indices of each dimension
%                         to read in cell array
%                         example: {[fromDim0:2:toDim0],[fromDim1:toDim1], ..., [fromDimD-1:toDimD-1]}
%
% OUTPUT:
%  rawChannelData       - the raw data read from the specified channel
%
% See also writeRawChannelData
%


    numVarargs = length(varargin);
    if numVarargs > 1
        error('Too many input arguments');
    end

    validateattributes(channelHandle,{'numeric'},{'vector','nonnegative','integer'});
    channelHandle = reshape(channelHandle,1,[]);
    if(length(channelHandle) < 4)
            error('The requested handle is not a measurement channel handle.');
    end
    measMetaData = obj.getMeasurementMetaDataRef(channelHandle(1:end-1));

    if(~isfield(measMetaData.data,'dimensions'))
        error('The requested handle is not a measurement channel handle.');
    end
    dimensions = horzcat(measMetaData.data.dimensions.size);
    numOfDimensions = length(dimensions);


    if(~isvector(dimensions) || (numOfDimensions ~= 2 && numOfDimensions ~= 3 && numOfDimensions ~= 4))
        error('Currently this function works with 2D (X,Y), 3D (X,Y,Z) and 4D (X,Y,Z,T) data');
    end
    channel= obj.getMeasurementMetaDataRef(channelHandle);
    readDataType = channel.data.dataType;

    if(strcmp(readDataType,'double'))
        isDouble = 1;
    elseif(strcmp(readDataType,'uint16'))
        isDouble = 0;
    else
        error(char(strcat("Not supported data type. Supported data types are ",...
            "'uint16'"," and ","'double'")));
    end

    q = char(39); % quote character
    sChannelHandle = strcat(q,num2str(channelHandle(1:end-1),'%d,'),num2str(channelHandle(end),'%d'''));

    if numVarargs == 0
        % all raw data is taken from the specified channel
        if(numOfDimensions == 2) % channel contains 1 image
           dimensions(3) = 1;
           numOfDimensions = 3;
        end
        
        sFromDims = sprintf(strcat(q,repmat('%d,',1,numOfDimensions-1),'%d'''), zeros(1,numOfDimensions));
        sCountDims = sprintf(strcat(q,repmat('%d,',1,numOfDimensions-1),'%d'''), dimensions);


        rawChannelData = femtoAPI('getMImageSlab', sChannelHandle, sFromDims, sCountDims, isDouble);
        rawChannelData = rawChannelData.Image;
    else
        % when subSlabSpec is present (can be 2D, 3D, and 4D)    
        subSlabSpec = varargin{1};
        validateattributes(subSlabSpec,{'cell'},{'nonempty','vector'});
        subSlabSpecDim = length(subSlabSpec);

        if(numOfDimensions == 2)
            if(subSlabSpecDim == 2)
                subSlabSpec{3} = 1;
                numOfDimensions = 3;
            elseif(subSlabSpecDim == 3 && subSlabSpec{3} == 1) 
                numOfDimensions = 3;  
            else
                error(strcat('In case of 2D array input, parameter subSlabSpec ',...
                'must be 2D or 3D  cell array, and in case of 3D array, the 3rd element must be 1.'));
            end    
        elseif( numOfDimensions == 3 && subSlabSpecDim ~= 3)
                error(strcat('In case of 3D array input, parameter subSlabSpec must be 3D cell array'));
        elseif( numOfDimensions == 4 && subSlabSpecDim ~= 4)
                error(strcat('In case of 4D array input, parameter subSlabSpec must be 4D cell array.'));
        end


        for i=1:numOfDimensions
            validateattributes(subSlabSpec{i},{'numeric'},{'nonempty','vector',...
                'positive','integer','increasing'});
        end

        minMaxs = zeros(numOfDimensions,2);
        for i=1:numOfDimensions
            % subtract 1 because subSlabSpec follows Matlab's indexing (from 1)
            % but MEScAPI follows C style indexing (from 0) 
            minMaxs(i,:) = [min(subSlabSpec{i}) max(subSlabSpec{i})] - 1;
        end

        fromDims = minMaxs(:,1);
        fromDims = reshape(fromDims,1,[]);
        countDims = minMaxs(:,2) - minMaxs(:,1) + 1;
        countDims = reshape(countDims,1,[]);

        sFromDims = sprintf(strcat(q,repmat('%d,',1,numOfDimensions-1),'%d'''), fromDims);
        sCountDims = sprintf(strcat(q,repmat('%d,',1,numOfDimensions-1),'%d'''), countDims);

        rawChannelData = femtoAPI('getMImageSlab',sChannelHandle,sFromDims, sCountDims, isDouble);    
        rawChannelData = rawChannelData.Image;

        % check the expected dimension size and the one get from read data are
        % equal -> countDims can be greater than dimension of image
    %     if(numOfDimensions ~= numel(rawChannelData))
    %         error('The expected dimension size and the read dimension size are not equal.');
    %     end

        % crop subslabspec to rawChannelData dimensions 
        ndimsChannelData = ndims(rawChannelData);
        if ndimsChannelData == 2 
            subSlabSpec{1} = find(subSlabSpec{1} <= dimensions(1));
            subSlabSpec{2} = find(subSlabSpec{2} <= dimensions(2));
            rawChannelData = rawChannelData(subSlabSpec{1},subSlabSpec{2});
        elseif ndimsChannelData == 3
            subSlabSpec{1} = find(subSlabSpec{1} <= dimensions(1));
            subSlabSpec{2} = find(subSlabSpec{2} <= dimensions(2));        
            subSlabSpec{3} = find(subSlabSpec{3} <= dimensions(3));
            rawChannelData = rawChannelData(subSlabSpec{1},subSlabSpec{2},subSlabSpec{3});      
        elseif ndimsChannelData == 4
            subSlabSpec{1} = find(subSlabSpec{1} <= dimensions(1));
            subSlabSpec{2} = find(subSlabSpec{2} <= dimensions(2));        
            subSlabSpec{3} = find(subSlabSpec{3} <= dimensions(3));
            subSlabSpec{4} = find(subSlabSpec{4} <= dimensions(4));
            rawChannelData = rawChannelData(subSlabSpec{1},subSlabSpec{2},subSlabSpec{3},subSlabSpec{4});         
        else
           error("Invalid data dimension."); % should not reach here  
        end
    end
  
    rawChannelData = rot90(rawChannelData); 
end




