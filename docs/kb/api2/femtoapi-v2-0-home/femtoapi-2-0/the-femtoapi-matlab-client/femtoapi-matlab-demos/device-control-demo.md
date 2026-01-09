# Device control demo 
This is a client program which connects to the MESc application (the server) and does some basic  
measurement control with the use of the FemtoAPI.

FemtoAPI provides an easy-to-use interface to interact with MESc, e.g., to obtain information from  
opened measurement files, to read and write image data, and to start and stop measurements. With  
the help of the FemtoAPI, users can write programs to process measurement data and to create  
custom measurement protocols.

  
This demo demonstrates a basic FemtoAPI measurement control program which does the following:  
• reads some specific device parameters (PMT and Pockels cell names, values) from MESc,  
• lets you modify these values and sends them back to the running MESc application which can  
be seen simultaneously in the MESc application.

  


  


The MATLAB user interface of the device control demo

  


  


***Prerequisites***  
1. Start the MESc application  
2. Click the “Acquisition (F3)” button to the right half of the MESc title bar  
3. Click the “Resonant” tab to the left  
4. Open “Device Parameters”  
5. Select “space1”  
6. Start MATLAB and run the demo program measurement_control_demo.m

  


***How it works***  
1. Click on the update button first to acquire data from the server: PMT Pockels cell names will  
appear in the list box, with the first one selected, and its value will be seen in % format in the  
edit box (the slider moves as well to the relative position of the selected value)  
2. Data is read once from the server, when you click the update button  
3. When selecting other PMTs or Pockels cells in the list box, the slider and the edit box will  
represent the value of the newly selected PMT or Pockels cell  
4. When the user drags the slider, the value in the edit box changes accordingly, but no data is  
sent back to the server. When the user releases the slider, the actual data in the edit box will  
be sent to MESc where it will be displayed  
5. When user edits the value in the edit box, and then click somewhere else on the GUI, slider  
changes it position accordingly, and the modified data is sent back to MESc where it will be  
displayed

  


***Notes***  
The demo program writes some information to the MATLAB command prompt, for example:  
• the connection to the server was successful,  
• data was read/sent from/to the running MESc application,  
• or when it starts and no data is read from MESc yet, and user clicks into the GUI, a message  
can be seen in the MATLAB command propmt to indicate clicking the update button,  
• or when user clicks on update, and no data can be seen, then it can be seen in the command  
prompt to change the MESc configuration (usually when space1 is selected in Device  
parameters, and there is no data).

  
When you close and reopen MESc, the demo program needs to be re-run to connect to the new  
MESc instance.
