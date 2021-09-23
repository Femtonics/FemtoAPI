% Copyright ©2021. Femtonics Kft. (Femtonics). All Rights Reserved. 
% Permission to use, copy, modify this software and its documentation for educational,
% research, and not-for-profit purposes, without fee and without a signed licensing agreement, is 
% hereby granted, provided that the above copyright notice, this paragraph and the following two 
% paragraphs appear in all copies, modifications, and distributions. Contact info@femtonics.eu
% for commercial licensing opportunities.
% 
% IN NO EVENT SHALL FEMTONICS BE LIABLE TO ANY PARTY FOR DIRECT, INDIRECT, SPECIAL, 
% INCIDENTAL, OR CONSEQUENTIAL DAMAGES, INCLUDING LOST PROFITS, ARISING OUT OF 
% THE USE OF THIS SOFTWARE AND ITS DOCUMENTATION, EVEN IF FEMTONICS HAS BEEN 
% ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
% 
% FEMTONICS SPECIFICALLY DISCLAIMS ANY WARRANTIES, INCLUDING, BUT NOT LIMITED TO, 
% THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR 
% PURPOSE. THE SOFTWARE AND ACCOMPANYING DOCUMENTATION, IF ANY, PROVIDED 
% HEREUNDER IS PROVIDED "AS IS". FEMTONICS HAS NO OBLIGATION TO PROVIDE 
% MAINTENANCE, SUPPORT, UPDATES, ENHANCEMENTS, OR MODIFICATIONS.

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
        m_compatible_mex_version = '1.0.0';
        m_compatible_commandSet_version = '1.0.0';
        m_waitForDisconnectTime = 0.01;
    end
    
    properties (Dependent = true, GetAccess = public)
        m_isConnected logical
    end
    
    %% Public properties
    properties
        m_urlAddress = 'ws://localhost:8888';
    end
    
    
    methods
        
        function obj = ConnectionManager(~)
            % check femtoapi mex version compatibility
            version = femtoAPI('getAppVersion');
            version = version.version;
            if(~strcmp(version, obj.m_compatible_mex_version))
                error(['Mex file version check failed. Currently ', ...
                    'used mex file version is ',version,', but compatible ',...
                    'version is ',obj.m_compatible_mex_version]);
            else
                disp(['Used mex file version: ',...
                    obj.m_compatible_mex_version]);
            end
        end
        
        function connect(obj,varargin)
            % CONNECT Connects to server with specified ip and port
            if length(varargin) > 1
                error(obj.m_usage);
            end
            
            if length(varargin) == 1
                validateattributes(varargin{1},{'char'},{'nonempty','row'});
                obj.validateConnectionAddress(varargin{1});
                if obj.m_isConnected && ~strcmp(obj.m_urlAddress, varargin{1})
                    error(["There is already an open websocket ", ...
                        "connection with url '%s', which will be used ", ...
                        "by now. If you want to open a new connection, ", ...
                        "please close the current connection first ", ...
                        "and then reconnect."],obj.m_urlAddress);
                end
                femtoAPI('connect',varargin{1});
                obj.m_urlAddress = varargin{1};
            else
                femtoAPI('connect');
            end
            
            try
                femtoAPI('login', obj.m_userName, obj.m_password);
                
                % get compatible FemtoAPI.dll version (compatibility is
                % checket at this point)
                dllVersion = femtoAPI('getDllVersion');
                dllVersion = dllVersion.version;
                disp(['Used FemtoAPI dll version: ',...
                    dllVersion]);
                
                % get compatible qt version (compatibility is checked at this point)
                compatible_qt_version = femtoAPI('getQtVersion');
                compatible_qt_version = compatible_qt_version.version;
                disp(['Used FemtoAPI mex and dll Qt version: ',...
                    compatible_qt_version]);
                
                % check api commandset version compatibility
                commandSet_version = femtoAPI('command','FemtoAPIFile.getCommandSetVersion()');
                commandSet_version = commandSet_version{1};
                if(~strcmp(commandSet_version, obj.m_compatible_commandSet_version))
                    error(['FemtoAPI commandset version check failed. ',...
                        'Current version is ',commandSet_version, ', but compatible version is ',...
                        obj.m_compatible_commandSet_version,'.']);
                else
                    disp(['Used FemtoAPI commandset version: ',...
                        obj.m_compatible_commandSet_version]);
                end
                
            catch ME
                obj.closeConnection();
                rethrow(ME);
            end
            
            
            
            disp('Successfuly connected to server.');
        end
        
        
        function closeConnection(obj)
            % CLOSECONNECTION Disconnects from server
            try
                disp('Closing connection...');
                femtoAPI('closeConnection');
                pause(obj.m_waitForDisconnectTime);
                disp('Connection closed.');
            catch ME
                %disp('Web socket is closed. Connect first.');
                error(ME.message);
            end
        end
        
        %% setter/getter methods
        function val = get.m_isConnected(obj)
            val = logical(femtoAPI('isConnectedToWebSocket'));
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

