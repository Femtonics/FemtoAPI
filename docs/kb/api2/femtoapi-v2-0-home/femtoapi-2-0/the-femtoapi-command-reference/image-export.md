# Image Export
###  **var result= FemtoAPIFile.createTmpTiff('identifier', nodeDescriptor, applyLUT\[, channels, compress, breakView, exportRawData, startTimeSlice, endTimeSlice]);**

Creates an [.ome.tiff](https://docs.openmicroscopy.org/ome-model/5.6.3/ome-tiff/) file synchonized way, with the following options:

* **identifier** is the unique identifier for the tiff creation in MESc. It can be any string.

* **nodeDescriptor**: unique index of a measurement unit, converted to a string, e.g. '43,0,0' 

* **applyLUT**: boolean, 

* **channels**: optional list of channel indices, separated by space converted to a string, eg '0,1'

* **compress**: optional boolean, loslessy compression

* **breakView**: optional boolean, rearrange image to the *break view* view

* **exportRawData**: optional boolean, export only raw data. This can be only true if applyLUT is false.

* **startTimeSlice** - **endTimeSlice**: the exportable frames interval.   
  It has different meaning depends on the method.

  * It means volume at:

    * multiROIMultiCube
    * muliROISnake
    * volumeScan

  * It means frame at:

    * multiROIChessBoard
    * multiROILongitudinalRibbonScan
    * multiROITransverseRibbonScan
    * zStack

  * It means line at:

    * multiROIPointScan
    * multiROILineScan
    * multiROIMultiLine

The command sends the exported file metadata as a binary file.

Returns a Json formatted string, which contains an object with the following keys:

* `succeeded` : boolean, the export succeeded, the file stored in a temporary directory on the MESc machine
* `id`: the input identifier
* `tmp`: if succeeded was true, this key exists. This is the full path of the saved file.
* `failExc`: exception message, which is same as send through `setLastCommandError` too

This call must followed by a getTmpTiff call with the same identifier argument if `succeeded` == true 

###  **var result = getTmpTiff('identifier')**

This call must preceeded by a createTmpTiff call with the same identifier argument.

* The **identifier** arg must be the same as the preceeded createTmpTiff call argument.

The command sends the exported file metadata as a binary file, if exists.  
  
Returns a number:

* the file size which send through in websocket
* 0 if the file is not exists
* int64_max on error



###  **var result = cancelTiff('identifier')**

* The **identifier** arg must be the same as the preceeded createTmpTiff call argument.

Returns true if this tiff export existed and succesfully notified to stop.

Returns false otherwise.

**Note: Currently this function is disabled**





