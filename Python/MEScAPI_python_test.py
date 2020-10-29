import sys, time, logging, os
import APIFunctions_logging
import miscFunctions
from PySide2.QtCore import *
from PySide2.QtWebSockets import *
from pathlib import Path
from femtoapi import PyFemtoAPI

ts = time.localtime()
timestamp = time.strftime("%Y%m%d%H%M%S", ts)
fname = "C:\\Jenkins\\workspace\\test_logs\\APIpythonTest_" + timestamp + ".txt"
logging.basicConfig(filename = Path(fname), level=logging.DEBUG)

app = QCoreApplication(sys.argv)

#time.sleep(30)

ws = APIFunctions_logging.initConnection()
print("Connected to API websocket host.")

APIFunctions_logging.login(ws, 'csp', 'asdf')
time.sleep(5)
print("API login successfull.")

state = APIFunctions_logging.getMicroscopeState(ws)['microscopeState']
if state:
    print("getMicroscopeState test: CHECK")
else:
    print("getMicroscopeState test: FAILED")
#state = res['microscopeState']
if state == "In an invalid state":
    logging.error("Microscope is in an invalid state! Testing cannot proceed. Restart might be needed.")
    sys.exit()
elif state == "Off":
    logging.error("Microscope is turned off! Testing cannot proceed. Hardver start needed..")
    sys.exit()
else:
    while state != "Ready":
        logging.info("Waiting for the Microscope to be ready...")
        time.sleep(5)
        state = APIFunctions_logging.getMicroscopeState(ws)['microscopeState']
        #res = APIFunctions_logging.getMicroscopeState(ws)
        #state = res['microscopeState']
    logging.info("Microscope is ready.")

#APIFunctions_logging.createNewFile(ws)


res = APIFunctions_logging.getProcessingState(ws)
if res:
    print("getProcessingState test: CHECK")
else:
    print("getProcessingState test: FAILED")
logging.info(res['openedMEScFiles'])

#string = '{"openedMEScFiles": [{"handle": [76]}]}'
currHandle = res['currentMeasurementSessionHandle']
currFileHandle = res['currentFileHandle']
#print(currHandle, currFileHandle)
comment = "testfile"
string = '{"comment": "' + comment + '", "handle": '+ str(currHandle) +'}'
APIFunctions_logging.setProcessingState(ws, string)
if res:
    print("setProcessingState test: CHECK")
else:
    print("setProcessingState test: FAILED")
res = APIFunctions_logging.getProcessingState(ws)
for e in res['openedMEScFiles']:
    #looks for the current measurement session and reads it's comment
    handle = e['handle']
    #print(handle)
    if handle == currFileHandle:
        for msession in e['measurementSessions']:
           validateComment = msession['comment']
if validateComment == comment:
    print("setProcessingState result validated\n")
else:
    print("setProcessingState result failed\n")
#print(res['openedMEScFiles'][0])
#print(handle)

res = APIFunctions_logging.getAcquisitionState(ws)
if res:
    print("getAcquisitionState test: CHECK")
else:
    print("getAcquisitionState test: FAILED")
logging.info("getAcquisitionState content:")
for e in res:
    logging.info(e)
logging.info("")


res = APIFunctions_logging.startGalvoScanSnapAsync(ws)
if res:
    print("startGalvoScanSnapAsync test: CHECK")
else:
    print("startGalvoScanSnapAsync test: FAILED")
miscFunctions.waitForMeasurementStop(ws)
res = APIFunctions_logging.startResonantScanSnapAsync(ws)
if res:
    print("startResonantScanSnapAsync test: CHECK")
else:
    print("startResonantScanSnapAsync test: FAILED")
miscFunctions.waitForMeasurementStop(ws)

res = APIFunctions_logging.createNewFile(ws)
if res:
    print("createNewFile test: CHECK")
else:
    print("createNewFile test: FAILED")
APIFunctions_logging.setMeasurementDuration(ws, 0, 'galvo')
res = APIFunctions_logging.startGalvoScanAsync(ws)
if res:
    print("startGalvoScanAsync test: CHECK")
