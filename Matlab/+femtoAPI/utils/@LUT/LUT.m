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

classdef LUT < matlab.mixin.Copyable
    % This class is for handling color "look up table" (LUT) data. 
    % 
    % A color is represented as an uint32 containing a quadruplet of uint8 
    % components. Color look up table contains the color - value mapping.
    % Values outside the given bounds mapped to the closest given color. 
    % 
    % Usage examples:
    %        lutStruct = struct('entries',[],'range',[]);
    %        lutStruct.entries = repmat(struct('color',[],'value',[]),[2 1]);
    %        lutStruct.entries(1).color = '#0000ff'; % RGBA color code
    %        lutStruct.entries(2).color = '#00ff00ff'; % RGBA color code
    %        lutStruct.entries(1).value = 0;
    %        lutStruct.entries(2).value = 1000;
    %        lutStruct.range(1) = 0;
    %        lutStruct.range(2) = 65535;
    %        lutObj = LUT(lutStruct)
    %        
    %        lutObj1 = LUT(); % constructs default LUT with 2 color-value
    %                           pairs
    %
    % @see Color
    %
    
    %% LUT Object properties
    properties (SetAccess = private)
        m_vecColors ;
        m_vecBounds ;
        m_rangeLowerBound ;
        m_rangeUpperBound ; 
        m_colorOrder ;
    end
    
    % properties for caching the LUT member variables, to check whether the
    % LUT invariant is fulfilled, if it is, then copy the *_tmp variables 
    % into the stored one
