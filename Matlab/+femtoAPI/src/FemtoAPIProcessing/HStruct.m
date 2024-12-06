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

classdef HStruct < matlab.mixin.Copyable % descends from handle
    %HStruct Handle class to wrap any data and use it as reference
    %   Handle class that aims to wrap any kind of data and use it as reference
    
    properties (Access = public)
        data
    end
    
    
    methods
        function obj = HStruct(data)
            obj.data = data;
        end
        
        
%         % overload '.' operator for simpler struct indexing
%         % aims to reference the underlying struct field instead of
%         % obj.data.field                          <-- obj.field
%         % obj.data.field1.field2                  <-- obj.field1.field2
%         % or obj.data(indices).field              <-- obj(indices).field
%         % or obj.data.field(indices)              <-- obj.field(indices)
%         % or obj.data(indices).field(indices)     <-- obj(indices).field(indices)
%         function varargout = subsref(obj,s)
%             switch s(1).type
%                 case '.'
%                     if(length(s) == 1)
%                         % Implement obj.field and obj.method
%                         if( isfield(obj.data,s(1).subs) )
%                             varargout = {obj.data.(s(1).subs)};
%                         elseif( any(strcmp(methods(obj),s(1).subs)) )
%                             varargout = {obj.(s(1).subs)};
%                         else
%                             error(['Reference to non-existent field or method',...
%                                 s(1).subs]);
%                         end
%                     elseif(length(s) == 2 && strcmp(s(2).type,'()') )
%                         % Implement obj.field(indices)
%                         try
%                             structField = obj.data.(s(1).subs);
%                             ind = sub2ind(size(structField),s(2).subs{:});
%                             varargout = {structField(ind)};
%                         catch ME
%                             disp(ME.message);
%                         end
%                     elseif(isa(obj.data.(s(1).subs),'HStruct')) % general class type?
%                         % Implement e.g. obj.field(indices).field2 ...
%                         % or obj.field.field2 where field is a HStruct
%                         varargout = {subsref(obj.data.(s(1).subs),s(2:end))};
%                     else
%                         % TODO -> case when structrue contains HStruct:
%                         % obj.field.hStruct.field2
%                         varargout = {builtin('subsref',obj.data,s)};
%                     end
%                     
%                 case '()'
%                     if( length(s) == 1 )
%                         % Implement obj(indices)
%                         try
% %                             if(length(s.subs) == 1)
% %                                 varargout = {obj(s(1).subs)};
% %                             else
%                                 varargout = {obj(s(1).subs{:})};
% %                            end
%                         catch ME
%                             disp(ME.message);
%                         end
%                     elseif( length(s) == 2 && strcmp(s(2).type,'.') )
%                         % Implement obj(indices).field
%                         try
%                             varargout = {obj(s(1).subs{:}).data.(s(2).subs)};
%                         catch ME
%                             disp(ME.message);
%                         end
%                         
%                     elseif( length(s) == 3 && strcmp(s(2).type,'.') && strcmp(s(3).type,'()') )
%                         % Implement obj(indices).field(indices)
%                         try
%                             %structField = obj(s(1).subs{:}).data.(s(2).subs);
%                             %ind = sub2ind(size(structField),s(2).subs{:});
%                             %varargout = {structField(ind)};
%                             
%                             varargout = {obj(s(1).subs{:}).data.(s(2).subs)(s(3).subs{:})};
%                         catch ME
%                             disp(ME.message);
%                         end
%                     elseif( isa(obj(s(1).subs{:}).data.(s(2).subs),'HStruct') )
%                         % Implement obj(indices).field1.field2 if field1 is
%                         % HSTruct
%                         varargout = {subsref(obj(s(1).subs{:}).data.(s(2).subs),s(3:end))};
% %                     elseif( length(s) == 3 && strcmp(s(2).type,'.') && strcmp(s(3).type,'.') )
% %                         % Implement obj(indices).field1.field2 if field1 is
% %                         % NOT a HSTruct                        
% %                         varargout = { obj(s(1).subs{:}).data.  }
%                     else
%                         % Use built-in for any other expression
%                         varargout = {builtin('subsref',obj(s(1).subs{:}).data,s(2:end))};
%                     end
%                     
%                 otherwise
%                     error('not supported operator ');
%             end
%             
%         end
%         
%         
%         % TODO only partly implemented
%         function obj = subsasgn(obj,s,varargin)
%             switch s(1).type
%                 case '.'
%                     if length(s) == 1
%                         % Implement obj.field = varargin{:};
%                         obj.data.(s(1).subs) = varargin{:};
%                     elseif length(s) == 2 && strcmp(s(2).type,'()')
%                         % Implement obj.field(indices) = varargin{:};
%                         obj.data.(s(1).subs)(s(2).subs{:}) = varargin{:};
%                     else
%                         % Call built-in for any other case
%                         obj = builtin('subsasgn',obj,s,varargin);
%                     end
%                 case '()'
%                     if length(s) == 1
%                         % Implement obj(indices) = varargin{:};
%                     elseif length(s) == 2 && strcmp(s(2).type,'.')
%                         % Implement obj(indices).PropertyName = varargin{:};
%                         ...
%                     elseif length(s) == 3 && strcmp(s(2).type,'.') && strcmp(s(3).type,'()')
%                     % Implement obj(indices).PropertyName(indices) = varargin{:};
%                     ...
%                     else
%                     % Use built-in for any other expression
%                     obj = builtin('subsasgn',obj,s,varargin);
%                     end
%                 case '{}'
%                     if length(s) == 1
%                         % Implement obj{indices} = varargin{:}
%                         ...
%                     elseif length(s) == 2 && strcmp(s(2).type,'.')
%                     % Implement obj{indices}.PropertyName = varargin{:}
%                     ...
%                         % Use built-in for any other expression
%                     obj = builtin('subsasgn',obj,s,varargin);
%                     end
%                 otherwise
%                     error('Not a valid indexing expression')
%             end
%         end
%         
%         function names = properties(obj)
%             if(isstruct(obj.data))
%                 names = fieldnames(obj.data);
%             elseif(isa(obj.data,'HStruct'))
%                 names = properties(obj.data);
%             else
%                 names = obj.data;
%             end
%         end
        
        
        
        
    end
    
    
    
    methods(Hidden)
        function val = isstruct(obj)
            val = isstruct(obj.data);
        end
        
        function names = fieldnames(obj)
            names = fieldnames(obj.data);
        end
        
        function lh = addlistener(varargin)
            lh = addlistener@handle(varargin{:});
        end
        function notify(varargin)
            notify@handle(varargin{:});
        end
        function delete(varargin)
            delete@handle(varargin{:});
        end
        function Hmatch = findobj(varargin)
            Hmatch = findobj@handle(varargin{:});
        end
        function p = findprop(varargin)
            p = findprop@handle(varargin{:});
        end
        function TF = eq(varargin)
            TF = eq@handle(varargin{:});
        end
        function TF = ne(varargin)
            TF = ne@handle(varargin{:});
        end
        function TF = lt(varargin)
            TF = lt@handle(varargin{:});
        end
        function TF = le(varargin)
            TF = le@handle(varargin{:});
        end
        function TF = gt(varargin)
            TF = gt@handle(varargin{:});
        end
        function TF = ge(varargin)
            TF = ge@handle(varargin{:});
        end
        
%         function TF = addprop(varargin)
%             TF = addprop@dynamicprops(varargin{:});
%         end
        % TODO: find a way to hide isvalid: it is sealed method, and cannot be overriden
        %       function TF = isvalid(varargin)
        %          TF = isvalid@handle(varargin{:});
        %       end
    end
    
    methods(Access = protected)
        % Override copyElement method:
        function cpObj = copyElement(obj)
            % Make a shallow copy of all properties
            %cpObj = copyElement@matlab.mixin.Copyable(obj);
            
            %          props = properties(obj);
            %          for i=1:length(props)
            %              cpObj.(props{i}) = obj.(props{i});
            %          end
            cpObj = HStruct(obj.data);
            %cpObj.DeepObj = copy(obj.DeepObj);
        end
    end
    
    
    %methods
    %        function val = ismethod(obj,methodName)
    % %           if(strcmp(methodName,'methods'))
    % %               val = true(1);
    % %           else
    % %               val = false(1);
    % %           end
    %             val = false(1);
    %        end
    
end
