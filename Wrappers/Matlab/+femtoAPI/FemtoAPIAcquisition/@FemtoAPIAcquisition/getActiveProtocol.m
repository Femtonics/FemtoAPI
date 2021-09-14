function [ protocol ] = getActiveProtocol(obj)
%GETACTIVEPROTOCOL Returns the active measurement protocol.
% It returns the active protocol as nested struct, it contains information 
% about actively selected output channels and waveforms, timing of
% waveforms, patterns and path in case of dual scanning, etc. 
% You can find details at 
% https://kb.femtonics.eu/display/MAN/Tools#Tools-getActiveProtocol
% 
% OUTPUT 
%  protocol            nested struct that contains the active protocol 
%

    protocol = femtoAPI('command', 'FemtoAPIMicroscope.getActiveProtocol()');
    protocol{1} = changeEncoding(protocol{1},obj.m_usedEncoding);
    protocol = jsondecode(protocol{1});
end

