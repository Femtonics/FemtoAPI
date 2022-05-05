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

"""
Example to start measurement
"""

import sys, os, time
import APIFunctions
from PySide2.QtCore import *
from PySide2.QtWebSockets import *
from femtoapi import PyFemtoAPI


app = QCoreApplication(sys.argv)

ws = APIFunctions.initConnection()
print("Connected to API websocket host.")

APIFunctions.login(ws, 'csp', 'asdf')
time.sleep(5)
print("API login successfull.")

"""
example to start an endless galvo measurement and stop it manually
"""
APIFunctions.setMeasurementDuration(ws, 0, 'galvo') # set galvo measurement duration to endless
APIFunctions.startGalvoScanAsync(ws)
print("Waiting 10 sec")
time.sleep(10)
isRunning = miscFunctions.isMeasurementRunning(ws)
if isRunning:
    APIFunctions.stopGalvoScanAsync(ws)
    miscFunctions.waitForMeasurementStop(ws)
else:
    logging.warning("\nTESTERROR : Measurement is not running. Either failed to start or stopped by itself.\n")


"""
example to start a resonant measurement with a set duration time and wait for it to stop
"""
APIFunctions.setMeasurementDuration(ws, 10, 'resonant') # set resonant measurement duration to 10 seconds
APIFunctions.startResonantScanAsync(ws)
time.sleep(3) # without the extra wait here the microscope state will not change to "Working" before the isMeasurementRunning() function checks it and will not be able to halt the sript until it finishes properly
isRunning = miscFunctions.isMeasurementRunning(ws)
if isRunning:
    miscFunctions.waitForMeasurementStop(ws)
else:
    logging.warning("\nTESTERROR : Measurement is not running. Either failed to start or stopped by itself.\n")



APIFunctions.closeConnection(ws)