else:
    print("startGalvoScanAsync test: FAILED")
logging.info("Waiting 10 sec")
time.sleep(10)
isRunning = miscFunctions.isMeasurementRunning(ws)
if isRunning:
    res = APIFunctions_logging.stopGalvoScanAsync(ws)
    if res:
        print("stopGalvoScanAsync test: CHECK")
    else:
        print("stopGalvoScanAsync test: FAILED")
    miscFunctions.waitForMeasurementStop(ws)
else:
    logging.warning("\nTESTERROR : Measurement is not running. Either failed to start or stopped by itself.\n")

APIFunctions_logging.createNewFile(ws)
res = APIFunctions_logging.startResonantScanAsync(ws)
if res:
    print("startResonantScanAsync test: CHECK")
else:
    print("startResonantScanAsync test: FAILED")
logging.info("Waiting 10 sec")
time.sleep(10)
isRunning = miscFunctions.isMeasurementRunning(ws)
if isRunning:
    res = APIFunctions_logging.stopResonantScanAsync(ws)
    if res:
        print("stopResonantScanAsync test: CHECK")
    else:
        print("stopResonantScanAsync test: FAILED")
    miscFunctions.waitForMeasurementStop(ws)
else:
    logging.info("\nTESTERROR : Measurement is not running. Either failed to start or stopped by itself.\n")

handles = []
res = APIFunctions_logging.getProcessingState(ws)
for e in res['openedMEScFiles']:
    handles.append(e['handle'][0])

logging.info("handles: "+ str(handles))
currFile = handles[0]
logging.info(type(currFile))
#save both measurement files using different functions (saveFileAsAsync, closeFileAndSaveAsAsync)
filePath1 = "C:/Jenkins/workspace/apitestsave1.mesc"
res = APIFunctions_logging.saveFileAsAsync(ws, filePath1, handles[1], 'true')
if res:
    print("saveFileAsAsync test: CHECK")
else:
    print("saveFileAsAsync test: FAILED")
cmdId = res["id"]
res = APIFunctions_logging.getStatus(ws, cmdId)
logging.info(res)

time.sleep(5)
filePath2 = "C:/Jenkins/workspace/apitestsave2.mesc"
res = APIFunctions_logging.closeFileAndSaveAsAsync(ws, filePath2, handles[2], 'true')
if res:
    print("closeFileAndSaveAsAsync test: CHECK")
else:
    print("closeFileAndSaveAsAsync test: FAILED")
cmdId = res["id"]
res = APIFunctions_logging.getStatus(ws, cmdId)
logging.info(res)

time.sleep(5)
#open the previously closed file2
res = APIFunctions_logging.openFilesAsync(ws, filePath2)
if res:
    print("openFilesAsync test: CHECK")
else:
    print("openFilesAsync test: FAILED")
cmdId = res["id"]
res = APIFunctions_logging.getStatus(ws, cmdId)
logging.info(res)
time.sleep(5)

#create a new measurement unit in file1 and save it with saveFileAsync
currFile = handles[1]
res = APIFunctions_logging.setCurrentFile(ws, currFile)
if res:
    print("setCurrentFile test: CHECK")
else:
    print("setCurrentFile test: FAILED")
APIFunctions_logging.startGalvoScanAsync(ws)
logging.info("Waiting 5 sec")
time.sleep(5)
res = miscFunctions.isMeasurementRunning(ws)
if res:
    APIFunctions_logging.stopGalvoScanAsync(ws)
    miscFunctions.waitForMeasurementStop(ws)
else:
    logging.warning("\nTESTERROR : Measurement is not running. Either failed to start or stopped by itself.\n")
    
res = APIFunctions_logging.saveFileAsync(ws)
if res:
    print("saveFileAsync test: CHECK")
else:
    print("saveFileAsync test: FAILED")
time.sleep(5)
#delete the new measurement unit from the file2 and close with closeFileNoSaveAsync
APIFunctions_logging.deleteMUnit(ws, ''+str(currFile)+',0,1')
res = APIFunctions_logging.closeFileNoSaveAsync(ws)
if res:
    print("closeFileNoSaveAsync test: CHECK")
