function buildProcessingStateHandle( obj, parentStruct )
%BUILDFEMTOSTATEHANDLE Builds server's state structure from handle objects
% Helper function, it gets server's processing state struct(nested structure), 
% that is obtained from json decoding, and wraps the structures in it in 
% HStruct handle objects, and rebuilds the server's processing state structure 
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
        %parentStruct.(fnames{i}) = repmat(HStruct(struct),length(structField),1);
        for j=1:length(structField) % if struct array
            % exchange struct with HStruct
            
            structFieldHandle = HStruct(structField(j));
            parentStruct.data.(fnames{i})(j) = structFieldHandle;
            %parentStruct.(fnames{i})(j) = structFieldHandle;
            obj.buildProcessingStateHandle( structFieldHandle );
        end
%     elseif( iscell(structField) )
%         parentStruct.data.(fnames{i}) = repmat(HStruct(struct),length(structField),1);
%         for j=1:length(structField) % if struct array
%             % exchange struct with HStruct
%             
%             structFieldHandle = HStruct(structField{j});
%             parentStruct.data.(fnames{i})(j) = structFieldHandle;
%             %parentStruct.(fnames{i})(j) = structFieldHandle;
%             obj.buildProcessingStateHandle( structFieldHandle );
%         end        
        
    end
end


end


