function buildTree(obj, parentStruct, nodeID )
%UNTITLED4 Summary of this function goes here
%   Detailed explanation goes here

% TODO commented validateattributes for performance reasons
%validateattributes(parentStruct,{'HStruct'},{'nonempty'});

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
            % copy back the wrapped HStruct into mescState stuct to achieve
            % that the tree and the original nested struct (mescState)
            % reference to the same data
            obj.buildTree(childStruct, childNodeID );
        end
    end
end

        
    
end



