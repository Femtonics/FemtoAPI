urlAddressAndPort = 'ws://localhost:8888'; 
mescapiObjP = FemtoAPIProcessing(urlAddressAndPort);

% API functions can be called here from the mescapiObjP object

mescapiObjP.disconnect();
clear mescapiObjP