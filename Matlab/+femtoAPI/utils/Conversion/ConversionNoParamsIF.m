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

classdef ConversionNoParamsIF < ConversionIF
    %ConversionNoParamsIF Summary of this class goes here
    %   Detailed explanation goes here
    
    
    properties (AbortSet = true)
        m_sTitle ;
        m_sUnitName ;
    end
    
    properties (Constant, Hidden)
        m_sDefaultTitle = 'untitled';
        m_sDefaultUnitName = 'unknown unit';
    end
    
    properties (SetAccess = protected, GetAccess = public)
        m_lowerLimitDouble = ConversionIF.m_defaultLowerLimitDouble;
        m_upperLimitDouble = ConversionIF.m_defaultUpperLimitDouble;
        m_lowerLimitUint16 = ConversionIF.m_defaultLowerLimitUint16;
        m_upperLimitUint16 = ConversionIF.m_defaultUpperLimitUint16;
    end
    

    methods
        function obj = ConversionNoParamsIF(conversionType, varargin)
            if nargin == 0
                error('Not enough input arguments');
            elseif nargin > 3
                error('Too many input arguments');
            end
            numvarargs = length(varargin);
            obj = obj@ConversionIF(conversionType);
            optargs = {obj.m_sDefaultTitle obj.m_sDefaultUnitName};
            optargs(1:numvarargs) = varargin;
            [title, unitName] = optargs{:};
            
            validateattributes(title,{'char'},{'vector'},'','title',2);
            validateattributes(unitName,{'char'},{'vector'},'','unitName',3);
            obj.m_sTitle = title;
            obj.m_sUnitName = unitName;
            