else:
    print("closeFileNoSaveAsync test: FAILED")
time.sleep(5)


#open the file1, delete the second measurement unit again and close with closeFileAndSaveAsync
APIFunctions_logging.openFilesAsync(ws, filePath1)
time.sleep(5)



handles = []
res = APIFunctions_logging.getProcessingState(ws)
for e in res['openedMEScFiles']:
    handles.append(e['handle'][0])
currFile = handles[len(handles)-1]

APIFunctions_logging.setCurrentFile(ws, currFile)
APIFunctions_logging.deleteMUnit(ws, ''+str(currFile)+',0,1')
res = APIFunctions_logging.closeFileAndSaveAsync(ws)
if res:
    print("closeFileAndSaveAsync test: CHECK")
else:
    print("closeFileAndSaveAsync test: FAILED")
time.sleep(5)
APIFunctions_logging.openFilesAsync(ws, filePath1)
time.sleep(5)

handles = []
res = APIFunctions_logging.getProcessingState(ws)
#print(res)
for e in res['openedMEScFiles']:
    handles.append(e['handle'][0])
    for ms in e['measurementSessions']:
        #print(ms)
        if 'measurements' in ms:
            for meas in ms['measurements']:
                logging.info([meas['handle']])
                logging.info("")
currFile = handles[len(handles)-1]
logging.info("current: "+ str(currFile))


APIFunctions_logging.closeFileNoSaveAsync(ws, handles[len(handles)-1])
time.sleep(5)
APIFunctions_logging.closeFileNoSaveAsync(ws, handles[len(handles)-2])
time.sleep(5)
filePath1 = "C:/Jenkins/workspace/measurement_1.mesc"
filePath2 = "C:/Jenkins/workspace/measurement_2.mesc"
APIFunctions_logging.openFilesAsync(ws, filePath1)
time.sleep(5)
APIFunctions_logging.openFilesAsync(ws, filePath2)
time.sleep(5)

handles = []
res = APIFunctions_logging.getProcessingState(ws)
for e in res['openedMEScFiles']:
    handles.append(e['handle'])
currFile = handles[len(handles)-1][0]
logging.info(currFile)
APIFunctions_logging.setCurrentFile(ws, currFile)
logging.info("Measurement units in current file:")
res = APIFunctions_logging.getProcessingState(ws)
for e in res['openedMEScFiles']:
    handle = e['handle'][0]
    if handle == currFile:
        #print(handle)
        for msession in e['measurementSessions']:
           for meas in msession['measurements']:
                logging.info(meas['handle'])
           
viewport='{"transformation": {"translation": [0,0,0],"rotationQuaternion": [0,0,0,1]},"size": [256,256]}'
tp='<Task Type="TaskFastXYGalvo" Version="1.0"><Devices/><Params/></Task>' 
res = APIFunctions_logging.createTimeSeriesMUnit(ws, 256, 256, tp, viewport)
if res:
    print("createTimeSeriesMUnit test: CHECK")
else:
    print("createTimeSeriesMUnit test: FAILED")
logging.info("Measurement units in current file:")
res = APIFunctions_logging.getProcessingState(ws)
for e in res['openedMEScFiles']:
    handle = e['handle'][0]
    if handle == currFile:
        #print(handle)
        for msession in e['measurementSessions']:
            for meas in msession['measurements']:
                logging.info(meas['handle'])

handles = []
res = APIFunctions_logging.getProcessingState(ws)
for e in res['openedMEScFiles']:
    handles.append(e['handle'])
#currFile = res['currentMeasurementSessionHandle'][0]
currFile = handles[len(handles)-1][0]
targetFile = handles[len(handles)-2][0]
#targetFile = handles[len(handles)-1][0]
logging.info("CurrentFile: " + str(currFile) + "    TargetFile: " + str(targetFile))

