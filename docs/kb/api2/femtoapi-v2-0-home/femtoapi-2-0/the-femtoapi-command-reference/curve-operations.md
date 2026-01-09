# Curve operations
## 

## **var result=FemtoAPIFile.deleteCurve(nodeDescriptor, idxCurve)**

Deletes a curve

### Arguments

* nodeDescriptor: string containing the node descriptor in which the curve is located
* idxCurve: integer containing the curve index to delete

### Return

Returns bool value. True on success, false otherwise. If false returned, an error message is also set

# 

## **var json=FemtoAPIFile.addCurve(nodeDescriptor, name, xType, xDataType, yType, yDataType)**

Adds a new curve without curve data. Curve data has to be written by one of the appendToCurveRaw and appendToCurve commands.

### Arguments

* nodeDescriptor: string containing the node descriptor in which the curve is located

* xType: string, value can be one of the followings:

  * equidistant: input data is represented as equidistant values, i.e the first value and the step are provided
  * vector: input data is a vector of x values

* xDataType: string, value can be one of the followings:

  * double: input data is represented in IEEE 754 64-bit floating point type

* yType: string, value can be one of the followings:

  * rle: input data is run-length encoded, i.e pairs of repetition count and value are provided
  * vector: input data is a vector of y values

* yDataType: string, value can be one of the followings:

  * double: input data is represented in IEEE 754 64-bit floating point type
  * uint16: input data is represented in 16-bit unsigned integers

### Attachment

Some curve parameters are provided via attachment:

* if xType == equidistant: it contains two values of xDataType: x0 and xstep. xstep must be greater than zero.

### Return

Returns a JSON string. On success:

```
{
	"success": true,
	"size": integer meaning the count of samples,
	"curveIdx": integer containing the index of the inserted curve,
	"xType": storage type of x in string, can be "equidistant" or "vector",
	"xDataType": storage data type of x in string, can be "uint16" or "double",
	"yType": storage type of y in string, can be "rle" or "vector",
	"yDataType": storage data type of y in string, can be "uint16" or "double"
}
```

On fail:

```
{
	"success": false
}
```

# 

## **var success =FemtoAPIFile.setCurveEquidistants(nodeDescriptor, idxCurve, x0Raw, deltaRaw)**

Sets the equidistant parameters of a curve.

### Arguments

* nodeDescriptor: string containing the node descriptor in which the curve is located
* idxCurve: index of the curve
* x0Raw: first equidistant double parameter
* deltaRaw: second equidistant double parameter

### Return

Returns whether the operation was successfull.

# 

## **var json=FemtoAPIFile.curveInfo(nodeDescriptor, idxCurve)**

Returns information about the selected curve

### Arguments

* nodeDescriptor: string containing the node descriptor in which the curve is located
* idxCurve: integer containing the curve index

### Return

The function returns the same JSON as the addCurve function

# 

## **var result=FemtoAPIFile.appendToCurveRaw(nodeDescriptor, idxCurve, size, xType, xDataType, yType, yDataType)**

Appends raw data to a curve.

See appendToCurve function for details.

### 

## **var result=FemtoAPIFile.appendToCurve(nodeDescriptor, idxCurve, size, xType, xDataType, yType, yDataType)**

Appends converted data to a curve.

### Arguments

* nodeDescriptor: string containing the node descriptor in which the curve is located

* idxCurve: integer containing the curve index

* size: count of the samples (x=y) to append to the curve

* xType: string, value can be one of the followings:

  * equidistant: input data is represented as equidistant values, i.e the first value and the step are provided. Only possible if the curve x axis is already equidistant
  * vector: input data is a vector of x values. Only possible if the curve x axis is already vector (**TODO** this could be changed)

* xDataType: string, value can be one of the followings:

  * double: input data is represented in IEEE 754 64-bit floating point type

* yType: string, value can be one of the followings:

  * rle: input data is run-length encoded, i.e pairs of repetition count and value are provided
  * vector: input data is a vector of y values

* yDataType: string, value can be one of the followings:

  * double: input data is represented in IEEE 754 64-bit floating point type
  * uint16: input data is represented in 16-bit unsigned integers

### Attachment

The actual data is provided as an attachment of the following format:

* &lt;x data> &lt;y data>

  * x data:

    * if xType == equidistant, it is empty, the new values for the x axis are determined by the equidistant axis properties (x0, xstep)
    * if xType == vector, it contains *size* values of xDataType. Values must be monothonic inreasing.

  * y data:

    * if yType == rle, it contains pairs of repetition count and value. Repetition count is always in uint32 format. Value is of yDataType. The sum of repetition counts must be equal to to *size*
    * if yType == vector, it contains *size* values of yDataType representing each sample

### Return

Returns bool value. True on success, false otherwise. If false returned, an error message is also set.

# 

## **var json=FemtoAPIFile.readCurveRaw(nodeDescriptor, idxCurve, vectorFormat, forceDouble)**

Reads a curve and returns raw curve data as attachment.  
Y data type will be the same as it is stored on disk (uint16 or double).

See readCurve function for details.

# 

## **var json=FemtoAPIFile.readCurve(nodeDescriptor, idxCurve, vectorFormat, forceDouble)**

Reads a curve and returns converted curve data as attachment.  
Y data type will always double.

### Arguments

* nodeDescriptor: string containing the node descriptor in which the curve is located
* idxCurve: integer containing the curve index
* vectorFormat: bool, if true, the RLE and equidistant curve data is extracted to vectors

### Return

The function returns the same JSON as the addCurve function.
