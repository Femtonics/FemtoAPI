function [result] = moveMUnit(obj, sourceMImageHandle, destMItemHandle)
%MOVEMUNIT Moves the source measurement image to the requested session/group.
% The destination session/group can be the same where the source image is, 
% or in an other file. 
% If the source or destination handle is invalid, or there is another
% file operation in progress on the files in question, an error is thrown.
% Channel contents are moved too. 
%
% INPUTS [required]:
%  sourceMImageHandle       numeric array, source measurement image handle                     
%
%  destMItemHandle          numeric array, measurement session or group 
%                           handle, where the source image to copy to 
% 
% OUTPUT: 
%   result                  struct, it contains the following values: 
%                            - id: (char array), the command id 
%                            - succeeded: bool flag, means whether the 
%                              synchronous part of the command ended 
%                              successfully or not   
%                            - movedMUnitIdx: handle of the new MUnit,
%                              where the source image is moved to
%                              
% Examples: 
%  - move MUnit within the same session:
%    result = obj.moveMUnit([34,0,1], [34,0])
%
%  - move MUnit to another session (which can be in an other file, too):
%    result = obj.moveMUnit([34,0,1], [40,1])
% 
% See also COPYMUNIT CREATEMUNIT DELETEMUNIT
% 

    validateattributes(sourceMImageHandle,{'numeric'},{'vector','nonnegative','integer'},mfilename,'sourceMUnitHandle');
    validateattributes(destMItemHandle,{'numeric'},{'vector','nonnegative','integer'},mfilename, 'destMItemHandle');

    sourceMImageHandle = reshape(sourceMImageHandle,1,[]);
    destMItemHandle = reshape(destMItemHandle,1,[]);

    q = char(39); % quote character
    sSourceMImageHandle = strcat(q,num2str(sourceMImageHandle(1:end-1),'%d,'),num2str(sourceMImageHandle(end),'%d''')); 
    sDestMItemHandle = strcat(q,num2str(destMItemHandle(1:end-1),'%d,'),num2str(destMItemHandle(end),'%d'''));
   
    result = femtoAPI('command',strcat('FemtoAPIFile.moveMUnit(', ...
        sSourceMImageHandle,',', sDestMItemHandle,')'));

    result{1} = changeEncoding(result{1},obj.m_usedEncoding);
    result = jsondecode(result{1});
    result.movedMUnitIdx = str2num(result.movedMUnitIdx);
end

