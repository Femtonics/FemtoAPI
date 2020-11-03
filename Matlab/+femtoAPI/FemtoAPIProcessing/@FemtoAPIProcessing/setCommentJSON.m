function [ dataToSend ] = setCommentJSON( measDataHandle, comment )
%SETCOMMENTJSON Creates JSON object from input input handle and comment.
%   Helper method to prepare JSON for setting 'comment' of a specified
%   measurement metadata (measurement session, group, or unit)

%validateattributes(measDataHandle,{'numeric'},{'nonempty','row','integer','nonnegative'},mfilename,'measDataHandle',1);
measDataHandle = reshape(measDataHandle,1,[]);
measDataHandleStr = strcat(num2str(measDataHandle(1:end-1),'%d,'),num2str(measDataHandle(end)));
dataToSend = char(strcat('{"handle"',' : ','"',measDataHandleStr,'", ','"comment"',' : ','"',string(comment),'"}'));

end

