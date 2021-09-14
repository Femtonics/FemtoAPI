import sys, time, os, subprocess, json
import APIFunctions
from PySide2.QtCore import *
from PySide2.QtWebSockets import *
from pathlib import Path
from femtoapi import PyFemtoAPI



class Application:
    """
    functionality to call scripts before scan start or after scan finish
    """

    def __init__( self):
        """
        information about an error from the last API call can be stored in the self.error variable
        """
        app = QCoreApplication(sys.argv)
        self.error = {}
        self.ws = APIFunctions.initConnection()
        APIFunctions.login(self.ws, "callback", "do")


    def waitForMeasurementStop( self ):
        """
        waits until the microscope state changes from working
        1-2 seconds of wait should be added after a scan start so the microscope state will change into Working for sure
        """
        state = APIFunctions.getMicroscopeState(self.ws)['microscopeState']
        if state == "Working":
            while state == "Working":
                time.sleep(1)
                print("...")
                state = APIFunctions.getMicroscopeState(self.ws)['microscopeState']
        if state == "Ready":
            return True
        else:
            return state


    def startResonantScanAsync( self ):
        """
        resonant scan start
        properties should be set from mesc beforehand
        """
        command='FemtoMicroscope.startResonantScanAsync()'
        simpleCmdParser=self.ws.sendJSCommand(command)
        resultCode=simpleCmdParser.getResultCode()
        if resultCode > 0:
            tmp = {}
            tmp.update({"code": str(resultCode)})
            tmp.update({"text": simpleCmdParser.getErrorText()})
            self.error = tmp
            return None
        else:
            cmdResult = simpleCmdParser.getJSEngineResult()
            return cmdResult


    def startGalvoScanAsync( self ):
        """
        galvo scan start
        properties should be set from mesc beforehand
        """
        command='FemtoMicroscope.startGalvoScanAsync()'
        simpleCmdParser=self.ws.sendJSCommand(command)
        resultCode=simpleCmdParser.getResultCode()
        if resultCode > 0:
            tmp = {}
            tmp.update({"code": str(resultCode)})
            tmp.update({"text": simpleCmdParser.getErrorText()})
            self.error = tmp
            return None
        else:
            cmdResult = simpleCmdParser.getJSEngineResult()
            return cmdResult



    def callbackStart( self, command ):
        """
        call script before scan start
        command: string which will be called from commandline
                 needs to be python compatible formatting
        """
        print("start")
        result = subprocess.check_output(command)
        #do something with result?
        
        res = self.startResonantScanAsync()
        if res:
            measEnd = self.waitForMeasurementStop()
            if measEnd != True:
                print("Microscope state after " + measEnd)
        else:
            print("Measurement could not be started!\n" + res["text"] + "\nErrorCode : " + res["code"])



    def callbackEnd( self, command ):
        """
        call script after scan finished
        
        command: string which will be called from commandline
                 needs to be python compatible formatting
        """
        print("start")
        res = self.startResonantScanAsync()
        if res:
            measEnd = self.waitForMeasurementStop()
            if measEnd != True:
                print("Microscope state after " + measEnd)
        else:
            print("Measurement could not be started!\n" + res["text"] + "\nErrorCode : " + res["code"])
        
        result = subprocess.check_output(command)
        #do something with result?
        print("finish")

    def close( self ):
        APIFunctions.closeConnection(self.ws)







if __name__ == '__main__':
    print("asd")
    application = Application()
    command = '"C:\\Program Files\\Python3_8_2\\python" C:\\Users\\csiszar.peter\\Documents\\MEScAPIPython\\script.py'
    print(command)
    application.callbackEnd(command)
    application.close()

