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

function [ result ] = createMultiROI3DMUnit( obj, xDim, yDim, tDim,...
    methodType, backgroundImageHandle, varargin )
%CREATEMULTIROI3DMUNIT Creates new MultiROI 3D measurement unit. 
% Parameters xDim, yDim, tDim must be positive.
%
% Note: X and Y axis conversion parameters are set separately. See examples 
% in doc.
%
% Valid methodTypes are: 
% 'multiRoiChessBoard', 'multiRoiTransverseRibbonScan',
% 'multiRoiLongitudinalRibbonScan'.
% 
% INPUTS [required]:
%  xDim                  positive int, measurement unit x resolution
%  yDim                  positive int, measurement unit y resolution
%  tDim                  positive int, number of samples in time
%  methodType            string, multiROI method type in string
%  backgroundImageHandle array, the handle of the background image
                      
% 
% INPUTS [optional]: 
%  deltaTInMs            positive double, measurement unit time resolution 
%                        in ms. Default value is 1.0. 
%
%  t0InMs                measurement time offset in ms. Default
%                        value is 0.0. 
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
%  obj.createMultiROI3DMUnit(xDim, yDim, tDim, methodType, backgroundImagePath,...
%  deltaTInMs, t0InMs);
%
% See also CREATEMULTIROI2DMUNIT CREATEMULTIROI4DMUNIT 
%  CREATETIMESERIESMUNIT CREATEZSTACKMUNIT 
% 

validateattributes(xDim,{'numeric'},{'scalar','positive','integer'});
validateattributes(yDim,{'numeric'},{'scalar','positive','integer'});
validateattributes(tDim,{'numeric'},{'scalar','positive','integer'});
validateattributes(methodType,{'char'},{'vector','row'});
validateattributes(backgroundImageHandle,{'numeric'}, ...
    {'vector','nonnegative','integer'});

% default arguments
t0InMs = 0.0;
deltaTInMs = 1.0;

numVarargs = length(varargin);
if numVarargs > 2
    error('Too many input arguments.');
end

if numVarargs >= 1
    validateattributes(varargin{1},{'numeric'},{'scalar','positive','real'});
    deltaTInMs = varargin{1};
end
if numVarargs == 2
    validateattributes(varargin{2},{'numeric'},{'scalar','nonnegative','real'});
    t0InMs = varargin{2};
end


result = obj.femtoAPIMexWrapper('FemtoAPIFile.createMultiROI3DMUnit', xDim, yDim, tDim, ...
    methodType, backgroundImageHandle, deltaTInMs, t0InMs);

result = jsondecode(result{1});
result.addedMUnitIdx = str2num(result.addedMUnitIdx);

end

