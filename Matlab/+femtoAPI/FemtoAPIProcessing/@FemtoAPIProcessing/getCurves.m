function curveMap = getCurves( obj, measurementHandle, channelType )
%GETCURVES Gets curve names and data for the given measurement unit 
% Returns a curve map with curve name as key and corresponding data as value 
% for the requested measurement unit and channel type (Input/output).
% If there is no curve for the selected channel type, an empty map is
% returned. 
% 
% Note: if the measurement contains lots of big curves, it can take long time 
% 
% INPUTS: 
%  measurementHandle         numeric array, handle of measurement unit,
%                            e.g. [23,0,0]
%
%  channelType               char array, type of channel to filter to, 
%                            must be 'Input' or 'Output'
%
% OUTPUT: 
%  curveMap                  map, contains curve name (key) and 
%                            corresponding curve data (values) 
%

% get metadata of curves as array
curvesMetaData = obj.getMeasurementMetaDataField(measurementHandle,'curves');
validatestring(channelType,{'Input','Output'});
if( strcmp(channelType,'Input') )
   comment =  ["INPUT", "ELECTROGRAM"];
else
   comment =  ["OUTPUT", "ELECTROGRAM"];
end

numOfAllCurves = length(curvesMetaData);
curveMap = containers.Map;

for i=1:numOfAllCurves
    curveMetaData = curvesMetaData(i);
    if( contains(curveMetaData.comment,comment(1),'IgnoreCase',true) && ... 
        contains(curveMetaData.comment,comment(2),'IgnoreCase',true) ) 
        curveName = curveMetaData.name;
        curveData = obj.getCurve(measurementHandle, curveMetaData.id);
        curveMap(curveName) = curveData;
    end  
end


end

