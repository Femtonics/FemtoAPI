%exaple script to get information about the ROIs in a speacial scan measurement
urlAddressAndPort = 'ws://localhost:8888'; 
mescapiObjP = FemtoAPIProcessing(urlAddressAndPort);
handle = [59 0 9]; 
try
    unitMetadata = mescapiObjP.getUnitMetadata(handle, 'BaseUnitMetadata');
    breakView = mescapiObjP.getUnitMetadata(handle, 'BreakView');

    pixelSizeX = unitMetadata.pixelSizeX
    pixelSizeY = unitMetadata.pixelSizeY

    numberOfROIs = length(breakView.measurementROIMaps)

    for i = 1 : length(breakView.measurementROIMaps)
        disp(breakView.measurementROIMaps(i).roiIndex)
        sizeX = breakView.measurementROIMaps(i).upperRightFramePix(1) - breakView.measurementROIMaps(i).lowerLeftFramePix(1) + 1
        sizeY = breakView.measurementROIMaps(i).upperRightFramePix(2) - breakView.measurementROIMaps(i).lowerLeftFramePix(2) + 1
        
    end
    
    t0InMs = unitMetadata.t0InMs
    tStepInMs = unitMetadata.tStepInMs
    
    mescapiObjP.disconnect();
catch err
    disp(err)
    % api connection always needs to get disconnected or it will get stuck
    mescapiObjP.disconnect();
    delete(mescapiObjP);
    
end