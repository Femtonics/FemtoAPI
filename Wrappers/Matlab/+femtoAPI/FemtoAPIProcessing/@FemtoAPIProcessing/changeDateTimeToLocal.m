function changeDateTimeToLocal(obj)
%CHANGEDATETIMETOLOCAL Change datetimes to local time
% Change all datetimes in server's processing state tree to local time
%
% It loops through the opened files, and set created, modified, saved times:
% 
% processing_state_root -> currentDate
% processing_state_root->openedFiles -> created, modified, saved
% processing_state_root->openedFiles -> measurementSessions 
%                      -> measurements -> date
% 

treeObj = obj.m_processingStateTreeObj;
fieldNames = [{'currentDate'},{'created'},{'modified'},{'saved'},{'date'}];

% iterate on nodeIDs, and do func
for j = 1:length(fieldNames)
    nodeIDs = find(treeObj.m_tree.treefun(@(x) isfield(x.data,fieldNames{j})));
    for i = nodeIDs
        treeObj.m_tree.Node{i}.data.(fieldNames{j}) = convertDateTimeToLocal(treeObj.m_tree.Node{i}.data.(fieldNames{j}));
    end
end

end

