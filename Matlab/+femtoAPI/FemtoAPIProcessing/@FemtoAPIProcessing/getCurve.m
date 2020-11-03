function [ curveData ] = getCurve( obj, measurementHandle, idxChannel )
%GETCURVE Gets curve data as Nx2 matrix from the specified measurement unit, 
% and channel within this unit. 
%
% INPUTS: 
%  measurementHandle        - unique measurement handle id, an 1xN (or Nx1)
%                             matrix
%  idxChannel               - index of the requested channel within the
%                             given measurement unit
% OUTPUT: 
%  curveData                - an Nx2 matrix containing the 'X' and 'Y'
%                             curve data
%
%
% Example: 
%  Getting curve data from measurement unit [72,0,1] and channel 0: 
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
validateattributes(idxChannel,{'numeric'},{'scalar','nonnegative','integer'},'getCurve','idxChannel',2);

measurementHandle = reshape(measurementHandle,1,[]);
nodeString = strcat(num2str(measurementHandle(1:end-1),'%d,'),num2str(measurementHandle(end)));

curveData = femtoAPI('getCurve',nodeString,idxChannel);

end

