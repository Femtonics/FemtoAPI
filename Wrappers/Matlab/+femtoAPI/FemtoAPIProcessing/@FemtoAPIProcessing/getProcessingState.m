function getProcessingState(obj)
   
if(isempty(obj.m_connectionObj) || ~obj.m_connectionObj.m_isConnected)
    error(['Could not update processing state because not connected to',...
        ' the server. Please connect first.']);
end

processingState = femtoAPI('command', 'FemtoAPIFile.getProcessingState()');
validateattributes(processingState,{'cell'},{'vector','nonempty','numel',1});

% reinterpret encoding according to the encoding used at server side
processingState{1} = changeEncoding(processingState{1},obj.m_usedEncoding);

% decode json
obj.m_ProcessingState = HStruct(jsondecode(processingState{1}));

% wrap structs that contain 'handle' field
% into HStruct handle objects for data synchronization
%(nested HStructs and tree)
obj.buildProcessingStateHandle(obj.m_ProcessingState);

% build and store the processing state tree
obj.m_processingStateTreeObj = TreeWrapper(obj.m_ProcessingState);

% reset all date fields in processing state from UCT to local time
obj.changeDateTimeToLocal();
disp('Server processing state structure updated successfully.');

end

