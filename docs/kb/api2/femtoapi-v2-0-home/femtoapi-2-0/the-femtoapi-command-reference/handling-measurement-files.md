# Handling measurement files
In its current release, the FemtoAPI supports the following operations on measurement files:

* createNewFile: Open a new, unnamed measurement file and set it as the destination for subsequent measurements
* setCurrentSession: Change to which open file the subsequent measurements will be saved into
* saveFileAsync: Save an open measurement file under its current name (if it already has one)
* saveFileAsAsync: Save an open measurement file under a new name
* closeFileNoSaveAsync: Close an open measurement file without saving
* closeFileAndSaveAsync: Save an open measurement file under its current name (if it already has one), then close it
* closeFileAndSaveAsAsync: Save an open measurement file under a new name, then close it
* openFilesAsync: Opens one or more existing measurement files

  


These operations should suffice for saving your freshly acquired measurement data to measurement files. 

All these commands here (except setCurrentSession() ) return a json object, with the following fields in common: 

* **succeeded**: bool value, itrue means that the file operation was initiated successfully and started in the background 
* **id**: unique id of the command in string, or "0", if the background file operation hasn't started, because there was an error during the initiation of it (succeeded = false in this case), or because there is no need to start the background process (succeeded = true in this case). For example, saving a file which hasn't been modified since last save results in this case.

In later sections, these common fields in the returned json will not be described again, but referenced as 'succeeded' and 'id'. Only the additional fields will be described. 

  


It is important to note that most of these measurement file operations run asynchronously, which means the following:

* When you call any of these operations, the FemtoAPI server checks whether all conditions of successfully starting the operation are met. If not, the FemtoAPI server returns a descriptive error message and does not start the file operation. Otherwise, the FemtoAPI server reports success and starts the file operation in the background.

You can check the status of the started file operation the following way:

* in the returned json, the value of 'id' can be used as input parameter to FemtoAPIFile.getStatus(commandID) command, which returns whether the started background operation is still running or has ended, and if it has ended, whether there was an error or not. If you want to know if there is a pending operation on the currently opened files, you can run FemtoAPIFile.getStatus() without parameters. Details of these commands are described  here ([Tools](tools.md)). 

  


*Note on error messages*: if you run any of these commands, and it fails, the error message will not show up on the MESc GUI in message box that requires user interaction. Instead of it, a status message will appear on the MESc GUI with the error message that vanishes within few seconds.

  


### Differences in Matlab

* in Matlab client, the function syntaxes are almost the same, the only difference is, that the input parameter handle is a number (in case of file), or an array (in case of session) instead of a string, and the return value is the json got from server parsed as Matlab struct
* you have to instantiate FemtoAPIProcessing class (as described  here ([Tutorial: using the FemtoAPI Matlab client](../the-femtoapi-matlab-client/tutorial-using-the-femtoapi-matlab-client.md))) to call these functions. It will be denoted as 'femtoapiObj' in the following sections
* in case of any error, you instanty get it as Matlab error type exception.

  


## **var result= FemtoAPIFile.createNewFile()**

  


Creates a new, unnamed file, and sets it as the current file (i.e., the file where new measurements are placed). As this file has no name yet, you cannot permanently save it with saveFileAsync or closeFileAndSaveAsync. To do so, you need to give it a name and a destination folder with saveFileAsAsync or closeFileAndSaveAsAsync.

  


Return value: json object, with 'succeeded' = true and a valid 'id' if the new file was successfully created, otherwise 'succeeded' = false and id = 0.

The new file cannot be created if

* the Windows TEMP drive is full,
* the Windows TEMP folder is not writable, or
* the number of files opened in MESc has reached its upper limit (currently: 400).

  


### Usage in Matlab

result = mescapObj.createNewFile(); 

The returned value 'result' is the json get from server parsed in Matlab struct. 

  


### Examples

***C++ code example:***

