#!/usr/bin/python
import sys, time
from PySide2.QtCore import *
from PySide2.QtWebSockets import *
from femtoapi import PyFemtoAPI
import json

if __name__ == '__main__':
    app = QCoreApplication(sys.argv)
    
#CONNECT	
    ws=PyMEScAPI.APIWebSocketClient('ws://localhost:8888')
    if ws == False:
        sys.exit(1)

    done=ws.connectToServer()

    if ws == False:
        sys.exit(1)

#LOGIN
    loginParser=ws.login('xyz','Asdfg')
    resultCode=loginParser.getResultCode()
    if resultCode > 0:
        print (loginParser.getErrorText())
        sys.exit(1)

#COMMANDS
    command="MEScFile.saveFileAsync()"
    print(command)
    simpleCmdParser=ws.sendJSCommand(command)
    resultCode=simpleCmdParser.getResultCode()
    #print(resultCode)
    if resultCode > 0:
        print ("Return code: " + str(resultCode))
        print (simpleCmdParser.getErrorText())
    else:	
        cmdResult = json.loads(simpleCmdParser.getJSEngineResult())
        print ("Filesave success: " + str(cmdResult["succeeded"]))

    asyncId = cmdResult["id"]
    print(asyncId)
    command="MEScFile.getStatus('" + str(asyncId) + "')"
    print(command)
    simpleCmdParser=ws.sendJSCommand(command)
    resultCode=simpleCmdParser.getResultCode()
    if resultCode > 0:
        print ("Return code: " + str(resultCode))
        print (simpleCmdParser.getErrorText())
    else:
        cmdResult = simpleCmdParser.getJSEngineResult()
        print ("getStatus success:" + str(cmdResult))

#CLOSE & EXIT
    ws.close()
    sys.exit(0)
