function layerSeparator(sourceHandle, sourcePath, varargin)
%LAYERSEPARATOR Creates separate measurement units from the different
%layers of a multiLayer or volumeScan measurement.
%   Matlab/femtoAPI equivalent of Python/layerSeparator.py. For every Z
%   layer of the source measurement, a new time series measurement unit
%   is created (with the same channels) in a new MESc file, and the
%   layer's image data is copied over frame by frame. The new file is
%   then saved and closed.
%
% INPUTS [required]:
%   sourceHandle        - [fileHandle, sessionHandle, unitHandle] of the
%                         source multiLayer/volumeScan measurement unit,
%                         e.g. [10, 0, 0]
%
%   sourcePath          - path of the source measurement (.mesc) file.
%                         The file must already be open in MESc; this
%                         path is only used to derive the default output
%                         folder.
%
% INPUTS [optional]:
%   targetPath           - full path of the output .mesc file to create.
%                          Default: '<folder of sourcePath>/separated_layers.mesc'
%                          If the given target folder does not exist, the
%                          source folder is used instead. If the target
%                          file already exists, a numeric suffix is added
%                          to the file name.
%
%   urlAddressAndPort    - femtoAPI websocket address.
%                          Default: 'ws://localhost:8888'
%
% Example:
%   layerSeparator([10,0,0], 'C:/Data/measurement.mesc')
%   layerSeparator([10,0,0], 'C:/Data/measurement.mesc', 'C:/Data/out.mesc')
%
% See also CREATETIMESERIESMUNIT EXTENDMUNIT ADDCHANNEL READRAWCHANNELDATA WRITERAWCHANNELDATA
%

narginchk(2,4);

validateattributes(sourceHandle,{'numeric'},{'vector','nonnegative','integer','numel',3}, ...
    mfilename,'sourceHandle');
sourceHandle = reshape(sourceHandle,1,[]);

validateattributes(sourcePath,{'char'},{'nonempty','row'},mfilename,'sourcePath');
if ~isfile(sourcePath)
    error('layerSeparator: source file does not exist: %s', sourcePath);
end

targetPath = '';
urlAddressAndPort = 'ws://localhost:8888';

if length(varargin) >= 1 && ~isempty(varargin{1})
    validateattributes(varargin{1},{'char'},{'row'},mfilename,'targetPath');
    targetPath = varargin{1};
end
if length(varargin) == 2
    validateattributes(varargin{2},{'char'},{'nonempty','row'},mfilename,'urlAddressAndPort');
    urlAddressAndPort = varargin{2};
elseif length(varargin) > 2
    error('layerSeparator: too many input arguments.');
end

