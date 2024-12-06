function  result = createTiff( obj, tiffUniqueId, unitHandle, varargin )
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here

narginchk(3,10);

% optional arguments defaults
applyLUT    = false; 
channelList = [];
compress = true;
breakView = false;
exportRawData = false;
startTimeSlice = uint64(0);
endTimeSlice = intmax("uint64");


if nargin >= 3 
    validateattributes(tiffUniqueId,{'char'},{'row'},mfilename,'tiffUniqueId');    
    validateattributes(unitHandle,{'numeric'},{'vector','nonnegative',...
         'integer'},mfilename,'unitHandle');
end

% optional arguments
numVarargs = length( varargin );

% applyLUT
if numVarargs >= 1
    validateattributes(varargin{1},{'logical'},{'scalar'},mfilename,'applyLUT');
    applyLUT = varargin{1};
end

% channelList
if numVarargs >= 2
    if ~isempty(varargin{2})
        validateattributes(varargin{2},{'numeric'},{'row','nonnegative','integer'}, ...
            mfilename,'channelList');
    end
    channelList = varargin{2};
end

% compress
if numVarargs >= 3
    validateattributes(varargin{3},{'logical'},{'scalar'},mfilename,'compress');
    compress = varargin{3};
end

% breakView
if numVarargs >= 4
    validateattributes(varargin{4},{'logical'},{'scalar'},mfilename,'breakView');
    breakView = varargin{4};
end

% exportRawData
if numVarargs >= 5
    validateattributes(varargin{5},{'logical'},{'scalar'},mfilename,'exportRawData');
    exportRawData = varargin{5};
end

% startTimeSlice
if numVarargs >= 6
    validateattributes(varargin{6},{'numeric'},{'scalar','nonnegative', ... 
        'real'},mfilename,'startTimeSlice');
    startTimeSlice = varargin{6};
end

% endTimeSlice
if numVarargs >= 7
    validateattributes(varargin{7},{'numeric'},{'scalar','nonnegative', ... 
        'real'},mfilename,'startTimeSlice');
    endTimeSlice = varargin{7};
end

result = obj.femtoAPIMexWrapper('FemtoAPIFile.createTiff', ...
    tiffUniqueId, ...
    unitHandle, ...
    applyLUT, ...
    channelList, ...
    compress, ...
    breakView, ...
    exportRawData, ...
    startTimeSlice, ...
    endTimeSlice);

end

