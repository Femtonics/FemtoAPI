function [ succeeded ] = setZStackLaserIntensityProfile(obj,zStackLaserIntensities)
%SETZSTACKLASERINTENSITYPROFILE Sets Z-stack PMT/laser intensity profile
% Sets Z-stack depth intensity profile for the specified devices, measurement
% type and space on server.
%
% Requres a struct as input, which holds the values of PMT/laser intensity 
% devices at specific Z depths, given by 'firstZ', 'lastZ' and
% 'zStep'. Optionally, an intermediate position 'intermediateZ' can be given.  
% The 'DepthCorrection', which is a struct contains the device names and
% values at the specified 2 (or 3) points. 
% The specified z points - device value pairs are used as reference points,
% and at other depths (which are specified by the z step parameter), 
% device values are interpolated. 
% For detailed information and examples, see 
%  https://kb.femtonics.eu/pages/viewpage.action?pageId=13435842
%
% INPUT: 
%  zStackLaserIntensities         nested struct, contains device
%                                 intensity depth profile
% 
% OUTPUT: 
%  succeeded                      true, if z-stack intensity depth profile 
%                                 was successfully set on server, false
%                                 otherwise 
%
% See also GETZSTACKLASERINTENSITYPROFILE
% 
    zStackLaserIntensities = jsonencode(zStackLaserIntensities);
    succeeded = femtoAPI('command', ...
        strcat('FemtoAPIMicroscope.setZStackLaserIntensityProfile(','''[', ...
        zStackLaserIntensities,']''',')'));
    succeeded{1} = changeEncoding(succeeded{1},obj.m_usedEncoding);
    succeeded = jsondecode(succeeded{1});

end

