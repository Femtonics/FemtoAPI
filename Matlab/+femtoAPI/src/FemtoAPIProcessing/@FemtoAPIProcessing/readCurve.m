function [ curveData, curveInfo ] = readCurve( obj, unitHandle, curveIdx, varargin )
%READCURVE Reads curve data and curveInfo from the given measurement unit 
% Reads curve data and info as an 1x3 cell array, curveData{1} 
% and curveData{2} contain the 'X' and 'Y' curve data, and curveData{3}
% contains the curve metadata. 
%
% INPUTS: 
%  unitHandle               - unique measurement unit handle id, an 1xN 
%                             (or Nx1) vector in which the curve is located 
%  curveIdx                 - integer containing the curve index
% 
% INPUTS [optional]: 
%  vectorformat             - bool, if true, the RLE and equidistant curve 
%                             data is extracted to vectors. Default: false 
%
%  forceDouble              - bool, if true, the uint16 output data samples
%                             are converted to double samples. 
%                             Default: false
%
% OUTPUT: 
%  curveData                - a 1x3 cell array containing the 'X' and 'Y'
%                             curve data and curveInfo struct
% 
%  curveInfo                - struct, contains basic curve metainformation.  
%
%
% Example: 
%  Getting curve data from measurement unit [72,0,1] and curve idx 0: 
% 
%  curveData = femtoAPIObj.readCurve([72,0,1],0);
% 
% See also WRITECURVE CURVEINFO 
% 
narginchk(3,5);
validateattributes(unitHandle,{'numeric'},{'vector','nonnegative', ...
    'integer'},'readCurve','measurementHandle');
validateattributes(curveIdx,{'numeric'},{'scalar','nonnegative','integer'}, ...
    'readCurve','curveIdx');

vectorFormat = false;
forceDouble = false; 

if nargin >= 4 
    validateattributes(varargin{1}, {'logical'}, {'scalar'},'readCurve', ...
        'vectorFormat');
    vectorFormat = varargin{1};
end 
if nargin == 5 
    validateattributes(varargin{2}, {'logical'}, {'scalar'},'readCurve', ...
        'forceDouble');
    forceDouble = varargin{2};
end 

[curveData, curveInfo] = obj.femtoAPIMexWrapper('FemtoAPIFile.readCurve', unitHandle, ...
    curveIdx, vectorFormat, forceDouble);
curveInfo = jsondecode(curveInfo);  

end

