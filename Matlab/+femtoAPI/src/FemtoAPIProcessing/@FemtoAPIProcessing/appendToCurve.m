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

function succeeded = appendToCurve( obj, measurementHandle, curveIdx, ...
    curveData, xType, xDataType, yType, yDataType )
%APPENDTOCURVE Appends an existing curve in a measurement unit.
%
% INPUTS:
%  measurementHandle        - unique measurement handle id, an 1xN (or Nx1)
%                             vector in which the curve is located
%  curveIdx                 - nonegative integer, index of the curve to
%                             append
%  curveData                - curve data to append with
%  xType                    - string, value can be 'equidistant' or 'vector'
%  xDataType                - string, value can be 'double' or 'uint16'
%  yType                    - string, value can be 'rle' or 'vector'
%  yDataType                - string, same as xDataType
%
% OUTPUT:
%  succeeded                - true, if curve append operation succeeded, 
%                             false otherwise
%
%
% Example:
%  Append curve to measurement unit [72,0,1]:
%
%  curveInfo = femtoAPIObj.appendToCurve([72,0,1],10, curveData,
%                   'equidistant', 'double','vector','double',true);
%
% See also READCURVE WRITECURVE CURVEINFO
%
narginchk(8,8);
validateattributes(measurementHandle,{'numeric'},{'vector','nonnegative', ...
    'integer'},'appendToCurve','measurementHandle');
validateattributes(curveIdx,{'numeric'},{'scalar','nonnegative','integer'}, ...
    'appendToCurve','size');
%validateattributes(curveData,{'numeric'},{'ncols',2},'writeCurve','curveData');
params = convertStringsToChars({xType, xDataType, yType, yDataType});
validateattributes(params{1},{'char'},{'vector','row'},'appendToCurve','xType');
validateattributes(params{2},{'char'},{'vector','row'},'appendToCurve','xDataType');
validateattributes(params{3},{'char'},{'vector','row'},'appendToCurve','yType');
validateattributes(params{4},{'char'},{'vector','row'},'appendToCurve','yDataType');

if xType == "equidistant"
    validateattributes(curveData,{'cell'},{'ncols',1},'appendToCurve','curveData');
    curveDataY = curveData{1};
    xDataSize = length(curveDataY);
else
    validateattributes(curveData,{'cell'},{'ncols',2},'appendToCurve','curveData');
    curveDataY = curveData{2};  
    xDataSize = length(curveData{1});
end

% set y data 
if yType == "vector"
    
    attachment    = cell(1, 2);    
    yDataSize     = length( curveDataY );
    
    if yDataType == "uint16"
        attachment{2} = uint16( curveDataY );
    elseif yDataType == "double"
        attachment{2} = double( curveDataY );  
    else
        error("Y data type valid values are 'uint16' or 'double'");
    end
        
elseif yType == "rle"
    
    if mod( length(curveDataY), 2 ) ~= 0 
        error("In case of 'rle' y type, y data size must be even.");
    end
    
    repCounts = uint32( curveDataY(1:2:end) ); % repCount is always uint32
    
    if yDataType == "uint16"
        values = uint16( curveDataY(2:2:end) );
    elseif yDataType == "double"
        values = double( curveDataY(2:2:end) );  
    else
        error("Y data type valid values are 'uint16' or 'double'");
    end
    
    attachment = cell(1, length(repCounts)*2 + 1);
    % upload data     
    for i = 1 : length(repCounts)
       attachment{i*2}     = repCounts(i);
       attachment{i*2 + 1} = values(i);
    end    
     
    yDataSize = sum(repCounts); 
else 
    error("Y data type must be 'vector' or 'rle'"); 
end

% set x data
if xType ~= "equidistant"    
    if xDataSize ~= yDataSize
       error("X and Y curve data size must be equal"); 
    end
    
    if xDataType == "double"
        attachment{1} = double(curveData{1});
    elseif xDataType == "uint16"
        attachment{1} = uint16(curveData{1});
    else 
        error("X data type valid values are 'uint16' or 'double'");
    end     
else 
    attachment{1} = [];
end


obj.femtoAPIMexWrapper('uploadAttachment',attachment);

succeeded = obj.femtoAPIMexWrapper('FemtoAPIFile.appendToCurve', ...
    measurementHandle, ...
    curveIdx, ...
    yDataSize, ...
    xType, xDataType, ...
    yType, yDataType);

succeeded = jsondecode(succeeded);
end

