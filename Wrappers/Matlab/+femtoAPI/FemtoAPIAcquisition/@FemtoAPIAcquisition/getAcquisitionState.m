function getAcquisitionState( obj )
%GETACQUISITIONSTATE Updates acquistion state struct from server. 
% Gets acquistion state json, parses it into struct and stores it locally. 
% Acquistion state contains measurement informations that can be seen on
% resonant/galvo tabs in the MESc GUI in Acquistion mode. 
% For example device values, modalities, axis positions, 
% 
% See also GETPROCESSINGSTATE
%
    acquisitionState = femtoMEScAPI('command','FemtoAPIMicroscope.getAcquisitionState()');
    acquisitionState{1} = changeEncoding(acquisitionState{1},'UTF-8');
    obj.m_mescAcquisitionState = jsondecode(acquisitionState{1});

end