```cpp
QString command = “var isCreated = FemtoAPIFile.createNewFile()”; 
auto cmdParser=client->sendJSCommand(command);
```

  


 ***Matlab client code example:*** 

```matlab
femtoapiObj = FemtoAPIProcessing(); % local connection
femtoapiObj.createNewFile(); 
```

  


***Python client code example:*** 

```py
command="FemtoAPIFile.createNewFile();"
simpleCmdParser=client.sendJSCommand(command)
resultCode=simpleCmdParser.getResultCode()

if resultCode > 0:
    print ("Return code: %d" % resultCode)
    print (simpleCmdParser.getErrorText())
else:	
    print ("createNewFile(): %s" % simpleCmdParser.getJSEngineResult())
```

*Note*: if the asynchronous portion of this call fails (e.g., the Windows TEMP drive is full or not writable), this call returns true and you can get error information by calling the getStatus(id) command with the appropriate command ID, and will not show up an error message in the MESc GUI. 

  


  


## **var setAsCurrent = FemtoAPIFile.setCurrentSession(handle)**

  


Sets the given file as the current file, which selects the last measurement session of the given file as the place to which subsequent measurements will be saved. You can also directly specify the last measurement session within an open file if you wish to do so.

Note that MESc guarantees that exactly one file is always selected as current. If, e.g., the last open file is closed, MESc creates a new measurement file and sets it as current. MESc also guarantees that all open measurement files contain at least one measurement session. Therefore, exactly one current measurement session is selected as current one during the whole runtime of MESc.

  


Input parameter:

**handle**: the unique descriptor string of an opened .mesc file or the last measurement session in an opened .mesc file. For example, '52,1' means the .mesc file with ID 52 and its last measurement session with ID 1, and it is valid if no session ID greater than 1 exists within this file . You can visually check these handles to the left of each item (file, measurement session, measurement) in the Processing mode of the MESc GUI.

  


Return value: true if the file has been successfully set as current, otherwise false. Possible reasons for failure:

* The input parameter is syntactically incorrect. It must represent a measurement file handle or a measurement session handle in the form 'fileIndex' or 'fileIndex,measurementSessionIndex'. Examples: '43', '65,0'.
* The given file or measurement session handle is syntactically adequate, but it does not represent an open file, or the last measurement session of an open file.
* The given file or the file of the given measurement session is being closed and, therefore, it is not accessible anymore.

  


### Usage in Matlab

succeeded = femtoapiObj.setCurrentSession(handle)

Input argument:

**handle:** the above described file or measurement session unique descriptor string as numeric value (file handle, e.g. 47) or Matlab array (session handle, e.g. \[45 0])

Return value: bool, the same as described above 

  


### Examples

***C++ code example:***

```cpp
// set the file with index 52 as current, provided its last measurement session
// index 0

QString command = “var setAsCurrent = FemtoAPIFile.setCurrentSession('52,0')”;
auto cmdParser=client->sendJSCommand(command);


// set the file with index 40 as current

QString command = “var setAsCurrent = FemtoAPIFile.setCurrentSession('40')”;
auto cmdParser=client->sendJSCommand(command);
```

  


***Matlab client code example:*** 

```matlab
femtoapiObj = FemtoAPIProcessing(); % local connection
femtoapiObj.setCurrentSession ([52,0]); 
```

  


***Python client code example:*** 

```py
command="FemtoAPIFile.setCurrentSession('52');"
simpleCmdParser=client.sendJSCommand(command)
resultCode=simpleCmdParser.getResultCode()

if resultCode > 0:
    print ("Return code: %d" % resultCode)
    print (simpleCmdParser.getErrorText())
else:	
    print ("setCurrentSession(): %s" % simpleCmdParser.getJSEngineResult())
```

  


## **var result= FemtoAPIFile.saveFileAsync( fileHandle = '')**

  


Saves the given measurement file, or the current measurement file if called without parameter or with an empty handle.

Input<span style="letter-spacing: 0.0px;"> parameter: </span>

