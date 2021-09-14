function succeeded = setProcessingState(obj,varargin)
%SETPROCESSINGSTATE Sets processing state on server. 
% Parses the input and filters the stored processing state based
% on it, then sends it to server.
%
% Currently, it can set the following values on server: 
%  - comment of measurement session/group/measurement 
%  - channel LUT/conversion  
%  - 'measurementParamsJSON' field of group/measurement
%  - 'isBeingRecorded' field of group/measurement
% 
% INPUT: 
%  Input can be one of the following: 
%   - none: the whole processing state is set on server
%   - a handle of measurement file/session/group/measurement/channel:  
%      the selected part of proc. state is set on server
%   - HStruct: part of processing state struct, obtained by 
%      getMeasurementMetaDataRef() function
%   - char array, part of processing state struct in JSON object, represents a 
%      file/session/group/measurement/channel
%
% OUTPUT:
%  Returns true if the sent data has been successfully set on server, false 
%  otherwise
%  It fails if the sent structure is invalid, or contains a handle that does 
%  not represent an open .mesc file.  
% 
% Examples: 
%  obj.setProcessingState(); -> sends whole struct to server
%  obj.setProcessingState([34,0]) -> sends the 
%
% See also GETPROCESSINGSTATE
%
numVarargs = length(varargin);
usage = ['Usage: input parameter must be one of the following values:\n',...
    '\t-none (the whole stored processing state is sent to the server)\n',...
    '\t-handle of a measurement file, session,group, measurement or channel\n',...
    '\t-structure (part of processing state structure)\n',...
    '\t-character array (part of processing state structure in JSON format)'];

if numVarargs == 0
    % whole processing state data is sent to server
    dataToSend = jsonencode(obj.m_mescProcessingState,'ConvertInfAndNaN',false);
elseif numVarargs == 1
    if(isnumeric(varargin{1}))
        handle = varargin{1};
        dataToSend = obj.getMeasurementMetaDataRef(handle);
        if(isfield(dataToSend.data,'type') && strcmp(dataToSend.data.type,'data'))
            % handle is a channel handle -> send the
            % measurement metaData in JSON, which has this channel
            dataToSend = obj.getMeasurementMetaDataRef(handle(1:end-1));
        end
        dataToSend = jsonencode(dataToSend.data,'ConvertInfAndNaN',false);
    elseif(isa(varargin{1},'HStruct'))
        if(isfield(varargin{1}.data,'type') && strcmp(varargin{1}.data.type,'data'))
            % in case of channel, get the measurement handle
            channelHandle = varargin{1}.data.handle;
            dataToSend = obj.getMeasurementMetaDataRef(channelHandle(1:end-1));
            dataToSend = jsonencode(dataToSend.data,'ConvertInfAndNaN',false);
        else
            dataToSend = jsonencode(varargin{1}.data,'ConvertInfAndNaN',false);
        end
    elseif(isstruct(varargin{1}))
        if(isfield(varargin{1},'type') && strcmp(varargin{1}.type,'data'))
            % in case of channel, get the measurement handle
            channelHandle = varargin{1}.handle;
            dataToSend = obj.getMeasurementMetaDataRef(channelHandle(1:end-1));
            dataToSend = jsonencode(dataToSend.data,'ConvertInfAndNaN',false);
        else
            dataToSend = jsonencode(varargin{1},'ConvertInfAndNaN',false);
        end
    elseif(ischar(varargin{1}))
        dataToSend = varargin{1};
    else
        error(usage); % TODO correct error message
    end
else
    error(usage); % TODO correct error message
end
%strrep(dataToSend,'\"','\\\"');
% convert 'Infinity' and '-Infinity' to double 
strrep(dataToSend, '-Infinity', num2str(realmin));
strrep(dataToSend, 'Infinity', num2str(realmax));
dataToSend = strcat('var taskParams = ','''',dataToSend,'''',';FemtoAPIFile.setProcessingState(taskParams)');

succeeded = femtoAPI('command',dataToSend);
succeeded{1} = changeEncoding(succeeded{1},obj.m_usedEncoding);
succeeded = jsondecode(succeeded{1});
%                 if( contains(succeed,'true') )
%                     disp('Processing state parameters were successfully set on server');
%                 else
%                     error(strcat('Could not set the following parameters on server:\n',ret));
%                 end

end


