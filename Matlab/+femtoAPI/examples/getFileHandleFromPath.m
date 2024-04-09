%apiobj: object containing an estabilished femtoapi connection
function handle = getFileHandleFromPath(apiobj, filePath)
	fileHandles = apiobj.getFileList();
	handle = [];
	for fileHandle = fileHandles
    	fileMetadata = apiobj.getFileMetadata(fileHandle);
        path = string(fileMetadata.path);
        if path == filePath
        	handle = fileHandle;
            return;
        end
    end
	handle = 0;
    return;
end