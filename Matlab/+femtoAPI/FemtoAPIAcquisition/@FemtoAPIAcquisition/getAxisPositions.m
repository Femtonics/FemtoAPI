function axisPositions = getAxisPositions( obj )
%GETAXISPOSITIONS Get position information of configured axes.
% Gets informations about all configured axes from server, like 
% absolute/relative position, axis alert threshold, lower/upper absolute
% position limits, labeling origin offset, objective mode, etc. 
% as nested struct. It also contains some parameters of the Focus panel 
% on the MESc GUI. 
% Details can be found here: 
%  https://kb.femtonics.eu/display/MAN/Manipulating+axis+positions
%
% OUTPUT: 
%  axisPositions            nested struct containing axis informations
%
% Usage: obj.getAxisPositions()
%
% See also GETAXISPOSITION SETAXISPOSITION
%
objectivePositions = femtoAPI('command','FemtoAPIMicroscope.getAxisPositions()');
objectivePositions{1} = changeEncoding(objectivePositions{1},'UTF-8');
axisPositions = jsondecode(objectivePositions{1});

end

