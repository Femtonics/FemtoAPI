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

function succeeded = setAxisPosition( obj, axisName, position, varargin)
%SETAXISPOSITION Sets the position of a given axis. 
% If tilted axis is moved, it resets the Z-stack parameters on the server's
% GUI.
%
% INPUTS[required]:    
%  axisName (char)      name of the axis 
%  position (double)    new position to set (means relative position to 
%                       labeling origin by default) 
%   
% INPUTS[optional]:
%  isRelativePosition (bool)     If true, the position to set means
%                                relative position, otherwise absolute position.
%                                Default: true
%
%  isRelativeToCurrentPosition (bool)     If true, relative position
%        means realtive to current position, otherwise to labeling origin
%        offset. To get know about current labeling origin offsets, run
%        femtoapiObj.getAxisPositions() command. Default: false 
%      
%
%  spaceName (char)       Specifies the space name. Default value is the 
%                         default space name.  
%     
%
% Usage example: 
%
%  axisName = "SlowX";
%  isRelativePosition = true;
%  isRelativeToCurrentPosition = true;  
%  spaceName = "space";
%  obj.setAxisPosition( axisName, position, isRelativePosition, ... 
%   isRelativeToCurrentPosition, spaceName) 
%
% See also GETAXISPOSITIONS
%
    if(isstring(axisName))
        axisName = char(axisName);
    end
    validateattributes(axisName,{'char'},{'row','nonempty'})
    optArgs = {true,false,'space1'}; % isRelativePosition, isRelativeToCurrentPosition, spaceName
    numVarargs = length(varargin);
    if numVarargs > 3
        error(['Too many input arguments. Usage: obj.setAxisPosition(axisName,',...
        ' position, isRelativePosition=true, isRelativeToCurrentPosition=false,',...
        ' spaceName=space1']);
    end

    if numVarargs >= 1 
        validateattributes(varargin{1},{'logical'},{'scalar'});
        optArgs{1} = varargin{1};
    end
    if numVarargs >= 2 
        validateattributes(varargin{2},{'logical'},{'scalar'});
        optArgs{2} = varargin{2};
    end

    if numVarargs == 3 
        if(isstring(varargin{3}))
            varargin{3} = char(varargin{3});
        end
        validateattributes(varargin{3},{'char'},{'row','nonempty'});
        optArgs{3} = varargin{3};
    end

    q = char(39); % quote character
    succeeded = femtoAPI('command', ...
        strcat('FemtoAPIMicroscope.setAxisPosition(', ...
        q, axisName, q, ...
        ',', num2str(position), ...
        ',', num2str(optArgs{1}), ...
        ',', num2str(optArgs{2}), ...
        ',', q, num2str(optArgs{3}), q, ...
        ')'));
    succeeded = jsondecode(succeeded{1});
end


