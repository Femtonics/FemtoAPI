# Summary

Femtonics Real-time Analysis Package enables you online analyze your data measured with Femtonics AO microscope
via [FemtoAPI](https://kb.femtonics.eu/display/SUP/FemtoAPI+1.0) while your measurement is still running. You can exploit the benefits of this great advantage
when online information from network dynamic is essential (i.e.: when performing photoStimulation)

Fast and scalable algorithms are implemented for
- online motion correction
- automatic source extraction, cell detection 
- calculationg and stroring cell centroids in a txt file and on the clipboard
- providing and visualizing Ca traces real-time

With the package the following measurements can be processed:
- 2D High Speed Arbitrary Frames Scans (Raster Scans)
- 3D VolumeScan and 
- 3D Multilayer 

The package is based on the popular [CaImAn](https://github.com/flatironinstitute/CaImAn) package of [Flatiron Institute](https://www.simonsfoundation.org/flatiron/), a paper explaining most of the 
implementation details and benchmarking can be found [here](https://elifesciences.org/articles/38173). The code can be updated with algorithm from GitHub
any time while codes for accessing data measured with Femtonics microscopes will not be changed.

The algorithm can be either finetuned with a GUI containing parameters for the data, for algorithm, etc or without GUI with default parameters.
<img src="https://github.com/Femtonics/FemtoAPI/blob/OnAcid/doc/img/Picture1.png" width="500" align="left">

Ca traces are visualized real time and using the check boxes next to the cells a subpopulation of cells can be selected so as to forward them to further measurements (i.e. chessboard scanning)
<img src="https://github.com/Femtonics/FemtoAPI/blob/OnAcid/doc/img/Picture2.png" width="500" align="left">

## Requirements

Femtonics Real-time Analysis Package is supported
- on Windows on Intel CPUs,
- CaImAn presently targets Python 3.7, parts of CaImAn are written in C++, but apart possibly during install, this is not visible to the user
- Conda
- [FemtoAPI](https://kb.femtonics.eu/display/SUP/FemtoAPI+1.0) from Femtonics Ltd is required for online analysis. At least 16G RAM is strongly recommended, and depending on datasets, 32G or more may be helpful
- For the source code of the required script files please visit [here](LINK-TO-FEMTOCAIMAN-PAGE).

## Download

To download corresponding package and data, please visit [OnAcid download]https://github.com/Kata5/FemtoOnAcid.

## Installation

[CaImAn/RTMC installation and setup](https://kb.femtonics.eu/pages/viewpage.action?pageId=51914704)