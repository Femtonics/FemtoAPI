classdef WebSocketState
    %WebSocketState Enumeration representing FemtoAPI websocket states 
    % Detailed explanation aboout websocket states can be found here: 
    % https://doc.qt.io/qt-5/qabstractsocket.html#SocketState-enum
    
    enumeration
        UnconnectedState
        HostLookupState
        ConnectingState
        ConnectedState
        BoundState
        ClosingState
        ListeningState
    end

end