<span style="letter-spacing: 0.0px;">**fileHandle**: the unique index of an open .mesc file converted to a string. For instance, handle '52' means the file with index 52. (File indices are displayed in the Processing mode of the MESc GUI, too.) If called with no file handle or an empty string, the current file will be saved.</span>

<span style="letter-spacing: 0.0px;">It returns the json object described . </span>

In the returned json: 

* 'succeeded' = true and valid 'id' : if the saving of the file was successfully initiated (in this case, the asynchronous portion of the call has been started successfully)
* 'succeeded' = true and 'id' = 0 : if the file hasn't been modified since last save, so saving the file hasn't started
* 'succeeded' = false and 'id' = 0 : failed to save file 

Possible reasons for failure:

* The given handle is syntactically incorrect, or there is no opened file in MESc with the given handle.
* The given file is being closed and, therefore, it is not accessible for saving anymore.
* The given file is new and does not yet have a name or it is open as read-only. Please use saveFileAsAsync in these cases instead.
* A previous save operation is in progress in the given file.

If the operation has been initiated successfully, then you can use the returned 'id' to obtain whether this operation is in progress or not, and if it has ended then get an error information. See  getStatus ([Tools](tools.md)) command for details.

  


*Note*: if the asynchronous portion of this call fails (e.g., the target drive gets full), you get error information in the MESc GUI too, as status message which vanishes within few seconds. 

  


### Usage in Matlab

In Matlab, if the current file wanted to be saved, then no parameter is given:

result = femtoapiObj.saveFileAsync(); 

Otherwise, give the handle of the file, as a number (positive integer) :

result = femtoapiObj.saveFileAsync(fileHandle) 

The returned value 'result' is the json described above parsed into a Matlab struct.

  


### Examples

***C++ code examples:***

```cpp
// save the current file if no input parameter is given, or an empty string
QString command = “var success = FemtoAPIFile.saveFileAsync()”; // or FemtoAPIFile.saveFileAsync('');
auto cmdParser=client->sendJSCommand(command);


// save the file with index 43:
QString command = “var success = FemtoAPIFile.saveFileAsync('43')”;
auto cmdParser=client→sendJSCommand(command);
```

  


***Matlab client code example:*** 

```matlab
femtoapiObj = FemtoAPIProcessing();

// save the current file if no input parameter is given, or an empty string
femtoapiObj.saveFileAsync();

// save the file with index 43:
femtoapiObj.saveFileAsync ([43])”;

```

  


***Python client code example:*** 

```py
command="FemtoAPIFile.saveFileAsync();"
simpleCmdParser=client.sendJSCommand(command)
resultCode=simpleCmdParser.getResultCode()

if resultCode > 0:
    print ("Return code: %d" % resultCode)
    print (simpleCmdParser.getErrorText())
else:	
    print ("saveFileAsync(): %s" % simpleCmdParser.getJSEngineResult())

```

  


## **var result= FemtoAPIFile.saveFileAsAsync(newAbsoluteUnicodePath, fileHandle = '', overWriteExistingFile = false)**

  


Saves the given measurement file, or the current measurement file, if called with an empty handle, to the given absolute path. You can also specify whether an existing file may be overwritten.

If the given absolute path equals the current path of the given file, the command works exactly as saveFileAsync and the overwrite flag argument is ignored.

Input parameters:

* newAbsoluteUnicodePath: The new absolute path as a Unicode string.
* fileHandle: The unique index of an open .mesc file converted to a string, e.g., '55'. If no file handle is given, MESc takes the current file.
* overWriteExistingFile: A Boolean flag denoting whether a preexisting file on newAbsoluteUnicodePath may be overwritten. If newAbsoluteFilePath equals the current path of the given file, this parameter is ignored.

  


It returns the json object described . 

In the returned json: 

