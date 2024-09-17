Requires python 3.8

Further required packages --> requiremets.txt

Download fresh Fiji ImageJ , older versions can contain incompatible JDK.

ImageJ requires Maven to be installed. --> https://maven.apache.org/download.cgi , also see https://maven.apache.org/install.html

javaconfig.py performs the JAVA environment setup for ImageJ. Use the JDK included in Fiji.

Important note: It is possible that the X,Y stage will not move the exact distance as instructed by the code. In this case the ImageJ stiching can compensate and create a well connected image but the FOW will be slightly smaller than expected.