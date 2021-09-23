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

function [ zStackLaserIntensityProfile ] = getZStackLaserIntensityProfile(obj,varargin)
%GETZSTACKLASERINTENSITYPROFILE Gets the Z-stack laser intensity profile.
% It gets the Z-Stack depth intensity profile of laser intensity devices
% from server. 
% 
% INPUTS [optional]: 
%  measurementType            char array, 'resonant' or 'galvo' or empty char. 
%                             Default: empty char
%
%  spaceName                  char array, name of space the measurement is
%                             performed. Default: default space ('space1')
%
% OUTPUT: 
%  imagingWindowParameters    struct, contains 
%
% See also SETZSTACKLASERINTENSITYPROFILE
% 
    zStackLaserIntensityProfile = femtoAPI('command','FemtoAPIMicroscope.getZStackLaserIntensityProfile()');
    zStackLaserIntensityProfile = jsondecode(zStackLaserIntensityProfile);
    obj.m_zStackLaserIntensities = zStackLaserIntensityProfile;

    numVarargs = length(varargin);
    usage = ['Usage: obj.getZStackLaserIntensityProfile(), ' ...
        'or obj.getZStackLaserIntensityProfile(spaceName,measurementType),',...
        ' where spaceName is the name of the space, ', ...
        'and measurementType can be resonant or galvo currently.'];
    if numVarargs == 0
        return;
    elseif numVarargs > 0 && numVarargs ~= 2
        error(['Wrong number of input parameters. ',usage]);
    else
        measurementTypes = {'galvo','resonant'};
        validateattributes(varargin{1},{'char','string'},{'nonempty'}, ...
            'getZStackLaserIntensityProfile','space name',1);
        validatestring(varargin{2},measurementTypes, ...
            'getZStackLaserIntensityProfile','measurement type',2);

        for i=1:length(obj.m_zStackLaserIntensities)
            if(~isfield(obj.m_zStackLaserIntensities(i),'measurementType'))
                error(['The read z stack laser intensity json from server should contain ',...
                    ' ''''measurementType'''' field']);
            end
            if(~isfield(obj.m_zStackLaserIntensities(i),'space'))
                error(['The read z stack laser intensity json from server should contain ',...
                    ' ''''space'''' field']);
            end

            if(isequal(obj.m_zStackLaserIntensities(i).space, varargin{1}) && ...
                    isequal(obj.m_zStackLaserIntensities(i).measurementType, varargin{2}))
                zStackLaserIntensityProfile = obj.m_zStackLaserIntensities(i);
                return;
            end
        end

    end

    % when invalid space name was given, nothing is returned
    zStackLaserIntensityProfile = [];

end