* 'succeeded' = true and valid 'id' : if the saving of the file was successfully initiated (in this case, the asynchronous portion of the call has been started successfully)
* 'succeeded' = true and 'id' = 0 : newAbsoluteUnicodePath is the same as the path of the file given with its handle, and it hasn't been modified since last save, so saving the file hasn't started
* 'succeeded' = false and 'id' = 0 : failed to save file 

Possible reasons for failure:

* The given handle is syntactically incorrect, or there is no open file in MESc with the given handle.
* The given file is being closed and, therefore, not accessible for saving.
* A previous save operation is in progress in the given file.
* The given path equals to the current path of the file, and the file is open as read-only, or it is new without a valid path. In this case, you should save the file under a different path.
* The given path differs from the current path of the file, but there is already a file there, and the overwrite flag was set to false.
* The given path differs from the current path of the file, there is a file on the given path, and the overwrite flag was set to true, but MESc could not delete the preexisting file.
* Could not create a read-write accessible file on the given path (the folder component of the given path does not exist, or it is not writable).

  


If the operation has been initiated successfully, then you can use the returned 'id' to obtain whether this operation is in progress or not, and if it has ended then get an error information. See  getStatus ([Tools](tools.md)) command for details.

*Note*: if the asynchronous portion of this call fails (e.g., the target drive gets full), you get error information in the MESc GUI too, as status message which vanishes within few seconds. 

  


### Usage in Matlab

In Matlab, the usage is the same, there are only some minor differences regarding types of input parameters and returned value:

result = femtoapiObj.saveFileAsAsync(newAbsoluteUnicodePath, fileHandle, overWriteExistingFile)

Input parameter (required): 

* newAbsoluteUnicodePath: character array

Input parameters (optional):

* fileHandle: (positive integer) number 
* overWriteExistingFile: bool

Returns the json described above parsed into a Matlab struct. 

### Examples

***C++ code usage and examples:***

```cpp
// save the current file on the given absolute path, do not overwrite existing file

QString command = “var result= FemtoAPIFile.saveFileAsAsync('C:/Users/user/Documents/Measurements/example.mesc')”;
auto cmdParser=client->sendJSCommand(command)



// save the file with index 53 on the given absolute path, do not overwrite an existing file

QString command = “var result= FemtoAPIFile.saveFileAsAsync('C:/Users/user/Documents/Measurements/example.mesc','53')”;
auto cmdParser=client->sendJSCommand(command)


// save the file with index 53 on the given absolute path, overwrite existing file

QString command = “var result= FemtoAPIFile.saveFileAsAsync('C:/Users/user/Documents/Measurements/example.mesc','52', true)”;
auto cmdParser=client->sendJSCommand(command)



// save the current file on the given absolute path, overwrite existing file

QString command = “var result= FemtoAPIFile.saveFileAsAsync('C:/Users/user/Documents/Measurements/example.mesc','', true)”;
auto cmdParser=client->sendJSCommand(command)



// save the current file on the given absolute path, do not overwrite existing file

QString command = “var result= FemtoAPIFile.saveFileAsAsync('C:/Users/user/Documents/Measurements/example.mesc','', false)”;
auto cmdParser=client->sendJSCommand(command)



// or, equivalently, you can simply write this as

QString command = “var result= FemtoAPIFile.saveFileAsAsync('C:/Users/user/Documents/Measurements/example.mesc')”;
auto cmdParser=client->sendJSCommand(command)
```

  


***Matlab client code example:*** 

```matlab
femtoapiObj = FemtoAPIProcessing();

% save current file to the specified absolute path. If file exists there, then it will not be overwritten, no save occurs and an error is returned
femtoapiObj.saveFileAsAsync('C:/Users/user/Documents/Measurements/example.mesc');

% Save file with handle 52 to the specified path. If file exists there, then it will not be overwritten, no save occurs and an error is returned. 
femtoapiObj.saveFileAsAsync('C:/Users/user/Documents/Measurements/example.mesc',52, true);

% save file with handle 52 to the specified path, if file exists, then overwrites it
femtoapiObj.saveFileAsAsync('C:/Users/user/Documents/Measurements/example.mesc',52, true);
```

  


