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

classdef ConversionIdentity < ConversionNoParamsIF
    %UNTITLED17 Summary of this class goes here
    %   Detailed explanation goes here
    
    
    properties (Dependent, Access = protected)
        m_monotonicity ;
    end
    
    properties (SetAccess = protected, GetAccess = public)
        m_convertedMinValueUint16 ;
        m_convertedMaxValueUint16 ;
        m_convertedMinValueDouble ;
        m_convertedMaxValueDouble ;
    end
    
    methods
        function obj = ConversionIdentity(title, unitName)
            obj@ConversionNoParamsIF(EConversionType.eIdentity,title,unitName);
        end
        
        
        % getter/setter methods
        function val = get.m_monotonicity(obj)
            if (obj.isLimited())
                val = EMonotonicity.eWeaklyIncreasing ;
            else
                val = EMonotonicity.eStrictlyIncreasing;
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
            val = obj.m_lowerLimitUint16 ;
        end
        
        function val = get.m_convertedMaxValueUint16(obj)
            val = obj.m_upperLimitUint16 ;
        end
        
        function val = get.m_convertedMinValueDouble(obj)
            val = obj.m_lowerLimitDouble ;
        end
        
        function val = get.m_convertedMaxValueDouble(obj)
            val = obj.m_upperLimitDouble ;
        end
        
        
        
        function ret = isWithinConvertedMinMaxValuesUint16(obj,val)
            ret = obj.isWithinLimitsUint16(val);
        end
        
        function ret = isWithinConvertedMinMaxValuesDouble(obj,val)
            ret = obj.isWithinLimitsDouble(val);
        end
        
        function ret = offsetBy(add)
            validateattributes(add,{'double'},{'scalar'},'','add');
            if(0 == add)
                ret = true(1);
            else
                ret = false(1);
            end
        end
        
        function ret = scaleBy(scale)
            validateattributes(scale,{'double'},{'scalar'},'','scale');
            if(1 == scale)
                ret = true(1);
            else
                ret = false(1);
            end
        end
        
    end
    
    % conversion helper methods implementation
    methods ( Access = protected, Hidden )
        function res = convertFromUint16ToUint16(obj,val)
            validateattributes(val,{'uint16'},{'nonempty'},'convertFromUint16ToUint16');
            if(obj.isLimitedUint16())
                res = uint16(clamp(obj.m_lowerLimitUint16, val, obj.m_upperLimitUint16)) ;
            else
                res = val;
            end
        end
        
        function res = convertFromUint16ToDouble(obj,val)
            validateattributes(val,{'uint16'},{'nonempty'},'convertFromUint16ToDouble');
            if(obj.isLimitedUint16())
                res = double(clamp(obj.m_lowerLimitUint16, val, obj.m_upperLimitUint16)) ;
            else
                res = double(val);
            end
        end
        
        function res = convertFromDoubleToUint16(obj,val)
            validateattributes(val,{'double'},{'nonempty'},'convertFromDoubleToUint16');
            clampLower = max(obj.m_lowerLimitDouble,double(intmin('uint16')));
            clampUpper = min(obj.m_upperLimitDouble,double(intmax('uint16')));
            
            res = uint16(clamp(clampLower,val,clampUpper));
        end
        
        function res = convertFromDoubleToDouble(obj,val)
            validateattributes(val,{'double'},{'nonempty'},'convertFromDoubleToDouble');
            if(obj.isLimitedDouble())
                res = double(clamp(obj.m_lowerLimitDouble, val, obj.m_upperLimitDouble)) ;
            else
                res = double(val);
            end
        end
        
        function res = invConvertFromUint16ToUint16(obj,val)
            res = convertFromUint16ToUint16(obj,val);
        end
        
        function res = invConvertFromUint16ToDouble(obj,val)
            res = convertFromUint16ToDouble(obj,val);
        end
        
        function res = invConvertFromDoubleToUint16(obj,val)
            res = convertFromDoubleToUint16(obj,val);
        end
        
        function res = invConvertFromDoubleToDouble(obj,val)
            res = convertFromDoubleToDouble(obj,val);
        end
        
    end
    
    
end

