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

function varargout = device_control_demo(varargin)
% device_control_demo MATLAB code for device_control_demo.fig
%      device_control_demo, by itself, creates a new device_control_demo or raises the existing
%      singleton*.
%
%      H = device_control_demo returns the handle to a new device_control_demo or the handle to
%      the existing singleton*.
%
%      device_control_demo('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in device_control_demo.M with the given input arguments.
%
%      device_control_demo('Property','Value',...) creates a new device_control_demo or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before device_control_demo_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to device_control_demo_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help device_control_demo

% Last Modified by GUIDE v2.5 17-Sep-2021 11:07:24

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
    'gui_Singleton',  gui_Singleton, ...
    'gui_OpeningFcn', @device_control_demo_OpeningFcn, ...
    'gui_OutputFcn',  @device_control_demo_OutputFcn, ...
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


% --- Executes just before device_control_demo is made visible.
function device_control_demo_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to device_control_demo (see VARARGIN)

% Choose default command line output for device_control_demo
handles.output = hObject;

% slider listener
handles.sliderListener = addlistener(handles.slider1,'ContinuousValueChange', ...
    @(hFigure,eventdata) slider1ContValCallback(...
    hObject,eventdata));


% create and store FemtoAPIAcquisition object 
handles.measControl = FemtoAPIAcquisition();

% get and store device values 

handles.deviceValues = handles.measControl.getPMTAndLaserIntensityDeviceValues();
% Update handles structure
guidata(hObject, handles);

% UIWAIT makes device_control_demo wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = device_control_demo_OutputFcn(hObject, eventdata, handles)
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes on button press in updateButton.
function updateButton_Callback(hObject, eventdata, handles)
% hObject    handle to updateButton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

handles.deviceValues = handles.measControl.getPMTAndLaserIntensityDeviceValues();

if(isempty(handles.deviceValues))
    waitfor(warndlg(['Device values get from server are empty. ',...
        'Change configuration on server']));
    return;
end

listOfDeviceNames = handles.deviceValues.getDeviceNames;

if(isempty(get(handles.listbox1,'String')))
    set(handles.listbox1,'String',listOfDeviceNames);
    index = 1;
else
    % get the currently selected pockels cell name from gui, and set slider
    % according to its value
    contents = cellstr(get(handles.listbox1,'String'));
    deviceName = contents{get(handles.listbox1,'Value')};
    index = handles.deviceValues.getDeviceIndexByName(deviceName);
end

sliderMin = handles.deviceValues(index).min;
sliderMax = handles.deviceValues(index).max;
sliderValue = clamp(sliderMin,...
    handles.deviceValues(index).value, sliderMax);

% set min and max value of slider
set(handles.slider1,'Min',sliderMin);
set(handles.slider1,'Max',sliderMax);
set(handles.slider1,'Value',sliderValue);
set(handles.edit1,'String',num2str(sliderValue,'%.1f'));
guidata(hObject, handles);

% --- Executes on slider movement.
%function slider1_Callback(hObject, eventdata, handles)
% hObject    handle to slider1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'Value') returns position of slider
%        get(hObject,'Min') and get(hObject,'Max') to determine range of slider

function slider1ContValCallback(hFigure,eventdata)
% test it out - get the handles object and display the current value
handles = guidata(hFigure);
sliderValue = get(handles.slider1,'Value');
set(handles.edit1,'String',num2str(sliderValue,'%.1f'));
%fprintf('slider value: %f\n',get(handles.slider1,'Value'))

% --- Executes during object creation, after setting all properties.
function slider1_CreateFcn(hObject, eventdata, handles)
% hObject    handle to slider1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end



function edit1_Callback(hObject, eventdata, handles)
% hObject    handle to edit1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit1 as text
%        str2double(get(hObject,'String')) returns contents of edit1 as a double

valueToSet = str2double(get(hObject,'String'));

% if textbox input is not a number, return
if(isnan(valueToSet))
    return;
end

listBoxContents = get(handles.listbox1,'String');
if(isempty(listBoxContents))
    disp('Data is empty. Click on update button to get data from server.');
    return;
end
listBoxContents = cellstr(listBoxContents);
deviceName = listBoxContents{get(handles.listbox1,'Value')};

sliderMin = get(handles.slider1,'Min');
sliderMax = get(handles.slider1,'Max');
deviceValueToSet = clamp(sliderMin,str2double(get(hObject,'String')),sliderMax);

% update edit box value to the clamped value
set(hObject,'String',num2str(deviceValueToSet,'%.1f'));