***Python client code example:*** 

```py
command="FemtoAPIFile.saveFileAsAsync('C:/Users/user/Documents/Measurements/example.mesc','52', true);"
simpleCmdParser=client.sendJSCommand(command)
resultCode=simpleCmdParser.getResultCode()
if resultCode > 0:
    print ("Return code: %d" % resultCode)
    print (simpleCmdParser.getErrorText())
else:	
    print ("saveFileAsAsync(): %s" % simpleCmdParser.getJSEngineResult())
```

  


  


## **var result = FemtoAPIFile.closeFileNoSaveAsync(fileHandle = '')**

  


Closes the given file without saving. With no or an empty input parameter, the current file is closed.

  


Input parameter:

* fileHandle: The unique index of an open .mesc file converted to a string. For instance, handle '52' means the file with index 52. (File indices are displayed in the Processing mode of the MESc GUI, too.) If called with no file handle or an empty string, the current file will be closed.

It returns the json object described . 

In the returned json: 

* 'succeeded' = true and valid 'id' : if the closing of the file was successfully initiated (in this case, the asynchronous portion of the call has been started successfully)
* 'succeeded' = false and 'id' = 0 : otherwise

  


Possible reasons for failure:

* The given handle is syntactically incorrect, or there is no open file in MESc with the given handle.
* A file operation is pending in the file: it is being closed or saved asynchronously.

  


If the operation has been initiated successfully, then you can use the returned 'id' to obtain whether this operation is in progress or not, and if it has ended then get an error information. See  getStatus ([Tools](tools.md)) command for details.

  


*Note1*: if the asynchronous portion of this call fails, you get error information in the MESc GUI too, as status message which vanishes within few seconds. 

  


*Note2:* MESc guarantees that exactly one file and its last measurement session is always selected as current. This means that if the current file is closed, MESc automatically selects another open file as current. If the last open file is closed, MESc creates a new measurement file and sets it as current.

### Usage in Matlab

In Matlab, if the current file wanted to be closed without save, then no parameter is given:

result = femtoapiObj.closeFileNoSaveAsync(); 

Otherwise, give the handle of the file as input, as a number (positive integer) :

result = femtoapiObj.closeFileNoSaveAsync(fileHandle) 

The returned value 'result' is the json described above parsed into a Matlab struct.

  


### Examples

***C++ code usage and examples:***

```cpp
// close the current file without saving

QString command = “var result= FemtoAPIFile.closeFileNoSaveAsync()”;
auto cmdParser=client->sendJSCommand(command);


// close the file with index 65 without saving it

QString command = “var result= FemtoAPIFile.closeFileNoSaveAsync('65')”;
auto cmdParser=client->sendJSCommand(command);
```

  


***Matlab client code example:*** 

```matlab
femtoapiObj = FemtoAPIProcessing();
femtoapiObj.closeFileNoSaveAsync ([65]);
```

  


***Python client code example:*** 

```py
command="FemtoAPIFile.closeFileNoSaveAsync('65');"
simpleCmdParser=client.sendJSCommand(command)
resultCode=simpleCmdParser.getResultCode()

if resultCode > 0:
    print ("Return code: %d" % resultCode)
    print (simpleCmdParser.getErrorText())
else:	
    print ("closeFileNoSaveAsync(): %s" % simpleCmdParser.getJSEngineResult())
```

  


  


  


## **var result= FemtoAPIFile.closeFileAndSaveAsync(fileHandle = '', compressFileIfPossible = false)**

  


Saves the given file, then closes it. Optionally, compresses the file during saving.

Input parameters:

* fileHandle: The unique index of an open .mesc file converted to a string, e.g., '55'. If no file handle or empty string is given, MESc takes the current file.
* compressFileIfPossible: A Boolean flag denoting whether the file should be compressed if possible.

  


