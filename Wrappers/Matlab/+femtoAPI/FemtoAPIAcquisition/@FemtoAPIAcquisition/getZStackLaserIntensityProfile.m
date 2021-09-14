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
    zStackLaserIntensityProfile = changeEncoding(zStackLaserIntensityProfile{1}, obj.m_usedEncoding);
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
