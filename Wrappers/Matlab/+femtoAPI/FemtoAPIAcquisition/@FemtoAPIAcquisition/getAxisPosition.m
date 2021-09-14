function  axisPosition = getAxisPosition(obj,axisName,varargin)
%GETAXISPOSITION Gets position of the given axis
% Gets the absolute, relative axis position, or the whole axis position
% struct get from server, if no optional arguments are given.
% 
% INPUT [required]: 
%  axisName                 char array, name of a configured axis 
% 
% INPUTS [optional]: 
%  positionType             char array, must be 'absolute' or 'relative'. 
%                           Default: empty char 
%  
%  spaceName                char array, name of space for which the axis is
%                           configured. Default: default space('space1')
%
% OUTPUT: 
%  axisPosition             various output depending on positionType: 
%                            - double, absolute position, if positionType 
%                              is 'absolute'  
%                            - double, relative position, if positionType 
%                              is 'relative'
%                            - struct, containing absolute/relative positions, 
%                              threshold, axis limits, labeling origin offset. 
%                              if positionType is not given.  
%
% Examples: 
%  axisPositionStruct = obj.getAxisPosition('SlowZ'); 
%  absolutePos = obj.getAxisPosition('SlowZ','absolute');
%  relativePos = obj.getAxisPosition('SlowZ','relative');
%
% See also GETAXISPOSITIONS
%
    numVarargs = length(varargin);
    optArgs = {'',obj.m_AcquisitionState.defaultSpaceName};
    if( numVarargs > 2)
        error('Too many input arguments.');
    end
    if( numVarargs >= 1 )
        if(~strcmp(varargin{1},'') && ~strcmpi(varargin{1},'Relative') && ...
                ~strcmpi(varargin{1},'Absolute'))
            error(strcat['Argument 2, ''positionType'' must be an empty char', ...
                ' (means relative and absolute), or ''relative'' or ''absolute'' (case insensitive)']);
        end
        optArgs{1} = varargin{1};
    end
    
    if( numVarargs == 2 )
        if(~ischar(varargin{2}) && ~isstring(varargin{2}))
            error('Argument 3, ''spacename'' must be a character array or string');
        end
        optArgs{2} = char(varargin{2});
    end

    spaceName = char(optArgs{2});
    axisName = char(axisName);
    q = char(39); % quote character
    axisPosition = femtoAPI('command', ...
        strcat('FemtoMicroscope.getAxisPosition(',q,axisName,q,',',q,spaceName,q,')'));
    axisPosition{1} = changeEncoding(axisPosition{1},obj.m_usedEncoding);
    axisPosition = jsondecode(axisPosition{1});

    if(strcmpi(optArgs{1},'absolute'))
        axisPosition = axisPosition.Absolute;
    elseif(strcmpi(optArgs{1},'relative'))
        axisPosition = axisPosition.Relative;
    else
        % no optional parameter was given -> get the whole axisposition struct
        return;
    end

end

