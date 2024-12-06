function [ result ] = setLinkedMUnit( obj, mainMUnitHandle, linkedMUnitHandle)
%SETLINKEDMUNIT Links one MUnit to another.
% Links MUnit specified by 'linkedMUnitHandle' to the main MUnit with 
%  'mUnitHandle'. The linked MUnit has to be in the background session
%  within the same file.
% 
% Linking has the following properties:
%  - linked MUnit can't be copied/moved/deleted manually, only 
%    with the main MUnit. 
%  - the linked MUnit is deleted automatically when the main MUnit is deleted. 
%    After an MUnit is linked to its main MUnit, it can't be deleted
%    manually.
%  - An MUnit in the background MSession can be linked to more than one
%  main MUnit. In this case, it is deleted when the last main MUnit 
%  pointing to it is deleted. 
%  - When copying a main MUnit, the linked MUnit is also copied. 
%  - When moving a main MUnit, the linked MUnit is only moved when there is no
%  other main MUnit pointing to it. Otherwise the linked MUnit is copied
%  with the main MUnit. 
%
% INPUTS [required]:
%  mainMUnitHandle       integer array, handle of the MUnit to link to
%  linkedMUnitHandle     integer array, handle of the linked MUnit
%                        
% 
% OUTPUT: 
%  result                bool, true if MUnit is linked successfully, false
%                        otherwise 
%  
% Usage: 
%  obj.setLinkedMUnit(mainMUnitHandle, mUnitToLinkHandle); 
%  
%
% See also CREATEBACKGROUNDFRAME CREATEBACKGROUNDZSTACK 
% 

validateattributes(mainMUnitHandle,{'numeric'},{'vector','nonnegative','integer'},mfilename,'mainMUnitHandle');
validateattributes(linkedMUnitHandle,{'numeric'},{'vector','nonnegative','integer'},mfilename, 'linkedMUnitHandle');

result = obj.femtoAPIMexWrapper('FemtoAPIFile.setLinkedMUnit', mainMUnitHandle, ...
    linkedMUnitHandle);

result = jsondecode(result{1});

end

