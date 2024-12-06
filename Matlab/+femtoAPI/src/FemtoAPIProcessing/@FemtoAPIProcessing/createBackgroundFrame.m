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

function [ result ] = createBackgroundFrame( obj, xDim, yDim,...
    technologyType, imageRole, viewportJson, varargin )
%CREATEBACKGROUNDFRAME Creates new MultiROI measurement unit. 
% Parameters xDim, yDim should be positive.
% Valid technologyTypes are: 'resonant', 'galvo', 'AO', 'dual'
% 
% INPUTS [required]:
%  xDim                  positive int, measurement unit x resolution
%  yDim                  positive int, measurement unit y resolution
%  technologyType        string, technology type 
%  imageRole             string, background image role, 'background' or
%                        'motionCorrection'
%  viewportJson          string, viewport of background image in json object 
%                        
% 
% INPUTS [optional]: 
%  fileHandle            positive int, handle of the file the background 
%                        measurement session will be added to 
%  z0InMs                double,  default value: 0
%  zStepInMs             double, default value: 1
%  zDimInitial           integer, default value: 1
%  isBessel              bool, default value: false
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
%  obj.createBackgroundFrame(xDim, yDim, technologyType, viewportJson, 
%   fileHandle, z0InMs, zStepInMs, zDimInitial ); 
%  
%
% See also CREATETIMESERIESMUNIT CREATEZSTACKMUNIT 
% 

validateattributes(xDim,{'numeric'},{'scalar','positive','integer'});
validateattributes(yDim,{'numeric'},{'scalar','positive','integer'});
validateattributes(technologyType,{'char'},{'vector','row'});
validateattributes(imageRole,{'char'},{'vector','row'});
validateattributes(viewportJson,{'char'},{'vector','row'});


numVarargs = length(varargin);
if numVarargs > 5
    error('Too many input arguments.');
end


% default arguments
fileHandle = [];
z0InMs = 0.0;
zStepInMs = 1.0;
zDimInitial = 1.0;
isBessel = false;

if numVarargs >= 1
    validateattributes(varargin{1},{'numeric'},{'scalar','nonnegative','real'});
    fileHandle = varargin{1};
end

if numVarargs >= 2
    validateattributes(varargin{2},{'numeric'},{'scalar','nonnegative','real'});
    z0InMs = varargin{2};
end

if numVarargs >= 3
    validateattributes(varargin{3},{'numeric'},{'scalar','nonnegative','real'});
    zStepInMs = varargin{3};
end

if numVarargs >= 4
    validateattributes(varargin{4},{'numeric'},{'scalar','nonnegative','real'});
    zDimInitial = varargin{4};
end

if numVarargs >= 5
    validateattributes(varargin{5},{'logical'},{'scalar'});
    isBessel = varargin{5};
end

result = obj.femtoAPIMexWrapper('FemtoAPIFile.createBackgroundFrame', xDim, yDim, ...
    technologyType, imageRole, viewportJson, fileHandle, ...
    z0InMs, zStepInMs, zDimInitial, isBessel);

result = jsondecode(result{1});
result.addedMUnitIdx = str2num(result.addedMUnitIdx);

end

