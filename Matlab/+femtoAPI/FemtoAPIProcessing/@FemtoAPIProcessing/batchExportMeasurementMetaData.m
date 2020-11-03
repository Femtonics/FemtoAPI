function  exportedFileNames = batchExportMeasurementMetaData(obj, measurementHandleArray, fileName)
%BATCHEXPORTMEASUREMENTMETADATA Exports measurement metadata to json. 
%   Export all measurement metadata ('measurementInfo' and
%   'measurementParams' fields in processing state) of the 
%   measurement units 'measurementHandleArray' to json files. 
%   The parameter 'fileName' is the common part in all saved json file 
%   names. The full file name is 'filename' appended with the measurement 
%   unit handle converted to character array, it can be a relative or 
%   absolute file name.
%
%
% INPUTS: 
%   measurementHandleArray - cell array of vectors containing the meaurement 
%                            unit handles which metadata wanted to be saved 
%
%   filename               - first part of file name of the saved 
%                            measurement metadata json files. This name will 
%                            be appended with the measurement unit handle 
%                            string to compose a relative or absolute file name. 
%
% OUTPUT: 
%  exportedFileNames       - cell array of saved file names 
% 
%
% Examples: 
%  savedFileNames = batchExportMeasurementMetaData({[99,0,1],[99,0,2]},...
%                    'C:/Data/my_measurement');
% 
%  In this case, savedFileNames is an array containing the names of the 
%  saved files: 
%    
%  savedFileNames = {'C:/Data/my_measurement_(99,0,1).json',...
%                    'C:/Data/my_measurement_(99,0,2).json'}
%
%

validateattributes(measurementHandleArray,{'cell'},{'vector'},'batchExportMeasurementMetaData','measurementHandleArray');
numOfMeasurementHandles = length(measurementHandleArray);
exportedFileNames = cell(numOfMeasurementHandles,1);
ext = '.json';

for i = 1: length(measurementHandleArray)
    measurementHandle = measurementHandleArray{i};
    allMeasurementParams = obj.getMeasurementMetaDataField(measurementHandle,'measurementInfo');
    measurementParamsXMLString = allMeasurementParams.measurementParamsXML;
    allMeasurementParams.measurementParamsXML = [];
    
    % xml to json -> xml to struct, then struct to json 
    %
    % TODO measurementParamsXML is not correct when unicode caracters are present in it, 
    % in this case the 'micro' sign. Correct character encoding in MESc, now manually corrected 
    % by replacing 'micro' sign with 'u'.  A bit better would be to implement 
    % the solution written at https://undocumentedmatlab.com/blog/parsing-xml-strings
    % correctly. 
    
    %measurementParamsXMLStruct = xmlString2struct(measurementParamsXMLString);
    measurementParamsXMLString = regexprep(measurementParamsXMLString,'".m"','"um"');
    measurementParamsXMLString = strrep(measurementParamsXMLString,'\"','"');
    measurementParamsXMLStruct = xml2struct(measurementParamsXMLString);
    allMeasurementParams.('measurementParamsXML') = measurementParamsXMLStruct;
    
    measurementParams = obj.getMeasurementMetaDataField(measurementHandle,'measurementParams');
    allMeasurementParams.('measurementParams') = measurementParams;
    
    % save to file 
    measurementHandle = reshape(measurementHandle,1,[]);
    measurementHandleStr = regexprep(num2str(measurementHandle),' +',',');
    exportFileName = strcat(fileName,'_(',measurementHandleStr,')',ext);
    
    % struct -> json 
    measurementParamsJSON = jsonencode(allMeasurementParams);
    
    % write data to file 
    fileID = fopen(exportFileName,'w');
    fprintf(fileID,'%s',measurementParamsJSON);
    fclose(fileID);
    
    exportedFileNames{i} = exportFileName;
end

end

