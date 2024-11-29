"""
Set the proper java environent variables according to Fiji ImageJ versions
"""

import os

def setJavaEnv():
    os.environ["JAVA_HOME"] = 'C:\\Program Files\\Fiji.app\\java\\win64\\zulu8.60.0.21-ca-fx-jdk8.0.322-win_x64\\jre'
    os.environ["PATH"] = 'C:\\Program Files\\Fiji.app\\java\\win64\\zulu8.60.0.21-ca-fx-jdk8.0.322-win_x64\\\jre\\bin' + ';' + os.environ["PATH"]
