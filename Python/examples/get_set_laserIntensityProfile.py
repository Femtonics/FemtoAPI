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

import sys, os, time
import APIFunctions
from PySide2.QtCore import *
from PySide2.QtWebSockets import *
from femtoapi import PyFemtoAPI

"""
Example to get and set laser intensity profile
"""

app = QCoreApplication(sys.argv)

ws = APIFunctions.initConnection()
print("Connected to API websocket host.")

APIFunctions.login(ws, 'csp', 'asdf')
time.sleep(5)
print("API login successfull.")


res = APIFunctions.getPMTAndLaserIntensityDeviceValues(ws)
for element in res:
    print(element)

# space, name , value
# only the value can be changed, the other two used to identify the object
# space is optional -> default space
string = '[{"name":"PMT_UG","value":55.0}]'
res = APIFunctions.setPMTAndLaserIntensityDeviceValues(ws, string)

res = APIFunctions.getPMTAndLaserIntensityDeviceValues(ws)
for element in res:
    print(element)

APIFunctions.closeConnection(ws)
