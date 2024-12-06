function [ result ] = createMultiROI2DMUnit( obj, xDim, tDim,...
    methodType, backgroundImageHandle, varargin )
%CREATEMULTIROI2DMUNIT Creates new MultiROI measurement unit. 
% Parameters xDim, tDim must be positive.
% 
% Note: X axis conversion parameters are set separately. See examples in
% doc.
% 
% Valid methodTypes are: 'multiRoiPointScan', 'multiRoiLineScan',
% 'multiRoiMultiLine'. 
% 
% INPUTS [required]:
%  xDim                  positive int, measurement unit x resolution
%  tDim                  positive int, number of samples in time
%  methodType            string, multiROI method type in string
%  backgroundImageHandle array, the handle of the background image
%                                               
% 
% INPUTS [optional]: 
%  deltaTInMs            positive double, measurement unit time resolution 
%                        in ms, default value is 1.0. 
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
%  obj.createMultiROI2DMUnit(xDim, tDim, methodType, backgroundImagePath,...
%  deltaTInMs,t0InMs);
%
% See also CREATEMULTIROI3DMUNIT CREATEMULTIROI4DMUNIT 
%  CREATETIMESERIESMUNIT CREATEZSTACKMUNIT 
% 

validateattributes(xDim,{'numeric'},{'scalar','positive','integer'});
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

result = obj.femtoAPIMexWrapper('FemtoAPIFile.createMultiROI2DMUnit', xDim, tDim, methodType, ...
    backgroundImageHandle, deltaTInMs, t0InMs);

result = jsondecode(result{1});
result.addedMUnitIdx = str2num(result.addedMUnitIdx);

end

