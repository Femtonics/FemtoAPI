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

function [ curveData ] = getCurve( obj, measurementHandle, curveIdx )
%GETCURVE Gets curve data as Nx2 matrix from the specified measurement unit, 
% and channel within this unit. 
%
% INPUTS: 
%  measurementHandle        - unique measurement handle id, an 1xN (or Nx1)
%                             matrix
%  curveIdx                 - index of the requested curve within the
%                             given measurement unit
% OUTPUT: 
%  curveData                - an Nx2 matrix containing the 'X' and 'Y'
%                             curve data
%
%
% Example: 
%  Getting curve data from measurement unit [72,0,1] and curve index 0: 
% 
%  curveData = femtoAPIObj.getCurve([72,0,1],0);
%  curveData(:,1) % contains curve data 'X' 
%  curveData(:,2) % contains curve data 'Y'
% 
% Note: 
%  This command gives only the curve data as output. Information about valid curve 
%  indexes per each opened measurement unit can acquired by issuing
%  getProcessingState() command.
% 
validateattributes(measurementHandle,{'numeric'},{'vector','nonnegative','integer'},'getCurve','measurementHandle',1);
validateattributes(curveIdx,{'numeric'},{'scalar','nonnegative','integer'},'getCurve','idxChannel',2);

measurementHandle = reshape(measurementHandle,1,[]);
nodeString = strcat(num2str(measurementHandle(1:end-1),'%d,'),num2str(measurementHandle(end)));

curveData = femtoAPI('getCurve',nodeString,curveIdx);

end

