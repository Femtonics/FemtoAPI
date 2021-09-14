function result = deleteChannel(obj,channelHandle)
%DELETECHANNEL Deletes the given channel
% Deletes the channel given by channelHandle. If there is no channel with
% the given handle, or it is in wrong format, an error message is returned.
% 
% INPUT: 
%  channelHandle      row/column array, represents a channel handle on the
%                     server
% OUTPUT:
%   result           struct, it contains the following values: 
%                     - id: (char array), the command id 
%                     - succeeded: bool flag, means whether the synchronous 
%                        part of the command ended successfully or not        
%
% Example: 
%  obj.deleteChannel([34 0 1 2]) -> deletes the channel with index 2 from 
%                                   mUnit with handle [34 0 1]
% 
% See also ADDCHANNEL GETSTATUS
%

validateattributes(channelHandle,{'numeric'},{'vector','nonnegative','integer'});
channelHandle = reshape(channelHandle,1,[]);
channelString = strcat(num2str(channelHandle(1:end-1),'%d,'),num2str(channelHandle(end))); 
q = char(39); % quote character
result = femtoAPI('command',strcat('FemtoAPIFile.deleteChannel(',q,channelString,q,')'));
result{1} = changeEncoding(result{1},obj.m_usedEncoding);
result = jsondecode(result{1});

end

