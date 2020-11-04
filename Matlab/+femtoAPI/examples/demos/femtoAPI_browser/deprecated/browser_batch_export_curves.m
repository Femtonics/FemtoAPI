function varargout = browser_batch_export_curves(varargin)
% BROWSER_BATCH_EXPORT_CURVES MATLAB code for browser_batch_export_curves.fig
%      BROWSER_BATCH_EXPORT_CURVES, by itself, creates a new BROWSER_BATCH_EXPORT_CURVES or raises the existing
%      singleton*.
%
%      H = BROWSER_BATCH_EXPORT_CURVES returns the handle to a new BROWSER_BATCH_EXPORT_CURVES or the handle to
%      the existing singleton*.
%
%      BROWSER_BATCH_EXPORT_CURVES('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in BROWSER_BATCH_EXPORT_CURVES.M with the given input arguments.
%
%      BROWSER_BATCH_EXPORT_CURVES('Property','Value',...) creates a new BROWSER_BATCH_EXPORT_CURVES or raises
%      the existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before browser_batch_export_curves_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to browser_batch_export_curves_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help browser_batch_export_curves

% Last Modified by GUIDE v2.5 12-Feb-2020 17:44:42

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @browser_batch_export_curves_OpeningFcn, ...
                   'gui_OutputFcn',  @browser_batch_export_curves_OutputFcn, ...
                   'gui_LayoutFcn',  [] , ...
                   'gui_Callback',   []);
if nargin && ischar(varargin{1})
    gui_State.gui_Callback = str2func(varargin{1});
end

if nargout
    [varargout{1:nargout}] = gui_mainfcn(gui_State, varargin{:});
else
    gui_mainfcn(gui_State, varargin{:});
end
% End initialization code - DO NOT EDIT

% --- Executes just before browser_batch_export_curves is made visible.
function browser_batch_export_curves_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to browser_batch_export_curves (see VARARGIN)

% Choose default command line output for browser_batch_export_curves
handles.output = hObject;


% validate and set channel list in channelSelector listbox 
channelList = varargin{1};
validateattributes(channelList,{'cell'},{'vector'});
handles.channelList = channelList;

% save parent haandle 
%handles.parent = varargin{2};

% initialize output arguments 
handles.fileName = '';
handles.absolutePath = ''; 
handles.ext = '';
handles.selectedChannelsList = {};

% Update handles structure
guidata(hObject, handles);

initialize_gui(hObject, handles, false);

% UIWAIT makes browser_batch_export_curves wait for user response (see UIRESUME)
uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = browser_batch_export_curves_OutputFcn(hObject, eventdata, handles)
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
%varargout{1} = handles.output;

varargout{1} = handles.absolutePath;
varargout{2} = handles.fileName;
varargout{3} = handles.ext;
varargout{4} = handles.selectedChannelsList;

%delete(hObject);


% --- Executes during object creation, after setting all properties.
function channelSelector_CreateFcn(hObject, eventdata, handles)
% hObject    handle to channelSelector (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function channelSelector_Callback(hObject, eventdata, handles)
% hObject    handle to channelSelector (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of channelSelector as text
%        str2double(get(hObject,'String')) returns contents of channelSelector as a double

% handles.

channelList = get(hObject,'String');
handles.selectedChannelsList = channelList(get(hObject,'Value'));
guidata(hObject,handles)



% --- Executes on button press in exportCurves.
function exportCurves_Callback(hObject, eventdata, handles)
% hObject    handle to exportCurves (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

if(isempty(handles.selectedChannelsList))
    uiwait(msgbox({'No channels are selected to export. Please select at least one channel from the list.'}));
    return;
end

% file path selector, and enter batch file name for export 
filter = {'*.txt';'*.mat'};

extIdx = length(filter) + 1;
while(extIdx > length(filter))
    [fileName, absolutePath, extIdx] = uiputfile(filter,'Select path and file type to save','exported_curves');
    if(fileName == 0) 
        return;
    end
end

ext = strrep(filter{extIdx},'*','');
handles.fileName = strrep(fileName,ext,'');
handles.absolutePath = strrep(absolutePath,'\','/');
handles.ext = ext;

guidata(hObject,handles);

% close ui
close(handles.figure1);


% --------------------------------------------------------------------
function initialize_gui(hObject, handles, isreset)

if isfield(handles, 'metricdata') && ~isreset
    return;
end

%handles.selectedChannels = {};
set(hObject,'WindowStyle','modal')

set(handles.channelSelector,'String',handles.channelList);
set(handles.channelSelector,'Max',length(handles.channelList),'Min',0);

% Update handles structure
%guidata(handles.figure1, handles);
guidata(hObject, handles);


% --- Executes when user attempts to close figure1.
function figure1_CloseRequestFcn(hObject, eventdata, handles)
% hObject    handle to figure1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: delete(hObject) closes the figure
if isequal(get(hObject, 'waitstatus'), 'waiting')
    % The GUI is still in UIWAIT, us UIRESUME
    uiresume(hObject);
else
    % The GUI is no longer waiting, just close it
    delete(hObject);
end
