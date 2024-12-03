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

classdef TreeWrapper < handle
    %TreeWrapper Creates tree object from nested structures. 
    %   Detailed explanation goes here
    
    properties (SetAccess = private)
        %m_searchMap = containers.Map('KeyType','double','ValueType','double');
        m_handles ;
        m_tree ;
    end
    
    properties (Constant, Access = private)
        doOnParamError = {'error','warning','noMessage'};
    end
    
    properties (SetAccess = private, Dependent)
       m_handlesTree 
    end
    
    methods
        function obj = TreeWrapper(rootStruct)
            rootStruct.data.('handle') = -1;
            obj.m_tree = tree(rootStruct);
            obj.buildTree(rootStruct,0);
            obj.m_handles = cellfun(@(x) reshape(x.data.handle,[],1), obj.m_tree.Node,'UniformOutput',false );        
            disp('Tree construction ended');            
        end
        
        function val = get.m_tree(obj)
            val = obj.m_tree;
        end
        
        function val = get.m_handlesTree(obj)
            val = obj.m_tree.treefun(@(x) num2str((x.data.handle)'));
        end
        
        function val = get.m_handles(obj)
            val = obj.m_handles;
        end        
        
        function val = getStructByHandle(obj,handle)
              val = obj.getHStructByHandle(handle).data;
        end


        % get reference (HStruct) object to the selected handle
        function val = getHStructByHandle(obj,handle)
            validateattributes(handle,{'numeric'},{'vector'},'getHStructByHandle',...
                'handle');
            handle = reshape(handle,[],1);
            nodeID = cellfun(@(x) isequal(x,handle), obj.m_handles);
            nodeID = find(nodeID);
            if(length(nodeID) > 1)  % should not occur
                error('Internal error: nodeID must be one integer number.');
            end
            if(isempty(nodeID))
                error('There is no element with the requested handle ID.');
            end            
            val = obj.m_tree.get(nodeID);
        end
        
        function val = getStructByNodeID(obj,nodeID)
              val = obj.getHStructByNodeID(nodeID);
              val = val.data;
        end        
        
        % get reference (HStruct) object to the selected node
        function val = getHStructByNodeID(obj,nodeID)
            validateattributes(nodeID,{'numeric'},{'integer','positive','scalar','<=',...
                length(obj.m_handles)},'getHStructByNodeID','nodeID');
            val = obj.m_tree.get(nodeID);
        end
        
        function val = getHandleByNodeID(obj,nodeID)
            validateattributes(nodeID,{'numeric'},{'integer','positive','vector','<=',...
                length(obj.m_handles)},'getHandleByNodeID','nodeID');
            val = {obj.m_handles{nodeID}};
        end
        
        function nodeID = getNodeIDByHandle(obj,handle)
            validateattributes(handle,{'numeric','cell'},{'vector','nonempty'},...
                'getNodeIDByHandle','handle',1); 
            handle = reshape(handle,[],1);
            nodeID = cellfun(@(x) isequal(x,handle), obj.m_handles);
            nodeID = find(nodeID);
        end
        
        function nodeIDs = getChildNodeIDs(obj,nodeID)
            validateattributes(nodeID,{'numeric'},{'nonempty','integer','positive','scalar','<=',...
                length(obj.m_handles)},'getChildNodeIDs','nodeID');
            nodeIDs = obj.m_tree.getchildren(nodeID);
        end
        
        function childrenHandles = getChildHandles(obj,handle)
            validateattributes(handle,{'numeric'},{'nonempty','vector'},...
                'getChildHandles','handle',1);
            nodeID = getNodeIDByHandle(obj,handle);
            childrenNodeIDs = obj.m_tree.getchildren(nodeID);
            childrenHandles = obj.getHandleByNodeID(childrenNodeIDs);
        end
        
        function numOfChildHandles = getNumOfChildHandles(obj, handle)
            validateattributes(handle,{'numeric'},{'nonempty','vector'},...
                'getChildHandles','handle',1);  
            nodeID = getNodeIDByHandle(obj,handle);
            numOfChildHandles = length(obj.m_tree.getchildren(nodeID));
        end
         
        % set methods
        function setStructByNodeID(obj, nodeID, newValue)
            validateattributes(nodeID,{'numeric'},{'integer','positive','scalar','<=',...
                length(obj.m_handles)},'setStructFieldByNodeID','nodeID',1);
            
            dataStructHandle = obj.getHStructByNodeID(nodeID);
            dataStructHandle.data = newValue;
        end        
        
        
        function setStructFieldByNodeID(obj, nodeID, fieldname, newValue)
            validateattributes(nodeID,{'numeric'},{'integer','positive','scalar','<=',...
                length(obj.m_handles)},'setStructFieldByNodeID','nodeID',1);
            validateattributes(fieldname,{'char'},{'vector'},...
                'setStructFieldByNodeID','fieldname',2);
            
            dataStructHandle = obj.getHStructByNodeID(nodeID);
            if( isfield(dataStructHandle.data,fieldname) )
                dataStructHandle.data.(fieldname) = newValue;
            else
                error('Fieldname cannot found, no data has been set.');
            end                
        end
        
        function val = setStructByHandle(obj, handle, newValue)
            validateattributes(handle,{'numeric'},{'vector'},...
                'setStructFieldByHandle','handle',1);
            
            val = [];
            % get the reference(handle) of the data
            dataStructHandle = obj.getHStructByHandle(handle);
            dataStructHandle.data = newValue;
        end 
        
        % Sets struct field by it handle. If fieldName is not found, optionally
        % an error or warning message, or no message can be shown, and it
        % returns false, otherwise returns true. 
        function val = setStructFieldByHandle(obj, handle, fieldName, newValue)
            validateattributes(handle,{'numeric'},{'vector'},...
                'setStructFieldByHandle','handle',1);
            validateattributes(fieldName,{'char'},{'row'},...
                'setStructFieldByHandle','fieldname',2);
            
            val = [];
            % get the reference(handle) of the data
            dataStructHandle = obj.getHStructByHandle(handle);
            if( isfield(dataStructHandle.data,fieldName) )
                dataStructHandle.data.(fieldName) = newValue;
            else
                error('Fieldname cannot be found, no data has been set.');
            end                
        end    
        
        % Gets struct field by handle ID. If 'fieldName' is not found, then
        % a logical false is returned. 
        function val = getStructFieldByHandle(obj, handle, fieldName)
            validateattributes(handle,{'numeric'},{'vector'},...
                'getStructFieldByHandle','handle',1);
            validateattributes(fieldName,{'char'},{'row'},...
                'getStructFieldByHandle','fieldname',2); 
                        
            % get the reference(handle) of the data
            dataStructHandle = obj.getHStructByHandle(handle); 
            val = false;  
            if( isfield(dataStructHandle.data,fieldName) )
                val = dataStructHandle.data.(fieldName);
            else
                error('Fieldname cannot be found.');
            end                
        end
        
        
        function nodeIDs = findStructFieldByName(obj,fieldName)
            nodeIDs = find(obj.m_tree.treefun(@(x) isfield(x.data,fieldName)));
        end
        
        % changes the value at field specified by fieldName to
        % newValue = func(value), where func is given as a function handle
        function treefunForField(obj,fieldName,funcHandle)
            % find fieldNames in tree
            nodeIDs = find(obj.m_tree.treefun(@(x) isfield(x.data,fieldName)));
            
            % iterate on nodeIDs, and do func
            for i = nodeIDs
                obj.m_tree.Node{i}.data.(fieldName) = funcHandle(obj.m_tree.Node{i}.data.(fieldName));
            end
        end
        
        % apply func to child nodes
        function modifyChildFieldByFunc(obj, rootNodeID, fieldName, funcHandle)
            childNodeIDs = obj.getChildNodeIDs(rootNodeID);
            for i= childNodeIDs
                if(isfield(obj.m_tree.Node{i}.data,fieldName))
                    obj.m_tree.Node{i}.data.(fieldName) = funcHandle(obj.m_tree.Node{i}.data.(fieldName));
                end 
            end
        end
        
        function modifyChildFieldByFunc2(obj, rootHandle, fieldName, funcHandle)
           rootNodeID = obj.getNodeIDByHandle(rootHandle);
           obj.modifyChildFieldByNodeID(rootNodeID,fieldName,funcHandle);
        end
        
        
        function modifyChildFieldByValue(obj,rootNodeID,fieldName, newVal)
            childNodeIDs = obj.getChildNodeIDs(rootNodeID);
            for i= childNodeIDs
                if(isfield(obj.m_tree.Node{i}.data,fieldName))
                    obj.m_tree.Node{i}.data.(fieldName) = newVal;
                end 
            end 
        end
        
        function modifyChildFieldByValue2(obj,rootHandle,fieldName, newVal)
           rootNodeID = obj.getNodeIDByHandle(rootHandle);
           obj.modifyChildFieldByValue(rootNodeID,fieldName,newVal);    
        end
        
        % applies func to every item in the tree
        function resultTree = batchProcessTree(obj,funcHandle)               
                resultTree = obj.m_tree.treefun(funcHandle);
        end

        function dispHandlesTree(obj)           
           disp(obj.m_handlesTree.tostring);
        end

        % helper method for building tree from nested structure
        buildTree(obj,parentStruct,nodeID);
    end
end

