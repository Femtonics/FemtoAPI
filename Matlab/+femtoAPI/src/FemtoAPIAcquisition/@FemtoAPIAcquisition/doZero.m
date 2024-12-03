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

function succeeded = doZero(obj,axisName,varargin)
%DOZERO Zero axis relative position
% This command is used for setting the relative position of the given axis
% to zero, and sets the labeling origin offset to the current absolute
% postion. The axis is given by the parameters axisName and space name.
% If space name is not given, default space is considered.
%
% Zero command can be done only on standard axes. Run getAxisPositions()
% command to obtain configured axis names.
%
% INPUTS [required]:
%  axisName             char array, name of the axis
%
% INPUTS [optional]:
%  spaceName            char array, name os space the axis is configured for.
%                       If not, or empty char is given, default space name ('space1') 
%                       is considered.
%                       
%
% OUTPUT:
%  succeded            - true, if the input parameters are OK, and the zero
%                        command was successfully issued,
%                      - false when the input parameters are invalid,
%                        or the 'Lock' checkbox is enabled on the MESc GUI.
%
% Examples:
%  obj.doZero('SlowZ') -> do zero if 'SlowZ' is configured for default
%   space
%  obj.doZero('TiltX','space2') -> do zero if 'TiltX' is configured for
%   space2
%
% See also SETAXISPOSITION GETAXISPOSITIONS
%

numVarargs = length(varargin);
spaceName = ''; % empty means default space

if(~ischar(axisName) && ~isstring(axisName))
    error('Argument 1, ''axisName'' must be of type character array or string.');
end
if numVarargs > 1
    error('Too many input arguments.');
elseif numVarargs == 1
    if(~ischar(varargin{1}) && ~isstring(varargin{1}))
        error('Argument 2, ''spaceName'' must be of type character array or string.');
    end
    spaceName = varargin{1};
end

succeeded = obj.femtoAPIMexWrapper('FemtoAPIMicroscope.doZero',axisName,spaceName);
succeeded = jsondecode(succeeded{1});

end

