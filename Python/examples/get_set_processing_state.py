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


res = APIFunctions.getProcessingState(ws)

for element in res:
    print(element , type(res[element]))
    if isinstance(res[element], dict):
        for subelement in res[element]:
            print("   " + str(subelement))
            if isinstance(subelement, dict):
                for e in subelement:
                    print("       " + str(e))
    if isinstance(res[element], list):
        for subelement in res[element]:
            if isinstance(subelement, dict):
                for e in subelement:
                    print("       "+ e + " : " + str(subelement[e]))
            else:
                print("   " + str(subelement), type(subelement))

"""
Currently, this command can be used to set the following values:
    measurement session/group/unit comment,
    channel LUT and conversion measurement metadata,
    'measurementParamsJSON' field of measurement group/unit
    'isBeingRecorded' field of measurement group/unit
"""


#string = '{"openedMEScFiles": [ {"handle": [ 56 ], "measurementSessions": [ { "comment": "comment1", "handle": [ 56, 0 ] } ] }, {"handle": [ 57 ], "measurementSessions": [ { "comment": "comment2", "handle": [ 57, 0 ] } ] }]}'
#string = '{"comment": "changed comment", "handle": [56, 0]}'

string = '{"openedMEScFiles": [ {"handle": [ 57 ], "measurementSessions": [ { "handle": [ 57, 0 ], "comment": "comment12" , "measurements": [ { "handle": [57, 0, 0] , "spaceName": "space2" , "setupName": "imaginarySetupName"} ] } ] } ] }'

res = APIFunctions.setProcessingState(ws, string)
print(res)


APIFunctions.closeConnection(ws)
