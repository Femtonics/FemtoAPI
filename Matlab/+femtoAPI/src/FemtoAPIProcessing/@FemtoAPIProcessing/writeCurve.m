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

function curveInfo = writeCurve( obj, unitHandle, curveData, name, ...
            xType, xDataType, yType, yDataType, optimize )
%WRITECURVE Adds new curve to the given measurement unit. 
%  Parameter curveData is an 1x2 cell array, which corresponds to  the x
%  and  y curve data. If y data type is 'rle', then curveData{2} is
%  an array which contains pairs of counts and values: 
%  [count1, value1, ... ,countN, valueN]. 
%  
% INPUTS: 
%  unitHandle               - unique measurement unit handle id, an 1xN 
%                             (or Nx1) vector in which the curve is located 
%  curveData                - 1x2 cell array, corresponding the x and y 
%                             curve data 
%  xType                    - char array or string, value can be 'equidistant' 
%                             or 'vector'
%  xDataType                - char array or string, value can be 'double' 
%                             or 'uint16' 
%  yType                    - char array string, value can be 'rle' or 
%                             'vector' 
%  yDataType                - char array or string, same as xDataType 
%
%  optimize                 - bool, flages whether the provided data is 
%                             wanted to be analyzed  for possible compressions 
%                             (encode x as equidistant or y as rle if it 
%                             provides a smaller size)
% 
% OUTPUT: 
%  curveInfo                - struct, containing basic info of the written
%                             curve
%
%
% Example: 
%  Adding an equidistant curve to measurement unit [72,0,1]:
%  curveData = {[0 1], [2.3 10.4 5 6 7 8]};
%  curveInfo = femtoAPIObj.writeCurve([72,0,1], curveData, 'Curve_007', ... 
%                  'equidistant', 'double','vector','double',true);
% 
% See also READCURVE CURVEINFO
% 
narginchk(9,9);
validateattributes(unitHandle,{'numeric'},{'vector','nonnegative', ...
    'integer'},'writeCurve','measurementHandle');
validateattributes(curveData,{'cell'},{'ncols',2},'writeCurve','curveData');

[name, xType, xDataType, yType, yDataType] = convertCharsToStrings(name,...
    xType, xDataType, yType, yDataType);

validateattributes(name,{'string'},{'scalar'},'writeCurve','name');
validateattributes(xType,{'string'},{'scalar'},'writeCurve','xType');
validateattributes(xDataType,{'string'},{'scalar'},'writeCurve','xDataType');
validateattributes(yType,{'string'},{'scalar'},'writeCurve','yType');
validateattributes(yDataType,{'string'},{'scalar'},'writeCurve','yDataType');
validateattributes(optimize,{'logical'},{'scalar'},'writeCurve','optimize');

% upload y data 
if yType == "vector"
    
    attachment    = cell(1, 2);
    
    curveSize     = length( curveData{2} );
    attachment{2} = curveData{2};
    
elseif yType == "rle"
    
    if mod( length(curveData{2}), 2 ) ~= 0 
        error("In case of 'rle' y type, y data size must be even.");
    end
    
    repCounts = uint32( curveData{2}(1:2:end) ); % repCount is always uint32
    
    if yDataType == "uint16"
        values = uint16( curveData{2}(2:2:end) );
    elseif yDataType == "double"
        values = double( curveData{2}(2:2:end) );  
    else
        error("Y data type valid values are 'uint16' or 'double'");
    end
    
    attachment = cell(1, length(repCounts)*2 + 1);
    % upload data     
    for i = 1 : length(repCounts)
       attachment{i*2}     = repCounts(i);
       attachment{i*2 + 1} = values(i);
    end    
     
    curveSize = sum(repCounts); 
else 
    error("Y data type must be 'vector' or 'rle'"); 
end

% upload x data
if xDataType == "double"
    attachment{1} = double(curveData{1});
elseif xDataType == "uint16"
    attachment{1} = uint16(curveData{1});
else 
    error("X data type valid values are 'uint16' or 'double'");
end

obj.femtoAPIMexWrapper('uploadAttachment', attachment);       
curveInfo = obj.femtoAPIMexWrapper('FemtoAPIFile.writeCurve', unitHandle, curveSize, ...
                        name, xType, xDataType, yType, yDataType, optimize);
curveInfo = jsondecode(curveInfo);  

end