It returns the json object described . 

In the returned json: 

* 'succeeded' = true and valid 'id' : if the combined operation of saving and closing the file was successfully initiated (in this case, the asynchronous portion of the call has been started successfully)
* 'succeeded' = false and 'id' = 0 : otherwise

Possible reasons for failure:

* The given handle is syntactically incorrect, or there is no opened file in MESc with the given handle.
* A file operation is pending in the file: it is being closed or saved asynchronously.
* The given file is new and does not yet have a name or it is open as read-only. Please use closeFileAndSaveAsAsync in these cases instead.

  


If the operation has been initiated successfully, then you can use the returned 'id' to obtain whether this operation is in progress or not, and if it has ended then get an error information. See  getStatus ([Tools](tools.md)) command for details.

  


*Note1*: if the asynchronous portion of this call fails, you get error information in the MESc GUI too, as status message which vanishes within few seconds. 

  


*Note2*: file compression means that the contents of the temporary file are copied to the given path, and the empty holes left behind by deleted objects are not. Since saving with compression is often slower than saving without compression (the latter being simple file copying), compression is never performed if nothing has been deleted from the measurement file, even if you set the compressFileIfPossible flag to true.

  


*Note3:* MESc guarantees that exactly one file and its last measurement session is always selected as current. This means that if the current file is closed, MESc automatically selects another open file as current. If the last open file is closed, MESc creates a new measurement file and sets it as current.

### Usage in Matlab

The usage in Matlab is the same as described above, except the types of input parameters and returned value are a bit different: 

result = femtoapiObj.closeFileAndSaveAsync(fileHandle, compressFileIfPossible);

Input parameters (optional): 

* fileHandle must be a (positive integer) number 
* compressFileIfPossible is boolean value 

The returned value 'result' is the json described above parsed into a Matlab struct.

  


### Examples

***C++ code usage and examples:***

```cpp
// close the current file and save it without trying to compress it
QString command = “var result= FemtoAPIFile.closeFileAndSaveAsync()”;
auto cmdParser=client->sendJSCommand(command);


// close the file with index 65 and save it without trying to compress it
QString command = “var result= FemtoAPIFile.closeFileAndSaveAsync('65')”;
auto cmdParser=client->sendJSCommand(command);


// or, equivalently
QString command = “var result= FemtoAPIFile.closeFileAndSaveAsync('65',false)”;
auto cmdParser=client->sendJSCommand(command);


// close the file with index 65 and save it, possibly with compression
QString command = “var result= FemtoAPIFile.closeFileAndSaveAsync('65', true)”;
auto cmdParser=client->sendJSCommand(command);
```

  


***Matlab client code example:*** 

```matlab
femtoapiObj = FemtoAPIProcessing();
femtoapiObj.closeFileAndSaveAsync ([65], true); % close the file with index 65 and save it, possibly with compression
```

  


***Python client code example:*** 

```py
command="FemtoAPIFile.closeFileAndSaveAsync('65', true);"
simpleCmdParser=client.sendJSCommand(command)
resultCode=simpleCmdParser.getResultCode()

if resultCode > 0:
    print ("Return code: %d" % resultCode)
    print (simpleCmdParser.getErrorText())
else:	
    print ("closeFileAndSaveAsync(): %s" % simpleCmdParser.getJSEngineResult())
```

  


## **var result = FemtoAPIFile.closeFileAndSaveAsAsync(newAbsoluteFilePath, fileHandle = '', overWriteExistingFile = false, compressFileIfPossible = false)**

  


Saves the given file under a new name, then closes it. Optionally, compresses the file during saving. You can also specify whether an existing file may be overwritten.

If the given absolute path equals the current path of the given file, the command works exactly as closeFileAndSaveAsync and the given overwrite flag is ignored.

  


Input parameters:

