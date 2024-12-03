% Copyright ©2021. Femtonics Ltd. (Femtonics). All Rights Reserved.
% Permission to use, copy, modify this software and its documentation for
% educational, research, and not-for-profit purposes, without fee and
% without a signed licensing agreement, is hereby granted, provided that
% the above copyright notice, this paragraph and the following two
% paragraphs appear in all copies, modifications, and distributions.
% Contact info@femtonics.eu for commercial licensing opportunities.
% 
% IN NO EVENT SHALL FEMTONICS BE LIABLE TO ANY PARTY FOR DIRECT, INDIRECT,
% SPECIAL, INCIDENTAL, OR CONSEQUENTIAL DAMAGES, INCLUDING LOST PROFITS,
% ARISING OUT OF THE USE OF THIS SOFTWARE AND ITS DOCUMENTATION, EVEN IF
% FEMTONICS HAS BEEN ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
% 
% FEMTONICS SPECIFICALLY DISCLAIMS ANY WARRANTIES, INCLUDING, BUT NOT
% LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A
% PARTICULAR PURPOSE. THE SOFTWARE AND ACCOMPANYING DOCUMENTATION, IF ANY,
% PROVIDED HEREUNDER IS PROVIDED "AS IS". FEMTONICS HAS NO OBLIGATION TO
% PROVIDE MAINTENANCE, SUPPORT, UPDATES, ENHANCEMENTS, OR MODIFICATIONS.

