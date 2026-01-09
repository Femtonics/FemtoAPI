# Introduction and architecture
Femto API (Application Programming Interface) is an optional module of the MESc measurement control and analysis application by Femtonics Ltd. It serves as a programmable client-server user interface to MESc, complementing its graphical user interface, the MESc GUI. 

  


  


The figure above depicts the main components of FemtoAPI.

* The black box represents a running instance of the MESc application, which serves as the FemtoAPI server. You can run only one MESc instance per computer.
* The blue boxes represent the core data handled by the MESc application: the .mesc files currently open in MESc, the microscope control interface, etc. These data are shared with the MESc GUI and all FemtoAPI connections, which means that each change in the open files or the microscope state is immediately and consistently reflected on the MESc GUI and in all FemtoAPI clients.
* The "Javascript-MESc function interface" represents a transcription layer making MESc core data accessible through a JavaScript code.
* The yellow boxes represent single-threaded JavaScript interpreters, one for each active FemtoAPI connection. These interpreters implement the Qt Script dialect of JavaScript described at the following link: <https://doc.qt.io/qt-5/ecmascript.html>.
* The green box represents the outermost server-side component of the FemtoAPI, a WebSocket server listening on TCP/IP port 8888 by default. Each FemtoAPI client communicates through a separate WebSocket connection of this service. The number of pending connections is limited to a preset value. Currently, the server accepts no more than 30 pending client connections.
* The top black boxes represent FemtoAPI clients running on different technologies. Currently, a MATLAB, C++ and a Python client is implemented.
* The black lines connecting the WebSocket server and the FemtoAPI clients represent FemtoAPI WebSocket connections. Since the WebSocket communication protocol is based on TCP/IP, FemtoAPI clients and servers can be run on the same computer or on different computers with a working TCP/IP network connection.

## FemtoAPI conventions

* All textual information is encoded in UTF-8.
* All binary information is sent and received in little-endian byte ordering.

## Simple WebSocket and extended binary WebSocket connection methods

Each FemtoAPI client can choose between two connection methods: *simple WebSocket* and *extended binary WebSocket*.

* *Extended binary WebSocket* connections utilize a 64-bit Windows DLL provided by Femtonics Ltd. to connect, log in, and issue commands to the running MESc application. This connection type uses an efficient, proprietary binary communication protocol and supports the complete FemtoAPI command set described in this manual.
* *Simple FemtoAPI WebSocket* connections can be created by any computer system implementing the WebSocket protocol. You can issue all FemtoAPI commands through simple WebSocket connections that do not send binary data through the communication line; i.e., all of the text-only FemtoAPI commands. A login mechanism is not implemented.
