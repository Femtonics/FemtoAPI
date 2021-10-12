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
    dataToSend = obj.jsonEncode_helper(obj.m_processingState);
elseif numVarargs == 1
    if(isnumeric(varargin{1}))
        handle = varargin{1};
        dataToSend = obj.getMeasurementMetaDataRef(handle);
        if(isfield(dataToSend.data,'type') && strcmp(dataToSend.data.type,'data'))
            % handle is a channel handle -> send the
            % measurement metaData in JSON, which has this channel
            dataToSend = obj.getMeasurementMetaDataRef(handle(1:end-1));
        end
        dataToSend = obj.jsonEncode_helper(dataToSend.data);
    elseif(isa(varargin{1},'HStruct'))
        if(isfield(varargin{1}.data,'type') && strcmp(varargin{1}.data.type,'data'))
            % in case of channel, get the measurement handle
            channelHandle = varargin{1}.data.handle;
            dataToSend = obj.getMeasurementMetaDataRef(channelHandle(1:end-1));
            dataToSend = obj.jsonEncode_helper(dataToSend.data);
        else
            dataToSend = obj.jsonEncode_helper(varargin{1}.data);
        end
    elseif(isstruct(varargin{1}))
        if(isfield(varargin{1},'type') && strcmp(varargin{1}.type,'data'))
            % in case of channel, get the measurement handle
            channelHandle = varargin{1}.handle;
            dataToSend = obj.getMeasurementMetaDataRef(channelHandle(1:end-1));
            dataToSend = obj.jsonEncode_helper(dataToSend.data);
        else
            dataToSend = obj.jsonEncode_helper(varargin{1});
        end
    elseif(ischar(varargin{1}))
        dataToSend = varargin{1};
    else
        error(usage); 
    end
else
    error(usage); 
end

dataToSend = strcat('var taskParams = ','''',dataToSend,'''',';FemtoAPIFile.setProcessingState(taskParams)');
succeeded = femtoAPI('command',dataToSend);
succeeded = jsondecode(succeeded{1});

end


