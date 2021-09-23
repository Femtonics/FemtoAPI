# FemtoAPI - Analysis, programming tool, automation


## Programming Femtonics microscopes: Femto-API

The Femto-API (Application Programming Interface) enables you to remote-control your FEMTOSmart
microscope. It serves as a programmable client-server user interface to the FEMTOSmart software,
and allows you to integrate a set of clearly defined instructions from various software systems,
such as MATLAB or Python. 
Create your own custom measurement protocols, online and offline data visualization and analysis
tools, and connect your Femtonics scope to your existing lab software environment easily with the Femto-API!
On [FemtoAPI](https://kb.femtonics.eu/display/SUP/FemtoAPI+1.0) page you can find the detailed documentation of our tool.
[Ask our experts for more details.](mailto:info@femtonics.eu)


## The key features and benefits of the Femto-API and its open-source wrapper functions: 

<img src="https://github.com/Femtonics/FemtoAPI/blob/main/docs/img/Picture1.png" width="500" align="right">

- Create personalized measurement protocols supporting automated measurements with MATLAB and Python commands  
- Design complex protocols for measurements with the built-in control of all connected modules and devices, exploiting the full automation capacity of the microscope with custom scripting:
  - 3D time-lapse images, repeated measurements at multiple locations or depths 
  - tile imaging
  - measurements triggered by external devices, or measurements triggered by behavioral feedback

- Use self-developed or other software tools for data analysis pipelines and offline data visualization with provided open-source wrapper functions.
- Open source platform: write your own code, share analysis tools, develop existing codes further, adapt your code to data acquired with their Femtonics microscopes.
- Aanalyze data online with real-time data access while your measurement is running. You can perform:
  - online motion correction
  - online cell detection and Ca<sup>2+</sup> source extraction
  
  <img src="https://github.com/Femtonics/FemtoAPI/blob/main/docs/img/Picture2.png" width="500" align="right">
  
- Remote control the Femtonics software from the comfort of the MATLAB IDE or your favorite Python IDE: keep accessing all the power of MATLAB and the Python ecosystem.  

## Technical specifications of the Femto-API:

  <img src="https://github.com/Femtonics/FemtoAPI/blob/main/docs/img/Picture3.png" width="500" align="right">

  - socket/network-based connection: measurement control and data visualization or analysis can run on a different workstations than the measurement  
  - open communication protocol: create new bindings easily
  - easy script creation: API functions closely refer to GUI buttons, parameter boxes, etc.
  - MATLAB and Python bindings

## Prerequisites for using the Femto-API library:
The Femto-API library depends on Qt, so it needs to be installed and added to the Windows PATH. The minimum Qt version required is Qt 5.10. Other tools are not needed.
### OnAcid:
- Real time Ca source detection on AO and resonant data.
- Video: https://www.youtube.com/watch?v=IQOnXeu4G7w&ab_channel=Femtonics

## Femtonics supported by community analysis packages
For the annotation, downstream analysis and curation of calcium imaging data recorded by [Femtonics microscopes](https://femtonics.eu/products/), we highly recommend the [Mesmerize package](https://github.com/kushalkolar/MESmerize) written by Kushal Kolar from the [Chatzigeorgiou Lab](https://www.chatzigeorgioulab.com/)
  
## Purchase

To purchase FemtoAPI please contact sales@femtonics.eu

## Documentation
To see full documentation please visit the [FemtoAPI](https://kb.femtonics.eu/display/SUP/FemtoAPI+1.0) page.

## Disclaimer
IN NO EVENT SHALL FEMTONICS BE LIABLE TO ANY PARTY FOR DIRECT, INDIRECT, SPECIAL, 
INCIDENTAL, OR CONSEQUENTIAL DAMAGES, INCLUDING LOST PROFITS, ARISING OUT OF 
THE USE OF THIS SOFTWARE AND ITS DOCUMENTATION, EVEN IF FEMTONICS HAS BEEN 
ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.

FEMTONICS SPECIFICALLY DISCLAIMS ANY WARRANTIES, INCLUDING, BUT NOT LIMITED TO, 
THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR 
PURPOSE. THE SOFTWARE AND ACCOMPANYING DOCUMENTATION, IF ANY, PROVIDED 
HEREUNDER IS PROVIDED "AS IS". FEMTONICS HAS NO OBLIGATION TO PROVIDE 
MAINTENANCE, SUPPORT, UPDATES, ENHANCEMENTS, OR MODIFICATIONS.
