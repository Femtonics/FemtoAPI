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

classdef MicroscopeState
    %MICROSCOPESTATE Class representing microscope state as enumeration.
    %
    enumeration
        Off, Initializing, Ready, Working, Invalid
    end
    
    
    methods (Static)
        function microscopeState = fromString(microscopeState)
            if(strcmp(microscopeState,'Off'))
                microscopeState = MicroscopeState.Off;
            elseif(strcmp(microscopeState,'Initializing'))
                microscopeState = MicroscopeState.Initializing;
            elseif(strcmp(microscopeState,'Ready'))
                microscopeState = MicroscopeState.Ready;
            elseif(strcmp(microscopeState,'Working'))
                microscopeState = MicroscopeState.Working;
            else
                microscopeState = MicroscopeState.Invalid;
            end
        end
        
    end
    
    methods
        function strMicroscopeState = toString(microscopeState)
            if(microscopeState == MicroscopeState.Off)
                strMicroscopeState = "Off";
            elseif(microscopeState == MicroscopeState.Initializing)
                strMicroscopeState = "Initializing";
            elseif(microscopeState == MicroscopeState.Ready)
                strMicroscopeState = "Ready";
            elseif(microscopeState == MicroscopeState.Working)
                strMicroscopeState = "Working";
            else
                strMicroscopeState = "Invalid";
            end
        end
        
        function strMicroscopeState = toCharArray(microscopeState)
            if(microscopeState == MicroscopeState.Off)
                strMicroscopeState = 'Off';
            elseif(microscopeState == MicroscopeState.Initializing)
                strMicroscopeState = 'Initializing';
            elseif(microscopeState == MicroscopeState.Ready)
                strMicroscopeState = 'Ready';
            elseif(microscopeState == MicroscopeState.Working)
                strMicroscopeState = 'Working';
            else
                strMicroscopeState = 'Invalid';
            end
        end        
    end
end

