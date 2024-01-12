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
Example for reading ROI information from MES8 Special Scan measurements
Only works with MES8 measurement files using API 2.0 (MESc 4.5)
"""

import sys, os, time
import APIFunctions
from PySide2.QtCore import *
from PySide2.QtWebSockets import *
from femtoapi import PyFemtoAPI


munitHandle = '59,0,9'  # measurement unit handle to export data from


app = QCoreApplication(sys.argv)
ws = APIFunctions.initConnection()
APIFunctions.login(ws, 'asd', '123')
time.sleep(2)
print("API login successfull.")


unitMetadata = APIFunctions.getUnitMetadata(ws, munitHandle, 'BaseUnitMetadata')
breakView = APIFunctions.getUnitMetadata(ws, munitHandle, 'BreakView')

print('Pixel size X: ' + str(unitMetadata['pixelSizeX'][0]))
print('Pixel size Y: ' + str(unitMetadata['pixelSizeY'][0]))

numberOfROIs = len(breakView['measurementROIMaps'])
print('Number of ROI-s: ' + str(numberOfROIs))
for roi in breakView['measurementROIMaps']:
    roiIndex = roi['roiIndex']
    sizeX = roi['upperRightFramePix'][0] - roi['lowerLeftFramePix'][0] + 1
    sizeY = roi['upperRightFramePix'][1] - roi['lowerLeftFramePix'][1] + 1
    print('ROI ' + str(roiIndex) + ' size: ' + str(sizeX) + ', ' + str(sizeY))


print('t0InMs: ' + str(unitMetadata['t0InMs']))
print('tStepInMs: ' + str(unitMetadata['tStepInMs']))
