function [ curveNamesFiltered, curveData ] = getCurvesByName( obj, measurementHandle, curveNames )
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here

% get metadata of curves as array
curvesMetaData = obj.getMeasurementMetaDataField(measurementHandle,'curves');
%validateattributes(channelNames,{'string'});


curveData = [];
curveNamesFiltered = [];
for i=1:curveNames
    curveMetaData = getCurveMetaData(curvesMetaData, curveNames(i));
    if( ~isempty(curveMetaData) )
        curveNamesFiltered = [curveNamesFiltered; curveMetaData.name];
        curveData = {curveData,getCurve(curveMetaData.id)};
    end  
end


end



