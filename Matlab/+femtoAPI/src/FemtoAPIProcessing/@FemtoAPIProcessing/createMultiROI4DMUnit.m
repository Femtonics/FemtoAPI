function [ result ] = createMultiROI4DMUnit( obj, xDim, yDim, zDim, tDim,...
    methodType, backgroundImageHandle,  varargin )
%CREATEMULTIROI4DMUNIT Creates new MultiROI4D measurement unit. 
% Parameters xDim, yDim, zDim, tDim must be positive.
%
% Valid methodTypes are: 'multiRoiMultiCube', 'multiRoiSnake'. 
% 
% INPUTS [required]:
%  xDim                  positive int, measurement unit x resolution
%  yDim                  positive int, measurement unit y resolution
%  zDim                  positive int, measurement unit z resolution
%  tDim                  positive int, number of timestamps
%  methodType            string, multiROI method type in string
%  backgroundImageHandle string, the handle of the background image
%  deltaTInMs            positive double, measurement unit time resolution 
%                        in ms                           
% 
% INPUTS [optional]: 
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
%  obj.createMultiROI4DMUnit(xDim, yDim, zDim, tDim, methodType,...
%    backgroundImagePath, deltaTInMs, t0InMs);
%
% See also CREATETIMESERIESMUNIT CREATEZSTACKMUNIT 
% 

validateattributes(xDim,{'numeric'},{'scalar','positive','integer'});
validateattributes(yDim,{'numeric'},{'scalar','positive','integer'});
validateattributes(zDim,{'numeric'},{'scalar','positive','integer'});
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

result = obj.femtoAPIMexWrapper('FemtoAPIFile.createMultiROI4DMUnit', xDim, yDim, zDim, tDim, ...
    methodType, backgroundImageHandle, deltaTInMs, t0InMs);


result = jsondecode(result{1});
result.addedMUnitIdx = str2num(result.addedMUnitIdx);

end