%     properties (SetAccess = private, Dependent, Hidden)
%         m_vecColors_tmp ;
%         m_vecBounds_tmp ;
%         m_rangeLowerBound_tmp ;
%         m_rangeUpperBound_tmp ;         
%     end

    
    properties (Dependent, SetAccess = private, GetAccess = public)
        m_colorMap ;
    end
    
    %% Constant properties
    properties (Constant, Hidden, GetAccess = private)
        LUTColorAs4CValueTypes = {'uint8'};
        LUTColorAs4CValueAttribs = {'>=',0,'<=',255};
        LUTColorAsUint32ValueTypes = {'uint32'};
        
        LUTEntryFieldNames = {'color','value'};
        LUTStructFieldNames = {'entries','range'};
        LUT4ColorFieldNames = {'alpha','red','green','blue'};
        LUT3ColorFieldNames = {'red','green','blue'};
        LUTRangeBoundValueTypes = {'double'};
        LUTRangeBoundValueAttribs = {'vector','numel',2,'nonnegative','increasing'};
        LUTColorType = {'char'}
        LUTColorAttribs = '#[0-9a-fA-F]{8}'; % pattern for uint32 number in hex format e.g. #FFAABB00
        m_defaultColorOrder = 'RGBA';
    end
    
    
    properties (Constant, Hidden)
        m_rangeLowerBound_default = 0;
        m_rangeUpperBound_default = 65535;
        m_rangeLowerBoundColor_default = Color(uint32(0),LUT.m_defaultColorOrder);
        m_rangeUpperBoundColor_default = Color(intmax('uint32'),LUT.m_defaultColorOrder); 
        m_opaqueBlack = Color("#000000FF",LUT.m_defaultColorOrder);
    end
    
    
    
    methods
        %% LUT Constructor
        function obj = LUT(varargin)
            obj.m_colorOrder = obj.m_defaultColorOrder;
            
            if nargin == 0
                obj = obj.fullReset();
            elseif (nargin == 1 || nargin == 2)
                
                % validate LUT structure and init members if, all parameters 
                % are valid             
                obj.validateLUTStructure(varargin{1});
                LUTStruct = varargin{1};
                
                % initialize properties
                obj.m_rangeLowerBound = LUTStruct.range(1);
                obj.m_rangeUpperBound = LUTStruct.range(2);
                obj.m_vecBounds = vertcat(LUTStruct.entries.value);

                colors = string(vertcat(LUTStruct.entries.color));
                obj.m_vecColors = repmat(Color,size(colors));
                if nargin == 1
                    for i=1:length(obj.m_vecBounds)
                        obj.m_vecColors(i) = Color(colors(i), obj.m_defaultColorOrder);
                    end
                else 
                    validatestring(varargin{2},{'RGBA','ARGB'});
                    obj.m_colorOrder = varargin{2};
                    for i=1:length(obj.m_vecBounds)
                        obj.m_vecColors(i) = Color(colors(i), obj.m_colorOrder);
                    end 
                end
                
                % check LUTStruct.entries(1).value >= rangeLowerBound and LUTStruct.entries(end).value <=rangeUpperBound
                % -> if not, clamp values within ranges
                if(obj.m_vecBounds(1) < obj.m_rangeLowerBound || obj.m_vecBounds(end) > obj.m_rangeUpperBound)
                   obj.clampBoundsWithinRanges();
                end
                
                try
                    obj.invariantFulfilled();
                catch ME
                    warning(strcat(ME.message,' Replacing with default LUT.'));
                    obj = obj.fullReset();
                end
                
            else
                error(['Too many input arguments. Usage: LUT(),', ...
                'LUT(lutStruct), LUT(lutStruct, colorOrder)']);
            end
        end
        
        %% PROPERTY SET/GET methods (setters are private)
        function set.m_rangeLowerBound(obj,lowerBound)
            validateattributes(lowerBound,{'double'},{'scalar'});
            obj.m_rangeLowerBound = lowerBound;
        end        
        
        function val = get.m_rangeLowerBound(obj)
            val = obj.m_rangeLowerBound;
        end
        
        function set.m_rangeUpperBound(obj,upperBound)
            validateattributes(upperBound,{'double'},{'scalar'});
            obj.m_rangeUpperBound = upperBound;
        end        
        
        function val = get.m_rangeUpperBound(obj)
            val = obj.m_rangeUpperBound;
        end       

        function set.m_vecColors(obj,vecColors)
            validateattributes(vecColors,{'Color'},{'vector'});
            obj.m_vecColors = vecColors;
        end
        
        function val = get.m_vecColors(obj)
            val = obj.m_vecColors;
        end
        
        function set.m_vecBounds(obj,vecBounds)
            validateattributes(vecBounds,{'double'},{'vector'});
            obj.m_vecBounds = vecBounds;
        end
        
        function val = get.m_vecBounds(obj)
            val = obj.m_vecBounds;
        end        
        
        function val = get.m_colorMap(obj)
            % Get color map as rows of RGB values
            numOfColors = size(obj.m_vecColors,1);
            val = zeros(numOfColors,4);
            for i=1:length(obj.m_vecColors)
                val(i,:) = obj.m_vecColors(i).m_colorAsARGBArray;
            end
            val = val(:,2:4)./255;
        end
        
        function lutStruct = getLUTStruct(obj)
            %GETLUTSTRUCT Gets LUT object as structure 
            
            lutStruct = struct('range',[],'entries',[]);
            lutStruct.range = [obj.m_rangeLowerBound;obj.m_rangeUpperBound];
            lutStruct.entries = repmat(struct('color',[],'value',[]),length(obj.m_vecBounds),1);
            for i=1:length(obj.m_vecBounds)
               lutStruct.entries(i).color = char(lower(obj.m_vecColors(i).m_colorAsHex));
               lutStruct.entries(i).value = obj.m_vecBounds(i);
            end             
        end

        %% COLOR <-> VALUE CONVERSION methods
        colorObj = convertToColorValue( obj, val );
        channelData_converted = convertChannelToARGB(obj, channelData );
        
        %% LUT data manipulation 
        rescale(obj,newLowerBound, newUpperBound);
        obj = setRangeBounds(obj, lower, upper);
        obj = setRangeLowerBound( obj, rangeLowerBound );
        obj = setRangeUpperBound( obj, rangeUpperBound );
        
        %% reset methods
        obj = fullReset(obj);
        reset(obj,varargin);
        
        %% Initialization, validation
        valid = validateLUTStructure( obj, LUTStruct );
       
    end
    
%     %% Static private methods
%     methods (Access = private, Static = true)
%         valid = validateLUTStructure(LUTStruct)
%     end    
    
    %% Private methods
    methods (Access = private)        
        invariantFulfilled(obj) ;
        clampBoundsWithinRanges(obj);
    end
    
end

