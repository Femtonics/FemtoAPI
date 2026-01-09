# Tutorial: using FemtoAPI with a simple WebSocket in Python
Firstly, install the Python [websocket-client](https://pypi.org/project/websocket_client/):

```py
pip install websocket-client
```

  


Connect to the local MESc server through WebSocket, and issue a command: 

```py
from websocket import create_connection
ws = create_connection("ws://localhost:8888/websocket")
ws.send("FemtoAPIFile.getProcessingState()")
result = ws.recv()
print ("Received '%s'" % result)
ws.close()
```

  


  


**Note:** The commands that would transfer binary data between client and server cannot be used with simple WebSocket API. Currently, the following commands are concerned:

* Write(Raw)ChannelDataFromAttachment 
* <span style="color: rgb(23,43,77);">read(Raw)ChannelDataToClientsBlob </span>
