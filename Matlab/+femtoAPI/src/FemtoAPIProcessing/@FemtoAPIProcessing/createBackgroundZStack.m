function [ result ] = createBackgroundZStack( obj, xDim, yDim, zDim,...
    technologyType, imageRole, viewportJson, varargin )
%CREATEBACKGROUNDZSTACK Creates new MultiROI measurement unit. 
% Parameters xDim, yDim should be positive.
% Valid technologyTypes are: 'resonant', 'galvo', 'AO', 'dual'
% 
% INPUTS [required]:
%  xDim                  positive int, measurement unit x resolution
%  yDim                  positive int, measurement unit y resolution
%  zDim                  positive int, number of z planes 
%
%  technologyType        string, technology type 
%  imageRole             string, background image role, it can be
%                        'background' or 'motionCorrection'
%  viewportJson          string, viewport of background image in json
%                        object
%                        
% 
% INPUTS [optional]: 
%  fileHandle            positive int, handle of the file the background 
%                        measurement session will be added to 
%  zStepInMicrons        double, default value: 1
% 
% OUTPUT: 
%  result                struct that contains the following data:
%                          - addedMUnitIdx: the node descriptor (handle)
%                            of the created measurement unit, e.g. [32,0,1]
%                          - id: (char array), the command id 
%                          - succeeded: bool flag, means whether the synchronous 
%                            part of the command ended successfully or not 
%                          - backgroundImagePath: path to the background 
%                            image within the mesc file (path to hdf group) 
%  
% Usage: 
%  obj.createBackgroundZStack(xDim, yDim, zDim, technologyType, imageRole, 
%   viewportJson, fileHandle, zStepInMicrons ); 
%  
%
% See also CREATETIMESERIESMUNIT CREATEZSTACKMUNIT 
% 

validateattributes(xDim,{'numeric'},{'scalar','positive','integer'});
validateattributes(yDim,{'numeric'},{'scalar','positive','integer'});
validateattributes(zDim,{'numeric'},{'scalar','positive','integer'});
validateattributes(technologyType,{'char'},{'vector','row'});
validateattributes(imageRole,{'char'},{'vector','row'});
validateattributes(viewportJson,{'char'},{'vector','row'});

numVarargs = length(varargin);
if numVarargs > 2
    error('Too many input arguments.');
end


% default arguments
fileHandle = [];
zStepInMicrons = 1.0;


if numVarargs >= 1
    validateattributes(varargin{1},{'numeric'},{'scalar','nonnegative','real'});
    fileHandle = varargin{1};
end

if numVarargs == 2
    validateattributes(varargin{2},{'numeric'},{'scalar','nonnegative','real'});
    zStepInMicrons = varargin{2};
    %zStepInMicrons = num2str(zStepInMicrons);
end


result = obj.femtoAPIMexWrapper('FemtoAPIFile.createBackgroundZStack', xDim, yDim, zDim, ...
    technologyType, imageRole, viewportJson, fileHandle, zStepInMicrons);
    
result = jsondecode(result{1});
result.addedMUnitIdx = str2num(result.addedMUnitIdx);

end


