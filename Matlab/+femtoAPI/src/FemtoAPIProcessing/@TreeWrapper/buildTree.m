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

function buildTree(obj, parentStruct, nodeID )
%BUILDTREE Helper function for building up local processing state tree
% Helper function that recursively traverses processing state nested 
% struct and adds each struct which was wrapped by HStruct object to the 
% tree. 
%

fnames = fieldnames(parentStruct.data);

% if struct contains handle, than add it to the tree
strcmp_res = strcmp('handle',fnames);
if(~isempty(strcmp_res) && any(strcmp_res == 1))
    [treeNodeData, childNodeID] = obj.m_tree.addnode(nodeID, parentStruct);
    obj.m_tree = treeNodeData;
else
    childNodeID = nodeID;
end

% extract nested structures and call buildTree recursively for them
for i=1:length(fnames)
     if(isa(parentStruct.data.(fnames{i}),'HStruct'))
        for j=1:length(parentStruct.data.(fnames{i}))            
            childStruct = parentStruct.data.(fnames{i})(j);
            % copy back the wrapped HStruct into proc. state stuct to achieve
            % that the tree and the original nested struct (mescState)
            % reference to the same data
            obj.buildTree(childStruct, childNodeID );
        end
    end
end

        
    
end



