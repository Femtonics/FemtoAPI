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
