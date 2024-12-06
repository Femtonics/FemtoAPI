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

function reset( obj, varargin )
%RESET Reset the Look up table (LUT) bound and/or color vectors.
%   Detailed explanation goes here
%validateattributes(constantColor, {'uint32','char','string','struct'},{'nonempty'},'reset','constantColor');



if nargin == 2 % reset to constant color
    validateattributes(varargin{1}, {'Color','string'},{'nonempty','scalar'},'reset','constantColor');
    
    obj.m_vecBounds = obj.m_rangeLowerBound;
    if(isa(varargin{1},'Color'))
        obj.m_vecColors = varargin{1};
    else
        obj.m_vecColors = Color(varargin{1});
    end
    
elseif nargin == 3  % reset to new vecBounds and vecColors
    if( ~isequal(size(varargin{1}), size(varargin{2})) )
        error('The size of the input parameters vecBound and vecColor must be equal.');
    end
    
    
    if(isempty(varargin{1}))
        obj.m_vecBounds = [];
        obj.m_vecColors = [];
    else
        % validate vecBounds
        validateattributes(varargin{1}, {'double'},{'vector','increasing'},'reset','vecBounds',1);
        % validate vecColors
        validateattributes(varargin{2}, {'Color','struct','string','numeric'},{'vector'},'reset','vecColors',2);
        
        obj.m_vecBounds = varargin{1};
        obj.m_vecColors = repmat(Color,size(obj.m_vecBounds));
        
        if(isa(varargin{2},'Color'))
            for i=1:length(obj.m_vecColors)
                obj.m_vecColors(i) = varargin{2}(i);
            end
        else
            for i=1:length(obj.m_vecColors)
                obj.m_vecColors(i) = Color(varargin{2}(i));
            end
        end
        
        obj.clampBoundsWithinRanges();
        
    end
    
else
    error('Too many input arguments.');
end

% check LUT object for validity
obj.invariantFulfilled();


end