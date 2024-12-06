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

classdef Color
    %COLOR Class to represent colors
    %   Represents colors multiple ways:
    %    - 3 (RGB) or 4 (ARGB or RGBA) element struct
    %    - hexadecimal representation as char array
    %    - array of uint32 numbers (bytes are alpha, red, green, blue
    %      channels in this order)
    % 
    %   Color can be constructed from multiple types: 
    %    - char array (each element is in format '#XXXXXX' or 'XXXXXXXX')
    %      (represents the alpha, red, green, blue channels as hex values
    %       0-255, in order) 
    %    - struct array in the same format as char array
    %    - array of uint32 numbers (same as the char array, only the hex
    %       numbers represented as uint32)
    %    - color struct array, where each element is a three (red, green, blue) 
    %      or four (alpha, red, green, blue) component color struct, where 
    %      range of each component is 0..255
    %
    %   Examples: 
    %     valuesARGB = struct('alpha',255,'red',10,'green',0,'blue',100);
    %     cObj = Color(valuesARGB,'ARGB')
    % 
    %     colors = ['#FF000000', '#00FF00FF'];
    %     cObj = Color(colors,'RGBA');
    %
    %     colors = uint32([255 65280])
    %     cObj = Color(colors,'ARGB');
    %
    
    
    properties (SetAccess = private)
        m_colorAs4C = struct('alpha',uint8(0),'red',uint8(0),'green',...
            uint8(0),'blue',uint8(0));
        m_colorAsUint32 = uint32(0);
        m_colorAsHex = "#00000000";
        %m_colorAsArray = [0 0 0 0];
        m_isARGB = false; % true if color order is 'ARGB', false otherwise
    end
    
    properties (Access = public, Constant) 
        m_defaultAlphaValue = uint8(255);
        m_defaultColorOrder = 'RGBA';
    end
    
    properties (SetAccess = private, Dependent)
       m_colorAsArray uint8
       m_colorAsARGBArray uint8 
       m_colorAsRGBAArray uint8      
    end
    
    methods(Static, Access = public)
        % color conversion methods 
        % hex <-> uint32
        colorsAsHex = colorUint32ToHex( colorsAsUint32, colorOrder );
        colorAsUint32 = colorHexToUint32( colorsAsHex )
        % uint32 <-> 4C 
        colorsAsFourComponent = colorUint32To4C(colorsAsUint32, colorOrder);
        colorAsUint32 = color4CToUint32(colorsAs4C, colorOrder);
        % hex <-> 4C 
        colorsAs4C = colorHexTo4C( colorsAsHex, colorOrder );
        colorsAsHex = color4CToHex( colorsAs4C, colorOrder );
        
        % uint8 array <-> uint32 
        colorAsUint32 = colorArrayToUint32( colorArray );
        colorAsUint8 = colorUint32ToArray( colorUint32 );
        
        % uint8 array <-> 4C 
        colorAs4C = colorArrayTo4C( colorArray, colorOrder );
        colorAsArray = color4CToArray( colorAs4C, colorOrder);

        % uint8 array <-> hex
        colorsAsHex = colorArrayToHex( colorArray, colorOrder );
        colorAsArray = colorHexToArray( colorAsHex, colorOrder );
       
        % colorMap -> hex
        colorMapAsHex = colorMapToHex( colormap, colorOrder );
    end
    
    methods
        function obj = Color(colorData,colorOrder)
            if(nargin > 2)
                error(strcat('Too many input arguments. Usage:',...
                'Color(colorData,colorOrder)'));
            elseif(nargin == 1)
                colorOrder = obj.m_defaultColorOrder;
                %error(strcat('Too few input arguments. Usage:',...
                %'Color(colorData, colorOrder)'));
            elseif(nargin == 0)
                return; % object constructed with default arguments
            else
               validatestring(colorOrder,{'ARGB','RGBA'},'Color','colorOrder');
               if(strcmp(colorOrder,'ARGB'))
                   obj.m_isARGB = true;
               else
                   obj.m_isARGB = false;
               end
            end
            
            if(isa(colorData,'char'))
                colorData = string(colorData);
            end
            
            if(isa(colorData,'string'))
                obj.m_colorAs4C = Color.colorHexTo4C(colorData,colorOrder);
                obj.m_colorAsUint32 = Color.colorHexToUint32(colorData);
                obj.m_colorAsHex = colorData; 
            elseif(isa(colorData,'uint32'))
                obj.m_colorAs4C = Color.colorUint32To4C(colorData,colorOrder);
                obj.m_colorAsHex = string(Color.colorUint32ToHex(colorData,colorOrder));
                obj.m_colorAsUint32 = colorData;
            elseif(isa(colorData,'uint8'))
                obj.m_colorAs4C = Color.colorArrayTo4C(colorData,colorOrder);
                obj.m_colorAsHex = string(Color.colorArrayToHex(colorData, colorOrder));
                obj.m_colorAsUint32 = Color.colorArrayToUint32(colorData);                
            elseif(isa(colorData,'struct'))
                obj.m_colorAsUint32 = Color.color4CToUint32(colorData, colorOrder);
                obj.m_colorAsHex = string(Color.color4CToHex(colorData,colorOrder));
                obj.m_colorAs4C = colorData;
            else
                error(['Input data type must be an array of ','''char'', ',...
                    '''string'', ','''uint32'', ','''uint8''',' or ','''struct''']);
            end
        end
        
        % getter functions (no setters, but one common reset method)
        function val = get.m_colorAs4C(obj)
            val = obj.m_colorAs4C;
        end
        
        function val = get.m_colorAsUint32(obj)
            val = obj.m_colorAsUint32;
        end
        
        function val = get.m_colorAsHex(obj)
            val = obj.m_colorAsHex;
        end
        
        function val = get.m_colorAsArray(obj)
            if(obj.m_isARGB)
               val = Color.color4CToArray(obj.m_colorAs4C,'ARGB'); 
            else
               val = Color.color4CToArray(obj.m_colorAs4C,'RGBA');
            end
        end
        
        function val = get.m_colorAsARGBArray(obj)
           val = Color.color4CToArray(obj.m_colorAs4C,'ARGB'); 
        end
        
        function val = get.m_colorAsRGBAArray(obj)
           val = Color.color4CToArray(obj.m_colorAs4C,'RGBA');
        end
        
        % conversion between ARGB <-> RGBA color
        function obj = convertToARGB(obj)
           if(obj.m_isARGB)
               return;
           else
              obj.m_colorAsHex = Color.color4CToHex(obj.m_colorAs4C,'RGBA');
              obj.m_colorAsUint32 = Color.color4CToUint32(obj.m_colorAs4C,'RGBA');
              obj.m_isARGB = true;
              %obj.m_colorAsUint8Array = Color.color4CToArray(obj.m_colorAs4C,'RGBA');
           end
        end
        
        function obj = convertToRGBA(obj)
            if(~obj.m_isARGB)
                return;
            else
              obj.m_colorAsHex = Color.color4CToHex(obj.m_colorAs4C,'ARGB');
              obj.m_colorAsUint32 = Color.color4CToUint32(obj.m_colorAs4C,'ARGB');   
              obj.m_isARGB = false;
            end
        end
        
        
        % resetting color: does the same as the constructor, but on an 
        % existing object
        function obj = reset(obj,colorData)
            if(nargin == 0)
                return;
            end
            obj = Color(colorData,'RGBA');
        end
        
        % Color object operator overloading
        function addedColor = plus(obj1,obj2)
            if(obj1.m_colorOrder ~= obj2.m_colorOrder)
                error('Cannot add colors, because color orders are different.');
            end
            
            if(strcmp(obj1.m_colorOrder,'ARGB'))
                addedColor = clamp(0,obj1.m_colorAsARGBArray + ...
                    obj2.m_colorAsARGBArray,255);
                addedColor = Color(uint8(addedColor),'ARGB');
            else
                addedColor = clamp(0,obj1.m_colorAsRGBAArray + ...
                    obj2.m_colorAsRGBAArray,255);
                addedColor = Color(uint8(addedColor),'ARGB');        
            end
           
        end
        
        % subtract two Colors
        function subtractedColor = minus(obj1,obj2)
            if(obj1.m_colorOrder ~= obj2.m_colorOrder)
                error('Cannot subtract colors, because color orders are different.');
            end            
            if(strcmp(obj1.m_colorOrder,'ARGB'))
                subtractedColorArray = clamp(0,obj1.m_colorAsARGBArray - ...
                    obj2.m_colorAsARGBArray,255);
                subtractedColor = Color(subtractedColorArray,'ARGB');
            else
                subtractedColorArray = clamp(0,obj1.m_colorAsRGBAArray - ...
                    obj2.m_colorAsRGBAArray,255);
                subtractedColor = Color(subtractedColorArray,'ARGB');                
            end
        end
        
        % multiply Color by number
        function colorMult = mtimes(val,obj1)
            validateattributes(val,{'numeric'},{'nonempty','scalar','positive'});
            colorMult = clamp(0,obj1.m_colorAsARGBArray * val,255);
            colorMult = Color(colorMult);
        end        
        
        % equality of two Color objects: lower/upper case of the same hex
        % character are equal as value
        function val = eq(obj1,obj2)
            val = isequal(obj1.m_colorAs4C,obj2.m_colorAs4C) && ...
                  isequal(obj1.m_colorAsArray,obj2.m_colorAsArray) && ...
                  isequal(obj1.m_colorAsUint32,obj2.m_colorAsUint32) && ...
                  strcmpi(obj1.m_colorAsHex,obj2.m_colorAsHex) && ...
                  isequal(obj1.m_isARGB, obj2.m_isARGB);        
        end
             
    end
    
    
    methods(Static, Access = private)
        validate4CStruct( colorsAs4C );
    end
    
    
end

