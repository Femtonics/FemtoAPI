urlAddressAndPort = 'ws://localhost:8888'; 
mescapiObjP = FemtoAPIProcessing(urlAddressAndPort);

data = read3DMultiRoi(mescapiObjP, [60 0 9 0], 1 );

mescapiObjP.disconnect();