viewport='{"transformation": {"translation": [0,0,0],"rotationQuaternion": [0,0,0,1]},"size": [256,256]}'
tp='<Task Type="TaskAOFullFrame" Version="1.0"><Devices/><Params/></Task>'
res = APIFunctions_logging.createTimeSeriesMUnit(ws, 256, 256, tp, viewport)
if res:
    print("createTimeSeriesMUnit AO test: CHECK")
else:
    print("createTimeSeriesMUnit AO test: FAILED")

res = APIFunctions_logging.extendMUnit(ws, ''+str(currFile)+',0,0', 5) # check return value
if res:
    print("extendMUnit test: CHECK")
else:
    print("extendMUnit test: FAILED")
res = APIFunctions_logging.copyMUnit(ws, ''+str(currFile)+',0,0', ''+str(currFile)+',0', 'false')
if res:
    print("copyMUnit test: CHECK")
else:
    print("copyMUnit test: FAILED")
res = APIFunctions_logging.moveMUnit(ws, res["copiedMUnitIdx"], ''+str(targetFile)+',0')
if res:
    print("moveMUnit test: CHECK")
else:
    print("moveMUnit test: FAILED")
res = APIFunctions_logging.addChannel(ws, ''+str(currFile)+',0,0' , 'whatever')
if res:
    print("addChannel test: CHECK")
else:
    print("addChannel test: FAILED")
time.sleep(1)
res = APIFunctions_logging.deleteChannel(ws, res["addedChannelIdx"])
if res:
    print("deleteChannel test: CHECK")
else:
    print("deleteChannel test: FAILED")

logging.info("")
IMparams = APIFunctions_logging.getImagingWindowParameters(ws)
if IMparams:
    print("getImagingWindowParameters test: CHECK")
else:
    print("getImagingWindowParameters test: FAILED")
logging.info(str(IMparams) + "\n")
string = '[{"space": "space1", "measurementType": "resonant", "size": [600, 400], "resolution": [450, 300], "transformation": {"translation": [-300.0,-200.0]}}]'
res = APIFunctions_logging.setImagingWindowParameters(ws, string)
if res:
    print("setImagingWindowParameters test: CHECK")
else:
    print("setImagingWindowParameters test: FAILED")
logging.info("")
IMparams = APIFunctions_logging.getZStackLaserIntensityProfile(ws)
if IMparams:
    print("getZStackLaserIntensityProfile test: CHECK")
else:
    print("getZStackLaserIntensityProfile test: FAILED")
logging.info(str(IMparams) + "\n")

string = '[{"measurementType":"galvo","firstZ":10.0,"intermediateZ": 12.0,"lastZ": 13.0,"zStep":0.5, "DepthCorrection":[{"name":"PMT_UG","values":[0,2,5]},{"name":"ResonantPockelsCell","values":[0,50,60]}]}]'
res = APIFunctions_logging.setZStackLaserIntensityProfile(ws, string)
if res:
    print("setZStackLaserIntensityProfile test: CHECK")
else:
    print("setZStackLaserIntensityProfile test: FAILED")
logging.info("")

res = APIFunctions_logging.getPMTAndLaserIntensityDeviceValues(ws)
if res:
    print("getPMTAndLaserIntensityDeviceValues test: CHECK")
else:
    print("getPMTAndLaserIntensityDeviceValues test: FAILED")
logging.info(res)
string = '[{"name":"PMT_UG","value":55.0}]'
res = APIFunctions_logging.setPMTAndLaserIntensityDeviceValues(ws, string)
if res:
    print("setPMTAndLaserIntensityDeviceValues test: CHECK")
else:
    print("setPMTAndLaserIntensityDeviceValues test: FAILED")
logging.info("")

filePath = "C:/Jenkins/workspace/measurement_1.mesc"
res = APIFunctions_logging.sendFileToClientsBlob(ws, filePath) # fejlesztői parancs
if res:
    print("sendFileToClientsBlob test: CHECK")
else:
    print("sendFileToClientsBlob test: FAILED")
logging.info("Size of file: " + str(res) + "\n")

filePath = "C:/Jenkins/workspace/apisavedfile2.mesc"
if Path.exists(Path(filePath)):
    mtimebef = os.path.getmtime(Path(filePath))
else:
    mtimebef = 0
