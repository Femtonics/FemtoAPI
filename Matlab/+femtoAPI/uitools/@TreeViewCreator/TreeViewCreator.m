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

classdef TreeViewCreator < handle
    %UNTITLED27 Summary of this class goes here
    %   Detailed explanation goes here
    
    properties (SetAccess = private)
        uitreeObj
        femtoApiTreeObj
    end
    
%     properties (Access = private)
%         femtoApiTreeObj.
%     end
    
    methods
        function obj = TreeViewCreator(ParentObj,femtoApiTreeObj)
            import uiextras.jTree.*
            uiextras.jTree.loadJavaCustomizations();
            
            
            obj.uitreeObj = Tree('Parent',ParentObj);
            %obj.uitreeObject = TreeControl('Parent',ParentObj);
            
            obj.femtoApiTreeObj = femtoApiTreeObj;
            %obj.mescapiTreeHandles = femtoApiTreeObj.m_handles;
            %% Hide the root
            obj.uitreeObj.RootVisible = false;   
            
            %% build tree from mescapi tree object
            %treeRoot = femtoApiTreeObj.m_mescStateTreeObj.m_tree.Node{1};
            
            uitreeRoot = obj.uitreeObj.Root;
            obj.buildUiTreeFromFemtoAPITree(uitreeRoot,1);
            
            %% Enable the tree
            obj.uitreeObj.Enable = true;
            
        end
        
        buildUiTreeFromFemtoAPITree(obj,uitreeRoot,nodeID);
        
        % getters
        function val = get.uitreeObj(obj)
            val = obj.uitreeObj;
        end
        
%         function val = getUiTreeNodeStructByHandle(obj,handle)
%             val = obj.femtoApiTreeObj.getStructByHandle(handle);
%         end
        
    end
    
%     methods (Access = private)
%         buildUiTreeFromFemtoAPITree.obj,uitreeRoot,nodeID);
%     end
    
end