* newAbsoluteUnicodePath: The new absolute path as a Unicode string.
* fileHandle: The unique index of an open .mesc file converted to a string, e.g., '55'. If no file handle is given, MESc takes the current file.
* overWriteExistingFile: A Boolean flag denoting whether a preexisting file on newAbsoluteUnicodePath may be overwritten. If newAbsoluteFilePath equals the current path of the given file, this parameter is ignored.
* compressFileIfPossible: A Boolean flag denoting whether the file should be compressed if possible.

  


It returns the json object described . 

In the returned json: 

* 'succeeded' = true and valid 'id' : if the combined operation of saving and closing the file was successfully initiated (in this case, the asynchronous portion of the call has been started successfully)
* 'succeeded' = false and 'id' = 0 : otherwise

  


Possible reasons for failure:

* The given handle is syntactically incorrect, or there is no open file in MESc with the given handle.
* A file operation is pending in the file: it is being closed or saved asynchronously.
* The given path equals to the current path of the file, and the file is open as read-only, or it is new without a valid path. In this case, you should save the file under a different path.
* The given path differs from the current path of the file, but there is a file there already, and the overwrite flag was set to false.
* The given path differs from the current path of the file, there is a file on the given path, and the overwrite flag was set to true, but MESc could not delete the preexisting file.
* Could not create a read-write accessible file on the given path (the folder does not exist, or it is not writable).

If the operation has been initiated successfully, then you can use the returned 'id' to obtain whether this operation is in progress or not, and if it has ended then get an error information. See  getStatus ([Tools](tools.md)) command for details.

  


*Note1:* if the asynchronous portion of this call fails(e.g., the target drive gets full), you get error information in the MESc GUI too, as status message which vanishes within few seconds. 

  


*Note2*: file compression means that the contents of the temporary file are copied to the given path, and the empty holes left behind by deleted objects are not. Since saving with compression is often slower than saving without compression (the latter being simple file copying), compression is never performed if nothing has been deleted from the measurement file, even if you set the compressFileIfPossible flag to true.

  


*Note3:* MESc guarantees that exactly one file and its last measurement session is always selected as current. This means that if the current file is closed, MESc automatically selects another open file as current. If the last open file is closed, MESc creates a new measurement file and sets it as current.

  


### Usage in Matlab

The usage in Matlab is the same as described above, except the types of input parameters and returned value are a bit different: 

result = femtoapiObj.closeFileAndSaveAsAsync(newAbsoluteFilePath, fileHandle, overWriteExistingFiles, compressFileIfPossible);

Input parameters (required):

* newAbsoluteFilePath: char array

Input parameters (optional): 

* fileHandle must be a (positive integer) number 
* overWriteExistingFiles is a boolen value 
* compressFileIfPossible is a boolean value 

The returned value 'result' is the json described above parsed into a Matlab struct.

  


### Examples

***C++ code usage and examples:***

```cpp
// close the current file and save it under a new name without compression
QString command = “var success = FemtoAPIFile.closeFileAndSaveAsAsync('C:/Users/user/Documents/Measurements/example.mesc')”;
auto cmdParser=client->sendJSCommand(command);


// close the file with index 65 and save it to the given path without compression, and fail if there is already a file on the given path
QString command = “var success = FemtoAPIFile.closeFileAndSaveAsAsync('C:/Users/user/Documents/Measurements/example.mesc','65', false)”;
auto cmdParser=client->sendJSCommand(command);


// the above can also be written without specifying the third parameter as
QString command = “var success = FemtoAPIFile.closeFileAndSaveAsAsync('C:/Users/user/Documents/Measurements/example.mesc','65')”;
auto cmdParser=client->sendJSCommand(command);


// close the current file and save it to the given path with compression, and overwrite the file on the given path if it exists
QString command = “var success = FemtoAPIFile.closeFileAndSaveAsAsync('C:/Users/user/Documents/Measurements/example.mesc','', true, true)”;
auto cmdParser=client->sendJSCommand(command);


// close the file with index 65 and save it with compression, and overwrite the file on the given path if it exists
QString command = “var success = FemtoAPIFile.closeFileAndSaveAsAsync('C:/Users/user/Documents/Measurements/example.mesc','65', true, true)”;
auto cmdParser=client->sendJSCommand(command);
```

  


