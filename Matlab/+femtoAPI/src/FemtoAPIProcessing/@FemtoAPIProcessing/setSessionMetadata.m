function succeeded = setSessionMetadata(obj,sessionHandle, value)
%SETSESSIONMETADATA Sets session metadata field 
%  

validateattributes(sessionHandle,{'numeric'},{'vector','nonnegative','integer'});
valueAsJSON = obj.jsonEncode_helper(value);
succeeded = obj.femtoAPIMexWrapper('FemtoAPIFile.setSessionMetadata', sessionHandle, ...
    valueAsJSON);
succeeded = jsondecode(succeeded);

end

