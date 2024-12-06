function currentSession = getCurrentSession(obj, varargin)
%GETCURRENTSESSION Returns the handle of the active measurement session
%

narginchk(1,2);

if nargin == 1
    subscribeOrUnsubscribe = "";
else
    validatestring(varargin{1},{'subscribe', 'unsubscribe'},mfilename,...
        'subscribeOrUnSubsrcibe');
    subscribeOrUnsubscribe = varargin{1};
end

currentSession = obj.femtoAPIMexWrapper('FemtoAPIFile.getCurrentSession', ...
    subscribeOrUnsubscribe);
currentSession = str2num(currentSession);

end

