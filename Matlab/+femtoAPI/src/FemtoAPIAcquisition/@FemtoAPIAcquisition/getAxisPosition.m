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

function  axisPosition = getAxisPosition(obj,axisName,varargin)
%GETAXISPOSITION Gets position of the given axis
% Gets the absolute, relative axis position, or the whole axis position
% struct get from server, if no optional arguments are given.
%
% INPUT [required]:
%  axisName                 char array, name of a configured axis
%
% INPUTS [optional]:
%  positionType             char array, must be 'absolute' or 'relative'.
%                           Default: empty char, means that absolute and 
%                           relative positions are included in the result
%
%  spaceName                char array, name of space for which the axis is
%                           configured. Default: default space('space1')
%
% OUTPUT:
%  axisPosition             various output depending on positionType:
%                            - double, absolute position, if positionType
%                              is 'absolute'
%                            - double, relative position, if positionType
%                              is 'relative'
%                            - struct, containing absolute/relative positions,
%                              threshold, axis limits, labeling origin offset.
%                              if positionType is not given.
%
% Examples:
%  axisPositionStruct = obj.getAxisPosition('SlowZ');
%  absolutePos = obj.getAxisPosition('SlowZ','absolute');
%  relativePos = obj.getAxisPosition('SlowZ','relative');
%
% See also GETAXISPOSITIONS
%

numVarargs = length(varargin);
positionType = ''; % empty means relative and absolu
spaceName = obj.m_AcquisitionState.defaultSpaceName;

if( numVarargs > 2)
    error('Too many input arguments.');
end
if( numVarargs >= 1 )
    validPosTypes = ["Relative","Absolute"];
    validatestring(varargin{1},validPosTypes,mfilename, 'positionType',2);
    positionType = varargin{1};
end

if( numVarargs == 2 )
    if(~ischar(varargin{2}) && ~isstring(varargin{2}))
        error('Argument 3, ''spacename'' must be a character array or string');
    end
    spaceName = varargin{2};
end

axisPosition = obj.femtoAPIMexWrapper('FemtoMicroscope.getAxisPosition',axisName, ...
    spaceName);
axisPosition = jsondecode(axisPosition);

if(strcmpi(positionType,'absolute'))
    axisPosition = axisPosition.Absolute;
elseif(strcmpi(positionType,'relative'))
    axisPosition = axisPosition.Relative;
else
    % no optional parameter was given -> get the whole axisposition struct
    return;
end

end

