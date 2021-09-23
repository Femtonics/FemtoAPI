# Copyright ©2021. Femtonics Kft. (Femtonics). All Rights Reserved. 
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

import sys, time, logging, os
import APIFunctions
import miscFunctions
from PySide2.QtCore import *
from PySide2.QtWebSockets import *
from pathlib import Path
from mescapi import PyMEScAPI
import TileScanPy


vpX = 400
vpY = 400
resX = 512
resY = int(resX / (vpX / vpY))
overlap = 50
xDim = 3
yDim = 3

scanner = "resonant"

app = QCoreApplication(sys.argv)
scan = TileScanPy.TileScanPy()
scan.connect()


dicty = {'x': [], 'y': []}
var = "y"
#maybe a button on the GUI that adds current location to the dicty x and y ?
while var != "n":
    var = input("Please enter something: ")
    dicty['x'].append(scan.getCurrentX())
    dicty['y'].append(scan.getCurrentY())

print(dicty)
outputDir = "C:/Users/csiszar.peter/Documents/MEScAPIPython"
result = scan.calculatetScanArea(dicty, vpX, vpY, overlap)
print(result)
scan.setParameters( scanner, vpX, vpY, resX, resY, result['dimX'], result['dimY'], overlap, result['x'], result['y'], outputDir)



scan.disConnect()
