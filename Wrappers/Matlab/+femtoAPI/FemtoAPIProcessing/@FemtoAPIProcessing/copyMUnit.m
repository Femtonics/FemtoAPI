function [result] = copyMUnit(obj, sourceMImageHandle, destMItemHandle, varargin)
%COPYMUNIT Copies the source measurement image to the requested session/group.
% The destination session/group can be the same where the source image is, 
% or in an other file. 
% If the source or destination handle is invalid, or there is another
% file operation in progress on the files in question, an error is thrown.
%
% INPUTS [required]:
%  sourceMImageHandle       numeric array, source measurement image handle                     
%
%  destMItemHandle          numeric array, measurement session or group 
%                           handle, where the source image to copy to 
%
% INPUTS [optional]: 
%  bCopyChannelContents     if true, the contents of channels in the
%                           source measurement image will be copied too. 
%                           Default: false
% 
% OUTPUT: 
%   result                  struct, it contains the following values: 
%                            - id: (char array), the command id 
%                            - succeeded: bool flag, means whether the 
%                              synchronous part of the command ended 
%                              successfully or not   
%                            - copiedMUnitIdx: handle of the new MUnit,
%                              where the soure image is copied to
% Examples: 
%  - copy MUnit with channel contents to the same session:
%    result = obj.copyMUnit([34,0,1], [34,0], true) 
% 
%  - copy MUnit without channel contents, 
%    result = obj.copyMUnit([97,0,0],[98,0])
%
% See also MOVEMUNIT CREATEMUNIT DELETEMUNIT
%
    if nargin > 4 
        error('Too many input arguments.');
    elseif nargin == 4 
        validateattributes(varargin{1},{'logical'},{'scalar'}, mfilename, 'bCopyChannelContents');
        bCopyChannelContents = varargin{1};
    elseif nargin == 3
        bCopyChannelContents = false;
    else
        error('Too few input arguments');
    end

    validateattributes(sourceMImageHandle,{'numeric'},{'vector','nonnegative','integer'},mfilename,'sourceMImageHandle');
    validateattributes(destMItemHandle,{'numeric'},{'vector','nonnegative','integer'},mfilename, 'destMItemHandle');

    sourceMImageHandle = reshape(sourceMImageHandle,1,[]);
    destMItemHandle = reshape(destMItemHandle,1,[]);

    q = char(39); % quote character
    sSourceMImageHandle = strcat(q,num2str(sourceMImageHandle(1:end-1),'%d,'),num2str(sourceMImageHandle(end),'%d''')); 
    sDestMItemHandle = strcat(q,num2str(destMItemHandle(1:end-1),'%d,'),num2str(destMItemHandle(end),'%d'''));
   
    result = femtoAPI('command',strcat('FemtoAPIFile.copyMUnit(', ...
        sSourceMImageHandle,',', sDestMItemHandle,',', ...
        num2str(bCopyChannelContents),')'));

    result{1} = changeEncoding(result{1},obj.m_usedEncoding);
    result = jsondecode(result{1});
    result.copiedMUnitIdx = str2num(result.copiedMUnitIdx);
end

