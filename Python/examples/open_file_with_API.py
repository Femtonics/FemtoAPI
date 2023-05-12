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
File open example
"""

import sys, time
import APIFunctions
import miscFunctions
from PySide2.QtCore import *
from PySide2.QtWebSockets import *

app = QCoreApplication(sys.argv)
ws = APIFunctions.initConnection()
print("Connected to API websocket host.")
APIFunctions.login(ws, 'user', 'pass')
time.sleep(2)

fullPath = "C:/path/filaname.mesc"
result = APIFunctions.openFilesAsync(ws, fullPath)
miscFunctions.waitForAsyncCommand(ws, result['id']) #wait for the async fileopen operation to finish

"""
If the handle of the newly opened file is needed
"""
state = APIFunctions.getChildTree(ws)
handle = state['openedMEScFiles'][-1]['handle'][0]

APIFunctions.closeConnection(ws)
