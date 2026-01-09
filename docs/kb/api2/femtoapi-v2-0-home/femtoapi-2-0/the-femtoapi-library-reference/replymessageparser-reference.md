# ReplyMessageParser reference
# int ReplyMessageParser::getResultCode()

Get the error code of the last AbstractAPIClient command. The list of error codes:

* 0: No error
* 100: Server reply timed out (typical timeout value: 30 s).
* 101: Unknown message type. This is an irrecoverable low-level protocol error.
* 102: Bad request ID. This is an irrecoverable low-level protocol error.
* 103: Can't get request ID. This is an irrecoverable low-level protocol error.
* 104: Unhandled binary message. This is an irrecoverable low-level protocol error.
* 210: Login name format error. The login name should be at least 3 characters long.
* 211: Password format error. The password should be at least 5 characters long and must contain at least one capital letter, at least one number, and at least one symbol.
* 212: Can't set login flag in the model. This should never happen.
* 213: Server is busy. The binary data has not yet arrived in full.

# QString ReplyMessageParser::getErrorText()

Get a textual error description of the last AbstractAPIClient command. Useful for reporting errors to users.

# QVariant ReplyMessageParser::getJSEngineResult()

Get the return value of a JavaScript command. The return value is usually a QString holding a JSON object.

# bool ReplyMessageParser::hasBinaryParts()

Returns whether the latest function call returned binary data.

# bool ReplyMessageParser::isInWaitState()

Returns whether the binary parser is still waiting to receive all data.

# bool ReplyMessageParser::isCompleted()

Returns whether we have received all binary data parts.

# QByteArrayList &ReplyMessageParser::getPartList()

Get the returned binary data sliced into one or more portions.

# void ReplyMessageParser::clear()

Reset the message parser.
