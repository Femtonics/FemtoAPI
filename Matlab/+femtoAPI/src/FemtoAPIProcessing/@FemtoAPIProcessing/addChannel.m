% Copyright ©2021. Femtonics Kft. (Femtonics). All Rights Reserved. 
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

function [ result ] = addChannel( obj, nodeDescriptor, channelName )
%ADDCHANNEL Adds channel with spcified name to an existing measurement unit
% The nodeDescriptor must be an index of a valid, opened measurement unit
% on the server side, otherwise this function gives an error.
%
% INPUTS:
%   nodeDescriptor              measurement unit index, where channel will
%                               be added to, e.g. [54,0,1]
%
%   channelName                 name of the channel to be added, e.g. 'UG'
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

validateattributes(nodeDescriptor,{'numeric'},{'vector','nonnegative','integer'});
validateattributes(channelName,{'char'},{'vector','row'});

nodeDescriptor = reshape(nodeDescriptor,1,[]);
nodeString = strcat(num2str(nodeDescriptor(1:end-1),'%d,'),num2str(nodeDescriptor(end)));


q = char(39); % quote character
result = femtoAPI('command',strcat('FemtoAPIFile.addChannel(',q,nodeString,q,...
    ',',q,channelName,q,')'));
result = jsondecode(result{1});
result.addedChannelIdx = str2num(result.addedChannelIdx);

end
