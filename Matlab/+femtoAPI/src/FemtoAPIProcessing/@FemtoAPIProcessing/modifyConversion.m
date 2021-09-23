% Copyright ©2021. Femtonics Kft. (Femtonics). All Rights Reserved. 
% Permission to use, copy, modify this software and its documentation for educational,
% research, and not-for-profit purposes, without fee and without a signed licensing agreement, is 
% hereby granted, provided that the above copyright notice, this paragraph and the following two 
% paragraphs appear in all copies, modifications, and distributions. Contact info@femtonics.eu
% for commercial licensing opportunities.
% 
% IN NO EVENT SHALL FEMTONICS BE LIABLE TO ANY PARTY FOR DIRECT, INDIRECT, SPECIAL, 
% INCIDENTAL, OR CONSEQUENTIAL DAMAGES, INCLUDING LOST PROFITS, ARISING OUT OF 
% THE USE OF THIS SOFTWARE AND ITS DOCUMENTATION, EVEN IF FEMTONICS HAS BEEN 
% ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
% 
% FEMTONICS SPECIFICALLY DISCLAIMS ANY WARRANTIES, INCLUDING, BUT NOT LIMITED TO, 
% THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR 
% PURPOSE. THE SOFTWARE AND ACCOMPANYING DOCUMENTATION, IF ANY, PROVIDED 
% HEREUNDER IS PROVIDED "AS IS". FEMTONICS HAS NO OBLIGATION TO PROVIDE 
% MAINTENANCE, SUPPORT, UPDATES, ENHANCEMENTS, OR MODIFICATIONS.

function succeeded = modifyConversion(obj, conversionName, scale, offset, varargin)
%MODIFYCONVERSION Modifies linear conversion in conversion manager.
% Modifies the named linear conversion scale and offset on server, and
% saves it if requested. By default, it won't be saved on server, just
% modified. If the maed conversion is identity
%
% Note: scale and offset means the following in linear conversion:
% converted_value = scale * value + offset
%
% INPUTS [required]:
%  conversionName           char array, name of the conversion.
%  scale                    double, scale of linear conversion
%  offset                   double, offset of linear conversion
%
% INPUTS [optional]:
%  bSave                    bool, if true, saves the named conversion on
%                           server if it has been modified successfully,
%                           otherwise no saving is made. Default: false
%
% OUTPUT:
%  succeeded                true if the sent of the named conversion has
%                           been modified successfully, false otherwise
%
% Examples:
%  Modify conversion and save new values on server:
%   obj.modifyConversion('conv1', 10.1, 3.2, true)
%   obj.modifyConversion('conv1', 2, 3) -> will not be saved to disk on
%                                          server
%
%
if(nargin > 5)
    error('Too many input arguments')
end

bSave = false;
if(nargin == 5)
    validateattributes(varargin{1},{'logical'},{'scalar'});
    bSave = varargin{1};
end

q = char(39); % quote character
succeeded = femtoAPI('command',strcat('FemtoAPIFile.modifyConversion(', ...
    q,conversionName,q,',',num2str(scale),',',num2str(offset),',',num2str(bSave),')'));
succeeded = jsondecode(succeeded{1});

end
