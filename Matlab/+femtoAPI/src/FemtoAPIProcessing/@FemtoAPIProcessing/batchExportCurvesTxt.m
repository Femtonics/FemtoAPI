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

function exportedFileNames = batchExportCurvesTxt( obj, commonCurveMetaDataTable, measurementHandlesSelected, selectedChannels, absoluteFilePath )
%BATCHEXPORTCURVESTXT Saves common input/output channels of given MUnits
% This is a helper function, filters the 'commonCurvesMetaDataTable' 
% for the selected channels, and measurement handles, 
% and saves it to the given path in .txt file.
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
if(isempty(selectedChannels))
    exportedFileNames = {};
    return;
end

% filter table for selected channels
filteredRows = cellfun(@(x) ismember(x, selectedChannels), commonCurveMetaDataTable.curveName);
filteredTable = commonCurveMetaDataTable(filteredRows,:);
ext = '.txt';
exportedFileNames = cell(length(measurementHandlesSelected),1);

% get curves based on metadata, and save it to files
for i = 1: length(measurementHandlesSelected)
    measurementHandle = measurementHandlesSelected{i};
    rows = cellfun(@(x) isequal(x, measurementHandle), filteredTable.measurementHandle);
    measurementMetaDataTable = filteredTable(rows,:);

    curveCellArray = {};
    %curveCellArray = zeros(2*max(
    headerNames = [];
    
    % collect data write to file 
    curveMetaDatas = measurementMetaDataTable.curveMetaData;
    for j = 1: length(curveMetaDatas)
        curveMetaData = curveMetaDatas(j);
        % correct curve name to be valid variable name 
        headerNames  = [headerNames, {'t',curveMetaData.name}];
        
        curveData = obj.getCurve(measurementHandle, curveMetaData.id); % get curve (X,Y) data from server
        if(~isempty(curveCellArray))
            curveCellArray = [curveCellArray, curveData(:,1), curveData(:,2)];
        else
            curveCellArray{1,1} = curveData(:,1);
            curveCellArray{1,2} = curveData(:,2);
        end
    end

    formatSpecHeader = [repmat('%12s %30s ',1,length(curveCellArray)/2),'\n'];
    formatSpec = [repmat('%12.4f %30.2f ',1,length(curveCellArray)/2),'\n'];

    % write collected data to file 

    % append with [] until max row size 
    maxRowNum = max(cellfun( @(x) size(x,1), curveCellArray ) );
    numOfCols = length(curveCellArray);
    for k=1:numOfCols
        nansToAppendWith = nan(maxRowNum - size(curveCellArray{1,k},1),1);
        if(~isempty(nansToAppendWith))
           curveCellArray{1,k} = [curveCellArray{1,k}; nansToAppendWith];
        end
    end
    
    % convert into string, then change nan-s to ''
    curveArray = cell2mat(curveCellArray);
    str = sprintf(formatSpec,curveArray');
    str = strrep(str, 'NaN', ' ');
    
    measurementHandle = reshape(measurementHandle,1,[]);
    measurementHandleStr = regexprep(num2str(measurementHandle),' +',',');
    exportFileFullPath = strcat(absoluteFilePath,'_(',measurementHandleStr,')',ext);
    
    % write data to file
    fileID = fopen(exportFileFullPath,'w');
    fprintf(fileID,formatSpecHeader,headerNames{1,:});
    fprintf(fileID,'%s',str);
    fclose(fileID);
    
    exportedFileNames{i} = exportFileFullPath;
end


end

