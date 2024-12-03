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
measurementType = '';
spaceName = '';

if(numVarargs > 2)
    error(['Too many input parameters. Usage: obj.getImagingWindowParameters(), or',...
        'obj.getImagingWindowParameters(measurementType,spaceName),',...
        ' measurementType = ''galvo'' or measurementType = ''resonant''']);
end
if(numVarargs >= 1)
    validatestring(varargin{1},{'resonant','galvo'});
    measurementType = varargin{1};
end
if(numVarargs == 2)
    if(~ischar(varargin{2}) && ~isstring(varargin{2}))
        error('Input argument 2, spaceName must be of type character array or string');
    end
    spaceName = varargin{2};
end

imagingWindowParameters = obj.femtoAPIMexWrapper('FemtoAPIMicroscope.getImagingWindowParameters', ...
    measurementType, spaceName);
imagingWindowParameters = jsondecode(imagingWindowParameters);
    

end

