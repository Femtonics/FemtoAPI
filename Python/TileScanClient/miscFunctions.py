import sys
import time
import logging
import APIFunctions

def waitForMeasurementStop(ws):
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
        logging.info("Microscope is Initializing. Why it is in this state is a mystery ...  Testing will stop anyways.")
        sys.exit()
    if state == "Ready":
        return True
    else:
        return False


def isMeasurementRunning(ws):
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
