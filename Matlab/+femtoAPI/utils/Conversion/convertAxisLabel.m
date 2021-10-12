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

function [ convertedLabelData ] = convertAxisLabel( labelData, conversionStruct )
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here
% axisLimits = [minDim maxdim]

validateattributes(labelData,{'numeric'},{'nonnegative','integer','increasing',...
    'row'});
validateattributes(conversionStruct,{'struct'},{'scalar'})
if(~isfield(conversionStruct,'scale') || ~isfield(conversionStruct,'offset') ||...
        ~isfield(conversionStruct,'type') )
    error('Invalid conversion structure.');
end


switch(conversionStruct.type)
    case 'identity'
        conversionObj = ConversionIdentity;
    case 'linear'
        offset = conversionStruct.offset;
        scale = conversionStruct.scale;
        conversionObj = ConversionLinear(scale,offset);
    otherwise
        error('Conversion type is not supported or wrong type.');
end

limits = conversionStruct.limits;

% set limits and do the conversion
conversionObj.resetLimitsFromDoubleValues(limits(1),limits(2));

convertedLabelData = conversionObj.convertToDouble(labelData);

end

