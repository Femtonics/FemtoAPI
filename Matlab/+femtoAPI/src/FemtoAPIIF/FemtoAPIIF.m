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
    
    properties (Constant, Hidden, Access = protected)
        m_usage = ['One optional parameter can be given: connection web address and port in format ws://server_ip:port_num .',...
            'In case of no input parameter, the client tries to connect to localhost on port 8888. (Default parameter is ws://localhost:8888)'];
    end
    
    properties(GetAccess = protected)
        m_connectionObj % ConnectionManager instance
    end
    
    
    methods
        function obj = FemtoAPIIF(varargin)
            %FEMTOAPIIF Constructor for FemtoAPIIF class.
            % Accepts the connection address, validates it, then
            % connects to the server. If the address was invalid, or
            % the connection could not be opened, an error message is
            % displayed.
            % If connected once, it will not create another connection.
            % Always disconnect from server before:
            %  - destroying descendant of this class, or
            %  - before making new connection (to a new server, for example)
            %
            % INPUT [optional]:
            %  varargin      connection address, it must be a char array in
            %                format ws:\\ip_address:port_number. If not given,
            %                conection to localhost is performed.
            %                Currently, port_number is 8888.
            %
            obj.m_connectionObj = ConnectionManager();
            
            if ~isempty(varargin) && ~isempty(varargin{1})
                validateattributes(varargin,{'cell'},{'nonempty','scalar'});
                validateattributes(varargin{1},{'cell'},{'nonempty','scalar'});
                
                if(~obj.isConnected)
                    obj.connect(varargin{1}{1}); % if not connected, connect
                end
            else
                if(~obj.isConnected)
                    obj.connect(); % if not connected, connect
                end
            end
        end
        
        
        function disconnect(obj)
            %DISCONNECT Disconnects from server.
            % Closes the actual connection. Run this before making new
            % connection, or destroying Femto API object.
            %
            % See also CONNECT ISCONNECTED
            %
            obj.m_connectionObj.closeConnection();
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
                obj.m_connectionObj.connect(varargin{1});
            else
                obj.m_connectionObj.connect();
            end
        end
        
        function val = isConnected(obj)
            %ISCONNECTED Returns whether connected to the server or not.
            %
            val = obj.m_connectionObj.m_isConnected;
        end
        
        function val = getUrlAddress(obj)
            %GETURLADDRESS Returns connection url
            % 
           val = obj.m_connectionObj.m_urlAddress; 
        end

        
        % Overload property names retrieval
        function names = properties(obj)
            names = fieldnames(obj);
        end
        
        % Overload field names retrieval
        function names = fieldNames(obj)
            names = properties(obj);
        end

    end
    
    methods(Static)
        function ver = getCommandSetVersion()
            %GETCOMMANDSETVERSION Returns the version of the Femto API commandset
            ver = femtoAPI('command','FemtoAPIFile.getCommandSetVersion()');
            ver = ver{1};
        end
    end
    
end

