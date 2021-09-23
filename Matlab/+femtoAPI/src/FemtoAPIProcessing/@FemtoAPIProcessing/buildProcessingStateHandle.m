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

function buildProcessingStateHandle( obj, parentStruct )
%BUILDPROCESSINGSTATEHANDLE Builds server's state structure from handle obj
% Helper function, it gets server's processing state struct(nested structure), 
% that is obtained from json decoding, and wraps the structures in HStruct 
% handle objects, and rebuilds the server's processing state structure 
% using HStruct objects instead of plain struct.
%
% INPUT: 
%  parentStruct - root of the server's processing state structure 
%

if(~isa(parentStruct,'HStruct') )
    error('Internal type error');
end

fnames = fieldnames(parentStruct.data);

for i=1:length(fnames)
    structField = parentStruct.data.(fnames{i});
    if( isstruct(structField) && ismember('handle',fieldnames(structField)) )
        parentStruct.data.(fnames{i}) = repmat(HStruct(struct),length(structField),1);
        for j=1:length(structField) % if struct array
            % exchange struct with HStruct
            
            structFieldHandle = HStruct(structField(j));
            parentStruct.data.(fnames{i})(j) = structFieldHandle;
            obj.buildProcessingStateHandle( structFieldHandle );
        end
    elseif( iscell(structField) )
        parentStruct.data.(fnames{i}) = repmat(HStruct(struct),length(structField),1);
        for j=1:length(structField) % if struct array
            % exchange struct with HStruct
            if(isstruct(structField{j}) && ismember('handle',fieldnames(structField{j}) ))
                structFieldHandle = HStruct(structField{j});
                parentStruct.data.(fnames{i})(j) = structFieldHandle;
                obj.buildProcessingStateHandle( structFieldHandle );
            end
        end        
     end
end


end


