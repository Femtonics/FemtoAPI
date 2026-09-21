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

function curveInfo = addCurve( obj, unitHandle, name, ...
            xType, xDataType, yType, yDataType, varargin )
%ADDCURVE Adds new curve to the given measurement unit. 
%  Data should be written into the curve with appendToCurve() or
%  appendRawToCurve(), possibly after setting the conversion with
%  setUnitMetadata().
%  
% INPUTS: 
%  unitHandle               - unique measurement unit handle id, an 1xN 
%                             (or Nx1) vector in which the curve is located 
%  xType                    - char array or string, value can be 'equidistant' 
%                             or 'vector'
%  xDataType                - char array or string, value can be 'double' 
%                             or 'uint16' 
%  yType                    - char array string, value can be 'rle' or 
%                             'vector' 
%  yDataType                - char array or string, same as xDataType 
% 
% INPUTS [optional]: 
%  x0                       - first X data in equidistant case
%
%  xStep                    - X data step in equidistant case
%
% OUTPUT: 
%  curveInfo                - struct, containing basic info of the written
%                             curve
%
%
% Example: 
%  Adding an equidistant curve to measurement unit [72,0,1]:
%  curveInfo = femtoAPIObj.writeCurve([72,0,1], 'Curve_007', ... 
%                  'equidistant', 'double', 'vector', 'double', 0, 0.03);
% 
% See also APPENDTOCURVE APPENDRAWTOCURVE READCURVE READRAWCURVE DELETECURVE
% 
narginchk(7,9);
validateattributes(unitHandle,{'numeric'},{'vector','nonnegative', ...
    'integer'},'addCurve','measurementHandle');

[name, xType, xDataType, yType, yDataType] = convertCharsToStrings(name,...
    xType, xDataType, yType, yDataType);

validateattributes(name,{'string'},{'scalar'},'addCurve','name');
validateattributes(xType,{'string'},{'scalar'},'addCurve','xType');
validateattributes(xDataType,{'string'},{'scalar'},'addCurve','xDataType');
validateattributes(yType,{'string'},{'scalar'},'addCurve','yType');
validateattributes(yDataType,{'string'},{'scalar'},'addCurve','yDataType');

if ~any(strcmp(yType, [ "vector", "rle" ]))
    error("Y data type must be 'vector' or 'rle'");
end

if ~any(strcmp(yDataType, [ "uint16", "double" ]))
    error("Y data type valid values are 'uint16' or 'double'");
end

if ~any(strcmp(xType, [ "vector", "equidistant" ]))
    error("X type must be 'vector' or 'equidistant'");
end

if ~any(strcmp(xDataType, [ "double", "uint16" ]))
    error("X data type valid values are 'uint16' or 'double'");
end

if nargin == 9
    validateattributes(varargin{1}, {'double'}, {'scalar'}, 'addCurve', ...
        'x0');
    x0 = varargin{1};
    
    validateattributes(varargin{2}, {'double'}, {'scalar'}, 'addCurve', ...
        'xStep');
    xStep = varargin{2};
end

if strcmp(xType, "equidistant")
    if nargin ~= 9
        error("If xType is 'equidistant' then x0 and xStep should be given");
    end
    
    obj.femtoAPIMexWrapper('uploadAttachment', { [ x0, xStep ] });
end

curveInfo = obj.femtoAPIMexWrapper('FemtoAPIFile.addCurve', unitHandle, ...
                        name, xType, xDataType, yType, yDataType);
curveInfo = jsondecode(curveInfo);

end