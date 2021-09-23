% Copyright ©2021. Femtonics Kft. (Femtonics). All Rights Reserved. 
% Permission to use, copy, modify this software and its documentation for educational,
% research, and not-for-profit purposes, without fee and without a signed licensing agreement, is 
% hereby granted, provided that the above copyright notice, this paragraph and the following two 
% paragraphs appear in all copies, modifications, and distributions. Contact info@femtonics.eu
% for commercial licensing opportunities.
% 
% IN NO EVENT SHALL FEMTONICS BE LIABLE TO ANY PARTY FOR DIRECT, INDIRECT, SPECIAL, 
% INCIDENTAL, OR CONSEQUENTIAL DAMAGES, INCLUDING LOST PROFITS, ARISING OUT OF 
% THE USE OF THIS SOFTWARE AND ITS DOCUMENTATION, EVEN IF FEMTONICS HAS BEEN 
% ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
% 
% FEMTONICS SPECIFICALLY DISCLAIMS ANY WARRANTIES, INCLUDING, BUT NOT LIMITED TO, 
% THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR 
% PURPOSE. THE SOFTWARE AND ACCOMPANYING DOCUMENTATION, IF ANY, PROVIDED 
% HEREUNDER IS PROVIDED "AS IS". FEMTONICS HAS NO OBLIGATION TO PROVIDE 
% MAINTENANCE, SUPPORT, UPDATES, ENHANCEMENTS, OR MODIFICATIONS.

function getProcessingState(obj)
   
if(isempty(obj.m_connectionObj) || ~obj.m_connectionObj.m_isConnected)
    error(['Could not update processing state because not connected to',...
        ' the server. Please connect first.']);
end

processingState = femtoAPI('command', 'FemtoAPIFile.getProcessingState()');
validateattributes(processingState,{'cell'},{'vector','nonempty','numel',1});

% decode json
obj.m_processingState = HStruct(jsondecode(processingState{1}))

% wrap structs that contain 'handle' field
% into HStruct handle objects for data synchronization
%(nested HStructs and tree)
obj.buildProcessingStateHandle(obj.m_processingState);

% build and store the processing state tree
obj.m_processingStateTreeObj = TreeWrapper(obj.m_processingState);

% reset all date fields in processing state from UCT to local time
obj.changeDateTimeToLocal();
disp('Server processing state structure updated successfully.');

end

