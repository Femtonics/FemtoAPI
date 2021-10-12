# Copyright ©2021. Femtonics Ltd. (Femtonics). All Rights Reserved. 
# Permission to use, copy, modify this software and its documentation for educational,
# research, and not-for-profit purposes, without fee and without a signed licensing agreement, is 
# hereby granted, provided that the above copyright notice, this paragraph and the following two 
# paragraphs appear in all copies, modifications, and distributions. Contact info@femtonics.eu
# for commercial licensing opportunities.
# 
# IN NO EVENT SHALL FEMTONICS BE LIABLE TO ANY PARTY FOR DIRECT, INDIRECT, SPECIAL, 
# INCIDENTAL, OR CONSEQUENTIAL DAMAGES, INCLUDING LOST PROFITS, ARISING OUT OF 
# THE USE OF THIS SOFTWARE AND ITS DOCUMENTATION, EVEN IF FEMTONICS HAS BEEN 
# ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
# 
# FEMTONICS SPECIFICALLY DISCLAIMS ANY WARRANTIES, INCLUDING, BUT NOT LIMITED TO, 
# THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR 
# PURPOSE. THE SOFTWARE AND ACCOMPANYING DOCUMENTATION, IF ANY, PROVIDED 
# HEREUNDER IS PROVIDED "AS IS". FEMTONICS HAS NO OBLIGATION TO PROVIDE 
# MAINTENANCE, SUPPORT, UPDATES, ENHANCEMENTS, OR MODIFICATIONS.

import sys, time, os, subprocess, json
import APIFunctions
from PySide2.QtCore import *
from PySide2.QtWebSockets import *
from pathlib import Path
from femtoapi import PyFemtoAPI



class Application:
    """
    functionality to call scripts before scan start and/or after scan finish
    """

    def __init__( self):
        """
        information about an error from the last API call can be stored in the self.error variable
        """
        app = QCoreApplication(sys.argv)
        self.error = {}
        self.ws = APIFunctions.initConnection()
        #login credentials are not checked on server side yet but this step is still necessary to estabilist an API connection
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
        command='FemtoAPIMicroscope.startResonantScanAsync()'
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
        command='FemtoAPIMicroscope.startGalvoScanAsync()'
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
            print("Measurement could not be started!\n" + self.error["text"] + "\nErrorCode : " + self.error["code"])



    def callbackEnd( self, command ):
        """
        call script after scan finished
        
        command: string which will be called from commandline
                 needs to be in python compatible formatting
        """
        print("start")
        res = self.startResonantScanAsync()
        if res:
            measEnd = self.waitForMeasurementStop()
            if measEnd != True:
                print("Microscope state after " + measEnd)
        else:
            print("Measurement could not be started!\n" + self.error["text"] + "\nErrorCode : " + self.error["code"])
        
        result = subprocess.check_output(command)
        #do something with result?
        print("finish")


    def callbackStartAndEnd( self, command1, command2):
        """
        call script1 before measurement start and script2 after measurement finish
        
        command1-2: string which will be called from commandline
                    needs to be in python compatible formatting
        """
        print("start")
        result = subprocess.run(command1) 
        
        res = self.startResonantScanAsync()
        #in case of galvo use the following line
        #res =  self.startGalvoScanAsync()
        
        print(res)
        if res:
            measEnd = self.waitForMeasurementStop()
            if measEnd != True:
                print("Microscope state after " + measEnd)
        else:
            print("Measurement could not be started!\n" + self.error["text"] + "\nErrorCode : " + self.error["code"])
        
        result = subprocess.run(command2, capture_output=False, encoding='utf-8') #capture_output=True if script output is needed
        #result.stdout to access script output
        
        print("finish")
        

    def close( self ):
        APIFunctions.closeConnection(self.ws)



if __name__ == '__main__':
    application = Application()
    # 
    command1 = "define script here"
    command2 = "define script here"

    application.callbackStartAndEnd(command1, command2)
    application.close()

