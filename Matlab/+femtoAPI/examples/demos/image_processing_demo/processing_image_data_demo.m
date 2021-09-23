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

function varargout = processing_image_data_demo(varargin)
% PROCESSING_IMAGE_DATA_DEMO MATLAB code for processing_image_data_demo.fig
%      PROCESSING_IMAGE_DATA_DEMO, by itself, creates a new PROCESSING_IMAGE_DATA_DEMO or raises the existing
%      singleton*.
%
%      H = PROCESSING_IMAGE_DATA_DEMO returns the handle to a new PROCESSING_IMAGE_DATA_DEMO or the handle to
%      the existing singleton*.
%
%      PROCESSING_IMAGE_DATA_DEMO('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in PROCESSING_IMAGE_DATA_DEMO.M with the given input arguments.
%
%      PROCESSING_IMAGE_DATA_DEMO('Property','Value',...) creates a new PROCESSING_IMAGE_DATA_DEMO or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before processing_image_data_demo_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to processing_image_data_demo_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help processing_image_data_demo

% Last Modified by GUIDE v2.5 15-Sep-2021 15:48:04

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
    'gui_Singleton',  gui_Singleton, ...
    'gui_OpeningFcn', @processing_image_data_demo_OpeningFcn, ...
    'gui_OutputFcn',  @processing_image_data_demo_OutputFcn, ...
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


% --- Executes just before processing_image_data_demo is made visible.
function processing_image_data_demo_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to processing_image_data_demo (see VARARGIN)

% Choose default command line output for processing_image_data_demo
set(hObject,'menu','default');
handles.output = hObject;

% slider listener
handles.sliderListener = addlistener(handles.slider1,'ContinuousValueChange', ...
    @(hFigure,eventdata) slider1_Callback(...
    hObject,eventdata));

handles.lutSliderListener = addlistener(handles.lutSlider,'ContinuousValueChange', ...
    @(hFigure,eventdata) lutSlider_Callback(...
    hObject,eventdata));

unitbutton_Callback(hObject, eventdata, handles)
handles = guidata(hObject);
guidata(hObject, handles);

% UIWAIT makes processing_image_data_demo wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = processing_image_data_demo_OutputFcn(hObject, eventdata, handles)
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes on selection change in listbox1.
function listbox1_Callback(hObject, eventdata, handles)
% hObject    handle to listbox1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
contents = cellstr(get(hObject,'String'));
handles.index = get(hObject,'Value');

if(~isempty(handles.unitstruct))
    handles.frameNum = 0;
    show_frame(hObject, eventdata, handles);
    handles = guidata(hObject);
    
    unit = handles.unitstruct(handles.index);
    
    set(handles.slider1,'Enable','On');
    set(handles.slider1,'Min',0);
    if(length(horzcat(unit.dimensions)) == 3)
        set(handles.slider1,'Max',unit.dimensions(3).size-1);
        set(handles.slider1,'SliderStep', [1/(unit.dimensions(3).size-1), 1/(unit.dimensions(3).size-1)]);
    else
        set(handles.slider1,'Max',0);
        set(handles.slider1,'SliderStep', [0,0]);
    end
    
    set(handles.slider1,'Value',0);
    set(handles.FrameNumText,'String',num2str(handles.frameNum+1));
    
    % set slider min/max values according to pockels cell name
    sliderMin = handles.lutObjects(handles.index).m_vecBounds(1);
    sliderMin = sliderMin + 0.01;
    sliderMax = handles.lutObjects(handles.index).m_rangeUpperBound;
    sliderValue = handles.lutObjects(handles.index).m_vecBounds(end);
    
    % set min and max value of slider
    set(handles.lutSlider,'Enable','On');
    set(handles.lutSlider,'Min',sliderMin);
    set(handles.lutSlider,'Max',sliderMax);
    set(handles.lutSlider,'Value',sliderValue);
    set(handles.lutSlider, 'SliderStep',[1/(sliderMax - sliderMin),1/(sliderMax - sliderMin)]);
    set(handles.lutEdit,'String',num2str(sliderValue,'%.4f'));
end
guidata(hObject, handles);


function show_frame(hObject, eventdata, handles)

unit = handles.unitstruct(handles.index);
dims = length(unit.dimensions);
set(handles.errorText,'String','');
if(dims ~= 2 && dims ~= 3)
    imagesc(handles.axes1,[]);
    set(handles.errorText,'String','Only data that are 2 or 3D can be shown.');
else
    handles.image = readChannelData(handles.femtoapiObj,(unit.channels(1).data.handle)', 'uint16', ...
        {[1:unit.dimensions(1).size],[1:unit.dimensions(2).size],[handles.frameNum+1:handles.frameNum+1]} );
    
    %lutObj = LUT(handles.lutstruct(handles.index));
    image = handles.lutObjects(handles.index).convertChannelToARGB(handles.image);
    imagesc(handles.axes1,image(:,:,2:4));
end
guidata(hObject, handles);

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


% --- Executes on button press in pushbutton1.
function pushbutton1_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

if isfield(handles, 'image')
    sigma = 4;
    hsize=ceil(sigma)*5+1;
    filt=fspecial('gaussian', hsize, sigma);
    handles.image=padfilter2(filt,handles.image);
    image = handles.lutObjects(handles.index).convertChannelToARGB(handles.image);
    imagesc(handles.axes1,image(:,:,2:4));
    unit = handles.unitstruct(handles.index);
    writeChannelData( handles.femtoapiObj, (unit.channels(1).data.handle)', ...
        handles.image, [1 1 handles.frameNum+1]  )
    guidata(hObject, handles);
end

function out=padfilter2(filter,im, value)
%pads image with value or with it's sides
%does filter2
%returns original size array
if numel(filter)==1
    out=double(im)*filter;
    return
end
sf=ceil(size(filter)./2);
si=size(im);

paddedsize=[sf(1)*2+si(1), sf(2)*2+si(2)];
if nargin<3 || isempty(value)
    padded=imresize(im, paddedsize, 'nearest');
else
    padded=ones(paddedsize(1), paddedsize(2))*value;
end

padded(sf(1)+1:sf(1)+si(1), sf(2)+1:sf(2)+si(2))=im;
padded=filter2(filter, padded);
out=padded(sf(1)+1:sf(1)+si(1), sf(2)+1:sf(2)+si(2));

% --- Executes on button press in unitbutton.
function unitbutton_Callback(hObject, eventdata, handles)
% hObject    handle to unitbutton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% create FemtoAPI object
handles.femtoapiObj = FemtoAPIProcessing;

% Update handles structure
unitstruct = [];
lutObjects = [];
listbox = handles.listbox1;
mfiles = handles.femtoapiObj.m_processingState.data.openedMEScFiles;
s = {};

% selecting units only with image data
for filei = 1 : length(mfiles)
    if isfield(mfiles(filei).data,'measurementSessions')
        for session = 1:length(mfiles(filei).data.measurementSessions)
            munits = mfiles(filei).data.measurementSessions(session).data.measurements;
            for ui = 1:length(munits)
                unitstruct = horzcat(unitstruct,munits(ui).data);
                %lutstruct = horzcat(lutstruct,munits(ui).channels.clut);
                lutObjects = horzcat(lutObjects,LUT(munits(ui).data.channels(1).data.clut));
                if ~(strcmp(munits(ui).data.measurementType, 'Electrogram'))
                    s{end+1} = [mfiles(filei).data.path,'__', num2str(munits(ui).data.handle(3))];
                end
            end
        end
    end
end
handles.unitstruct = unitstruct;
handles.lutObjects = lutObjects;

handles.index = get(handles.listbox1,'Value');
if(~isempty(handles.unitstruct))
    sliderMin = handles.lutObjects(handles.index).m_vecBounds(1);
    sliderMin = sliderMin + 0.01;
    
    sliderMax = handles.lutObjects(handles.index).m_rangeUpperBound;
    sliderValue = handles.lutObjects(handles.index).m_vecBounds(end);
    
    % set min and max value of slider
    set(handles.lutSlider,'Min',sliderMin);
    set(handles.lutSlider,'Max',sliderMax);
    set(handles.lutSlider,'Value',sliderValue);
    set(handles.lutSlider, 'SliderStep',[1/(sliderMax - sliderMin),1/(sliderMax - sliderMin)] );
    set(handles.lutEdit,'String',num2str(sliderValue,'%.4f'));
    handles.frameNum = 0;
    set(listbox, 'String',s)
    show_frame(hObject, eventdata, handles);
else
    handles.frameNum = 0;
    sliderValue = get(handles.lutSlider,'Min');
    set(handles.lutSlider,'Value',sliderValue);
    set(listbox, 'String',s);
    set(handles.lutEdit,'String','');
    set(handles.FrameNumText,'String','');
    imagesc(handles.axes1,[]);
end

guidata(hObject, handles);




% --- Executes on slider movement.
function slider1_Callback(hObject, eventdata, handles)
% hObject    handle to slider1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'Value') returns position of slider
%        get(hObject,'Min') and get(hObject,'Max') to determine range of slider
if nargin==2
    handles = guidata(hObject);
    handles.frameNum = round(get(handles.slider1,'Value'));
