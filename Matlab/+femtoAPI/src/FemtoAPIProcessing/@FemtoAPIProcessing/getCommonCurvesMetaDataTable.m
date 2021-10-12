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

function [commonCurvesMetaDataTable] = getCommonCurvesMetaDataTable(obj, measurementHandleArray, channelType)
%GETCOMMONCURVEMETADATATABLE Gets metadata of common input/output curves 
% Gets metadata of common input/output curves based on common curve names 
% of the requested measurement handles given by 'measurementHandleArray', 
% 'channelType' denotes the input/output channels. 
%
% Example: 
%  femtoapiObj = FemtoAPIProcessing; 
%  commonCurveMetaDataTable = femtoapiObj.getCommonCurvesMetaDataTable({[99
%  0 1],[99 0 2],[99 0 3]}, 'Input');
% 

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
