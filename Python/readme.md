# FemtoAPI - Python wrapper

APIFunction.py contains a collection of the API calls and it is used by all the example scripts in this repository. The 'femtoapi' package is used to communicate with the API server. It can be installed from PyPI: "pip install femtoapi"


For a detailed description of these functions please visit the [FemtoAPI](https://femtonics.atlassian.net/wiki/spaces/API2/pages/1448161743/FemtoAPI+2.0) site.

Here is a list of the presented functions.  
	- [accessMetadataInMESc_4_5_files.py](https://github.com/Femtonics/FemtoAPI/blob/Atlas/Python/accessMetadataInMESc_4_5_files.py):  
		Example for accessing some metadata from the 4.5 measurement file.  
	- [averagedFrames.py](https://github.com/Femtonics/FemtoAPI/blob/Atlas/Python/averagedFrames.py):  
		Creates a measurement unit with averaged frames, based on opened measurement "SOURCE", and average defined by "FRAMES".  
	- [copyFrames.py](https://github.com/Femtonics/FemtoAPI/blob/Atlas/Python/copyFrames.py):  
		FemtoAPI application to copy data between two specified frames into a new measurement unit.  
	- [imageToMEScFile.py](https://github.com/Femtonics/FemtoAPI/blob/Atlas/Python/imageToMEScFile.py):  
		Example script to show how to convert a picture file into a mesc measurement file.  
		In this example, the different color channels are imported into separate channels in the measurement unit.  
	- [layerSeparator.py](https://github.com/Femtonics/FemtoAPI/blob/Atlas/Python/layerSeparator.py):  
		FemtoAPI application to create separate measurement units from the different layers in multilayer and volumescan measurements.  
	- [readChannelData_MES8.py](https://github.com/Femtonics/FemtoAPI/blob/Atlas/Python/readChannelData_MES8.py):  
		How to read channel data from MES8 AO measurements into a numpy array.  
	