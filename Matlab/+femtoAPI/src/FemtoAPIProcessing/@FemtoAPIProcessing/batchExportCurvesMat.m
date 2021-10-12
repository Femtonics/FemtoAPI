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

function exportedFileNames = batchExportCurvesMat( obj, commonCurveMetaDataTable, measurementHandlesSelected, selectedChannels, absoluteFilePath )
%BATCHEXPORTCURVESMAT Saves common input/output channels of given MUnits
% This is a helper function, filters the 'commonCurvesMetaDataTable' 
% for the selected channels, and measurement handles, 
% and saves it to the given path in .mat file. See
% getCommonCurveMetaDataTabe() for details. 
%
% INPUTS:
%  commonCurveMetaDataTable        table of common curves, output of
%                                  getCommonCurvesMetaDataTable()
%  
%  measurementHandlesSelected      cell array containing measurement
%                                  handles
% 
% selectedChannels                 cell array containing channel names
% 
% absoluteFilePath                 absolute file path to save the common
%                                  curves
%
% OUTPUT: 
%  exportedFileNames               cell array, containing the exported file paths
%
%
% See also GETCOMMONCURVESMETADATATABLE 

% filter output channels, that are common in all measurement units 
%validatestring(channelType,{'Input','Output'});
%commonCurveMetaDataTable = obj.getCommonCurvesMetaDataTable(measurementHandlesSelected,channelType);

% filter table for selected channels
filteredRows = cellfun(@(x) ismember(x, selectedChannels), commonCurveMetaDataTable.curveName);
filteredTable = commonCurveMetaDataTable(filteredRows,:);
exportedFileNames = cell(length(measurementHandlesSelected),1);


% get curves based on metadata, and save it to files
curveDataStruct = struct('xData',[],'yData',[],'channelName','','comment','','handle','');
%curveDataArray = repmat(curveDataStruct,length(measurementHandlesSelected),length(selectedChannels));

for i = 1: length(measurementHandlesSelected)
    measurementHandle = measurementHandlesSelected{i};
    rows = cellfun(@(x) isequal(x, measurementHandle), filteredTable.measurementHandle);
    measurementMetaDataTable = filteredTable(rows,:);

    
    % collect data write to file 
    curveMetaDatas = measurementMetaDataTable.curveMetaData;
    curveDataArray = repmat(curveDataStruct,1,length(curveMetaDatas));
    for j = 1: length(curveMetaDatas)
        curveMetaData = curveMetaDatas(j);
        curveDataArray(j).channelName = curveMetaData.name;
        curveDataArray(j).comment = curveMetaData.comment;
        
        curveData = obj.getCurve(measurementHandle, curveMetaData.id); % get curve (X,Y) data from server
        curveDataArray(j).xData = curveData(:,1);
        curveDataArray(j).yData = curveData(:,2);
        curveDataArray(j).handle = measurementHandle;
    end


    % write collected data to file 
    measurementHandle = reshape(measurementHandle,1,[]);
    measurementHandleStr = regexprep(num2str(measurementHandle),' +',',');
    exportFileFullPath = strcat(absoluteFilePath,'_(',measurementHandleStr,')','.mat');

    save(exportFileFullPath,'curveDataArray');
    
    exportedFileNames{i} = exportFileFullPath;
end


end