***Matlab client code example:*** 

```matlab
femtoapiObj = FemtoAPIProcessing();

% close the file with index 65 and save it with compression, and overwrite the file on the given path if it exists
femtoapiObj.closeFileAndSaveAsAsync('C:/Users/user/Documents/Measurements/example.mesc',[65], true, true); 
```

  


***Python client code example:*** 

```py
command="FemtoAPIFile.closeFileAndSaveAsAsync('C:/Users/user/Documents/Measurements/example.mesc','65', true, true);"
simpleCmdParser=client.sendJSCommand(command)
resultCode=simpleCmdParser.getResultCode()

if resultCode > 0:
    print ("Return code: %d" % resultCode)
    print (simpleCmdParser.getErrorText())
else:	
    print ("closeFileAndSaveAsync(): %s" % simpleCmdParser.getJSEngineResult())
```

  


  


## 

## **var result = FemtoAPIFile.openFilesAsync(filePaths)**

Opens one or more file(s) asynchronously. 

Input parameter: 

* **filePaths**: one or more full file path(s) in one unicode string(s), separated with semicolon within the string

It returns the json object described . 

In the returned json: 

* 'succeeded' = true and valid 'id' : if opening the file(s) was successfully initiated (in this case, the asynchronous portion of the call has been started successfully)
* 'succeeded' = false and 'id' = 0 : otherwise

Possible reasons for failure: 

* at least one given file path is invalid: it does not exists or is a dangling symbolic link/shourtcut
* the number of files opened in MESc has reached its upper limit (currently: 400)

  


If the operation has been initiated successfully, then you can use the returned 'id' to obtain whether this operation is in progress or not, and if it has ended then get an error information. See  getStatus ([Tools](tools.md)) command for details.

  


*Note1:* If file opening is initiated from the MESc GUI and from the FemtoAPI at the same time, it does not generates an error, even if there are common files to open. The union of the two file list will be opened. 

  


### Usage in Matlab

Usage is the same, but 'filePaths' is a character array

result = femtoapiObj.openFilesAsync(filePaths)

Input parameter (required): 

filePaths: character array, file paths are separated with semicolon

The returned value 'result' is the json described above parsed into a Matlab struct.

  


### Examples

***C++ code usage and examples:***

```cpp
// open one file
QString command = “var result= FemtoAPIFile.openFilesAsync('C:/Users/user/Documents/Measurements/example.mesc')”;
auto cmdParser=client->sendJSCommand(command);

// open two files
QString command = “var result= FemtoAPIFile.openFilesAsync('C:/Users/user/Documents/Measurements/example.mesc;C:/Users/user/Documents/Measurements/example.mesc')”;
auto cmdParser=client->sendJSCommand(command);
```

  


***Matlab client code example:*** 

```matlab
femtoapiObj = FemtoAPIProcessing();

% open one file 
femtoapiObj.openFilesAsync('C:/Users/user/Documents/Measurements/example.mesc'); 

% open two files
femtoapiObj.openFilesAsync('C:/Users/user/Documents/Measurements/example.mesc;C:/Users/user/Documents/Measurements/example2.mesc');
```

  


***Python client code example:*** 

```py
command="FemtoAPIFile.closeFileAndSaveAsAsync('C:/Users/user/Documents/Measurements/example.mesc');"
simpleCmdParser=client.sendJSCommand(command)
resultCode=simpleCmdParser.getResultCode()

if resultCode > 0:
    print ("Return code: %d" % resultCode)
    print (simpleCmdParser.getErrorText())
else:	
    print ("closeFileAndSaveAsync(): %s" % simpleCmdParser.getJSEngineResult())
```

  


  
