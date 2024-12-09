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

function [ result ] = createBesselTimeSeriesMUnit( obj, xDim, yDim,...
    referenceViewportJson, varargin )
%CREATEBESSELTIMESERIESMUNIT Creates new bessel time series measurement unit. 
% Parameters xDim, yDim, zDim and zStepInMs should be positive, 
% viewport may only contain a rotation around the Z axis. 
% 
% INPUTS [required]:
%  xDim                  measurement unit x resolution
%  yDim                  measurement unit y resolution 
%  referenceViewportJson viewport json (for exact format, see the example
%                        below)
% 
% INPUTS [optional]: 
%  z0InMs                Positive, double, default value is 0.0
%  zStepInMs             Positive, double, default value is 1.0 
%  zDimInitial           Positive, integer, default value is 1. 
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
%  obj.createBesselTimeSeriesMUnit(xDim, yDim, viewport, ...
%                             z0InMs, zStepInMs, zDimInitial)
%
% Example: 
%
%  viewportJson =strcat(' {"GeomTransTransl": [0,0,0], ...
%    "GeomTransRot":[0,0,0,1]}, "Width": 256, "Height": 256}');
%
%  obj.createBesselTimeSeriesMUnit(256,256,viewportJson)
%
% 
% See also CREATEZSTACKMUNIT ADDCHANNEL 
% 

referenceViewportJson = convertCharsToStrings(referenceViewportJson);
validateattributes(xDim,{'numeric'},{'scalar','positive','integer'});
validateattributes(yDim,{'numeric'},{'scalar','positive','integer'});
validateattributes(referenceViewportJson,{'string'},{'scalar'});

numVarargs = length(varargin);
if numVarargs > 3
    error('Too many input arguments.');
end


% default arguments
z0InMs = 0.0;
zStepInMs = 1.0;
zDimInitial = 1;


if numVarargs >= 1
    validateattributes(varargin{1},{'numeric'},{'scalar','nonnegative','real'});
    z0InMs = varargin{1};
end

if numVarargs >= 2
    validateattributes(varargin{2},{'numeric'},{'scalar','nonnegative','real'});
    zStepInMs = varargin{2};
end

if numVarargs == 3
    validateattributes(varargin{3},{'numeric'},{'scalar','nonnegative','real'});
    zDimInitial = varargin{3};
end


result = obj.femtoAPIMexWrapper('FemtoAPIFile.createBesselTimeSeriesMUnit', xDim, yDim, ...
    referenceViewportJson, ...
    z0InMs, zStepInMs, zDimInitial);

result = jsondecode(result);
result.addedMUnitIdx = str2num(result.addedMUnitIdx);

end
