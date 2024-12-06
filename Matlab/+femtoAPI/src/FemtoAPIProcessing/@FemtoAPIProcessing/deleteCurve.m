function result = deleteCurve( obj, unitHandle, curveIdx)
%DELETECURVE Deletes a curve.
% Deletes a curve in the measurement unit given by 'unitHandle',
% at index 'curveIdx' 
%
% See also WRITECURVE READCURVE CURVEINFO
% 

validateattributes(unitHandle,{'numeric'},{'vector','nonnegative','integer'}, ...
    'deleteCurve','unitHandle');
validateattributes(curveIdx,{'numeric'},{'scalar','nonnegative','integer'} ...
    ,'deleteCurve','curveIdx');

result = obj.femtoAPIMexWrapper('FemtoAPIFile.deleteCurve', unitHandle, curveIdx);
result = jsondecode(result);
end

