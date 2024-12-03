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

%ADDCHANNEL Adds channel with spcified name to an existing measurement unit
% The nodeDescriptor must be an index of a valid, opened measurement unit
% on the server side, otherwise this function gives an error.
%
% INPUTS [required]:
%   nodeDescriptor              measurement unit index, where channel will
%                               be added to, e.g. [54,0,1]
%
%   channelName                 name of the channel to be added, e.g. 'UG'
%
% INPUTS [optional]:
%   compressionPreset           integer, type of compression preset
% 
%   channelDataType             string, type of channel data, its value 
%                               can be "uint16" or "double"     
%
% OUTPUT:
%   result                struct that contains the following data:
%                          - addedChannelIdx: the concatenation of 'nodeDescriptor'
%                             and the the index of the new channel that has
%                             been added, e.g. [54,0,1,0]
%                          - id: (char array)
%                          - succeeded: synchronous part ended successfully
%
% Example:
%  If [54,0,1] is an index of an already opened measurement unit:
%  result = obj.addChannel([54,0,1],'UG')
%
% See also DELETECHANNEL CREATEMEASUREMENTUNIT
%

narginchk(3,5);

validateattributes(nodeDescriptor,{'numeric'},{'vector','nonnegative','integer'});
validateattributes(channelName,{'char'},{'vector','row'});

if nargin == 3 

    result = obj.femtoAPIMexWrapper('FemtoAPIFile.addChannel',nodeDescriptor, channelName);     

elseif nargin == 4
    
    compressionPreset = varargin{1};
    validateattributes(compressionPreset,{'numeric'},{'scalar','nonnegative','integer'});
    result = obj.femtoAPIMexWrapper('FemtoAPIFile.addChannel',nodeDescriptor, channelName, compressionPreset);  
    
else 
    
    compressionPreset = varargin{1};
    channelDataType   = varargin{2};
    channelDataType   = convertCharsToStrings(channelDataType);

    validateattributes(compressionPreset,{'numeric'},{'scalar','nonnegative','integer'});
    validateattributes(channelDataType,{'string'},{'scalar'});
    result = obj.femtoAPIMexWrapper('FemtoAPIFile.addChannel',nodeDescriptor, ... 
        channelName, compressionPreset, channelDataType);     
    
end

result = jsondecode(result);
result.addedChannelIdx = str2num(result.addedChannelIdx);

end
