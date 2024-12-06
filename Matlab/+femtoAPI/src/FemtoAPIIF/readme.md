# FemtoAPI Matlab Wrapper — FemtoAPIIF

[ConnectionManager.m](https://github.com/Femtonics/FemtoAPI/blob/main/Matlab/+femtoAPI/src/FemtoAPIIF/ConnectionManager.m):  
Handles connect/disconnect to/from the server. Always call close current connection before opening a new connection.

[FemtoAPIIF.m](https://github.com/Femtonics/FemtoAPI/blob/main/Matlab/+femtoAPI/src/FemtoAPIIF/FemtoAPIIF.m):  
Common interface for processing and acquisition classes. It manages the connection to the server and provides a function to get the connection status.
