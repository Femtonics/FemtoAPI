function [ result ] = createMultiLayerMUnit( obj, xDim, yDim, tDim, ...
    technologyType, referenceViewportJson )
%CREATEMULTILAYERMUNIT Creates new MultiLayer measurement unit. 
% Parameters xDim, yDim, tDim must be positive.
%
% Valid methodTypes are: 'multiRoiMultiCube', 'multiRoiSnake'. 
% 
% INPUTS [required]:
%  xDim                  positive int, measurement unit x resolution
%  yDim                  positive int, measurement unit y resolution
%  tDim                  positive int, number of timestamps
%  technologyType        string, type of measurement technology
%  referenceViewportJson string, reference viewport in json format                          
% 
%
% OUTPUT: 
%  result                struct that contains the following data:
%                          - addedMUnitIdx: the node descriptor (handle)
%                            of the created measurement unit, e.g. [32,0,1]
%                          - id: (char array), the command id 
%                          - succeeded: bool flag, means whether the synchronous 
%                            part of the command ended successfully or not 
%  
% Usage: 
%  obj.createMultiLayerMUnit(xDim, yDim, tDim, technologyType,...
%    referenceViewportJson);
%
% See also CREATETIMESERIESMUNIT CREATEZSTACKMUNIT 
% 

validateattributes(xDim,{'numeric'},{'scalar','positive','integer'});
validateattributes(yDim,{'numeric'},{'scalar','positive','integer'});
validateattributes(tDim,{'numeric'},{'scalar','positive','integer'});
validateattributes(technologyType,{'char'},{'vector','row'});
validateattributes(referenceViewportJson,{'char'},{'vector','row'});

result = obj.femtoAPIMexWrapper('FemtoAPIFile.createMultiLayerMUnit', xDim, yDim, ...
    tDim, technologyType, referenceViewportJson);

result = jsondecode(result{1});
result.addedMUnitIdx = str2num(result.addedMUnitIdx);

end

