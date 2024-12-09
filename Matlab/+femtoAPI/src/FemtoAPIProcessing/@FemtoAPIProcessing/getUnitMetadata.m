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

function [unitMetadata, fromCache] = getUnitMetadata(obj, unitHandle, itemTypeStr, varargin)
%UNTITLED6 Summary of this function goes here
%   Detailed explanation goes here

narginchk(3,4);
% validate unitHandle
validateattributes(unitHandle,{'numeric'},{'vector','nonnegative',...
    'integer'},mfilename,'unitHandle');

% validate itemType
validateattributes(itemTypeStr,{'char'},{'row'},mfilename,'itemTypeStr');

if nargin == 3 
    subscribeOrUnSubscribe = "";
else
    validatestring(varargin{1},{'subscribe', 'unsubscribe'},mfilename,...
        'subscribeOrUnSubsrcibe');
    subscribeOrUnSubscribe = string(varargin{1});
end

if subscribeOrUnSubscribe ~= "unsubscribe" && ...
        obj.m_metadataCache.containsKey(unitHandle,itemTypeStr)
    
    unitMetadata = obj.m_metadataCache.getMetadata(unitHandle,itemTypeStr);
    debug('Unit metadata get from cache');
    fromCache = true;
    return;
    
else 
    
    unitMetadata = obj.femtoAPIMexWrapper('FemtoAPIFile.getUnitMetadata',unitHandle, ...
        itemTypeStr,subscribeOrUnSubscribe);
    unitMetadata = jsondecode(unitMetadata);    
    fromCache = false;
    debug('Unit metadata get from server');

    if subscribeOrUnSubscribe == "subscribe"
        obj.m_metadataCache.setMetadata(unitHandle, itemTypeStr, unitMetadata);
    elseif subscribeOrUnSubscribe == "unsubscribe"
        obj.m_metadataCache.removeKey(unitHandle, itemTypeStr);
    end
    
end

end

