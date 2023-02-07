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

import sys, re, json, argparse
import APIFunctions
from PySide2.QtCore import *
from PySide2.QtWebSockets import *
import xml.etree.ElementTree as ET
from femtoapi import PyFemtoAPI


class settingsLoader:

    def __init__(self):
        self.sourceMeas = ''


    def getArguments(self):
        parser = argparse.ArgumentParser(description="Usable with MESc 4.0 and femtoAPI 1.0 versions.")
        parser.add_argument('source', metavar='SOURCE',
                            help='Handle of the source measurement unit with channel number. e.g.: "10,0,0"')
        args = parser.parse_args()
        self.sourceMeas = str(args.source)


    def run(self):      
        app = QCoreApplication(sys.argv)
        ws = APIFunctions.initConnection()
        APIFunctions.login(ws, 'asd', '123')
        if re.search("[0-9]+,[0-9]+,[0-9]+", self.sourceMeas):
            pos = self.sourceMeas.find(",")
            file_handler = self.sourceMeas[:pos]
            source = self.sourceMeas[pos+1:]
            pos = source.find(",")
            session_handler = source[:pos]
            unit_handler  = source[pos+1:]
        else:
            print(source)
            print("Bad source format given!\nThe source should look like: '10,0,0'")
            sys.exit()

        res = APIFunctions.getPMTAndLaserIntensityDeviceValues(ws)

        deviceDict = {}
        for elem in res:
            deviceDict.update({elem['name']: elem})
        xmlstring = ""
        pstate = APIFunctions.getProcessingState(ws)
        for e in pstate['openedMEScFiles']:
            if e['handle'] == [int(file_handler)]:
                for session in e['measurementSessions']:
                    if session['handle'] == [int(file_handler),int(session_handler)]:
                        for munit in session['measurements']:
                            if munit['handle'] == [int(file_handler),int(session_handler), int(unit_handler)]:
                                xmlstring = str(munit['measurementInfo']['measurementParamsXML'])

        root = ET.fromstring(xmlstring)
        for child in root:
            if child.tag == 'Devices':
                for device in child:
                    if device.tag in ('Gear', 'APTMotor'):

                        if device.attrib['name'] in deviceDict:
                            if device.attrib['type']== 'PMT':
                                for param in device:
                                    if param.attrib['name'] == 'reference_voltage':
                                        deviceDict[device.attrib['name']]['value'] = float(param.attrib['value'])
                            elif device.attrib['type']== 'PockelsCell':
                                for param in device:
                                    if param.attrib['name'] == 'onintensity':
                                        deviceDict[device.attrib['name']]['value'] = float(param.attrib['value'])
                            elif device.attrib['type']== 'APTMotor':
                                for param in device:
                                    if param.attrib['name'] == 'position':
                                        deviceDict[device.attrib['name']]['value'] = float(param.attrib['value'])
        tmp = []
        for elem in deviceDict:
            tmp.append(deviceDict[elem])
        # manual space name declaration might be necessary as they cannot be empty when using the set function
        for elem in tmp:
            elem['space'] = 'space1'
            
        jsonstring = json.dumps(tmp)

        APIFunctions.setPMTAndLaserIntensityDeviceValues(ws, jsonstring)
        ws = APIFunctions.closeConnection(ws)


if __name__ == "__main__":
    app = settingsLoader()
    app.getArguments()
    app.run()
