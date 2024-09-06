import os
import imagej
import imagej.doctor

print(os.environ["JAVA_HOME"])
print(os.environ["PATH"])
imagej.doctor.checkup()

os.environ["JAVA_HOME"] = 'C:\\Program Files\\Fiji.app\\java\\win64\\zulu8.60.0.21-ca-fx-jdk8.0.322-win_x64\\jre'
os.environ["PATH"] = 'C:\\Program Files\\Zulu\\zulu-8\\jre\\bin' + ';' + os.environ["PATH"]

print(os.environ["PATH"])
imagej.doctor.checkup()
