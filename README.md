# FemtoAPI - Analysis, programming tool, automation
<p align="center">  
<a href="https://pypi.org/project/femtoapi" target="_blank">
    <img src="https://badge.fury.io/py/femtoapi.svg" alt="Package version">
</a>
<a href="https://pepy.tech/project/femtoapi" target="_blank">
    <img src="https://pepy.tech/badge/femtoapi" alt="Downloads">
</a>
<a href="https://www.gnu.org/licenses/gpl-2.0" target="_blank">
    <img src="https://img.shields.io/badge/License-GPLv2-blue.svg" alt="License">
</a>
</p>

## Programming Femtonics microscopes: FemtoAPI

The FemtoAPI (Application Programming Interface) enables you to remote-control your FEMTOSmart
microscope. It serves as a programmable client-server user interface to the FEMTOSmart software
and allows you to integrate a set of clearly defined instructions from various software systems,
such as MATLAB or Python. 
Create your custom measurement protocols, online and offline data visualization and analysis
tools, and connect your Femtonics scope to your existing lab software environment easily with the FemtoAPI!
On the [FemtoAPI](https://femtonics.atlassian.net/wiki/spaces/API2/pages/1448161743/FemtoAPI+2.0) page, you can find the detailed documentation of our tool.
[Ask our experts for more details](mailto:info@femtonics.eu).

## The key features and benefits of the FemtoAPI and its open-source wrapper functions

<img src="https://github.com/Femtonics/FemtoAPI/blob/main/docs/img/Picture1.png" width="500" align="right">

- Create personalized measurement protocols supporting automated measurements with MATLAB and Python commands.
- Design complex protocols for measurements with the built-in control of all connected modules and devices, exploiting the full automation capabilities of the microscope with custom scripting:
  - 3D time-lapse images, repeated measurements at multiple locations or depths,
  - tile imaging,
  - measurements triggered by external devices, or measurements triggered by behavioral feedback.

- Use self-developed or other software tools for data analysis pipelines and offline data visualization with provided open-source wrapper functions.
- Open-source platform: write your code, share analysis tools, develop existing codes further, and adapt your code to data acquired with their Femtonics microscopes.
- Analyze data online with real-time data access while your measurement is running. You can perform:
  - online motion correction,
  - online cell detection, and Ca<sup>2+</sup> source extraction.
  
  <img src="https://github.com/Femtonics/FemtoAPI/blob/main/docs/img/Picture2.png" width="500" align="center">
  
- Remote control the Femtonics software from the comfort of the MATLAB IDE or your favorite Python IDE: keep accessing all the power of MATLAB and the Python ecosystem.  

## Technical specifications of the FemtoAPI

  <img src="https://github.com/Femtonics/FemtoAPI/blob/main/docs/img/Picture3.png" width="500" align="right">

  - Socket/network-based connection: measurement control and data visualization or analysis can run on different workstations than the measurement.
  - Open communication protocol: create new bindings easily.
  - Easy script creation: API functions closely refer to GUI buttons, parameter boxes, etc.
  - MATLAB and Python bindings.

## Installation

### Prerequisites for using the FemtoAPI library
The FemtoAPI library depends on Qt, so it needs to be installed and added to the Windows PATH. The minimum Qt version required is Qt 5.15. Other tools are not needed.

#### OnAcid:
- Real-time Ca source detection on AO and resonant data.
- Video: [Program your Femtonics microscope with the FemtoAPI](https://www.youtube.com/watch?v=IQOnXeu4G7w&ab_channel=Femtonics).

## FemtoAPI libraries
In the open-source libraries, you can find a collection of the FemtoAPI functions.
There are some example/demo applications in both Python and Matlab folders.

### Technology types
According to the different Femtonics microscope technology types, there are several collections of API functions and examples, which you can find in the corresponding FemtoAPI Github branches.
- [main](https://github.com/Femtonics/FemtoAPI/tree/main): Here you can find the full functionality of FemtoAPI. Contains both microscope control, and data processing related functions and examples.
- [Atlas](https://github.com/Femtonics/FemtoAPI/tree/Atlas): The ```Atlas``` branch contains all the functions, that you can use when having a Femtonics Atlas system. It contains the FemtoAPI commands to use during processing measurement data.

## Femtonics supported by community analysis packages
For the annotation, downstream analysis, and curation of calcium imaging data recorded by [Femtonics microscopes](https://femtonics.eu/products/), we highly recommend the [Mesmerize package](https://github.com/kushalkolar/MESmerize) written by Kushal Kolar from the [Chatzigeorgiou Lab](https://www.chatzigeorgioulab.com/).
  
## Purchase

To purchase FemtoAPI please contact sales@femtonics.eu.

## Documentation
To see full documentation please visit the [FemtoAPI](https://femtonics.atlassian.net/wiki/spaces/API2/pages/1448161743/FemtoAPI+2.0) page.

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
