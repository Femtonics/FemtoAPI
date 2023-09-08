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
from PySide2 import QtCore
from PySide2 import QtWidgets
import APIFunctions
import miscFunctions
import time
import logging
import json
import os
try:
    import imagej
except ImportError:
    raise RuntimeError("PyImageJ package not found, Tiff file Stitching function deactivated.")
import shutil
from pathlib import Path


class TiffSticher:
    def __init__(self, outputDir):
        #self.wsConnection = APIFunctions.initConnection('ws://localhost:8888')
        self.wsConnection = APIFunctions.initConnection('ws://192.168.43.4:8888')
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
        if not Path.is_dir(workingDir):
            Path.mkdir(workingDir)
        res = APIFunctions.getChildTree(self.wsConnection, handle)
        for unit in res['measurements']:
            unitHandle = unit['handle'][2]
            measHandle = handle + ',' +str(unitHandle)
            filePath = Path(workingDir, str(unitHandle) + '.tif')
            APIFunctions.tiffExport(self.wsConnection, filePath, measHandle, 0)

    def getStiching(self, order, gridX, gridY, overlap):
        ij = imagej.init('C:/Program Files/Fiji.app')
        #ij = imagej.init('2.14.0')
        print(ij.getVersion())

        #order = 'Right & Up'
        #gridX = 4
        #gridY = 4
        #overlap = 50 # %
        TiffExportPath = Path(self.dirPath, 'tmptiff')

        ij.IJ.run('Grid/Collection stitching','type=[Grid: snake by rows] \
                    order=[' + order + '] \
                    directory=[' + str(TiffExportPath) + '] \
                    grid_size_x=' + str(gridX) + ' grid_size_y=' + str(gridY) + ' tile_overlap='  + str(overlap) + ' \
                    first_file_index_i=0 \
                    confirm_files output_textfile_name=TileConfiguration.txt  \
                    fusion_method=[Linear Blending] regression_threshold=0.30 \
                    max/avg_displacement_threshold=2.50 absolute_displacement_threshold=3.50 \
                    subpixel_accuracy computation_parameters=[Save memory (but be slower)] \
                    image_output=[Write to disk] \
                    file_names=[{i}.tif] \
                    image_output=[Fused.tif] \
                    output_directory=[' + str(self.dirPath) + '\]')
        shutil.rmtree(TiffExportPath)
        ij.dispose()

