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
  
result = obj.femtoAPIMexWrapper('FemtoAPIFile.extendMUnit',mUnitHandle,frameCount);
result = jsondecode(result);

end

