function [ succeeded ] = setComment( obj, handle, newComment )
%SETCOMMENT Sets comment of the given measurement session/unit/group
% Sets comment on the server, if the given handle is valid.
%
% INPUTS: 
%  handle        numeric array, must be a session/unit/group unique descriptor
% 
%  newComment    char array, the new comment wanted to be set
%
% OUTPUT: 
%  succeeded     true if comment was successfully set, 
%                false otherwise 
%
% Examples: 
%  obj.setComment([55,0],'session comment') 
%  obj.setComment([55,0,1],'measurement unit comment')
%

    validateattributes(handle,{'numeric'},{'nonempty','vector','integer','nonnegative'},...
        mfilename, 'handle');
    validateattributes(newComment,{'char'},{'row'},...
        mfilename, 'comment');

    %newComment = changeEncoding(newComment,mescapiObj.m_usedEncoding);
    handle = reshape(handle,1,[]);
    handleStr = strcat(num2str(handle(1:end-1),'%d,'),num2str(handle(end)));
    dataToSend = char(strcat('{"handle"',' : ','"',handleStr,'", ','"comment"',' : ','"',string(newComment),'"}'));
    try
        succeeded = obj.setProcessingState(dataToSend); 
    catch ME
        disp(ME.message)
        succeeded = false;
    end    
end