% set slider to the value in edit box
set(handles.slider1,'Value',deviceValueToSet);

% set the value of the appropriate device on deviceValues struct (locally)
handles.deviceValues.setDeviceValueByName(deviceName,deviceValueToSet);
% set changes on server
handles.measControl.setPMTAndLaserIntensityDeviceValues(handles.deviceValues);
guidata(hObject, handles);

% --- Executes during object creation, after setting all properties.
function edit1_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on selection change in listbox1.
function listbox1_Callback(hObject, eventdata, handles)
% hObject    handle to listbox1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns listbox1 contents as cell array
%        contents{get(hObject,'Value')} returns selected item from listbox1

% get currently selected item
contents = get(hObject,'String');
if(isempty(contents))
    disp('Data is empty. Click on update button to get data from server.');
    return;
end
contents = cellstr(contents);
deviceValue = contents{get(hObject,'Value')};
%index = handles.femtoapiObj.getPockelsCellIndexByName(pockelsCellName);
%index = handles.measControl.getPockelsCellIndexByName(deviceValue);
index = handles.deviceValues.getDeviceIndexByName(deviceValue);
% set slider min/max values according to pockels cell name
% sliderMin = handles.femtoapiObj.m_taskParams.pockels(index).min;
% sliderMax = handles.femtoapiObj.m_taskParams.pockels(index).max;
% sliderValue = clamp(sliderMin,...
%     handles.femtoapiObj.m_taskParams.pockels(index).value, sliderMax);

sliderMin = handles.deviceValues(index).min;
sliderMax = handles.deviceValues(index).max;
sliderValue = clamp(sliderMin,...
    handles.deviceValues(index).value, sliderMax);

% set min and max value of slider
set(handles.slider1,'Min',sliderMin);
set(handles.slider1,'Max',sliderMax);
set(handles.slider1,'Value',sliderValue);
set(handles.edit1,'String',num2str(sliderValue,'%.1f'));


% --- Executes during object creation, after setting all properties.
function listbox1_CreateFcn(hObject, eventdata, handles)
% hObject    handle to listbox1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: listbox controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on key press with focus on slider1 and none of its controls.
function slider1_KeyPressFcn(hObject, eventdata, handles)
% hObject    handle to slider1 (see GCBO)
% eventdata  structure with the following fields (see MATLAB.UI.CONTROL.UICONTROL)
%	Key: name of the key that was pressed, in lower case
%	Character: character interpretation of the key(s) that was pressed
%	Modifier: name(s) of the modifier key(s) (i.e., control, shift) pressed
% handles    structure with handles and user data (see GUIDATA)


% --- Executes on slider movement.
function slider1_Callback(hObject, eventdata, handles)
% hObject    handle to slider1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'Value') returns position of slider
%        get(hObject,'Min') and get(hObject,'Max') to determine range of slider
contents = get(handles.listbox1,'String');
if(isempty(contents))
    disp('Data is empty. Click on update button to get data from server.');
    return;
end
contents = cellstr(contents);
deviceName = contents{get(handles.listbox1,'Value')};

%index = handles.femtoapiObj.getPockelsCellindexByName(pockelsCellName);
sliderValue = get(hObject,'Value');

% set slider value to appropriate pockels cell value
% handles.femtoapiObj.setTaskParamsPockelsValue(pockelsCellName,sliderValue);
% handles.femtoapiObj.writeTaskParams;
% handles.measControl.setTaskParamsPockelsValue(deviceName,sliderValue);
% handles.measControl.writeTaskParams;
handles.deviceValues.setDeviceValueByName(deviceName,sliderValue);
handles.measControl.setPMTAndLaserIntensityDeviceValues(handles.deviceValues);


% --- Executes on key press with focus on listbox1 and none of its controls.
function listbox1_KeyPressFcn(hObject, eventdata, handles)
% hObject    handle to listbox1 (see GCBO)
% eventdata  structure with the following fields (see MATLAB.UI.CONTROL.UICONTROL)
%	Key: name of the key that was pressed, in lower case
%	Character: character interpretation of the key(s) that was pressed
%	Modifier: name(s) of the modifier key(s) (i.e., control, shift) pressed
% handles    structure with handles and user data (see GUIDATA)


% --- Executes when user attempts to close figure1.
function figure1_CloseRequestFcn(hObject, eventdata, handles)
% hObject    handle to figure1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% close femtoapi connection 
if ~isempty( handles.measControl )
    handles.measControl.disconnect();
end

% Hint: delete(hObject) closes the figure
delete(hObject);
