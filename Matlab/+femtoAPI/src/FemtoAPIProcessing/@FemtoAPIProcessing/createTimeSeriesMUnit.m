% Copyright ©2021. Femtonics Kft. (Femtonics). All Rights Reserved. 
% Permission to use, copy, modify this software and its documentation for educational,
% research, and not-for-profit purposes, without fee and without a signed licensing agreement, is 
% hereby granted, provided that the above copyright notice, this paragraph and the following two 
% paragraphs appear in all copies, modifications, and distributions. Contact info@femtonics.eu
% for commercial licensing opportunities.
% 
% IN NO EVENT SHALL FEMTONICS BE LIABLE TO ANY PARTY FOR DIRECT, INDIRECT, SPECIAL, 
% INCIDENTAL, OR CONSEQUENTIAL DAMAGES, INCLUDING LOST PROFITS, ARISING OUT OF 
% THE USE OF THIS SOFTWARE AND ITS DOCUMENTATION, EVEN IF FEMTONICS HAS BEEN 
% ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
% 
% FEMTONICS SPECIFICALLY DISCLAIMS ANY WARRANTIES, INCLUDING, BUT NOT LIMITED TO, 
% THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR 
% PURPOSE. THE SOFTWARE AND ACCOMPANYING DOCUMENTATION, IF ANY, PROVIDED 
% HEREUNDER IS PROVIDED "AS IS". FEMTONICS HAS NO OBLIGATION TO PROVIDE 
% MAINTENANCE, SUPPORT, UPDATES, ENHANCEMENTS, OR MODIFICATIONS.

function [ result ] = createTimeSeriesMUnit( obj, xDim, yDim,...
    taskXMLParameters, viewportJson, varargin )
%CREATETIMESERIESMUNIT Creates new time series measurement unit.
% Parameters xDim, yDim, zDim and zStepInMs should be positive,
% viewport may only contain a rotation around the Z axis.
%
% INPUTS [required]:
%  xDim                  measurement unit x resolution
%  yDim                  measurement unit y resolution
%  taskXMLParameters     task parameter in xml string format
%  viewportJson          viewport json (for exact format, see the example
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
%  obj.createTimeSeriesMUnit(xDim, yDim, taskXMLParameters, viewportJson, ...
%                             z0InMs, zStepInMs, zDimInitial)
%
% Example:
%  Sample Task parameter (JS):
%  for galvo unit:
%  tp='<Task Type="TaskFastXYGalvo" Version="1.0"><Devices/><Params/></Task>'
%  for resonant unit:
%  tp='<Task Type="TaskResonantCommon" Version="1.0"><Devices/><Params/></Task>'
%  for AO unit:
%  tp='<Task Type="TaskAOFullFrame" Version="1.0"><Devices/><Params/></Task>'
%
%  viewportJson =strcat('{"transformation": {"translation": [0,0,0],',...
%                '"rotationQuaternion":[0,0,0,1]}, "size": [256, 256]}');
%  obj.createTimeSeriesMUnit(256,256,tp,viewportJson)
%
%
% See also CREATEZSTACKMUNIT ADDCHANNEL
%

validateattributes(xDim,{'numeric'},{'scalar','positive','integer'});
validateattributes(yDim,{'numeric'},{'scalar','positive','integer'});
validateattributes(taskXMLParameters,{'char'},{'vector','row'});
validateattributes(viewportJson,{'char'},{'vector','row'});


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
    zStepInMs = num2str(zStepInMs);
end

if numVarargs == 3
    validateattributes(varargin{3},{'numeric'},{'scalar','nonnegative','integer'});
    zDimInitial = varargin{3};
    zDimInitial = num2str(zDimInitial);
end
q = char(39); % quote character
result = femtoAPI('command',strcat('FemtoAPIFile.createTimeSeriesMUnit(',...
    num2str(xDim),',',num2str(yDim),',',q,taskXMLParameters,q,',',q,viewportJson,q,',',...
    num2str(z0InMs),',',num2str(zStepInMs),',',num2str(zDimInitial),')'));
result = jsondecode(result{1});
result.addedMUnitIdx = str2num(result.addedMUnitIdx);

end
