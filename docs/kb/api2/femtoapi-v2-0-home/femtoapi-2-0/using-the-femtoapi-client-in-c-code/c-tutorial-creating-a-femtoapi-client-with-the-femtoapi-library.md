# C++ tutorial: creating a FemtoAPI client with the FemtoAPI library
Femtonics recommends that all FemtoAPI clients are built on the official FemtoAPI library provided by Femtonics Ltd. This library is developed in tandem with the server side of FemtoAPI and offers full compatibility and good performance upon all future MESc releases.

This section is aimed at FemtoAPI client implementors and describes the structure and use of the official FemtoAPI library.

The public interface of the FemtoAPI library is described by three C++ header file: ReplyMessageParser.h

Below, we describe in detail the sequence of steps needed to use the FemtoAPI library.

# Create an API WebSocketClient

The first step of initializing the client side of a FemtoAPI connection is instantiating an APIWebSocketClient object. The FemtoAPI client can run on the same computer as MESc or on any other computer that can access the port the FemtoAPI server is listening on (default: 8888). 

FemtoAPI is connecting with a WebSocket connection to the running MESc instance of your choice. To maximize the versatility of FemtoAPI,

* any number of FemtoAPI clients can connect to the same FemtoAPI server, from the same computer or from different ones, and
* a FemtoAPI client can make any number of connections to any number of FemtoAPI servers, running on the same computer or on different computers.

  


C++ code example for connecting to the FemtoAPI server running on the same computer as the FemtoAPI client and listening on the default port:

  


***C++ code example:***

```cpp
APIWebSocketClient *wsClient=new APIWebSocketClient(QUrl("ws://localhost:8888"));
bool isOk = wsClient->connectToServer(); 
```

<span style="letter-spacing: 0.0px;">If the connection is successfully created, true is returned. Otherwise, false is returned and the state of the FemtoAPI client is not changed in any way.</span>

# Log in to the FemtoAPI server

The last step of initializing the client side of a FemtoAPI connection is authenticating to the FemtoAPI server.

The FemtoAPI server implements password-based authentication. Any login names with at least three characters and any passwords of at least five characters, containing at least one capital letter, one numeral, and one symbol are accepted. This arrangement may change in the future.

C++ code example for logging in to the FemtoAPI server:

```cpp
auto loginParser = wsclient->login("userName","Passwd123%");

if(loginParser->getResultCode() != 0) { 
	qDebug() << loginParser->getErrorText();
} 
```

  
The ReplyMessageParser object returned by the login() method above

* is managed by the AbstractAPIClient object, i.e., you do not need to delete it, and
* is guaranteed to hold its contents until the next method call of the AbstractAPIClient object.

# Run a JavaScript command in the FemtoAPI server

The main utility of a FemtoAPI connection is in remotely running JavaScript commands on the FemtoAPI server. The FemtoAPI server usually answers by returning a JSON object encoded in UTF-8.

C++ code example for running a JavaScript command sequence in the FemtoAPI server and receiving its reply:

```cpp
auto simpleCmdParser = wsclient->sendJSCommand("a=100; b=200; c=a+b;"); 
QString result = simpleCmdParser->getJSEngineResult().toString();
```

  


# Send binary data as an argument of a JavaScript command

Some of the JavaScript commands interpreted by the FemtoAPI server need binary data as one of their arguments. These binary data should be uploaded as an attachment to the FemtoAPI server before running the respective JavaScript command.

C++ code example for attaching data from file to a subsequent JavaScript command:

```cpp
QFile file("fileNameToAttach"); 
if(file.open(QIODevice::ReadOnly)) {
	QByteArray buffer;
	buffer = file.readAll();
	wsclient->uploadAttachment(buffer);
	file.close(); 
}

QString command = QString("...");
auto cmdReplyParser = wsclient->sendJSCommand(command);
```

C++ code example for attaching raw data to a subsequent JavaScript command:

```cpp
QByteArray buffer;
std::vector<double> vecData = {0, 10};

buffer.append(QByteArray::fromRawData (reinterpret_cast<char *>(vecData.data()), vecData.size() * sizeof (double)));

wsclient->uploadAttachment(buffer);

QString command = QString("...");
auto cmdReplyParser = wsclient->sendJSCommand(command);
```

  


# Read binary data from FemtoAPI

WARNING: The methods in this section are subject to minor changes.

You can read binary data from MESc with FemtoAPI in several ways.

* *Transfer binary data to the FemtoAPI client as a binary blob.* This method is useful for quickly transferring large amounts of binary data from the server to the client.

  
C++ code example:

```cpp
QString command = "FemtoAPIFile.readRawChannelDataToClientsBlob('47,0,0,0','0,0,0', '512,512,1')";
auto binaryParser = wsclient->sendJSCommand(command);
while(!binaryParser->isCompleted()) {
	QThread::msleep(100);
}

QFile binFile("fileOut.bin");
binFile.open(QIODevice::WriteOnly); 

if(binaryParser->hasBinaryParts()) {
	QDataStream out(&binFile);
	for(auto parts: binaryParser->getPartList()) {
		out.writeRawData(parts.data(),parts.size()); 
	} 
}
binFile.close();
```

  


* *Transfer binary data to the FemtoAPI client as textual data in JSON format.* This method is too slow for production code, but it is a useful debugging tool.

  
C++ code example:

```cpp
QString command = “FemtoAPIFile.readRawChannelDataJSON('47,0,0,0', '0,0,1', '512,512,1');"; 
auto cmdParser = wsclient->sendJSCommand(command);
```

  


* *Transfer binary data to a server-side JavaScript variable.* Usage example: server-side image processing.

  
C++ code example:

```cpp
QString command = "var binaryvar = FemtoAPIFile.readRawChannelData('47,0,0,0','0,0,0','512,512,1');";
auto cmdParser=wsclient->sendJSCommand(command);
```

  
  


# Close the FemtoAPI connection and clean up

C++ code example for properly terminating a single FemtoAPI connection and cleaning up:

```cpp
wsclient->close();
delete clientManager;
```

  
