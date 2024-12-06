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

classdef (ConstructOnLoad) UnitEventData < EventDataBase
    %UNTITLED5 Summary of this class goes here
    %   Detailed explanation goes here
    
    properties
        handle % runtime unique handle of measurement unit
        eventSubType % in case of unit events, BaseUnitMetadataChanged, etc
        unitPart % type of unitMetadata, e.g. BaseUnitMetadata, CurveInfo, etc.
        index % index of curve/channel in case of 'CurveInfo', 'ChannelInfo'
    end
    
    methods
        function obj = UnitEventData(eventStruct)
            %UNTITLED5 Construct an instance of this class
            %   Detailed explanation goes here
            obj@EventDataBase(eventStruct);

            if isfield(eventStruct,'nodeDescriptor')
                obj.handle = str2num(regexprep(eventStruct.nodeDescriptor,'[\(\)]',''));
            else
                error("Unit event data should contain 'nodeDescriptor'");
            end

            if isfield(eventStruct,'jsonItem')
                obj.eventSubType = eventStruct.jsonItem ;
                obj.eventSubType = strcat(upper(obj.eventSubType(1)),obj.eventSubType(2:end),"Changed");
                obj.unitPart = strcat(upper(eventStruct.jsonItem(1)),eventStruct.jsonItem(2:end));
            elseif obj.eventType == "unitMetadataChanged"
                error("Unit metadata change event should contain 'jsonItem' field");
            else
                obj.eventSubType = "";
                obj.unitPart = "";
            end
            
            if isfield(eventStruct,'index')
                obj.index = str2double(eventStruct.index) + 1; % because Matlab starts indexing from 1
            end
            
        end
        
    end
end

