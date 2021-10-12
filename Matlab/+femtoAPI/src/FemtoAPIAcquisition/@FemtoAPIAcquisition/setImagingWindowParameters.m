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

function [ succeeded ] = setImagingWindowParameters( obj, imagingParams )
%SETIMAGINGWINDOWPARAMETERS Sets imaging window parameters on server. 
% Sets imaging window parameters, which are the following: 
%   - imaging window size in X and Y direction,
%   - imaging window position ( given by "transformation" json object, 
%     in which the X and Y translation (from the origin) can be set)
%
% Restrictions:
%   - it sets viewport translation in X and Y directions, but not in Z 
%     direction.
%   - viewport rotation is not set
%
% Imaging parameters can be set per measurement type (resonant or galvo) 
% and space. The parameters must be within the limits (imaging window size
% and resolution limits, etc.), and if not, no changes are made at the server.
% Galvo and resonant imaging parameters can be set at a time, 
% but 'measurementType' and 'space' must be unique.
% 
%
% INPUT: 
%  imagingParams           struct, containing the imaging window
%                          parameters. 
%
% OUTPUT: 
%  succeeded               true, if the parameters are valid and changes
%                          are made on the server, false otherwise. 
%
% Examples: 
%  Details and examples can be found at:  
%  https://kb.femtonics.eu/display/MAN/Get-set+imaging+window+%28viewport%29+parameters
% 
% See also GETIMAGINGWINDOWPARAMETERS
% 
    validateattributes(imagingParams,{'struct'},{'vector'});
    imagingParamsJson = jsonencode(imagingParams);
    q = char(39); % quote character
    if(length(imagingParams) > 1)
        succeeded = femtoAPI('command', ...
            strcat('FemtoAPIMicroscope.setImagingWindowParameters(',q, ...
            imagingParamsJson,q,')'));
    else
        succeeded = femtoAPI('command', ...
            strcat('FemtoAPIMicroscope.setImagingWindowParameters(','''[', ...
            imagingParamsJson,']''',')'));
    end

    succeeded = jsondecode(succeeded{1});

end