else
    handles.frameNum = round(get(hObject,'Value'));
end
set(handles.FrameNumText,'String',num2str(handles.frameNum+1));
guidata(hObject, handles);
show_frame(hObject, eventdata, handles);

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
% hObject    handle to FrameNumText (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of FrameNumText as text
%        str2double(get(hObject,'String')) returns contents of FrameNumText as a double


% --- Executes during object creation, after setting all properties.
function FrameNumText_CreateFcn(hObject, eventdata, handles)
% hObject    handle to FrameNumText (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on slider movement.
function lutSlider_Callback(hObject, eventdata, handles)
% hObject    handle to lutSlider (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'Value') returns position of slider
%        get(hObject,'Min') and get(hObject,'Max') to determine range of slider
if nargin == 2
    handles = guidata(hObject);
    sliderValue = get(handles.lutSlider,'Value');
else
    sliderValue = get(hObject,'Value');
end

% set lut entry range upper bound to the slider value
%handles.lutstruct(handles.index).entries(end).value = sliderValue;
if(isfield(handles,'unitstruct') && ~isempty(handles.unitstruct))
    lowerValue = handles.lutObjects(handles.index).m_vecBounds(1);
    handles.lutObjects(handles.index).rescale(lowerValue,sliderValue);
    
    set(handles.lutEdit,'String',num2str(sliderValue,'%.4f'));
    guidata(hObject, handles);
    show_frame(hObject, eventdata, handles);
end

% --- Executes during object creation, after setting all properties.
function lutSlider_CreateFcn(hObject, eventdata, handles)
% hObject    handle to lutSlider (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end



function lutEdit_Callback(hObject, eventdata, handles)
% hObject    handle to lutEdit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of lutEdit as text
%        str2double(get(hObject,'String')) returns contents of lutEdit as a double
if(~isempty(handles.unitstruct))
    sliderMin = get(handles.lutSlider,'Min');
    sliderMax = get(handles.lutSlider,'Max');
    
    sliderValue = clamp(sliderMin,str2double(get(handles.lutEdit,'String')),sliderMax);
    set(handles.lutSlider,'Value',sliderValue);
    set(handles.lutEdit,'String',num2str(sliderValue));
    
    %handles.lutstruct(handles.index).entries(end).value = sliderValue;
    lowerValue = handles.lutObjects(handles.index).m_vecBounds(1);
    handles.lutObjects(handles.index).rescale(lowerValue,sliderValue);
    
    guidata(hObject, handles);
    show_frame(hObject, eventdata, handles);
end
%lutSlider_Callback(hObject, eventdata, handles)
%show_frame(hObject, eventdata, handles);

% --- Executes during object creation, after setting all properties.
function lutEdit_CreateFcn(hObject, eventdata, handles)
% hObject    handle to lutEdit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on selection change in popupmenu1.
function popupmenu1_Callback(hObject, eventdata, handles)
% hObject    handle to popupmenu1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns popupmenu1 contents as cell array
% %        contents{get(hObject,'Value')} returns selected item from popupmenu1
% colorIndex = get(hObject,'Value');
% newLutObj = handles.lutObjects(handles.index);
% switch colorIndex
%     case 1: % Select
%     case 2: % red
%         newLutObj.reset(


% --- Executes during object creation, after setting all properties.
function popupmenu1_CreateFcn(hObject, eventdata, handles)
% hObject    handle to popupmenu1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

% --- Executes when user attempts to close figure1.
function uipanel1_DeleteFcn(hObject, eventdata, handles)
% hObject    handle to figure1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: delete(hObject) closes the figure
delete(hObject);


% --- Executes when user attempts to close figure1.
function figure1_CloseRequestFcn(hObject, eventdata, handles)
% hObject    handle to figure1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% close femtoapi connection 
if ~isempty( handles.femtoapiObj )
    handles.femtoapiObj.disconnect();
end
% Hint: delete(hObject) closes the figure
delete(hObject);
