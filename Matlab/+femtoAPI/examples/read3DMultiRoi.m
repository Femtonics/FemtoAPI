%apiobj: object containing an estabilised femtoapi connection
%handle: format as [10 0 0 0], the last number replresents the channel number
%roinum: roi numbering starts at 1
function roidata = read3DMultiRoi(apiobj ,handle, roinum)
    unitMetadata = apiobj.getUnitMetadata(handle(1:3), 'BaseUnitMetadata');
    if ~ismember(unitMetadata.methodType , ['multiROILongitudinalRibbonScan', 'multiROITransverseRibbonScan', 'multiROIChessBoard'])
    	error("Bad measurement type, only 3D MultiRoi types are acceptable ...")
    end
    xDim = unitMetadata.xDim;
    yDim = unitMetadata.yDim;
    zDim = unitMetadata.zDim;
    bw = apiobj.getUnitMetadata(handle(1:3), 'BreakView');
    for i = 1 : length(bw.measurementROIMaps)
        if bw.measurementROIMaps(i).roiIndex == roinum
            roiId = i;
        end
    end
    x1 = bw.measurementROIMaps(roiId).lowerLeftFramePix(1);
    y1 = bw.measurementROIMaps(roiId).lowerLeftFramePix(2);
    x2 = bw.measurementROIMaps(roiId).upperRightFramePix(1);
    y2 = bw.measurementROIMaps(roiId).upperRightFramePix(2);
    fromDims = [x1,y1,1];
    toDims = [x2,y2,zDim];
    resultData = apiobj.readChannelData(handle, 'double', fromDims, toDims);
    roidata = resultData;
end