function [ data ] = changeEncoding( data, newEncoding )
%CHANGEENCODING Summary of this function goes here
%   Detailed explanation goes here

% get bytes according to the encoding used by user, then interpret the
% bytes in the new encoding

data = native2unicode(unicode2native(data),newEncoding);

end

