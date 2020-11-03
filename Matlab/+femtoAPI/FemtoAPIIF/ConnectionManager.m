classdef ConnectionManager < handle
    %CONNECTIONMANAGER Handles connect/disconnect to/from server
    % Always call close current connection before opening a new connection.
    % 
    properties (Constant,Hidden)
        m_userName = 'user';
        m_password = 'sdDSF234$';
        m_usage = ['Connection address is invalid. Usage: ws://server_ip:port_number .',...
            'In case of no input parameter is given, the client tries to connect to localhost on port 8888',...
            '(default parameter: ws://localhost:8888).'];              
    end
    
    properties (Dependent = true, GetAccess = public)
        m_isConnected
    end
    
    %% Public properties
    properties
        m_urlAddress = 'ws://localhost:8888';
    end
    
    
    methods 
        function connect(obj,varargin)
            % CONNECT Connects to server with specified ip and port
            if length(varargin) > 1
                error(obj.m_usage);
            end
            
            if length(varargin) == 1
                validateattributes(varargin{1},{'char'},{'nonempty','row'});
                obj.validateConnectionAddress(varargin{1});
                femtoMEScAPI('connect',varargin{1});
                obj.m_urlAddress = varargin{1};
            else
                femtoMEScAPI('connect');
            end
            
            femtoMEScAPI('login', obj.m_userName, obj.m_password);
            disp('Successfuly connected to server.');
        end
        
        
        function closeConnection(obj)
            % CLOSECONNECTION Disconnects from server
            try
                disp('Closing connection...');
                femtoMEScAPI('closeConnection');
                disp('Connection closed.');
            catch ME
               %disp('Web socket is closed. Connect first.'); 
               error(ME.message);
            end
        end
        
        %% setter/getter methods     
        function val = get.m_isConnected(obj)
            val = femtoMEScAPI('isConnectedToWebSocket');
        end
        
        function validateConnectionAddress(obj,connectionAddress)
            expression = '^(ws://){1}(localhost|((([0-9]|[1-9][0-9]|1[0-9]{2}|2[0-4][0-9]|25[0-5])\.){3}([0-9]|[1-9][0-9]|1[0-9]{2}|2[0-4][0-9]|25[0-5]))):[0-9]+$';
            address = regexp(connectionAddress,expression,'match');
            if(isempty(address) || ~strcmp(address{1},connectionAddress))
                error(obj.m_usage);
            end
        end
        
    end
    
end

