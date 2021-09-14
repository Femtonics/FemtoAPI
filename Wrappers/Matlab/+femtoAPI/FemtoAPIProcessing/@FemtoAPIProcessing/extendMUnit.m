function [ result ] = extendMUnit(obj, mUnitHandle, frameCount)
%EXTENDMUNIT Extends the given measurement unit with frames
% Extends the measurement unit given by 'mUnitHandle' with the specified
% number of frames 'frameCount'. 
%
% It returns a struct that contains a command id, which can be used to
% monitor the asynchron file operation status (see getStatus() for
% details). The succeeded field is true means that the asynchronous command
% has been initated successfully. Otherwise, an error is returned.
%
% This command can fail, if the given measurement unit handle is invalid, 
% the image type is not extendable, or if an other asynchronous operation 
% is pending on the file. 
%
% 
% INPUTS: 
%  mUnitHandle             numeric array, unique measurement unit
%                          descriptor (handle), e.g. [54,0,0]
% 
%  frameCount              positive integer, the number of frames to extend
%                          the measurement unit with
% 
% OUTPUT: 
%  result                struct that contains the following data:
%                          - id: (char array), the command id 
%                          - succeeded: bool flag, means whether the synchronous 
%                            part of the command ended successfully or not              
%  
validateattributes(mUnitHandle,{'numeric'},{'vector','nonnegative','integer'});
validateattributes(frameCount,{'numeric'},{'scalar','positive','integer'});

mUnitHandle = reshape(mUnitHandle,1,[]);
strMUnitHandle = strcat(num2str(mUnitHandle(1:end-1),'%d,'),num2str(mUnitHandle(end)));
    
q = char(39); % quote character
result = femtoAPI('command',strcat('FemtoAPIFile.extendMUnit(',...
    q,strMUnitHandle,q,',',num2str(frameCount),')'));

result{1} = changeEncoding(result{1},obj.m_usedEncoding);
result = jsondecode(result{1});

end

