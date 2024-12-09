% Copyright ©2021. Femtonics Ltd. (Femtonics). All Rights Reserved.
% Permission to use, copy, modify this software and its documentation for
% educational, research, and not-for-profit purposes, without fee and
% without a signed licensing agreement, is hereby granted, provided that
% the above copyright notice, this paragraph and the following two
% paragraphs appear in all copies, modifications, and distributions.
% Contact info@femtonics.eu for commercial licensing opportunities.
% 
% IN NO EVENT SHALL FEMTONICS BE LIABLE TO ANY PARTY FOR DIRECT, INDIRECT,
% SPECIAL, INCIDENTAL, OR CONSEQUENTIAL DAMAGES, INCLUDING LOST PROFITS,
% ARISING OUT OF THE USE OF THIS SOFTWARE AND ITS DOCUMENTATION, EVEN IF
% FEMTONICS HAS BEEN ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
% 
% FEMTONICS SPECIFICALLY DISCLAIMS ANY WARRANTIES, INCLUDING, BUT NOT
% LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A
% PARTICULAR PURPOSE. THE SOFTWARE AND ACCOMPANYING DOCUMENTATION, IF ANY,
% PROVIDED HEREUNDER IS PROVIDED "AS IS". FEMTONICS HAS NO OBLIGATION TO
% PROVIDE MAINTENANCE, SUPPORT, UPDATES, ENHANCEMENTS, OR MODIFICATIONS.

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
