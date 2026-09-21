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

function [ curveData, curveInfo ] = readRawCurve( obj, unitHandle, curveIdx, varargin )
%READCURVE Reads raw curve data and curveInfo from the given measurement unit 
% Reads raw curve data as an 1x2 cell array, curveData{1} 
% and curveData{2} contain the 'X' and 'Y' curve data, and curveInfo
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
% OUTPUT: 
%  curveData                - a 1x2 cell array containing the 'X' and 'Y'
%                             curve data
% 
%  curveInfo                - struct, contains basic curve metainformation.  
%
%
% Example: 
%  Getting curve data from measurement unit [72,0,1] and curve idx 0: 
% 
%  [curveData, curveInfo] = femtoAPIObj.readCurve([72,0,1], 0);
% 
% See also ADDCURVE APPENDTOCURVE APPENDRAWTOCURVE READCURVE DELETECURVE
% 
narginchk(3,5);
validateattributes(unitHandle,{'numeric'},{'vector','nonnegative', ...
    'integer'},'readRawCurve','measurementHandle');
validateattributes(curveIdx,{'numeric'},{'scalar','nonnegative','integer'}, ...
    'readRawCurve','curveIdx');

vectorFormat = false;

if nargin >= 4 
    validateattributes(varargin{1}, {'logical'}, {'scalar'},'readRawCurve', ...
        'vectorFormat');
    vectorFormat = varargin{1};
end 

[curveData, curveInfo] = obj.femtoAPIMexWrapper('FemtoAPIFile.readCurveRaw', unitHandle, ...
    curveIdx, vectorFormat);
curveInfo = jsondecode(curveInfo);  

end

