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
    succeeded = jsondecode(succeeded{1});

end

