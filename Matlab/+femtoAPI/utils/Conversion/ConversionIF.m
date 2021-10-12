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

classdef ConversionIF < matlab.mixin.Copyable
    %ConversionIF Interface for Conversions
    %   Detailed explanation goes here
    
    properties (Access = protected)
        m_conversionType ;
    end
    
    properties (Constant, Access = public, Hidden)
        m_defaultLowerLimitUint16 = intmin('uint16'); % default lower conversion limit for uint16 type
        m_defaultUpperLimitUint16 = intmax('uint16'); % default upper conversion limit for uint16 type
        m_defaultLowerLimitDouble = -realmax('double'); % default lower conversion limit for double type
        m_defaultUpperLimitDouble = realmax('double'); % default upper conversion limit for double type
    end
    
    properties (Dependent, Access = protected,Abstract)
        m_monotonicity ; % monotonicity of the conversion
    end
    
    properties (Abstract, SetAccess = protected, GetAccess = public)
        m_lowerLimitDouble ;  % lower limit for double values
        m_upperLimitDouble ;  % upper limit for double values
        m_lowerLimitUint16 ; % lower limit for uint16 values
        m_upperLimitUint16 ;  % upper limit for uint16 values
        
        m_convertedMinValueUint16 ; % lower limit in converted space for uint16 values
        m_convertedMaxValueUint16 ; % upper limit in converted space for uint16 values
        m_convertedMinValueDouble ; % lower limit in converted space for double values
        m_convertedMaxValueDouble ; % upper limit in converted space for double values
    end
    
    
    
    methods
        function obj = ConversionIF( conversionType )
            % CONVERSIONIF Constructs with specified conversion type
            % in case of no input argument, object with default properties
            % will be created
            if nargin ~= 1
                error('Wrong number of input arguments given');
            else
                if( ~isequal(class(conversionType),'EConversionType') )
                    error('Input argument must be valid conversion type.');
                end
                obj.m_conversionType = conversionType;
            end
        end
        
        function convType = get.m_conversionType(obj)
            convType = obj.m_conversionType;
        end
        
    end
    
    % abstract set/get methods
    methods (Abstract)
        res = isWithinConvertedMinMaxValuesUint16(obj,value);
        res = isWithinConvertedMinMaxValuesDouble(obj,value);
        val = offsetBy(obj,add);
        val = scaleBy(obj,scale);
        
        % reset methods
        resetLimitsFromUint16Values(obj,varargin)
        resetLimitsFromDoubleValues(obj,varargin)
    end
    
    
    
    methods ( Access = protected, Abstract, Hidden )
        res = convertFromUint16ToUint16(obj,val);
        res = convertFromUint16ToDouble(obj,val);
        res = convertFromDoubleToUint16(obj,val);
        res = convertFromDoubleToDouble(obj,val);
        
        res = invConvertFromUint16ToUint16(obj,val);
        res = invConvertFromUint16ToDouble(obj,val);
        res = invConvertFromDoubleToUint16(obj,val);
        res = invConvertFromDoubleToDouble(obj,val);
    end
    
    methods (Access = protected, Hidden)
        limitsChanged(obj);
    end
    
    %% implemented methods
    methods
        % limit checking methods
        function val = isLimitedUint16(obj)
            val = logical(~isequal(obj.m_lowerLimitUint16,intmin('uint16') ) || ...
                ~isequal(obj.m_upperLimitUint16, intmax('uint16') ) );
        end
        
        function val = isLimitedDouble(obj)
            val = logical(~isequal(obj.m_lowerLimitDouble, -realmax('double') ) || ...
                ~isequal(obj.m_upperLimitDouble, realmax('double') ) );
            
        end
        
        function val = isLimited(obj)
            val =  isLimitedUint16(obj) || isLimitedDouble(obj) ;
        end
        
        function val = isWithinLimitsUint16(obj,num)
            val = obj.m_lowerLimitUint16 <= num && ...
                num <= getUpperLimitUint16(obj) ;
        end
        
        function val = isWithinLimitsDouble(obj,num)
            val = getLowerLimitDouble(obj) <= num && ...
                num <= getUpperLimitDouble(obj) ;
        end
        
        
        % methods for resetting values
        function resetLowerLimitsFromUint16Value(obj, varargin)
            numvarargs = length(varargin);
            if numvarargs > 1
                error('Too many input arguments');
            end
            optargs = {obj.m_defaultLowerLimitUint16};
            optargs(1:numvarargs) = varargin;
            lowerLimitUint16 = optargs{:};
            validateattributes(lowerLimitUint16,{'uint16'},{'scalar','nonempty'});
            
            obj.resetLimitsFromUint16Values(lowerLimitUint16, obj.m_upperLimitUint16 );
        end
        
        
        function resetUpperLimitsFromUint16Value(obj, varargin)
            numvarargs = length(varargin);
            if numvarargs > 1
                error('Too many input arguments');
            end
            optargs = {obj.m_defaultUpperLimitDouble};
            optargs(1:numvarargs) = varargin;
            upperLimitUint16 = optargs{:};
            validateattributes(upperLimitUint16,{'uint16'},{'scalar','nonempty'});
            
            obj.resetLimitsFromUint16Values(getLowerLimitUint16(obj), upperLimitUint16 );
        end
        
        
        function resetLowerLimitsFromDoubleValue( obj, varargin )
            numvarargs = length(varargin);
            if numvarargs > 1
                error('Too many input arguments');
            end
            optargs = {obj.m_defaultLowerLimitDouble};
            optargs(1:numvarargs) = varargin;
            lowerLimitDouble = optargs{:};
            validateattributes(lowerLimitDouble,{'double'},{'scalar','nonempty'});
            
            obj.resetLimitsFromDoubleValues(lowerLimitDouble, obj.m_upperLimitDouble );
        end
        
        
        function resetUpperLimitsFromDoubleValue( obj, varargin )
            numvarargs = length(varargin);
            if numvarargs > 1
                error('Too many input arguments');
            end
            optargs = {obj.m_defaultUpperLimitDouble};
            optargs(1:numvarargs) = varargin;
            upperLimitDouble = optargs{:};
            validateattributes(upperLimitDouble,{'double'},{'scalar','nonempty'});
            
            obj.resetLimitsFromDoubleValues(obj.m_lowerLimitDouble, upperLimitDouble );
        end
        
        function res = convertToDouble(obj,val)
            validTypes = {'double','uint16'};
            validateattributes(val,validTypes,{'nonempty'},'convertToDouble');
            valType = class(val);
            
            if(isequal(valType,'double'))
                res = convertFromDoubleToDouble(obj,val);
            elseif(isequal(valType,'uint16'))
                res = convertFromUint16ToDouble(obj,val);
            else
                %should never reach here
                error('Invalid data type');
            end
        end
        
        function res = convertToUint16(obj,val)
            validTypes = {'double','uint16'};
            validateattributes(val,validTypes,{'nonempty'},'convert');
            valType = class(val);
            
            if(isequal(valType,'double'))
                res = convertFromDoubleToUint16(obj,val);
            elseif(isequal(valType,'uint16'))
                res = convertFromUint16ToUint16(obj,val);
            else
                %should never reach here
                error('Invalid data type');
            end
        end
        
        function res = invConvertToDouble(obj,val)
            validTypes = {'double','uint16'};
            validateattributes(val,validTypes,{'nonempty'},'convert');
            valType = class(val);
            
            if(isequal(valType,'double'))
                res = invConvertFromDoubleToDouble(obj,val);
            elseif(isequal(valType,'uint16'))
                res = invConvertFromUint16ToDouble(obj,val);
            else
                %should never reach here
                error('Invalid data type');
            end
        end
        
        
        function res = invConvertToUint16(obj,val)
            validTypes = {'double','uint16'};
            validateattributes(val,validTypes,{'nonempty'},'convert');
            valType = class(val);
            
            if(isequal(valType,'double'))
                res = invConvertFromDoubleToUint16(obj,val);
            elseif(isequal(valType,'uint16'))
                res = invConvertFromUint16ToUint16(obj,val);
            else
                %should never reach here
                error('Invalid data type');
            end
        end
        
        
        % methods for overloaded operators
        function res = eq(obj,otherObj)
            res = obj.m_conversionType == otherObj.m_conversionType ;
        end
        
        function res = compareNumericParams(obj, otherObj)
            res = obj.m_conversionType == otherObj.m_conversionType ;
        end
        
        function res = ne(obj,otherObj)
            res = obj.m_conversionType ~= otherObj.m_conversionType ;
        end
        
    end
    
    
end

