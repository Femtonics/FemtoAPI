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

import sys, time, os, csv
import APIFunctions
from PySide2.QtCore import *
from PySide2.QtWebSockets import *
from pathlib import Path
from femtoapi import PyFemtoAPI

"""
Example script on how to read curve data and change the format to vector arrays if needed
Optionally the result can be saved into CSV files

Include APIFunctions.py in the same directory

Change 'handle' variable according to measurement unit handle.
Set 'DO_CSV' value to True to also write data into a csv file.
Set 'name' to only read a specific curve
"""

handle = '59,0,0'
DO_CSV = True
path = '' #folder path for the CSV file saving
name = '' #name of the specific curve, if emply string all curves will be processed

app = QCoreApplication(sys.argv)
ws = APIFunctions.initConnection()
print("Connected to API websocket host.")
APIFunctions.login(ws, 'user', '123')
time.sleep(3)
print("API login successfull.")


res = APIFunctions.getUnitMetadata(ws, handle, 'CurveInfo')
if not res:
    print("ERROR: No open file seems to exist with the given measurements handle.")
    sys.exit(0)
curveId = ''
curveInfo = ''

for curve in res['curves']:
    curveName =  curve['name']
    curveId = curve['curveIdx']
    if name and curveName != name:
        continue
    result = APIFunctions.readCurve(ws, handle, curveId, False, False)
    xDataType = result['Result']['xDataType']
    xType = result['Result']['xType']
    yDataType = result['Result']['yDataType']
    yType = result['Result']['yType']
    xdata = result['CurveData']['xData']
    ydata = result['CurveData']['yData']

    datavecX = []
    datavecY = []

    if yType == 'rle':
        for i in range(0, len(ydata), 2):
            for j in range(int(ydata[i])):
                datavecY.append(ydata[i+1])
    else:
        datavecY = ydata

    if xType == 'equidistant':
        datavecX.append(xdata[0])
        for i in range(1, len(datavecY)):
            datavecX.append(datavecX[i-1]+xdata[1])
    else:
        datavecX = xdata

    filepath = Path(path, curveName+ '(' + str(curveId)+')_'+str(handle)+ '.csv')
    if DO_CSV:
        with open(filepath, 'w', encoding='UTF8', newline='') as f:
            writer = csv.writer(f, delimiter=',', quotechar='"', quoting=csv.QUOTE_MINIMAL)
            for i in range(len(datavecX)):
                writer.writerow([datavecX[i] , datavecY[i]])

APIFunctions.closeConnection(ws)
