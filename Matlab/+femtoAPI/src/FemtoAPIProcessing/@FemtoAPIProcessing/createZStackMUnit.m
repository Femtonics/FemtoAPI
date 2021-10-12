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

function [ result ] = createZStackMUnit( obj, xDim, yDim, zDim,...
    taskXMLParameters, viewportJson, varargin )
%CREATEZSTACKMUNIT Creates new z-stack measurement unit. 
% Creates z-stack measurement unit for resonant, galvo, or AO measurements. 
% The type of measurement is given in the xml taskXMLParameters. 
% Parameters xDim, yDim, zDim and zStepInMicrons should be positive, 
% viewport may only contain a rotation around the Z axis. 
% Currently implemented only for galvo task. 
% 
% INPUTS [required]:
%  xDim                  measurement unit x resolution
%  yDim                  measurement unit y resolution
%  zDim                  number of z planes
%  taskXMLParameters     task parameter in xml string format 
%  viewportJson          viewport json (for exact format, see the example
%                        below)
% 
% INPUTS [optional]: 
%  zStepInMicrons        step between z planes in microns. Must be positive,
%                        double, default value is 1.0
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
%  obj.createZStackMUnit(xDim, yDim, zDim, taskXMLParameters, viewportJson, ...
%                             zStepInMicrons)
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
%  obj.createZStackMUnit(256,256,10,tp,viewportJson)
% 
% See also CREATETIMESERIESMUNIT ADDCHANNEL 
% 

validateattributes(xDim,{'numeric'},{'scalar','positive','integer'});
validateattributes(yDim,{'numeric'},{'scalar','positive','integer'});
validateattributes(taskXMLParameters,{'char'},{'vector','row'});
validateattributes(viewportJson,{'char'},{'vector','row'});


numVarargs = length(varargin);
if numVarargs > 1
    error('Too many input arguments.');
end


% default arguments
zStepInMicrons = 1.0;


if numVarargs == 1
    validateattributes(varargin{1},{'numeric'},{'scalar','nonnegative','double'});
    zStepInMicrons = varargin{1};
    zStepInMicrons = num2str(zStepInMicrons);
end
q = char(39); % quote character
result = femtoAPI('command',strcat('FemtoAPIFile.createZStackMUnit(',...
    num2str(xDim),',',num2str(yDim),',',num2str(zDim),',',... 
    q,taskXMLParameters,q,',',q,viewportJson,q,',',...
    num2str(zStepInMicrons),')'));
result = jsondecode(result{1});
result.addedMUnitIdx = str2num(result.addedMUnitIdx);

end
