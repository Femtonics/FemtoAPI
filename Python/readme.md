# FemtoAPI - Python wrapper

APIFunction.py contains a collection of the API calls and it is used by all the example scripts in this repository. The 'femtoapi' package is used to communicate with the API server. It can be installed from PyPI: "pip install femtoapi"


For a detailed description of these functions please visit the [FemtoAPI](https://femtonics.atlassian.net/wiki/spaces/API2/pages/1448161743/FemtoAPI+2.0) site.

Here is a list of the presented functions.  
	- [MeasurementAutomation.py](https://github.com/Femtonics/FemtoAPI/blob/main/Python/MeasurementAutomation.py):  
		Contains the functionalities to call scripts before scan start and/or after scan finish.  
	- [accessMetadataInMESc_4_5_files.py](https://github.com/Femtonics/FemtoAPI/blob/main/Python/accessMetadataInMESc_4_5_files.py):  
		Example for accessing some metadata from the 4.5 measurement file.  
	- [averagedFrames.py](https://github.com/Femtonics/FemtoAPI/blob/main/Python/averagedFrames.py):  
		Creates a measurement unit with averaged frames, based on opened measurement "SOURCE", and average defined by "FRAMES".  
	- [copyFrames.py](https://github.com/Femtonics/FemtoAPI/blob/main/Python/copyFrames.py):  
		FemtoAPI application to copy data between two specified frames into a new measurement unit.  
	- [imageToMEScFile.py](https://github.com/Femtonics/FemtoAPI/blob/main/Python/imageToMEScFile.py):  
		Example script to show how to convert a picture file into a mesc measurement file.  
		In this example, the different color channels are imported into separate channels in the measurement unit.  
	- [layerSeparator.py](https://github.com/Femtonics/FemtoAPI/blob/main/Python/layerSeparator.py):  
		FemtoAPI application to create separate measurement units from the different layers in multilayer and volumescan measurements.  
	- [miscFunctions.py](https://github.com/Femtonics/FemtoAPI/blob/main/Python/miscFunctions.py):  
		Contains a collection of functions related to running operations.  
	- [readChannelData_MES8.py](https://github.com/Femtonics/FemtoAPI/blob/main/Python/readChannelData_MES8.py):  
		How to read channel data from MES8 AO measurements into a numpy array.  
	