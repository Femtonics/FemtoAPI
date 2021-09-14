function [commonCurvesMetaDataTable] = getCommonCurvesMetaDataTable(obj, measurementHandleArray, channelType)
%GETCOMMONCURVEMETADATA
% Gets curve metadata based on common curve names of the requested
% measurement handles.

validatestring(channelType,{'Input','Output'});
commonCurvesMetaDataTable = table;
curveNames = [];
for i = 1:length(measurementHandleArray)
    % get metadata of curves as array
    measurementHandle = measurementHandleArray{i};
    curvesMetaData = obj.getMeasurementMetaDataField(measurementHandle,'curves');
    
    for j=1:length(curvesMetaData)
        curveMetaData = curvesMetaData(j);
        curveName = curveMetaData.name;
        curveComment = curveMetaData.comment;
        
        if(contains(curveComment,channelType,'IgnoreCase',true))
            curveNames = [curveNames {curveName}];
            tableRow = {curveName, {measurementHandle}, curveMetaData};
            commonCurvesMetaDataTable = [commonCurvesMetaDataTable; tableRow];
        end
    end
end

% select curveNames that are common in all measurement units
if(~isempty(commonCurvesMetaDataTable))
    commonCurvesMetaDataTable.Properties.VariableNames = {'curveName','measurementHandle','curveMetaData'};
    for curveNameCell = curveNames
       curveName = cell2mat(curveNameCell);
       rows = find(cellfun(@(x) isequal(x, curveName), commonCurvesMetaDataTable.curveName));

       if(length(rows) ~= length(measurementHandleArray))
           commonCurvesMetaDataTable(rows,:) = [];
       end
    end
end


end
