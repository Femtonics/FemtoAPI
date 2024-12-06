function succeeded = setFileMetadata(obj, fileHandle, fileMetadata)
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here
    
validateattributes(fileHandle,{'numeric'},{'scalar','nonnegative','integer'});
valueAsJSON = obj.jsonEncode_helper(fileMetadata);
succeeded = obj.femtoAPIMexWrapper('FemtoAPIFile.setFileMetadata',fileHandle, valueAsJSON);
succeeded = jsondecode(succeeded);

end