res = APIFunctions_logging.saveAttachmentToFile(ws, filePath)
if res:
    print("saveAttachmentToFile test: CHECK")
else:
    print("saveAttachmentToFile test: FAILED")
time.sleep(2)
mtimeaft = os.path.getmtime(Path(filePath))
logging.info(mtimebef)
logging.info(mtimeaft)
if mtimebef < mtimeaft:
    print("saveAttachmentToFile result: VALIDATED")
else:
    print("saveAttachmentToFile result: FAILED")
logging.info("")

res = APIFunctions_logging.modifyConversion(ws, 'convPMT0', -1, 65535, 'false')
if res:
    print("modifyConversion test: CHECK")
else:
    print("modifyConversion test: FAILED")
logging.info("")
res = APIFunctions_logging.setFocusingMode(ws, 'Alternative', 'space1')
if res:
    print("setFocusingMode test: CHECK")
else:
    print("setFocusingMode test: FAILED")
logging.info("")



res = APIFunctions_logging.readChannelDataToClientsBlob(ws, ''+str(currFile)+',0,0,0', '1,1,1', '512,512,1')
if res:
    print("readChannelDataToClientsBlob test: CHECK")
else:
    print("readChannelDataToClientsBlob test: FAILED")
logging.info("")
#ws.uploadAttachment(res)
filePath = "C:/Jenkins/workspace/apisavedfile1.tmp"
res = APIFunctions_logging.saveAttachmentToFile(ws, filePath)
filePath = "C:/Jenkins/workspace/apisavedfile2.tmp"
res = APIFunctions_logging.readChannelDataToClientsBlob(ws, ''+str(currFile)+',0,0,0', '0,0,0', '512,512,1', filePath)
filePath = "C:/Jenkins/workspace/apisavedfile3.tmp"
res = APIFunctions_logging.readRawChannelData(ws, 'datavar', ''+str(currFile)+',0,0,0', '0,0,0', '512,512,1')
if res:
    print("readRawChannelData test: CHECK")
else:
    print("readRawChannelData test: FAILED")
logging.info("")
res = APIFunctions_logging.saveVarToFile(ws, 'datavar', filePath)
if res:
    print("saveVarToFile test: CHECK")
    print(res)
else:
    print("saveVarToFile test: FAILED")
logging.info("")



res = APIFunctions_logging.readRawChannelDataJSON(ws, ''+str(currFile)+',0,0,0', '0,0,0', '512,512,1')
if res:
    logging.info("Res type: " + str(type(res)) + ", Res lenght: "  + str(len(res)) + "\n")
    print("readRawChannelDataJSON test: CHECK")
else:
    print("readRawChannelDataJSON test: FAILED")

res = APIFunctions_logging.readChannelDataJSON(ws, ''+str(currFile)+',0,0,0', '0,0,0', '512,512,1')
if res:
    logging.info("Res type: " + str(type(res)) + ", Res lenght: "  + str(len(res)) + "\n")
    print("readChannelDataJSON test: CHECK")
else:
    print("readChannelDataJSON test: FAILED")

filePath = Path("C:/Jenkins/workspace/apisavedfile4.tmp")
res = APIFunctions_logging.readRawChannelDataToClientsBlob(ws, ''+str(currFile)+',0,0,0', '0,0,0', '512,512,1', filePath)
if res:
    print("readRawChannelDataToClientsBlob test: CHECK")
else:
    print("readRawChannelDataToClientsBlob test: FAILED")
logging.info("save to file: " + str(res))
readData = APIFunctions_logging.readRawChannelDataToClientsBlob(ws, ''+str(currFile)+',0,0,0', '0,0,0', '512,512,1')
#print("readRawchannel done? -> " + str(res))
logging.info("done " + str(type(res)))
res = APIFunctions_logging.addChannel(ws, ''+str(targetFile)+',0,0' , 'towrite1')
res = APIFunctions_logging.writeRawChannelDataFromAttachment(ws, readData, res["addedChannelIdx"], '0,0,0', '512,512,1')
if res:
    print("writeRawChannelDataFromAttachment test: CHECK")
