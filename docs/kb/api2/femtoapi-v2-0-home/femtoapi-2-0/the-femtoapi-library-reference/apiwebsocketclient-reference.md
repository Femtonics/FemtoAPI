# APIWebSocketClient reference
# bool APIWebSocketClient::connectToServer()

Opens a WebSocket connection to the FemtoAPI server. It returns true, if the connection is established successfully, otherwise, it returns false.

# void APIWebSocketClient::close()

Close the WebSocket connection.

# virtual ReplyMessageParser \* APIWebSocketClient::login(const QString &userName, const QString &password)

Login to the FemtoAPI server using password-based authentication. The password is always transferred in an encoded form over the FemtoAPI connection.

# virtual ReplyMessageParser::ReleasePtr APIWebSocketClient::sendJSCommand(const QString &message)

Send a JavaScript command sequence to the FemtoAPI server. It returns a ReplyMessageParser object.

# ReplyMessageParser \* APIWebSocketClient::binaryParser()

Get a pointer to the binary parser object.

# void APIWebSocketClient::uploadAttachment(QByteArray &attachment)

Upload a binary attachment for sending.
