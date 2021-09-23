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

function buildUiTreeFromFemtoAPITree(obj, parentUiNode, nodeID )
%UNTITLED26 Summary of this function goes here
%   Detailed explanation goes here
%import uiextras.jTree.*

% do not want 'channels' in tree view
if(isfield(obj.femtoApiTreeObj.getStructByNodeID(nodeID),'channels'))
    return;
end

% get children of current node, and add them to ui tree
iterator = obj.femtoApiTreeObj.m_tree.getchildren(nodeID);
if(isempty(iterator))
    return;
end

for i = 1:length(iterator)
    % only create new node when it is not a channel handle
    %fileHandle = obj.femtoApiTreeObj.getHandleByNodeID(iterator(i));
    structNodeRef = obj.femtoApiTreeObj.getStructByNodeID(iterator(i));
    fileHandle = structNodeRef.handle;
    %fileHandle = obj.mescapiTreeHandles(iterator(i));
    %fileHandle = cell2mat(obj.femtoApiTreeObj.m_handles.data(iterator(i)));
    nodeStr = strrep(strcat('(',sprintf('%d,',fileHandle),')'),',)',')');
    
    if(length(fileHandle) == 1 && isfield(structNodeRef,'path') )
        % no comment, place file name after handle string
        [~,filename,ext] = fileparts(structNodeRef.path);
        nodeStr = strcat([nodeStr,' ',filename,ext]);
    elseif(isfield(structNodeRef,'comment'))
        nodeStr = strcat([nodeStr,' ',structNodeRef.comment]);
    end
      
    childUiNode = uiextras.jTree.TreeNode('Name',nodeStr,'Parent',...
        parentUiNode,'Value',structNodeRef);
    
%     childUiNode = uiextras.jTree.TreeNode('Name',nodeStr,'Parent',...
%         parentUiNode,'Value',fileHandle);
    %childUiNode.Value = structNode;
    
    buildUiTreeFromFemtoAPITree(obj, childUiNode, iterator(i) );
end

end

