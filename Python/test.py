import sys, time, logging, os, numpy
import APIFunctions
import miscFunctions
from PySide2.QtCore import *
from PySide2.QtWebSockets import *
from pathlib import Path
from mescapi import PyMEScAPI
from femtoapi import PyFemtoAPI
from pathlib import PosixPath

app = QCoreApplication(sys.argv)


ws=PyMEScAPI.APIWebSocketClient('ws://localhost:8888')
if ws == False:
    print("WebSocketHost could not be found?")
    sys.exit(1)

timer = 0
while timer < 10:
    print("Trying to connect to server...")
    done=ws.connectToServer()
    if done == False:
        time.sleep(1)
    else:
        break
    timer = timer + 1
print("Connection initialized: " + str(done))
if done == False:
    sys.exit(1)





#ws = APIFunctions.initConnection()
#print("Connected to API websocket host.")
APIFunctions.login(ws, 'csp', 'asdf')
#time.sleep(5)
#print("API login successfull.")


#res = APIFunctions.getProcessingState(ws)
#print(res)

"""
res = APIFunctions.getCurve(ws, '57,0,0', '2')
print(res["Result"])
x = res["BinaryData"]["xData"]
y = res["BinaryData"]["yData"]

print(len(x), len(y))
print(x)
print(y)
"""
APIFunctions.closeConnection(ws)
