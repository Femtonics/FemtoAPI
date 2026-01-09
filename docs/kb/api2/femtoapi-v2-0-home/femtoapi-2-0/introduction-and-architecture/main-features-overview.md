# Main features overview
#### Common

* Connect to running MESc instance from local or remote PC
* API actions logged, most important commands displayed in MESc
* only safe operations allowed (but you can cause damage with your script)

#### Measurement control (*FemtoAPIMicroscope namespace*)

* Get current status of the microscope
* Start and stop image acquisition
* Set measurement duration
* Select a scanner type for measurement: Galvo-galvo or Resonant-Galvo 
* Select acquisition mode: Time series, Z-Stack or Volume Scan
* Set measurement parameters for Z-Stack acquisition such as PMT reference voltages or Laser intensity
* Set depth correction parameters for Z-Stack acquisition
* Control the objective Arm or motorized stage
* Save the last acquired frame to a measurement unit
* Set text description for measurement units

**Note:** Please test your measurement control script first in safe conditions (without objective and tissue, etc)

#### **Data processing** (*FemtoAPIFile namespace*)

* create measurement file, unit, channel and curve
* open, modify and close measurement files
* copy, modify and delete measurement units
