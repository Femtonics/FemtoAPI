# Measurement control demo
This is a client program which connects to the MESc application (the server) and performs a measurement snap of the selected type. 

  


This demo program demonstrates a basic measurement control. It can do the following: 

* get some of the relevant measurement parameters for resonant/galvo measurements and for the selected sub type on the MESc GUI 
* start/stop a measurement of the selected measurement type
* set duration of the measurement 
* when the measurement ends, it updates the measurement parameters and shows a frame from the measurement
* image channel name can be selected from a drop-down list, and the image of the selected channel will be shown accordingly
* if the measurement start command failed for some reason (hardware is initializing, or in off state, of an error happened during measurement), it shows the reason of failure in a message box

  


***Prerequisites***

1. Start the MESc application
2. Set up and attach the hardware to be able to run measurements
3. Click the “Acquistion(F3)” button to the right half of the MESc title bar
4. Start MATLAB and run the demo program measurement_control_demo.mlapp

  


***How it works***  


1. After opening the measurement_control_demo program, you can see an empty table and axes. Click on the "Update measurement parameters" button to get the parameters that are currently set on the MESc GUI, for galvo/resonant tabs. 
2. If there are some .mesc files opened, the 1st frame of the last measurement unit of the current measurement session is shown in the demo UI.
3. You can select the image channel by from the dropdown list, and frame from that channel is shown accordingly.
4. You can switch between "Resonant" and "Galvo" tabs, you can see the measurement parameters of the selected type.
5. Set the duration of the selected measurement in the "duration" edit box, then click on the "Set measurement duration" button to make changes on the server. If you set it to 0, an infinite measurement will be started.
6. If you click on "Update measurement parameters", you can see the updated measurement duration that you previously set.
7.  Click on "Start" button. It will start the measurement of the selected type. In case of infinite measurement, you have to stop it manually by pressing the "Stop" button. Otherwise, the measurement will stop automatically when the measurement time has elapsed. Beside "Stop" button, the message changes to "Measurement is running". 
8. If the hardware layer is off, or an error happened, a message box appears with the last measurement error. 
9. After the measurement ends without an error, an image from the middle of the measurement is shown. The handle of the measurement unit and the index of the shown frame can be seen in the "measurement unit handle" and "frame index" fields. Beside "Stop" button, the message changes to "No measurement is running".

  


***Notes:***

<span style="color: rgb(9,30,66);">This demo example is supported only by Matlab R2019b or higher versions!</span>

The demo program writes some information to the MATLAB command prompt, e.g.:

* the connection to the server was successful or not,
* data was read from the running MESc application.

When you close and reopen MESc, the demo program needs to be restarted to connect to the new MESc instance.

  


  


  


  


  


  


  


  


  


  


  


  
