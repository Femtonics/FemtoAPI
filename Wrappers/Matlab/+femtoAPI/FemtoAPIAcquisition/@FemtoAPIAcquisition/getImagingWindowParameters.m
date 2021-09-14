function [ imagingWindowParameters ] = getImagingWindowParameters( obj, varargin )
%GETIMAGINGWINDOWPARAMETERS Gets imaging window parameters from the server.
% Gets imaging parameters filtered with measurement type (resonant/galvo)
% and space name. If measurement type is not given or empty char is given,
% parameters from both measurements are get. If spaceName is not given, 
% default space is considered. 
% Detailed description about imaging window parameters can be found here: 
% https://kb.femtonics.eu/display/MAN/Get-set+imaging+window+%28viewport%29+parameters
%  
% 
% INPUTS [optional]: 
%  measurementType            char array, 'resonant' or 'galvo' or empty char. 
%                             Default: empty char
%
%  spaceName                  char array, name of space the measurement is
%                             performed. Default: default space ('space1')
%
% OUTPUT: 
%  imagingWindowParameters    struct, contains parameters like viewport
%                             size, resolution, traslational and rotational 
%                             transformation of viewport, resulution limits, 
%                             etc. 
%
%
% Examples: 
%  resoImagingParams = obj.getImagingWindowParameters('resonant'); 
%  resoImagingParams = obj.getImagingWindowParameters('resonant');
%  resoAndGalvoImagingParams = obj.getImagingWindowParameters();
%
% See also SETIMAGINGWINDOWPARAMETERS
%
    numVarargs = length(varargin);
    optArgs = {'',''};
    if(numVarargs > 2) 
        error(['Too many input parameters. Usage: obj.getImagingWindowParameters(), or',...
            'obj.getImagingWindowParameters(measurementType,spaceName),',...
            ' measurementType = ''galvo'' or measurementType = ''resonant''']);
    end
    if(numVarargs >= 1)
            %validatestring(varargin{1},{'resonant','galvo'});
            optArgs{1} = varargin{1}; 
    end
    if(numVarargs == 2)
        if(~ischar(varargin{2}) && ~isstring(varargin{2}))
            error('Input argument 2, spaceName must be of type character array or string');
        end
        optArgs{2} = varargin{2};
    end
    q = char(39); % quote character    
    imagingWindowParameters = femtoAPI('command', ...
        strcat('FemtoAPIMicroscope.getImagingWindowParameters(',q,optArgs{1},q,',',q,optArgs{2},q,')'));
    imagingWindowParameters = changeEncoding(imagingWindowParameters{1},obj.m_usedEncoding);
    imagingWindowParameters = jsondecode(imagingWindowParameters);
    
end

