# Tutorial: creating a FemtoAPI Python client with the FemtoAPI library
  


  


Install FemtoAPI Python client

```py
pip install femtoapi
```

  


Connect to the API server

```py
from PySide2.QtCore import *
from PySide2.QtWebSockets import *
from femtoapi import PyFemtoAPI

app = QCoreApplication(sys.argv)
ws=PyFemtoAPI.APIWebSocketClient('ws://localhost:8888')
ws.login("name", "pass")
```

  


Example command use

```py
command='FemtoAPIFile.getProcessingState()'
simpleCmdParser=ws.sendJSCommand(command)
resultCode=simpleCmdParser.getResultCode()
	if resultCode > 0:
	print ("Return code: " + str(resultCode))
	print (simpleCmdParser.getErrorText())
else:
	print(json.loads(simpleCmdParser.getJSEngineResult())) #import json

```

  


Close connection

```py
ws.close()
```

  
