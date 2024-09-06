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

# This Python file uses the following encoding: utf-8
from PySide2.QtCore import *
from PySide2 import QtWidgets
import APIFunctions
import miscFunctions
import time
import logging
import json
import os, sys
import numpy
from PIL import Image
import javaconfig
try:
    import imagej
    #import imagej.doctor
except ImportError:
    raise RuntimeError("PyImageJ package not found, Tiff file Stitching function deactivated.")
import shutil
from pathlib import Path


class TiffSticher:
    def __init__(self, outputDir):
        self.wsConnection = APIFunctions.initConnection()
        outputDir = Path(outputDir)
        if not Path.is_dir(outputDir):
            Path.mkdir(outputDir)
        self.dirPath = outputDir
        self.connect()

    def connect(self, userName="TileScanPy", password="12345"):
        APIFunctions.login(self.wsConnection, userName, password)
        time.sleep(3)

    def disConnect(self):
        APIFunctions.closeConnection(self.wsConnection)
        
    def tiffExport(self, handle):
        workingDir = Path(self.dirPath, 'tmptiff')
        #print(workingDir)
        if not Path.is_dir(workingDir):
            Path.mkdir(workingDir)
        res = APIFunctions.getProcessingState(self.wsConnection)

        for file in res['openedMEScFiles']:
            if file["handle"][0] == handle[0]:
                for session in file["measurementSessions"]:
                    if session["handle"] == handle:
                        for unit in session["measurements"]:
                            measHandle = str(unit["handle"][0]) + ',' + str(unit["handle"][1]) + ',' + str(unit["handle"][2]) + ',0'
                            dimX = unit["dimensions"][0]["size"]
                            dimY = unit["dimensions"][1]["size"]
                            dimZ = 1
                            fromDims = '0,0,0'
                            countDims = str(dimX) + ',' + str(dimY) + ',1'
                            data = APIFunctions.readChannelDataToClientsBlob(self.wsConnection, measHandle, fromDims, countDims)
                            stream = QDataStream(QByteArray(data))
                            stream.setByteOrder(QDataStream.ByteOrder.LittleEndian)
                            tmplist = []
                            while not stream.atEnd():
                                pixelvalue = stream.readDouble()
                                tmplist.append(numpy.int32(pixelvalue))
                            rawdata = numpy.array(tmplist)
                            shapedData = numpy.reshape(rawdata, (dimY, dimX))
                            shapedData = numpy.flip(shapedData, 0)
                            img = Image.fromarray(shapedData)
                            saveName = Path(workingDir, str(unit["handle"][2]) + '.tif')
                            img.save(str(saveName), compression="tiff_deflate", save_all=True)
                            
    def getStiching(self, order, gridX, gridY, overlap):
        javaconfig.setJavaEnv()
        ij = imagej.init('C:/Program Files/Fiji.app')
        #ij = imagej.init()
        #print(ij.getVersion())
        TiffExportPath = Path(self.dirPath, 'tmptiff')
        #print(TiffExportPath)
        ij.IJ.run('Grid/Collection stitching','type=[Grid: snake by rows] \
                    order=[' + order + '] \
                    directory=[' + str(TiffExportPath) + '] \
                    grid_size_x=' + str(gridX) + ' grid_size_y=' + str(gridY) + ' tile_overlap='  + str(overlap) + ' \
                    first_file_index_i=0 \
                    confirm_files output_textfile_name=TileConfiguration.txt  \
                    fusion_method=[Linear Blending] regression_threshold=0.30 \
                    max/avg_displacement_threshold=2.50 absolute_displacement_threshold=3.50 \
                    subpixel_accuracy computation_parameters=[Save memory (but be slower)] \
                    file_names=[{i}.tif] \
                    image_output=[Write to disk] \
                    output_directory=[' + str(self.dirPath) + '\]')
        #shutil.rmtree(TiffExportPath)
        ij.dispose()
        print("Done stiching")

#testing
if __name__ == "__main__":
    app = QCoreApplication(sys.argv)
    sticher = TiffSticher("C:/GITrepos/FemtoAPI_archive/Python/TileScanClient/test")
    sticher.tiffExport([58,0])
    sticher.getStiching("Left & Down", 3, 3, 50)
