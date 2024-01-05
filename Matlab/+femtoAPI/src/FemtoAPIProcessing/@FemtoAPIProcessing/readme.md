# FemtoAPI Matlab Wrapper — FemtoAPIProcessing functions

In this list, you can see the implemented FemtoAPIProcessing functions, and a short description of them:
	- [FemtoAPIProcessing.m](https://github.com/Femtonics/FemtoAPI/blob/Atlas/Matlab/+femtoAPI/src/FemtoAPIProcessing/@FemtoAPIProcessing/FemtoAPIProcessing.m):  
		This class is for handling measurement processing data.  
	- [addChannel.m](https://github.com/Femtonics/FemtoAPI/blob/Atlas/Matlab/+femtoAPI/src/FemtoAPIProcessing/@FemtoAPIProcessing/addChannel.m):  
		Adds channel with specified name to an existing measurement unit.  
	- [addLastFrameToMSession.m](https://github.com/Femtonics/FemtoAPI/blob/Atlas/Matlab/+femtoAPI/src/FemtoAPIProcessing/@FemtoAPIProcessing/addLastFrameToMSession.m):  
		Adds measurement snap image to the given session.  
	- [batchExportCurvesMat.m](https://github.com/Femtonics/FemtoAPI/blob/Atlas/Matlab/+femtoAPI/src/FemtoAPIProcessing/@FemtoAPIProcessing/batchExportCurvesMat.m):  
		Saves common input/output channels of given MUnits.  
	- [batchExportCurvesTxt.m](https://github.com/Femtonics/FemtoAPI/blob/Atlas/Matlab/+femtoAPI/src/FemtoAPIProcessing/@FemtoAPIProcessing/batchExportCurvesTxt.m):  
		Saves common input/output channels of given MUnits.  
	- [batchExportMeasurementMetaData.m](https://github.com/Femtonics/FemtoAPI/blob/Atlas/Matlab/+femtoAPI/src/FemtoAPIProcessing/@FemtoAPIProcessing/batchExportMeasurementMetaData.m):  
		Exports measurement metadata to json.   
	- [buildProcessingStateHandle.m](https://github.com/Femtonics/FemtoAPI/blob/Atlas/Matlab/+femtoAPI/src/FemtoAPIProcessing/@FemtoAPIProcessing/buildProcessingStateHandle.m):  
		Builds server's state structure from handle obj.  
	- [changeDateTimeToLocal.m](https://github.com/Femtonics/FemtoAPI/blob/Atlas/Matlab/+femtoAPI/src/FemtoAPIProcessing/@FemtoAPIProcessing/changeDateTimeToLocal.m):  
		Change datetimes to local time.  
	- [closeFileAndSaveAsAsync.m](https://github.com/Femtonics/FemtoAPI/blob/Atlas/Matlab/+femtoAPI/src/FemtoAPIProcessing/@FemtoAPIProcessing/closeFileAndSaveAsAsync.m):  
		Close file and save as asynchronously.  
	- [closeFileAndSaveAsync.m](https://github.com/Femtonics/FemtoAPI/blob/Atlas/Matlab/+femtoAPI/src/FemtoAPIProcessing/@FemtoAPIProcessing/closeFileAndSaveAsync.m):  
		Saves an already existing file then closes it.  
	- [closeFileNoSaveAsync.m](https://github.com/Femtonics/FemtoAPI/blob/Atlas/Matlab/+femtoAPI/src/FemtoAPIProcessing/@FemtoAPIProcessing/closeFileNoSaveAsync.m):  
		Closes an already existing file without closing it.  
	- [copyMUnit.m](https://github.com/Femtonics/FemtoAPI/blob/Atlas/Matlab/+femtoAPI/src/FemtoAPIProcessing/@FemtoAPIProcessing/copyMUnit.m):  
		Copies the source measurement image to the requested session/group.  
	- [createNewFile.m](https://github.com/Femtonics/FemtoAPI/blob/Atlas/Matlab/+femtoAPI/src/FemtoAPIProcessing/@FemtoAPIProcessing/createNewFile.m):  
		Cretes a new MESc File in the MESc GUI.  
	- [createStructHandles.m](https://github.com/Femtonics/FemtoAPI/blob/Atlas/Matlab/+femtoAPI/src/FemtoAPIProcessing/@FemtoAPIProcessing/createStructHandles.m):  
		Creates handle structure from a complex embedded structure.  
	- [createTimeSeriesMUnit.m](https://github.com/Femtonics/FemtoAPI/blob/Atlas/Matlab/+femtoAPI/src/FemtoAPIProcessing/@FemtoAPIProcessing/createTimeSeriesMUnit.m):  
		Creates new time series measurement unit.  
	- [createZStackMUnit.m](https://github.com/Femtonics/FemtoAPI/blob/Atlas/Matlab/+femtoAPI/src/FemtoAPIProcessing/@FemtoAPIProcessing/createZStackMUnit.m):  
		Creates new z-stack measurement unit.  
	- [deleteChannel.m](https://github.com/Femtonics/FemtoAPI/blob/Atlas/Matlab/+femtoAPI/src/FemtoAPIProcessing/@FemtoAPIProcessing/deleteChannel.m):  
		Deletes the given channel.  
	- [deleteMUnit.m](https://github.com/Femtonics/FemtoAPI/blob/Atlas/Matlab/+femtoAPI/src/FemtoAPIProcessing/@FemtoAPIProcessing/deleteMUnit.m):  
		Deletes a measurement unit from the server program's GUI.  
	- [extendMUnit.m](https://github.com/Femtonics/FemtoAPI/blob/Atlas/Matlab/+femtoAPI/src/FemtoAPIProcessing/@FemtoAPIProcessing/extendMUnit.m):  
		Extends the given measurement unit with frames.  
	- [getCommonCurvesMetaDataTable.m](https://github.com/Femtonics/FemtoAPI/blob/Atlas/Matlab/+femtoAPI/src/FemtoAPIProcessing/@FemtoAPIProcessing/getCommonCurvesMetaDataTable.m):  
		Gets metadata of common input/output curves.  
	- [getCurve.m](https://github.com/Femtonics/FemtoAPI/blob/Atlas/Matlab/+femtoAPI/src/FemtoAPIProcessing/@FemtoAPIProcessing/getCurve.m):  
		Gets curve data as Nx2 matrix from the specified measurement unit, and channel within this unit.  
	- [getCurves.m](https://github.com/Femtonics/FemtoAPI/blob/Atlas/Matlab/+femtoAPI/src/FemtoAPIProcessing/@FemtoAPIProcessing/getCurves.m):  
		Gets curve names and data for the given measurement unit.  
	- [getCurvesByName.m](https://github.com/Femtonics/FemtoAPI/blob/Atlas/Matlab/+femtoAPI/src/FemtoAPIProcessing/@FemtoAPIProcessing/getCurvesByName.m):  
		Gets curve data of the specified curves.   
	- [getProcessingState.m](https://github.com/Femtonics/FemtoAPI/blob/Atlas/Matlab/+femtoAPI/src/FemtoAPIProcessing/@FemtoAPIProcessing/getProcessingState.m):  
		Gets the list of open files and the trees of all measurement sessions and measurements within them, together with most of the available metadata.  
	- [getStatus.m](https://github.com/Femtonics/FemtoAPI/blob/Atlas/Matlab/+femtoAPI/src/FemtoAPIProcessing/@FemtoAPIProcessing/getStatus.m):  
		Gets the status of all open files or specified commands.  
	- [modifyConversion.m](https://github.com/Femtonics/FemtoAPI/blob/Atlas/Matlab/+femtoAPI/src/FemtoAPIProcessing/@FemtoAPIProcessing/modifyConversion.m):  
		Modifies linear conversion in conversion manager.  
	- [moveMUnit.m](https://github.com/Femtonics/FemtoAPI/blob/Atlas/Matlab/+femtoAPI/src/FemtoAPIProcessing/@FemtoAPIProcessing/moveMUnit.m):  
		Moves the source measurement image to the requested session/group.  
	- [openFilesAsync.m](https://github.com/Femtonics/FemtoAPI/blob/Atlas/Matlab/+femtoAPI/src/FemtoAPIProcessing/@FemtoAPIProcessing/openFilesAsync.m):  
		Open files in the server program's GUI.   
	- [readChannelData.m](https://github.com/Femtonics/FemtoAPI/blob/Atlas/Matlab/+femtoAPI/src/FemtoAPIProcessing/@FemtoAPIProcessing/readChannelData.m):  
		Reads converted channel data.  
	- [readRawChannelData.m](https://github.com/Femtonics/FemtoAPI/blob/Atlas/Matlab/+femtoAPI/src/FemtoAPIProcessing/@FemtoAPIProcessing/readRawChannelData.m):  
		Reads raw channel data.  
	- [saveFileAsAsync.m](https://github.com/Femtonics/FemtoAPI/blob/Atlas/Matlab/+femtoAPI/src/FemtoAPIProcessing/@FemtoAPIProcessing/saveFileAsAsync.m):  
		Saves the file to the path given by newAbsolutePath.  
	- [saveFileAsync.m](https://github.com/Femtonics/FemtoAPI/blob/Atlas/Matlab/+femtoAPI/src/FemtoAPIProcessing/@FemtoAPIProcessing/saveFileAsync.m):  
		Saves the file asynchronously.  
	- [setComment.m](https://github.com/Femtonics/FemtoAPI/blob/Atlas/Matlab/+femtoAPI/src/FemtoAPIProcessing/@FemtoAPIProcessing/setComment.m):  
		Sets comment of the given measurement session/unit/group.  
	- [setCommentJSON.m](https://github.com/Femtonics/FemtoAPI/blob/Atlas/Matlab/+femtoAPI/src/FemtoAPIProcessing/@FemtoAPIProcessing/setCommentJSON.m):  
		Creates JSON object from input handle and comment.  
	- [setCurrentFile.m](https://github.com/Femtonics/FemtoAPI/blob/Atlas/Matlab/+femtoAPI/src/FemtoAPIProcessing/@FemtoAPIProcessing/setCurrentFile.m):  
		Sets the current file in the MESc GUI.  
	- [setProcessingState.m](https://github.com/Femtonics/FemtoAPI/blob/Atlas/Matlab/+femtoAPI/src/FemtoAPIProcessing/@FemtoAPIProcessing/setProcessingState.m):  
		Sets processing state on the server.  
	- [waitForCompletion.m](https://github.com/Femtonics/FemtoAPI/blob/Atlas/Matlab/+femtoAPI/src/FemtoAPIProcessing/@FemtoAPIProcessing/waitForCompletion.m):  
		Waits until the asynchronous operation is completed.  
	- [writeChannelData.m](https://github.com/Femtonics/FemtoAPI/blob/Atlas/Matlab/+femtoAPI/src/FemtoAPIProcessing/@FemtoAPIProcessing/writeChannelData.m):  
		Writes converted channel data.  
	- [writeRawChannelData.m](https://github.com/Femtonics/FemtoAPI/blob/Atlas/Matlab/+femtoAPI/src/FemtoAPIProcessing/@FemtoAPIProcessing/writeRawChannelData.m):  
		Writes raw channel data.  