classdef FemtoAPIIF < handle
    %FEMTOAPIIF Common interface for processing and acquisition classes.
    % It manages connection to the server and provides function to get
    % connection status.
    % Only one connection can be created, and it must be disconnected before
    % a descendant object is destroyed, or another connection wanted to be set.
    % If multiple instances of a descendant classes are created, the first created
    % object will create the connection, and the subsequent will not, and use
    % the same connection.
    % So you can create multiple instances of FemtoAPIProcessing and
    % FemtoAPIAcquistion objects to the same server, they will use the same
    % connection, which will be created when the first object is created.
    %
    
    properties (Constant, Hidden)
        m_userName = 'user';
        m_password = 'sdDSF234$';
        m_usage    = [ ...
            'Connection address is invalid. Usage: ws://server_ip:port_number. ', ...
            'In case of no input parameter is given, the client tries to connect to localhost on port 8888', ...
            ' (default parameter: ws://localhost:8888).' 
            ];
        m_compatible_mex_version = '2.0.0';
        m_compatible_commandSet_version = '3.0.0';
    end
    
    properties (GetAccess = public)
        m_urlAddress = 'ws://localhost:8888';
        m_isOutOfProcessMode = false;
    end
    
    properties (Dependent = true, GetAccess = public)
        m_isConnected
    end
    
    properties(Access = private)
        m_mexHost matlab.mex.MexHost;
    end
    
    
    methods
        function obj = FemtoAPIIF(varargin)
            %FEMTOAPIIF Constructor for FemtoAPIIF class.
            % Accepts the connection address, validates it, then
            % connects to the server. If the address was invalid, or
            % the connection could not be opened, an error message is
            % displayed.
            %
            % If connected once, it will not create another connection.
            % Always disconnect from server before:
            %  - destroying descendant of this class, or
            %  - before making new connection (to a new server, for example)
            %
            % Note: after creating a femtoAPI object, the mex file will
            % be locked, so it cannot be cleared from memory.
            % It will be unlocked when the femtoAPI object is deleted.
            % You can call obj.femtoapiMexWrapper('mexUnlock') explicity
            % if you want to unlock the femtoAPI mex before destroying
            % the femtoAPI object.
            % After the femtoAPI object is destroyed, you have to
            % explicitly clear mex from memory.
            %
            %
            % INPUT [optional]:
            %  url             it must be a char array in
            %                  format ws:\\ip_address:port_number. If not given,
            %                  conection to localhost is performed.
            %                  Currently, port_number is 8888.
            %
            % outOfProcessMode runs femtoAPI mex function in separate
            %                  process. Default: false
            %
            
            narginchk(0,2);
            numOfInputs = length(varargin{:});
            
            
            if numOfInputs == 0
                
                urlAddress = 'ws://localhost:8888';
                
            else
                
                validateattributes(varargin{1},{'cell'},{'nonempty','vector'});
                args       = varargin{1};
                numVarargs = length(args);
                
                if numVarargs >= 1
                    
                    validateattributes(args{1},{'char'},{'nonempty','row'});
                    urlAddress = args{1};
                    
                end
                
                if numVarargs == 2
                    
                    validateattributes(args{2},{'logical'},{'nonempty','scalar'});
                    isOutOfProcessMode = args{2};
                    
                    if isOutOfProcessMode
                        obj.m_mexHost = obj.getCreateMexHost();
                    end
                    
                    obj.m_isOutOfProcessMode = isOutOfProcessMode;
                    
                end
                
            end
            
            obj.checkMexVersionCompatibility();
            
            if ~obj.isConnected
                obj.connect(urlAddress); % if not connected, connect
            end
            
            obj.login();
            obj.m_urlAddress = urlAddress;
            
        end
        
        
        function delete(obj)
            
            debug("FemtoAPIIF destructor");
            
            try
                obj.disconnect();
                obj.femtoAPIMexWrapper('unregisterMatlabObject');
                obj.femtoAPIMexWrapper('mexUnlock');
            catch ME
                debug(ME.message);
            end
            
        end
        
        
        function disconnect(obj)
            %DISCONNECT Disconnects from server.
            % Closes the actual connection. Run this before making new
            % connection, or destroying Femto API object.
            %
            % See also CONNECT ISCONNECTED
            %
            debug('Closing connection...');
            obj.femtoAPIMexWrapper('closeConnection');
            
        end
        
        
        function connect(obj,varargin)
            %CONNECT Connects to the server
            % Connects to the server specified by connection addres and port,
            % in format 'ws:\\server_ip:8888'.
            % Before making new connection, disconnect the actual connection.
            %
            % See also DISCONNECT ISCONNECTED
            %
            if nargin > 2
                error(obj.m_usage);
            end
            
            if nargin == 2
                validateattributes(varargin{1},{'char'},{'nonempty','row'});
                obj.validateConnectionAddress(varargin{1});
                obj.femtoAPIMexWrapper('connect',varargin{1});
                obj.m_urlAddress = varargin{1};
            else
                obj.femtoAPIMexWrapper('connect');
            end
            
            debug('Successfuly connected to server.');
            
        end
        
        
        function login(obj)
            
            %LOGIN Login to the server with default credentials
            % In case of failure, it throws an exception
            try
                obj.femtoAPIMexWrapper('login', obj.m_userName, obj.m_password);
                
                % get compatible qt version (compatibility is checked at this point)
                compatible_qt_version = obj.femtoAPIMexWrapper('getQtVersion');
                disp(['Used FemtoAPI mex Qt version: ',...
                    compatible_qt_version]);
                
                % check api commandset version compatibility
                commandSet_version = obj.femtoAPIMexWrapper('FemtoAPIFile.getCommandSetVersion');
                
                if(~strcmp(commandSet_version, obj.m_compatible_commandSet_version))
                    
                    error(['FemtoAPI commandset version check failed. ',...
                        'Current version is ', char(commandSet_version), ...
                        ', but compatible version is ',...
                        obj.m_compatible_commandSet_version,'.']);
                    
                else
                    
                    disp(['Used FemtoAPI commandset version: ',...
                        obj.m_compatible_commandSet_version]);
                    
                end
                
            catch ME
                obj.disconnect();
                rethrow(ME);
            end
            
        end
        
        
        
        function setEventSubscription(obj, eventName, subscribeOrUnsubscribe)
            % SETEVENTSUBSCRIPTION Subscribe/unsubscribe additional events
            % Event example: websocketStateChanged
            obj.femtoAPIMexWrapper('setEventSubscription', eventName, subscribeOrUnsubscribe);
        end
        
        
        function val = isConnected(obj)
            %ISCONNECTED Returns whether connected to the server or not.
            %
            val = obj.femtoAPIMexWrapper('isConnectedToWebSocket');
            
        end
        
        function val = sendCommand(obj, commandName, varargin)
            val = obj.femtoAPIMexWrapper( commandName, varargin{:} );
        end
        
        
        function varargout = femtoAPIMexWrapper(obj, commandName, varargin)
            %FEMTOAPI Wrapper for femtoAPI mex, to run in separate process
            
            if obj.m_isOutOfProcessMode
                
                [varargout{1:nargout}] = feval( obj.m_mexHost, 'femtoAPI', ...
                    commandName, varargin{:});
                
            else
                
                % run mex function in Matlab process
                [varargout{1:nargout}] = femtoAPI(commandName, varargin{:});
                
            end
            
        end
        
        
        function host = getMexHost(obj)
            host = obj.m_mexHost;
        end
        
        
        
        % Overload property names retrieval
        function names = properties(obj)
            names = fieldnames(obj);
        end
        
        
        % Overload field names retrieval
        function names = fieldNames(obj)
            names = properties(obj);
        end
        
        function ver = getCommandSetVersion(obj)
            %GETCOMMANDSETVERSION Returns the version of the Femto API commandset
            ver = obj.femtoAPIMexWrapper('FemtoAPIFile.getCommandSetVersion');
        end
        
        function ver = getWebSocketState(obj)
            %GETCOMMANDSETVERSION Returns the version of the Femto API commandset
            ver = obj.femtoAPIMexWrapper('getWebSocketState');
        end
        
    end
    
    
    methods(Static)
        
        
        function host = getCreateMexHost()
            
            persistent mh;
            if ~(isa(mh,'matlab.mex.MexHost') && isvalid(mh))
                mh = mexhost();
            end
            
            host = mh;
            
        end
        
    end
    
    
    methods (Access = private)
        
        function checkMexVersionCompatibility(obj)
            
            % check femtoapi mex version compatibility
            version = obj.femtoAPIMexWrapper('getAppVersion');
            if(~strcmp(version, obj.m_compatible_mex_version))
                error(['Mex file version check failed. Currently ', ...
                    'used mex file version is ',version,', but compatible ',...
                    'version is ',obj.m_compatible_mex_version]);
            else
                disp(['Used mex file version: ',...
                    obj.m_compatible_mex_version]);
            end
            
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