%             obj.m_lowerLimitDouble = ConversionIF.m_defaultLowerLimitDouble;
%             obj.m_upperLimitDouble = ConversionIF.m_defaultUpperLimitDouble;
%             obj.m_lowerLimitUint16 = ConversionIF.m_defaultLowerLimitUint16;
%             obj.m_upperLimitUint16 = ConversionIF.m_defaultUpperLimitUint16;
        end
        
        
        % setter/getter methods
        function set.m_lowerLimitDouble(obj,val)
            validateattributes(val,{'double'},{'scalar','nonempty'});
            obj.m_lowerLimitDouble = val;
        end
        
        function set.m_upperLimitDouble(obj,val)
            validateattributes(val,{'double'},{'scalar','nonempty'});
            obj.m_upperLimitDouble = val;
        end
        
        function set.m_lowerLimitUint16(obj,val)
            validateattributes(val,{'uint16'},{'scalar','nonempty'});
            obj.m_lowerLimitUint16 = val;
        end
        
        function set.m_upperLimitUint16(obj,val)
            validateattributes(val,{'uint16'},{'scalar','nonempty'});
            obj.m_upperLimitUint16 = val;
        end
        
        
        function val = get.m_lowerLimitDouble(obj)
            val = obj.m_lowerLimitDouble;
        end
        
        function val = get.m_upperLimitDouble(obj)
            val = obj.m_upperLimitDouble;
        end
        
        function val = get.m_lowerLimitUint16(obj)
            val = obj.m_lowerLimitUint16;
        end
        
        function val = get.m_upperLimitUint16(obj)
            val = obj.m_upperLimitUint16 ;
        end
        
        function title = get.m_sTitle(obj)
            title = obj.m_sTitle;
        end
        
        function unitName = get.m_sUnitName(obj)
            unitName = obj.m_sUnitName;
        end
        
        %         function val = get.m_sDefaultTitle(obj)
        %             val = obj.m_sDefaultTitle;
        %         end
        %
        %         function val = get.m_sDefaultUnitName(obj)
        %             val = obj.m_sDefaultUnitName;
        %         end
        
        function set.m_sTitle(obj,newTitle)
            validateattributes(newTitle,{'char'},{'vector'},'set.m_sTitle');
            if(~isequal(obj.m_sTitle,newTitle))
                obj.m_sTitle = newTitle;
            end
        end
        
        function set.m_sUnitName(obj, newUnitName)
            validateattributes(newUnitName,{'char'},{'vector'},'set.m_sUnitName');
            if(~isequal(obj.m_sUnitName,newUnitName))
                obj.m_sUnitName = newUnitName;
            end
        end
        
        
        function resetLimitsFromUint16Values(obj,varargin)
            numVarargs = length(varargin);
            if numVarargs > 2
                error('Too many input arguments');
            end
            
            optargs = {obj.m_defaultLowerLimitUint16 obj.m_defaultUpperLimitUin16};
            optargs(1:numVarargs) = varargin;
            [lowerLimitUint16, upperLimitUint16] = optargs{:};
            validateattributes(lowerLimitUint16,{'uint16'},{'scalar','nonempty'},'resetLimitsFromUint16Values',1);
            validateattributes(upperLimitUint16,{'uint16'},{'scalar','nonempty'},'resetLimitsFromUint16Values',2);
            
            if( lowerLimitUint16 > upperLimitUint16)
                temp = lowerLimitUint16;
                lowerLimitUint16 = upperLimitUint16;
                upperLimitUint16 = temp;
            end
            
            lowerLimitDouble = intmin('uint16');
            if(lowerLimitDouble == obj.m_lowerLimitUint16)
                lowerLimitDouble = realmin('double');
            else
                lowerLimitDouble = double(obj.m_lowerLimitUint16);
            end
            
            upperLimitDouble = intmax('uint16');
            if(upperLimitDouble == obj.m_upperLimitUint16)
                upperLimitDouble = realmax('double');
            else
                upperLimitDouble = double(obj.m_lowerLimitUint16);
            end
            
            if(obj.m_lowerLimitUint16 ~= lowerLimitUint16 || ...
                    obj.m_upperLimitUint16 ~= upperLimitUint16 || ...
                    obj.m_lowerLimitDouble ~= lowerLimitDouble || ...
                    obj.m_upperLimitDouble ~= upperLimitDouble )
                obj.m_lowerLimitUint16 = lowerLimitUint16;
                obj.m_upperLimitUint16 = upperLimitUint16;
                obj.m_lowerLimitDouble = lowerLimitDouble;
                obj.m_upperLimitDouble = upperLimitDouble;
                obj.limitsChanged();
            end
        end
        
        function resetLimitsFromDoubleValues(obj, varargin)
            numVarargs = length(varargin);
            if numVarargs > 2
                error('Too many input arguments');
            end
            
            optargs = {obj.m_defaultLowerLimitDouble obj.m_defaultUpperLimitDouble};
            optargs(1:numVarargs) = varargin;
            [lowerLimitDouble, upperLimitDouble] = optargs{:};
            validateattributes(lowerLimitDouble,{'double'},{'scalar','nonempty'},'resetLimitsFromDoubleValues',...
                'lowerLimitDouble');
            validateattributes(upperLimitDouble,{'double'},{'scalar','nonempty'},'resetLimitsFromDoubleValues',...
                'upperLimitDouble');
            
            
            if( lowerLimitDouble > upperLimitDouble)
                temp = lowerLimitDouble;
                lowerLimitDouble = upperLimitDouble;
                upperLimitDouble = temp;
            end
            
            
            lowerLimitUint16 = uint16(clamp(double(intmin('uint16')),lowerLimitDouble,...
                double(intmax('uint16'))));
            
            upperLimitUint16 = uint16(clamp(double(intmin('uint16')),upperLimitDouble,...
                double(intmax('uint16'))));
            
            if(obj.m_lowerLimitUint16 ~= lowerLimitUint16 || ...
                    obj.m_upperLimitUint16 ~= upperLimitUint16 || ...
                    obj.m_lowerLimitDouble ~= lowerLimitDouble || ...
                    obj.m_upperLimitDouble ~= upperLimitDouble )
                obj.m_lowerLimitUint16 = lowerLimitUint16;
                obj.m_upperLimitUint16 = upperLimitUint16;
                obj.m_lowerLimitDouble = lowerLimitDouble;
                obj.m_upperLimitDouble = upperLimitDouble;
                obj.limitsChanged();
            end
        end
        
    end
    
end

