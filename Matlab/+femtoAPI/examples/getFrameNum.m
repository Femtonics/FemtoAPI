urlAddressAndPort = 'ws://localhost:8888'; 
mescapiObjP = FemtoAPIProcessing(urlAddressAndPort);

for i = 0:11
    res = mescapiObjP.getUnitMetadata([60 0 i], 'BaseUnitMetadata');
    frameNum = res.logicalDimSizes(end)
end
mescapiObjP.disconnect();
clear mescapiObjP