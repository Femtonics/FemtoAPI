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

classdef ConversionLinear < ConversionNoParamsIF
    %CONVERSIONLINEAR Class for linear conversions  
    %   Detailed explanation goes here
    
    properties (Dependent, Access = protected)
        m_monotonicity ;
    end
    
    properties( SetAccess = protected, GetAccess = public )
        m_convertedMinValueUint16 ;
        m_convertedMaxValueUint16 ;
        m_convertedMinValueDouble ;
        m_convertedMaxValueDouble ;
    end
    
    properties
        m_scale = 1.0;
        m_offset = 0.0;
    end
    
    properties (SetAccess = private)
        m_invScale = 1.0;
    end
    
    methods
        function obj = ConversionLinear(varargin)
            obj = obj@ConversionNoParamsIF(EConversionType.eLinearConv);
            numvarargs = length(varargin);
            if numvarargs > 4
                error('MATLAB:TooManyInputs',...
                    'Constructor requires at most four inputs. See help for usage.');
            end
            
            optargs = {1.0 0.0 obj.m_sDefaultTitle obj.m_sDefaultUnitName};
            optargs(1:numvarargs) = varargin;
            [scale, offset, title, unitName] = optargs{:};
            
            obj.m_sTitle = title;
            obj.m_sUnitName = unitName;
            obj.m_scale = scale;
            obj.m_offset = offset;
            obj.updateInvScale(scale);
            
            obj.limitsChanged();
        end
        
        %setter/getter methods
        function val = get.m_monotonicity(obj)
            if 0.0 > obj.m_scale
                if obj.isLimited()
                    val = EMonotonicity.eWeaklyDecreasing;
                else
                    val = EMonotonicity.eStrictlyDecreasing;
                end
            elseif 0.0 == obj.m_scale
                val = EMonotonicity.eConstant;
            else
                if obj.isLimited()
                    val = EMonotonicity.eWeaklyIncreasing;
                else
                    val = EMonotonicity.eStrictlyIncreasing;
                end
            end
        end
        
        function set.m_convertedMinValueUint16(obj,val)
            validateattributes(val,{'uint16'},{'scalar'});
            obj.m_convertedMinValueUint16 = val ;
        end
        
        function set.m_convertedMaxValueUint16(obj,val)
            validateattributes(val,{'uint16'},{'scalar'});
            obj.m_convertedMaxValueUint16 = val ;
        end
        
        function set.m_convertedMinValueDouble(obj,val)
            validateattributes(val,{'double'},{'scalar'});
            obj.m_convertedMinValueDouble = val;
        end
        
        function set.m_convertedMaxValueDouble(obj,val)
            validateattributes(val,{'double'},{'scalar'});
            obj.m_convertedMaxValueDouble = val ;
        end        
        
        function val = get.m_convertedMinValueUint16(obj)
            val = obj.m_convertedMinValueUint16 ;
        end
        
        function val = get.m_convertedMaxValueUint16(obj)
            val = obj.m_convertedMaxValueUint16 ;
        end
        
        function val = get.m_convertedMinValueDouble(obj)
            val = obj.m_convertedMinValueDouble ;
        end
        
        function val = get.m_convertedMaxValueDouble(obj)
            val = obj.m_convertedMaxValueDouble ;
        end
        
        function set.m_scale(obj,scale)
            validateattributes(scale,{'numeric'},{'scalar','nonempty'},'set.m_scale','m_scale');
            if(~isequal(class(scale),'double'))
                scale = double(scale);
            end
            if(scale ~= obj.m_scale)
                obj.m_scale = scale;
                obj.updateInvScale(scale);
                obj.limitsChanged();
            end
        end
        
        function val = get.m_scale(obj)
            val = obj.m_scale;
        end
        
        function set.m_invScale(obj,invScale)
            validateattributes(invScale,{'numeric'},{'scalar','nonempty'},'set.m_invScale','m_invScale');
            if(~isequal(class(invScale),'double'))
                invScale = double(invScale);
            end            
            obj.m_invScale = invScale;
        end
        
        function val = get.m_invScale(obj)
            val = obj.m_invScale;
        end
        
        function set.m_offset(obj,offset)
            validateattributes(offset,{'numeric'},{'scalar','nonempty'},'set.m_offset','m_offset');
            if(~isequal(class(offset),'double'))
                offset = double(offset);
            end            
            obj.m_offset = offset;
            obj.limitsChanged();
        end
        
        function val = get.m_offset(obj)
            val = obj.m_offset;
        end
        
        % scale/offset modifiers
        function val = offsetBy(obj,add)
            val = true;
            if(0 == add)
                return;
            end
            obj.m_offset = obj.m_offset + add;
            obj.limitsChanged();
        end
        
        function val = scaleBy(obj,scale)
            val = true;
            if(1 == scale)
                return;
            end
            obj.m_scale = obj.m_scale * scale;
            obj.m_offset = obj.m_offset * scale;
            obj.updateInvScale(scale);
            obj.limitsChanged();
        end
        

        function res = isWithinConvertedMinMaxValuesUint16(obj,value)
            res = obj.m_convertedMinValueUint16 <= value && ...
                value <= obj.m_convertedMaxValueUint16;
        end
        
        function res = isWithinConvertedMinMaxValuesDouble(obj,value)
            res = obj.m_convertedMinValueDouble <= value && ...
                value <= obj.m_convertedMaxValueDouble;
        end
        
        
    end
    
    
    methods ( Access = protected, Hidden )

        function limitsChanged(obj)
            if(obj.isLimitedDouble())
                obj.m_convertedMinValueDouble = ConversionLinear.affineTransform(obj.m_lowerLimitDouble,...
                    obj.m_scale, obj.m_offset);
                obj.m_convertedMaxValueDouble = ConversionLinear.affineTransform(obj.m_upperLimitDouble,...
                    obj.m_scale, obj.m_offset);
               
                % ensure that converted value cannot be Inf or -Inf
                obj.m_convertedMinValueDouble = clamp(-realmax('double'),...
                    obj.m_convertedMinValueDouble, realmax('double'));
                obj.m_convertedMaxValueDouble = clamp(-realmax('double'),...
                    obj.m_convertedMaxValueDouble, realmax('double'));
                
                if(obj.m_convertedMinValueDouble > obj.m_convertedMaxValueDouble)
                    temp = obj.m_convertedMinValueDouble;
                    obj.m_convertedMinValueDouble = obj.m_convertedMaxValueDouble;
                    obj.m_convertedMaxValueDouble = temp;
                end
            else
                obj.m_convertedMinValueDouble = -realmax('double');
                obj.m_convertedMaxValueDouble = realmax('double');
            end
            
            obj.m_convertedMinValueUint16 = uint16(clamp(double(intmin('uint16')),...
                obj.m_convertedMinValueDouble, double(intmax('uint16'))));
            obj.m_convertedMaxValueUint16 = uint16(clamp(double(intmin('uint16')),...
                obj.m_convertedMaxValueDouble, double(intmax('uint16'))));
        end
        
        
        % methods for (inverse)conversion (override)
        function res = convertFromUint16ToUint16(obj,val)
            validateattributes(val,{'uint16'},{'nonempty'},'convertFromUint16ToUint16');
            if(obj.isLimitedUint16())
                res = uint16(ConversionLinear.clampAffineTransform(obj.m_lowerLimitUint16, val,...
                    obj.m_upperLimitUint16, obj.m_scale, obj.m_offset)) ;
            else
                res = uint16(ConversionLinear.affineTransform(val,obj.m_scale, obj.m_offset)) ;
            end
        end
        
        function res = convertFromUint16ToDouble(obj,val)
            validateattributes(val,{'uint16'},{'nonempty'},'convertFromUint16ToDouble');
            if(obj.isLimitedUint16())
                res = double(ConversionLinear.clampAffineTransform(obj.m_lowerLimitUint16,...
                    val, obj.m_upperLimitUint16, obj.m_scale, obj.m_offset)) ;
            else
                res = double(ConversionLinear.affineTransform(val, obj.m_scale, obj.m_offset)) ;
            end
        end
        
        function res = convertFromDoubleToUint16(obj,val)
            validateattributes(val,{'double'},{'nonempty'},'convertFromDoubleToUint16');
            if(obj.isLimitedDouble())
                res = uint16(ConversionLinear.clampAffineTransform(obj.m_lowerLimitDouble,...
                    val, obj.m_upperLimitDouble, obj.m_scale, obj.m_offset)) ;
            else
                res = uint16(ConversionLinear.affineTransform(val, obj.m_scale, obj.m_offset)) ;
            end
        end
        
        function res = convertFromDoubleToDouble(obj,val)
            validateattributes(val,{'double'},{'nonempty'},'convertFromDoubleToDouble');
            if(obj.isLimitedDouble())
                res = double(ConversionLinear.clampAffineTransform(obj.m_lowerLimitDouble,...
                    val, obj.m_upperLimitDouble, obj.m_scale, obj.m_offset)) ;
            else
                res = double(ConversionLinear.affineTransform(val, obj.m_scale, obj.m_offset)) ;
            end
        end
        
        
        function res = invConvertFromUint16ToUint16(obj,val)
            validateattributes(val,{'uint16'},{'nonempty'},'invConvertFromUint16ToUint16');
            if(obj.isInvConversionLimitedUint16())
                res = uint16(ConversionLinear.clampInvAffineTransform(obj.m_convertedMinValueUint16,...
                    val, obj.m_convertedMaxValueUint16, obj.m_invScale, obj.m_offset)) ;
            else
                res = uint16(ConversionLinear.invAffineTransform(val, obj.m_invScale, obj.m_offset)) ;
            end
        end
        
        function res = invConvertFromUint16ToDouble(obj,val)
            validateattributes(val,{'uint16'},{'nonempty'},'invConvertFromUint16ToDouble');
            if(obj.isInvConversionLimitedUint16())
                res = double(ConversionLinear.clampInvAffineTransform(obj.m_convertedMinValueUint16,...
                    val, obj.m_convertedMaxValueUint16, obj.m_invScale, obj.m_offset)) ;
            else
                res = double(ConversionLinear.invAffineTransform(val, obj.m_invScale, obj.m_offset)) ;
            end
        end
        
        function res = invConvertFromDoubleToUint16(obj,val)
            validateattributes(val,{'double'},{'nonempty'},'invConvertFromDoubleToUint16');
            if(obj.isInvConversionLimitedDouble())
                res = uint16(ConversionLinear.clampInvAffineTransform(obj.m_convertedMinValueDouble,...
                    val, obj.m_convertedMaxValueDouble, obj.m_invScale, obj.m_offset)) ;
            else
                res = uint16(ConversionLinear.invAffineTransform(val, obj.m_invScale, obj.m_offset)) ;
            end
        end
        
        function res = invConvertFromDoubleToDouble(obj,val)
            validateattributes(val,{'double'},{'nonempty'},'invConvertFromDoubleToDouble');
            if(obj.isInvConversionLimitedDouble())
                res = double(ConversionLinear.clampInvAffineTransform(obj.m_convertedMinValueDouble,...
                    val, obj.m_convertedMaxValueDouble, obj.m_invScale, obj.m_offset)) ;
            else
                res = double(ConversionLinear.invAffineTransform(val, obj.m_invScale, obj.m_offset)) ;
            end
        end
        
        
        
    end
    
    
    
    methods( Access = private, Hidden)
        
        function isLimited = isInvConversionLimitedUint16(obj)
            isLimited = intmin('uint16') ~= obj.m_convertedMinValueUint16 || ...
                intmax('uint16') ~= obj.m_convertedMaxValueUint16 ;
        end
        
        function isLimited = isInvConversionLimitedDouble(obj)
            isLimited = realmin('double') ~= obj.m_convertedMinValueDouble || ...
                realmax('double') ~= obj.m_convertedMaxValueDouble ;
        end
        
        function updateInvScale(obj,scale)
            obj.m_invScale =  ConversionLinear.scaleToInvScale(scale);
        end
         
    end
    
    
    methods( Access = private, Static = true, Hidden )
        
        function val = scaleToInvScale(scale)
            if scale == 0.0
                val = 0.0;
            else
                val = 1.0 / double(scale);
            end
        end
        
        function transformedVal = affineTransform(value, slope, intercept)
            transformedVal = double(value)* double(slope) + double(intercept);
        end
        
        
        function transformedVal = clampAffineTransform(lowerLimit,value,upperLimit,slope,intercept)
            transformedVal = double(clamp(lowerLimit,value,upperLimit)) * double(slope) + double(intercept);
        end
        
        
        function invTransformedVal = invAffineTransform(value, invSlope, intercept)
            invTransformedVal = (double(value) - double(intercept)) * double(invSlope);
        end
        
        
        function invTransformedVal = clampInvAffineTransform(lowerLimit,value,upperLimit,invSlope,intercept)
            invTransformedVal = (double(clamp(lowerLimit,value,upperLimit)) - double(intercept)) * double(invSlope);
        end
        
    end
    
end


