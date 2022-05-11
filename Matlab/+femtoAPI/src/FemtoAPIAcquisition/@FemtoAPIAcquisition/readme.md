# FemtoAPI Matlab Wrapper — FemtoAPIAcquisition functions

In this list, you can see the implemented FemtoAPIAcquisition functions, and a short description of them:
	- [FemtoAPIAcquisition.m](https://github.com/Femtonics/FemtoAPI/blob/main/Matlab/+femtoAPI/src/FemtoAPIAcquisition/@FemtoAPIAcquisition/FemtoAPIAcquisition.m):  
		Class for handling measurement data acquisition. The purpose of this class is to provide methods for easy handling of measurement acquisition-related functions, like set/get device values, start/stop measurements, get acquisition state, etc.  
	- [doZero.m](https://github.com/Femtonics/FemtoAPI/blob/main/Matlab/+femtoAPI/src/FemtoAPIAcquisition/@FemtoAPIAcquisition/doZero.m):  
		This command is used for setting the relative position of the given axis to zero and sets the labeling origin offset to the current absolute position. The axis is given by the parameters axisName and space name. If space name is not given, default space is considered.  
	- [getAcquisitionState.m](https://github.com/Femtonics/FemtoAPI/blob/main/Matlab/+femtoAPI/src/FemtoAPIAcquisition/@FemtoAPIAcquisition/getAcquisitionState.m):  
		Updates acquisition state struct from the server.  
	- [getActiveProtocol.m](https://github.com/Femtonics/FemtoAPI/blob/main/Matlab/+femtoAPI/src/FemtoAPIAcquisition/@FemtoAPIAcquisition/getActiveProtocol.m):  
		Returns the active measurement protocol.  
	- [getActiveSubTaskForTask.m](https://github.com/Femtonics/FemtoAPI/blob/main/Matlab/+femtoAPI/src/FemtoAPIAcquisition/@FemtoAPIAcquisition/getActiveSubTaskForTask.m):  
		Gets the active subtask for the given task.  
	- [getActiveSubTaskParameters.m](https://github.com/Femtonics/FemtoAPI/blob/main/Matlab/+femtoAPI/src/FemtoAPIAcquisition/@FemtoAPIAcquisition/getActiveSubTaskParameters.m):  
		Gets parameters to active subtask for a task.  
	- [getActiveTaskAndSubTask.m](https://github.com/Femtonics/FemtoAPI/blob/main/Matlab/+femtoAPI/src/FemtoAPIAcquisition/@FemtoAPIAcquisition/getActiveTaskAndSubTask.m):  
		Gets the active task and subtask.  
	- [getAxisPosition.m](https://github.com/Femtonics/FemtoAPI/blob/main/Matlab/+femtoAPI/src/FemtoAPIAcquisition/@FemtoAPIAcquisition/getAxisPosition.m):  
		Gets the position of the given axis.  
	- [getAxisPositions.m](https://github.com/Femtonics/FemtoAPI/blob/main/Matlab/+femtoAPI/src/FemtoAPIAcquisition/@FemtoAPIAcquisition/getAxisPositions.m):  
		Get position information of configured axes.  
	- [getConfiguredAxes.m](https://github.com/Femtonics/FemtoAPI/blob/main/Matlab/+femtoAPI/src/FemtoAPIAcquisition/@FemtoAPIAcquisition/getConfiguredAxes.m):  
		Gets the configured axis names.  
	- [getFocusingModes.m](https://github.com/Femtonics/FemtoAPI/blob/main/Matlab/+femtoAPI/src/FemtoAPIAcquisition/@FemtoAPIAcquisition/getFocusingModes.m):  
		Gets available focusing modes from the server.  
	- [getImagingWindowParameters.m](https://github.com/Femtonics/FemtoAPI/blob/main/Matlab/+femtoAPI/src/FemtoAPIAcquisition/@FemtoAPIAcquisition/getImagingWindowParameters.m):  
		Gets imaging window parameters from the server.  
	- [getMicroscopeState.m](https://github.com/Femtonics/FemtoAPI/blob/main/Matlab/+femtoAPI/src/FemtoAPIAcquisition/@FemtoAPIAcquisition/getMicroscopeState.m):  
		Gets the microscope state and last measurement error.  
	- [getPMTAndLaserIntensityDeviceValues.m](https://github.com/Femtonics/FemtoAPI/blob/main/Matlab/+femtoAPI/src/FemtoAPIAcquisition/@FemtoAPIAcquisition/getPMTAndLaserIntensityDeviceValues.m):  
		Gets PMT/Laser device parameters.  
	- [getTaskParameters.m](https://github.com/Femtonics/FemtoAPI/blob/main/Matlab/+femtoAPI/src/FemtoAPIAcquisition/@FemtoAPIAcquisition/getTaskParameters.m):  
		Helper for filtering acquisition state task parameters.  
	- [getZStackLaserIntensityProfile.m](https://github.com/Femtonics/FemtoAPI/blob/main/Matlab/+femtoAPI/src/FemtoAPIAcquisition/@FemtoAPIAcquisition/getZStackLaserIntensityProfile.m):  
		Gets the Z-stack laser intensity profile.  
	- [isAxisConfigured.m](https://github.com/Femtonics/FemtoAPI/blob/main/Matlab/+femtoAPI/src/FemtoAPIAcquisition/@FemtoAPIAcquisition/isAxisConfigured.m):  
		Tells whether the input axis name is valid or not.  
	- [isAxisMoving.m](https://github.com/Femtonics/FemtoAPI/blob/main/Matlab/+femtoAPI/src/FemtoAPIAcquisition/@FemtoAPIAcquisition/isAxisMoving.m):  
		Returns whether the axis is moving or not.  
	- [setActiveTaskAndSubTask.m](https://github.com/Femtonics/FemtoAPI/blob/main/Matlab/+femtoAPI/src/FemtoAPIAcquisition/@FemtoAPIAcquisition/setActiveTaskAndSubTask.m):  
		Sets active task and subtask in the server's GUI.  
	- [setAxisPosition.m](https://github.com/Femtonics/FemtoAPI/blob/main/Matlab/+femtoAPI/src/FemtoAPIAcquisition/@FemtoAPIAcquisition/setAxisPosition.m):  
		Sets the position of a given axis.  
	- [setFocusingMode.m](https://github.com/Femtonics/FemtoAPI/blob/main/Matlab/+femtoAPI/src/FemtoAPIAcquisition/@FemtoAPIAcquisition/setFocusingMode.m):  
		Sets focusing mode on the server's GUI.  
	- [setImagingWindowParameters.m](https://github.com/Femtonics/FemtoAPI/blob/main/Matlab/+femtoAPI/src/FemtoAPIAcquisition/@FemtoAPIAcquisition/setImagingWindowParameters.m):  
		Sets imaging window parameters on the server.  
	- [setMeasurementDuration.m](https://github.com/Femtonics/FemtoAPI/blob/main/Matlab/+femtoAPI/src/FemtoAPIAcquisition/@FemtoAPIAcquisition/setMeasurementDuration.m):  
		Sets measurement duration.  
	- [setPMTAndLaserIntensityDeviceValues.m](https://github.com/Femtonics/FemtoAPI/blob/main/Matlab/+femtoAPI/src/FemtoAPIAcquisition/@FemtoAPIAcquisition/setPMTAndLaserIntensityDeviceValues.m):  
		Sets PMT/Laser intensity device values.  
	- [setZStackLaserIntensityProfile.m](https://github.com/Femtonics/FemtoAPI/blob/main/Matlab/+femtoAPI/src/FemtoAPIAcquisition/@FemtoAPIAcquisition/setZStackLaserIntensityProfile.m):  
		Sets Z-stack PMT/laser intensity profile.  
	- [startGalvoScanAsync.m](https://github.com/Femtonics/FemtoAPI/blob/main/Matlab/+femtoAPI/src/FemtoAPIAcquisition/@FemtoAPIAcquisition/startGalvoScanAsync.m):  
		Starts Galvo XY scan measurement asynchronously.  
	- [startGalvoScanSnapAsync.m](https://github.com/Femtonics/FemtoAPI/blob/main/Matlab/+femtoAPI/src/FemtoAPIAcquisition/@FemtoAPIAcquisition/startGalvoScanSnapAsync.m):  
		Starts Galvo XY scan snap.  
	- [startResonantScanAsync.m](https://github.com/Femtonics/FemtoAPI/blob/main/Matlab/+femtoAPI/src/FemtoAPIAcquisition/@FemtoAPIAcquisition/startResonantScanAsync.m):  
		Starts Resonant XY scan measurement asynchronously.  
	- [startResonantScanSnapAsync.m](https://github.com/Femtonics/FemtoAPI/blob/main/Matlab/+femtoAPI/src/FemtoAPIAcquisition/@FemtoAPIAcquisition/startResonantScanSnapAsync.m):  
		Starts a resonant scan snap.  
	- [stopGalvoScanAsync.m](https://github.com/Femtonics/FemtoAPI/blob/main/Matlab/+femtoAPI/src/FemtoAPIAcquisition/@FemtoAPIAcquisition/stopGalvoScanAsync.m):  
		Stops Galvo XY scan measurement asynchronously.  
	- [stopResonantScanAsync.m](https://github.com/Femtonics/FemtoAPI/blob/main/Matlab/+femtoAPI/src/FemtoAPIAcquisition/@FemtoAPIAcquisition/stopResonantScanAsync.m):  
		Stops Resonant XY scan measurement asynchronously.  
