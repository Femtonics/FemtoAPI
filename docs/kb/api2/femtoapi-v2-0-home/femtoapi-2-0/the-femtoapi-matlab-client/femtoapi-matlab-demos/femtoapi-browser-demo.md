# FemtoAPI browser demo
This is a client program which connects to the MESc application (the server) and demonstrates some of the basic data access functionality of the FemtoAPI.

The FemtoAPI provides an easy-to-use interface to interact with MESc, e.g., to obtain information from opened measurement files, to read and write image data, and to start and stop measurements. With the help of the FemtoAPI, users can write programs to process measurement data and to create custom measurement protocols.

This demo demonstrates a basic file browser of .mesc files opened in the MESc application. It does the following:

* lists currently opened measurement files, measurement sessions, and measurement units,
* displays some of the measurement metadata in a way similar to the Processing tab of the MESc application,
* reads an image frame (selected with a slider) from the selected measurement unit,
* can get and save common input/output channel data of the selected measurement units
* can save measurement parameters to json file

  


 The MATLAB user interface of the FemtoAPI browser demo 

  


***Prerequisites***

1. Start the MESc application
2. Open one or more MESc files
3. Click the “Processing (F4)” button to the right half of the MESc title bar
4. Open a measurement unit in the measurement unit viewer by double clicking on it in the tree view to the left
5. Start MATLAB and run the demo program femtoapi_browser_App

***How it works***  


1. After opening the femtoapi_browser_App program, the list of measurement units open in the running MESc application is acquired. All measurement units from each opened MESc file will be listed in a tree structure, similar to the Processing tab of MESc.

2. When selecting a measurement unit in the list box, its first frame is read from the running MESc application and displayed in the image field. Some metadata of the selected measurement file/session/unit is also displayed in the table to the bottom left.

3. When you drag the slider, the image frames are read from the running MESc application and displayed in the image field.

4. Above the image field, a drop-down list contains the names of channels in the selected measurement unit. If the measurement unit contains more than one channels, by switching channel in the drop-down list, the image of the selected channel is displayed.

5. Open some new files in the running MESc application, then click the “Refresh data” button in the demo window to acquire the updated list of open measurement units.

6.   

   <details>
   <summary>Steps of batch exporting input/output curve data to file:</summary>

   * select one or more measurement units from the treeview and click the "Batch export input curves..." or "Batch export output curves..." button
   * then you can see the name of common input/output channels of the selected measurement units. You can select one or more channels and press "Ok". 
   * after that, a window appears, where you can specify the file name type you want to save to (.mat or .txt). Then press OK. 
   * the created file contains the curve data from the common input/output channels of the selected measurement units

   </details>


7.   

   <details>
   <summary>Steps of exporting measurement parameters</summary>

   * select one or more measurement units from the treeview and click the "Batch export measurement parameters..." button
   * after that, a window appears, where you can specify the file name. Then press OK. 
   * the saved file the content of "measurementInfo", "measurementParamsXML" and "measurementParams". See the  processing state json(DEV-A-1668703787) structure for details.

   </details>


  


***Notes:***

The demo program writes some information to the MATLAB command prompt, e.g.: 

* the connection to the server was successful or not,
* data was read from the running MESc application.

If a new file is opened in the MESc application, the "Refresh data" button needs to be clicked to update the file list in mescapi_browser.

When you close and reopen MESc, the demo program needs to be restarted to connect to the new MESc instance 
