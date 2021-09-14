function createStructHandles(obj, parentStructHandle )
%CREATESTRUCTHANDLES Creates handle structure from complex embedded structure

validateattributes(parentStructHandle,{'struct'},{'nonempty','vector'});
fnames = fieldnames(parentStructHandle);

%obj.m_mescStateHandles.(parentStructName) = HStruct(parentStruct);
%parentStructHandle = HStruct(parentStructHandle);

% extract nested structures and call buildTree recursively for them
for i=1:length(fnames)
    if(isstruct(parentStructHandle.(fnames{i})))
        for j=1:length(parentStructHandle.(fnames{i}))
            childStruct = parentStructHandle.data.(fnames{i})(j);
            childStructHandle = HStruct(childStruct);
            obj.createStructHandles(childStructHandle);
        end
    end
end



end





