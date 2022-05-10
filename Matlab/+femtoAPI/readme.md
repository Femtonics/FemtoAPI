# FemtoAPI Matlab Wrapper

Here you can find some examples of the use of the FemtoAPI Matlab client.
 - ```src``` contains the collection of the implemented FemtoAPI functions in Matlab.
 - You can find the external dependencies in ```libs```.
 - ```utils``` contains some common functions.
 - In ```uitools/@TreeViewCreator``` there are user-interface related functions.
 - ```examples/demos``` contains the published demo and example scripts.
 
The Matlab client wraps the FemtoAPI library's functionality and makes it easy to use from Matlab.  
In Atlas technology we use a main class: FemtoAPIProcessing.  

[FemtoAPIProcessing](https://github.com/Femtonics/FemtoAPI/blob/Atlas/Matlab/+femtoAPI/src/FemtoAPIProcessing) class: used for measurement processing purposes, such as file operations (read, write, create a new file, or measurement unit, set current file, etc.), getting the processing state (metadata found on the processing panel of the MESc GUI) or the setting part of the processing state (e.g. comment of measurement session/group/unit, channel conversion and LUT), etc.  

For a detailed description, please visit the [FemtoAPI Matlab client](https://kb.femtonics.eu/display/SUP/The+FemtoAPI+Matlab+client) page.

Under the [FemtoAPI Matlab demos](https://kb.femtonics.eu/display/SUP/FemtoAPI+Matlab+demos) section, you can find the details on how to use these example programs.

## Notes

- Recommended Matlab version: R2019b or later.
