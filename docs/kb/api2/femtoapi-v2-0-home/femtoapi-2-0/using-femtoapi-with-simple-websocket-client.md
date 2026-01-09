# Using FemtoAPI with Simple WebSocket Client
FemtoAPI can be used in any environment that supports WebSocket. It only needs to connect, no login is required, and there is no handshake mechanism.

With Simple WebSocket Client, only textual data are sent/received on the communication line, so the FemtoAPI commands that send/receive binary data to/from the server cannot be used here. Currently, this concerns the following commands:

* *FemtoAPIFile.read(Raw)ChannelDataToClientsBlob*  
    
* *FemtoAPIFile.write(Raw)ChannelDataFromAttachment*

  


## Example: 

For the Chrome browser, install the Simple WebSocket Client <span style="text-decoration: none;">extension</span>, open MESc on the same machine, type ws://localhost:8888 in<span style="text-decoration: none;"> the URL field</span>, then click connect. After connecting to the server, you can type FemtoAPI commands, described later in this manual, in the Request field. You can write your own script in javascript and issue it in one command.

  


  


  


An example of the Python websocket client code can be found in the following chapter:  API2-A-1448161780 

  


  
