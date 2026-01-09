# Image processing demo
  


<span style="letter-spacing: 0.0px;">This is a client program which connects to the MESc application (the server) and performs a basic</span>

image processing step with the use of the FemtoAPI.

  
FemtoAPI provides an easy-to-use interface to interact with MESc, e.g., to obtain information from  
opened measurement files, to read and write image data, and to start and stop measurements. With  
the help of the FemtoAPI, users can write programs to process measurement data and to create  
custom measurement protocols.

  
This demo demonstrates a basic FemtoAPI image processing program which does the following:  
• lists measurement units opened in the MESc software,  
• reads an image frame (selected with a slider) from the selected measurement unit,  
• performs Gaussian filtering on the selected image frame, and  
• writes the filtered image frame through the FemtoAPI into the MESc file which can be seen  
simultaneously in the MESc application.

  


  


The MATLAB user interface of the image processing demo

  


***Prerequisites***

1\. Start the MESc application  
2. Open one or more MESc files  
3. Click the “Processing (F4)” button to the right half of the MESc title bar  
4. Open a measurement unit in the measurement unit viewer by double clicking on it in the  
tree view to the left  
5. Start MATLAB and run the demo program processing_image_data_demo.m

  
***How it works***  
1. Click the “Update Unit List” button in the demo window to acquire the list of open  
measurement units in the running MESc application. All measurement units from each  
opened MESc file will be listed  
2. When selecting a measurement unit in the list box, the first image will be read from the  
running MESc application and displayed in the image field  
3. When you drag the slider, the image frames will be read from the running MESc application  
and displayed in the image field  
4. When you click the “Smooth” button, the smoothed image frame data will be displayed and  
sent back to the running MESc application which will immediately display this change  
<span style="color: rgb(51,51,51);">5. In the LUT options area set the desired LUT value to enhance the visibility of the important  
features of your </span><span style="color: rgb(51,51,51);">measurement data. You can drag the slider, or type the required value in the  
field below</span>

  
***Notes***  
The demo program writes some information to the MATLAB command prompt, e.g.:  
• the connection to the server was successful,  
• data was read/sent from/to the running MESc application,  
• when the demo starts up and the user clicks into the GUI, a message gives the advice to click  
the “Update Unit List” button first.

  
When you close and reopen MESc, the demo program needs to be re-run to connect to the new  
MESc instance.
