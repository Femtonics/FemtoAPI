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
This example contains a collection of functions related to running measurements.
"""

import sys
import time
import logging
import APIFunctions

def waitForMeasurementStop(ws):
    """
    Checks the microscope state and waits until it changes to 'Ready' from 'Working'
    """
    logging.info("wait")
    state = APIFunctions.getMicroscopeState(ws)['microscopeState']
    if state == "Working":
        logging.info("Waiting for measurement to stop ...")
        while state == "Working":
            time.sleep(3)
            state = APIFunctions.getMicroscopeState(ws)['microscopeState']
    if state == "In an invalid state":
        logging.error("Microscope is in an invalid state! Testing cannot proceed. Restart might be needed.")
        sys.exit()
    if state == "Off":
        logging.error("Microscope is turned off! Testing cannot proceed. Hardver start needed..")
        sys.exit()
    if state == "Initializing":
        logging.info("Microscope is Initializing. Microscope needs to be fully started before running measurements. Aborting script.")
        sys.exit()
    if state == "Ready":
        return True
    else:
        return False


def isMeasurementRunning(ws):
    """
    Return value is True if the microscope state is 'Working' which means scanning is in progress, False otherwise
    """
    state = APIFunctions.getMicroscopeState(ws)['microscopeState']
    logging.info("Mic state is " + str(state))
    if state == "Working":
        return True
    elif state == "Ready":
        return False
    elif state == "Off":
        logging.error("Microscope is off!!")
        return False
    elif state == "Initializing":
        logging.info("Microscope is Initializing.")
        return False
    else:
        logging.error("Microscope is in an invalid state!")
        return False


def waitForOperationDone(ws, operationID = None, limit = 180):
    '''
    Waits for operation defined by operationID to finish. Timeout is defined by the variable 'limit'.
    Not too dependable as of MESc 4.0
    '''
    pending = True
    timer = 0
    print(pending, timer, operationID)
    while pending == True and timer < limit:
        timer += 1
        time.sleep(1)
        #print(timer)
        res = APIFunctions.getStatus(ws, operationID)
        #print(res)
        if res['error']:
            print('Error happened during the operation. ErrorMessage: ' + str(res['error']))
        pending = res['isPending']
    if timer < limit:    
        print('Asynchronous operation done.')
        return True
    else:
        print('Asynchronous operation still running. Function timeout.')
        return False
    
    
    
