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
Example script to show how to convert a picture file into a mesc measurement file.
In this example the different color channels are imported into separate channels in the measurement unit.
"""

import sys, time, numpy
import APIFunctions
from PySide2.QtCore import *
from PySide2.QtWebSockets import *
from pathlib import Path
from femtoapi import PyFemtoAPI
from PIL import Image
import pathlib
from pyometiff import OMETIFFReader

impath = "C:/Users/csiszar.peter/Documents/mm_test/mm_test_MMStack_Pos0.ome.tif"

img_fpath = pathlib.Path(impath)
reader = OMETIFFReader(fpath=img_fpath)
img_array, metadata, xml_metadata = reader.read()
print(img_array.size)
print(metadata["SizeX"], metadata["SizeY"], metadata["SizeZ"])
sizeX = metadata["SizeX"]
sizeY = metadata["SizeY"]
sizeZ = metadata["SizeZ"]



app = QCoreApplication(sys.argv)
ws = APIFunctions.initConnection()
print("Connected to API websocket host.")
APIFunctions.login(ws, 'ImageToMESc', '123')
time.sleep(5)
print("API login successfull.")


viewport='{"referenceViewportFormatVersion": 1, "viewports":[{"geomTransTransl": [0,0,0],"geomTransRot": [0,0,0,1],"width": ' + str(sizeX) + ',"height": ' + str(sizeY) + '}]}'
tp='camera' 
res = APIFunctions.createTimeSeriesMUnit(ws, sizeX, sizeY, tp, viewport)
time.sleep(2)
handle = res['addedMUnitIdx']


res = APIFunctions.addChannel(ws, handle , 'Camera')

if sizeZ-1 > 0:
    res = APIFunctions.extendMUnit(ws, handle, sizeZ-1)

img_array = numpy.flip(img_array, 0)
newarr = img_array.astype(numpy.double)


stream = QByteArray(newarr.tobytes(order='C'))
res = APIFunctions.writeChannelDataFromAttachment(ws, stream,  handle + ',0', '0,0,0', str(sizeX) + ',' + str(sizeY) + ',' + str(sizeZ))



APIFunctions.closeConnection(ws)


