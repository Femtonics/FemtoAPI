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

classdef (ConstructOnLoad) FileIOErrorEventData < EventDataBase
    %FILEIOERROREVENTDATA Summary of this class goes here
    %   Detailed explanation goes here
    
    properties
        commandID
        errorMessage
        errorType
    end
    
    methods
        function obj = FileIOErrorEventData(eventStruct)
            %FILEIOERROREVENTDATA Construct an instance of this class
            %   Detailed explanation goes here
            obj@EventDataBase(eventStruct);
            
            obj.commandID = eventStruct.values.commandID;
            obj.errorMessage = eventStruct.values.errorMessage;
            obj.errorType = eventStruct.values.errorType;
            if isfield(eventStruct.values, 'nodeDescriptor')
                obj.addprop('handle');
                obj.handle = eventStruct.values.nodeDescriptor;
            end
        end
        
    end
end