[sourceFolder,~,~] = fileparts(sourcePath);
sourceFolder = strrep(sourceFolder,'\','/');
if isempty(sourceFolder)
    sourceFolder = '.';
end

if isempty(targetPath)
    targetPath = [sourceFolder, '/separated_layers.mesc'];
    disp(['No target file was given.', newline, ...
        'Using default output location and default filename: ', targetPath]);
else
    [targetFolder, targetName, targetExt] = fileparts(targetPath);
    if isempty(targetFolder) || ~isfolder(targetFolder)
        disp(['Target folder does not exist.', newline, ...
            'Using default output folder: ', sourceFolder]);
        targetFolder = sourceFolder;
    end
    targetFolder = strrep(targetFolder,'\','/');
    targetPath = [targetFolder, '/', targetName, targetExt];
end

mescapiObjP = FemtoAPIProcessing(urlAddressAndPort);

try
    %% gather source measurement metadata
    unitMetadata = mescapiObjP.getUnitMetadata(sourceHandle, 'BaseUnitMetadata');
    if ~ismember(unitMetadata.methodType, {'volumeScan','multiLayer'})
        warning(['Bad type of measurement detected: ', unitMetadata.methodType, ...
            '. layerSeparator only works on volumeScan or multiLayer measurements.']);
    end

    channelInfo = mescapiObjP.getUnitMetadata(sourceHandle, 'ChannelInfo');
    channelNames = {channelInfo.channels.name};
    numChannels = length(channelNames);

    dimx = unitMetadata.logicalDimSizes(1);
    dimy = unitMetadata.logicalDimSizes(2);
    dimz = unitMetadata.logicalDimSizes(3);
    dimt = unitMetadata.logicalDimSizes(4);
    tScale = unitMetadata.tStepInMs;

    viewportInfo = mescapiObjP.getUnitMetadata(sourceHandle, 'ReferenceViewport');
    layerViewports = viewportInfo.viewports;
    numLayerViewports = length(layerViewports);

    % volumeScan measurements report a single shared viewport, whose Z
    % translation has to be shifted per layer from minZ/maxZ/slices/
    % scanningDirection; multiLayer measurements already report one
    % explicit viewport per layer, so no shift is applied there.
    % Mirrors the fix in Python/layerSeparator.py (commit 41fa962).
    step = 0;
    zDiff = 0;
    slices = dimz;
    if strcmp(unitMetadata.methodType, 'volumeScan')
        minZ = unitMetadata.minZ;
        maxZ = unitMetadata.maxZ;
        slices = unitMetadata.slices;
        direct = 1;
        if strcmp(unitMetadata.scanningDirection, 'topToBottom')
            direct = -1;
        end
        step = ((maxZ - minZ) / (slices - 1)) * direct;
        zDiff = maxZ - minZ;
        tScale = tScale / slices;
    end

    %% create the target file and one time series MUnit per Z layer
    mescapiObjP.createNewFile();
    currentSession = mescapiObjP.getCurrentSession();
    newFileHandle = currentSession(1);

    handleArray = zeros(dimz,3);
    for i = 1:dimz
        if numLayerViewports > 1
            vp = layerViewports(i);
        else
            vp = layerViewports(1);
        end

        vpOut.geomTransTransl = vp.geomTransTransl;
        if numLayerViewports <= 1
            vpOut.geomTransTransl(3) = vpOut.geomTransTransl(3) + step * (i-1) + zDiff;
        end
        vpOut.geomTransRot = vp.geomTransRot;
        vpOut.width = vp.width;
        vpOut.height = vp.height;

        viewportStruct.referenceViewportFormatVersion = 1;
        viewportStruct.viewports = {vpOut};
        viewportJson = jsonencode(viewportStruct);

        % z0InMs/zStepInMs mirror the offsets used by Python/layerSeparator.py
        result = mescapiObjP.createTimeSeriesMUnit(dimx, dimy, unitMetadata.technologyType, ...
            viewportJson, (i-1) * tScale, tScale * slices);
        waitAndCheck(mescapiObjP, result, 'createTimeSeriesMUnit');
        handle = result.addedMUnitIdx;

        for ch = 1:numChannels
            mescapiObjP.addChannel(handle, channelNames{ch});
        end

        handleArray(i,:) = handle;
    end

    %% copy channel data from each source layer into its own MUnit
    % Raw (uncoverted) read/write is used on purpose: the source channel's
    % conversion (scale/offset) can map raw values to negative "converted"
    % doubles, which a freshly added channel's default conversion would
    % clip back to 0 on write. Copying the raw values instead preserves
    % the data exactly, independently of any conversion settings.
    % The whole per-layer time series is copied in a single call per
    % channel (instead of frame by frame) to avoid one API round trip per
    % frame.
    for layerNum = 1:dimz
        mescapiObjP.extendMUnit(handleArray(layerNum,:), dimt-1);
        for ch = 1:numChannels
            sourceDataType = channelInfo.channels(ch).dataType;
            targetDataType = mescapiObjP.getUnitMetadata(handleArray(layerNum,:), ...
                'ChannelInfo').channels(ch).dataType;
            if ~strcmp(sourceDataType, targetDataType)
                warning(['Channel "', channelNames{ch}, '" data type mismatch: source is ', ...
                    sourceDataType, ', target is ', targetDataType, '. Values will be cast.']);
            end

            rawData = mescapiObjP.readRawChannelData([sourceHandle, ch-1], ...
                [1,1,layerNum,1], [dimx,dimy,1,dimt]);
            rawData = reshape(rawData,[dimx,dimy,dimt]);
            mescapiObjP.writeRawChannelData([handleArray(layerNum,:), ch-1], rawData, [1,1,1]);
        end
    end

    %% save the new file under a non-existing path, then close it
    [outFolder, outName, outExt] = fileparts(targetPath);
    finalPath = targetPath;
    suffix = 2;
    while isfile(finalPath)
        finalPath = [outFolder, '/', outName, num2str(suffix), outExt];
        suffix = suffix + 1;
    end

    result = mescapiObjP.closeFileAndSaveAsAsync(finalPath, newFileHandle);
    waitAndCheck(mescapiObjP, result, 'closeFileAndSaveAsAsync');

    disp(['Saved separated layers to: ', finalPath]);

    mescapiObjP.disconnect();
catch ME
    % api connection always needs to get disconnected or it will get stuck
    mescapiObjP.disconnect();
    delete(mescapiObjP);
    rethrow(ME);
end

end


function waitAndCheck(obj, result, description)
%WAITANDCHECK Waits for an async command and errors out if it failed.
%   obj.waitForCompletion only looks at the isPending flag, so a command
%   that finishes with a server-side error (status.error non-empty, e.g.
%   "File I/O error occured.") is otherwise silently treated as success.
obj.waitForCompletion(result);
status = obj.getStatus(result.id);
if ~isempty(status.error)
    error('layerSeparator:asyncOperationFailed', '%s failed: %s', description, status.error);
end
end