else:
    print("writeRawChannelDataFromAttachment test: FAILED")


filePath = Path("C:/Users/csiszar.peter/Documents/MEScAPIPython/binarydata")
readData = APIFunctions_logging.readChannelDataToClientsBlob(ws, ''+str(currFile)+',0,0,0', '0,0,0', '512,512,1')
#print("done " + str(type(res)))
res = APIFunctions_logging.addChannel(ws, ''+str(targetFile)+',0,0' , 'towrite2')
time.sleep(1)
res = APIFunctions_logging.writeChannelDataFromAttachment(ws, readData, res["addedChannelIdx"], '0,0,0', '512,512,1')
if res:
    print("writeChannelDataFromAttachment test: CHECK")
else:
    print("writeChannelDataFromAttachment test: FAILED")

res = APIFunctions_logging.readRawChannelData(ws, 'datavar', str(currFile)+',0,0,0', '0,0,0', '512,512,1')
if res:
    print("readRawChannelData test: CHECK")
else:
    print("readRawChannelData test: FAILED")
#print("done " + str(res))
res = APIFunctions_logging.addChannel(ws, ''+str(targetFile)+',0,0' , 'towrite3')
res = APIFunctions_logging.writeRawChannelData(ws, 'datavar', res["addedChannelIdx"], '0,0,0', '512,512,1')
if res:
    print("writeRawChannelData test: CHECK")
else:
    print("writeRawChannelData test: FAILED")
res = APIFunctions_logging.readChannelData(ws, 'datavar', ''+str(currFile)+',0,0,0', '0,0,0', '512,512,1')
if res:
    print("readChannelData test: CHECK")
else:
    print("readChannelData test: FAILED")

#print("done " + str(res))
res = APIFunctions_logging.addChannel(ws, ''+str(targetFile)+',0,0' , 'towrite4')
res = APIFunctions_logging.writeChannelData(ws, 'datavar', res["addedChannelIdx"], '0,0,0', '512,512,1')
if res:
    print("writeChannelData test: CHECK")
else:
    print("writeChannelData test: FAILED")

res = APIFunctions_logging.setFocusingMode(ws, 'Standard', 'space1')
if res:
    print("setFocusingMode test: CHECK")
else:
    print("setFocusingMode test: FAILED")
time.sleep(5)

res = APIFunctions_logging.getAxisPositions(ws)
if res:
    print("getAxisPositions test: CHECK")
else:
    print("getAxisPositions test: FAILED")
logging.info(res)
#res = APIFunctions_logging.doZero(ws, "SlowX")
#print(res)
#time.sleep(3)
res = APIFunctions_logging.setAxisPosition(ws, "SlowX", 900)
if res:
    print("setAxisPosition test: CHECK")
else:
    print("setAxisPosition test: FAILED")
res = APIFunctions_logging.isAxisMoving(ws, "SlowX")
if res:
    print("isAxisMoving test: CHECK")
else:
    print("isAxisMoving test: FAILED")
time.sleep(1)
res = APIFunctions_logging.getAxisPosition(ws, "SlowX")
logging.info(res['absolute'])
res = APIFunctions_logging.setAxisPosition(ws, "SlowX", -900)
time.sleep(1)
res = APIFunctions_logging.getAxisPosition(ws, "SlowX")
logging.info(res['absolute'])
#APIFunctions_logging.setAxisPosition(ws, "SlowY", -500)
#res = APIFunctions_logging.setAxisPosition(ws, "SlowZ", 10)
#res = APIFunctions_logging.setAxisPosition(ws, "VirtX", 50)

#res = APIFunctions_logging.setAxisPosition(ws, "VirtY", 50)
#print(res)
#time.sleep(3)


res = APIFunctions_logging.getProcessingState(ws)
APIFunctions_logging.createNewFile(ws)
for e in res['openedMEScFiles']:
    APIFunctions_logging.closeFileNoSaveAsync(ws, e['handle'][0])
    time.sleep(1)

APIFunctions_logging.closeConnection(ws)

time.sleep(3)

print("End of test.")

