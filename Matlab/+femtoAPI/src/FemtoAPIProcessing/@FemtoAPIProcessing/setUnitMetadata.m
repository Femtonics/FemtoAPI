function succeeded = setUnitMetadata(obj,unitHandle, itemStr, value)
%SETUNITMETADATA Sets unit metadata field 
%  
validateattributes(unitHandle,{'numeric'},{'vector','nonnegative','integer'});
validateattributes(itemStr,{'char'},{'vector','row'});
valueAsJSON = obj.jsonEncode_helper(value);
succeeded = obj.femtoAPIMexWrapper('FemtoAPIFile.setUnitMetadata',unitHandle, ...
    itemStr, valueAsJSON);
succeeded = jsondecode(succeeded);

end

