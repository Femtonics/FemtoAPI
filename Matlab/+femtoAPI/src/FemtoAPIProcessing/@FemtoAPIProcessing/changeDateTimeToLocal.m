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

function changeDateTimeToLocal(obj)
%CHANGEDATETIMETOLOCAL Change datetimes to local time
% Change all datetimes in server's processing state tree to local time
%
% It loops through the opened files, and set created, modified, saved times:
% 
% processing_state_root -> currentDate
% processing_state_root->openedFiles -> created, modified, saved
% processing_state_root->openedFiles -> measurementSessions 
%                      -> measurements -> date
% 

treeObj = obj.m_processingStateTreeObj;
fieldNames = [{'currentDate'},{'created'},{'modified'},{'saved'},{'date'}];

% iterate on nodeIDs, and do func
for j = 1:length(fieldNames)
    nodeIDs = find(treeObj.m_tree.treefun(@(x) isfield(x.data,fieldNames{j})));
    for i = nodeIDs
        treeObj.m_tree.Node{i}.data.(fieldNames{j}) = convertDateTimeToLocal(treeObj.m_tree.Node{i}.data.(fieldNames{j}));
    end
end

end

