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

