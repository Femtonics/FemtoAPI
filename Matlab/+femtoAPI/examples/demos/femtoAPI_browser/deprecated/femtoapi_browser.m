function varargout = femtoapi_browser(varargin)
% FEMTOAPI_BROWSER MATLAB code for mescapi_browser.fig
%      FEMTOAPI_BROWSER, by itself, creates a new FEMTOAPI_BROWSER or raises the existing
%      singleton*.
%
%      H = FEMTOAPI_BROWSER returns the handle to a new FEMTOAPI_BROWSER or the handle to
%      the existing singleton*.
%
%      FEMTOAPI_BROWSER('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in FEMTOAPI_BROWSER.M with the given input arguments.
%
%      FEMTOAPI_BROWSER('Property','Value',...) creates a new FEMTOAPI_BROWSER or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before femtoapi_browser_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to femtoapi_browser_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help femtoapi_browser

% Last Modified by GUIDE v2.5 22-Nov-2019 10:00:00
   
% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
    'gui_Singleton',  gui_Singleton, ...
    'gui_OpeningFcn', @femtoapi_browser_OpeningFcn, ...
    'gui_OutputFcn',  @femtoapi_browser_OutputFcn, ...
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


% --- Executes just before femtoapi_browser is made visible.
function femtoapi_browser_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to femtoapi_browser (see VARARGIN)

% Choose default command line output for femtoapi_browser
handles.output = hObject;

handles.sliderListener = addlistener(handles.slider1,'ContinuousValueChange', ...
    @(hFigure,eventdata) slider1_Callback(...
    hObject,eventdata));

pushbutton1_Callback(hObject, eventdata, handles);

%femtoapiObj = MEScAPI;
%handles.femtoapiObj = femtoapiObj;
%handles.uitreeObj = uitreeFromMEScAPIObj(handles.uipanel1,femtoapiObj);
% Update handles structure
handles = guidata(hObject);
guidata(hObject, handles);

% UIWAIT makes femtoapi_browser wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = femtoapi_browser_OutputFcn(hObject, eventdata, handles)
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes on button press in pushbutton1.
function pushbutton1_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
handles.mescAPIObj = MEScAPIProcessing;
%handles.mescAPIObj.readTaskParams;
%femtoapiTreeObj = handles.mescAPIObj.m_mescStateTreeObj;
treeViewCreatorObj = TreeViewCreator(handles.measTreeUipanel,handles.mescAPIObj.m_mescProcessingStateTreeObj);
%treeViewCreatorObj = TreeViewCreator(handles.uipanel1,handles.mescAPIObj.m_mescStateTreeObj);

handles.uitreeObj = treeViewCreatorObj.uitreeObj;
%handles.femtoapiTreeObj = treeViewCreatorObj.femtoapiTreeObj;

%handles.uitreeObj.SelectionType = 'single';
handles.uitreeObj.SelectionType = 'discontiguous';
u1 = uicontextmenu('Parent',handles.figure1);
m1 = uimenu(u1,'Label','Run nrmc','Callback',@menuActionCallback);
m2 = uimenu(u1,'Label','Export input curves...','Callback',@menuActionCallback);
m3 = uimenu(u1,'Label','Export output curves...','Callback',@menuActionCallback);
m4 = uimenu(u1,'Label','Export measurement metadata...','Callback',@menuActionCallback);

set(handles.uitreeObj,'UIContextMenu',u1);

handles.frameNum = 1;
set(handles.slider1,'Value',1);
set(handles.frameNumText,'String',{''});

% setup callback functions and listeners
% handles.uitreeObj.MouseClickedCallback = @(h,e,ha) uitree_mouseClicked_Callback(hObject, ...
%     eventdata, handles);

handles.uitreeObj.SelectionChangeFcn  = @(h, e, ha) uitree_selectionChanged_Callback(hObject, ...
    eventdata, handles);


% set selected nodes empty
handles.selectedNodes = [];
handles.treeNodeStruct = [];

% update gui handles
guidata(hObject,handles)
handles = guidata(hObject);

% clear info panel
setInfoText(hObject, eventdata, handles)

% clear channel name and set value to 1
set(handles.lutChannelsPopupMenu,'String',{''});
set(handles.lutChannelsPopupMenu,'Value',1);

% show empty frame
show_frame(hObject, eventdata, handles);
guidata(hObject, handles);



% --- Executes on selection change in lutChannelsPopupMenu.
function lutChannelsPopupMenu_Callback(hObject, eventdata, handles)
% hObject    handle to lutChannelsPopupMenu (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns lutChannelsPopupMenu contents as cell array
%        contents{get(hObject,'Value')} returns selected item from lutChannelsPopupMenu
%channelNum = get(hObject,'Value');

% get tree item -> if it is not a measurement, just return
if(~isfield(handles.uitreeObj.SelectedNodes(1).Value,'channels') )
    disp('Not a measurement unit');
    return;
end

%handles.treeNodeStruct = handles.uitreeObj.SelectedNodes(1).Value;
%set(handles.lutChannelsPopupMenu,'Value',1);

% show frame
show_frame(hObject, eventdata, handles);



% --- Executes during object creation, after setting all properties.
function lutChannelsPopupMenu_CreateFcn(hObject, eventdata, handles)
% hObject    handle to lutChannelsPopupMenu (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


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
%frameNum = fix(get(handles.slider1,'Value'));
%set(handles.slider1,'Value',frameNum);
%set(handles.frameNumText,'String',num2str(handles.frameNum));

set(handles.frameNumText,'String',num2str(handles.frameNum));
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



function frameNumText_Callback(hObject, eventdata, handles)
% hObject    handle to frameNumText (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of frameNumText as text
%        str2double(get(hObject,'String')) returns contents of frameNumText as a double

% not do anything with text if there is no treenode selected or the
% selected node is not a measurement
selectedNodes = handles.uitreeObj.SelectedNodes;

if(isempty(selectedNodes) || ...
        ~isfield(selectedNodes(1).Value,'channels') )
    set(handles.errorMessageText,'String',['Frame can only be set if '...
        'the selected item is a measurement data.']);
    return;
end

%validateattributes(sliderValue,{'double'},{'scalar','nonnan'});
sliderValue = fix(str2double(get(handles.frameNumText,'String')));
if(isnan(sliderValue) || ~isscalar(sliderValue))
    set(handles.errorMessageText,'String','Frame number must be a numeric value.')
    return;
end
set(handles.errorMessageText,'String','');

sliderMin = get(handles.slider1,'Min');
sliderMax = get(handles.slider1,'Max');

sliderValue = clamp(sliderMin, sliderValue ,sliderMax);
handles.frameNum = sliderValue;

set(handles.slider1,'Value',sliderValue);
set(handles.frameNumText,'String',num2str(sliderValue));
guidata(hObject,handles);
show_frame(hObject, eventdata, handles);


%disp('FrameNumText callback called');

% --- Executes during object creation, after setting all properties.
function frameNumText_CreateFcn(hObject, eventdata, handles)
% hObject    handle to frameNumText (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


function uitree_mouseClicked_Callback(hObject, eventdata, handles)

%set(handles.listbox1,'String','mouse clicked');
%setInfoText(hObject, eventdata, handles);
handles.uitreeObj.SelectedNodes
disp('mouse clicked');

function uitree_selectionChanged_Callback(hObject, eventdata, handles)

% one node is surely selected
%handles.treeNodeStruct = handles.uitreeObj.SelectedNodes(1).Value;
handles.selectedNodes = handles.uitreeObj.SelectedNodes;
if(~isempty(handles.selectedNodes))
    handles.treeNodeStruct = handles.selectedNodes(1).Value;
else
    handles.treeNodeStruct = [];
end

% save handles and update
guidata(hObject,handles);
handles = guidata(hObject);


% set info text
setInfoText(hObject, eventdata, handles);

%handles.treeNodeStruct = handles.uitreeObj.SelectedNodes(1).Value.data;
%handles.treeNodeStruct = handles.selectedNodes.Value.data;

% set LUT names in popup menu when selected node is channel
if(isfield(handles.treeNodeStruct,'channels') && ...
        isfield(handles.treeNodeStruct,'dimensions') && ...
        ismember(length(handles.treeNodeStruct.dimensions),[2,3]))
    
    channelNum = length(handles.treeNodeStruct.channels);
    channelNames = cell(channelNum,1);
    for i=1:channelNum
        channelNames{i,1} = handles.treeNodeStruct.channels(i).data.name;
    end
    set(handles.lutChannelsPopupMenu,'String', channelNames);
else
    set(handles.lutChannelsPopupMenu,'String', {''});
end

% set channel selection value to 1 (minimum number of channels)
set(handles.lutChannelsPopupMenu,'Value',1);
set(handles.slider1,'Value',1);
set(handles.errorMessageText,'String','');

if(isfield(handles.treeNodeStruct,'dimensions') && ismember(length(handles.treeNodeStruct.dimensions),[2,3]))
    dimSize = length(handles.treeNodeStruct.dimensions);
    % set slider min/max values
    set(handles.slider1,'Min',1);
    if(dimSize == 3)
        set(handles.slider1,'Max', handles.treeNodeStruct.dimensions(3).size);
        set(handles.slider1,'SliderStep',[1/(handles.treeNodeStruct.dimensions(3).size -1),...
            1/(handles.treeNodeStruct.dimensions(3).size -1)]);
    else
        set(handles.slider1,'Max', 1);
        set(handles.slider1,'SliderStep',[0 0]);        
    end
    
    % set slider value edit box
    %set(handles.frameNumText,'String',num2str(handles.frameNum));
    set(handles.frameNumText,'String','1');
    
    % make label conversion
    % check rotation, and set the labeling according to it
    if(~isfield(handles.treeNodeStruct,'rotationQuaternion'))
        error('Internal error: No fieldname rotationQuaternion is present.');
    end
    rotationQuaternion = handles.treeNodeStruct.rotationQuaternion;
    conversionStructX = handles.treeNodeStruct.dimensions(1).conversion;
    conversionStructY = handles.treeNodeStruct.dimensions(2).conversion;
    sizeX = handles.treeNodeStruct.dimensions(1).size;
    sizeY = handles.treeNodeStruct.dimensions(2).size;
    
    xLabel = 1:sizeX;
    yLabel = 1:sizeY;
    
    xLabel = convertAxisLabel(xLabel,conversionStructX);
    yLabel = convertAxisLabel(yLabel,conversionStructY);
    
    % [0;0;0;1] - no rotation, in case of rotation, no change
    if(isequal(rotationQuaternion,[0;0;0;1]))
        xLabel = xLabel + handles.treeNodeStruct.translation(1) - handles.treeNodeStruct.labelingOrigin(1);
        yLabel = yLabel + handles.treeNodeStruct.translation(2) - handles.treeNodeStruct.labelingOrigin(2);
    end
    
    %choose 5 points for labeling and save the labels
    handles.xLabel = linspace(xLabel(1),xLabel(end),5);
    handles.yLabel = linspace(yLabel(1),yLabel(end),5);
    
    handles.xTicks = fix(linspace(1,handles.treeNodeStruct.dimensions(1).size,5));
    handles.yTicks = fix(linspace(1,handles.treeNodeStruct.dimensions(2).size,5));
    
    %     set(handles.axes1,'XTick',xTicks, 'XTickLabel',...
    %         fix(handles.xLabel));
    %     set(handles.axes1, 'YTick',yTicks, 'YTickLabel',...
    %         fliplr(fix(handles.yLabel)));
    
    handles.xlabelText = strcat(handles.treeNodeStruct.dimensions(1).conversion.title,'[',...
        handles.treeNodeStruct.dimensions(1).conversion.unitName,...
        ']');
    handles.ylabelText = strcat(handles.treeNodeStruct.dimensions(2).conversion.title,'[',...
        handles.treeNodeStruct.dimensions(2).conversion.unitName,...
        ']');
    %     xlabel(handles.axes1,labelX);
    %     ylabel(handles.axes1,labelY);
else
    set(handles.frameNumText,'String','');
end

if(isfield(handles.treeNodeStruct,'dimensions') && ~ismember(length(handles.treeNodeStruct.dimensions),[2,3]))
        set(handles.errorMessageText,'String','Only data that are 2 or 3D can be shown.');
end


guidata(hObject, handles);
show_frame(hObject, eventdata, handles);
%disp('selections changed');


function setInfoText(hObject, eventdata, handles)

infoStr = struct;
infoStr.column1 = "";
infoStr.column2 = "";

if(~isempty(handles.selectedNodes))
    % if(length(handles.uitreeObj.SelectedNodes) > 1)
    %     error('Only one node can be selected at a time');
    % end
    %handles.treeNodeStruct = handles.uitreeObj.SelectedNodes(1).Value.data;
    %handles.treeNodeStruct = handles.selectedNodes(1).Value.data;
    
    if(~isfield(handles.treeNodeStruct,'handle'))
        error('Internal error: tree node structure has no handle field.'); % should not occur
    end
    
    validateattributes(handles.treeNodeStruct.handle,{'numeric'},{'vector','nonempty','nonnegative','integer'});
    
    %if(isfield(handles.treeNodeStruct,'measurementSessions'))
    if(length(handles.treeNodeStruct.handle) == 1)
        % type: mesc file handle
        if(isfield(handles.treeNodeStruct,'measurementSessions'))
            infoStr.column1 = string({"Item type";"Path";"Status";"Is modified";"Is compressible";...
                "Created";"Modified";"Saved";"Measurement sessions"});
            
            infoStr.column2 = string({"MESc file"; handles.treeNodeStruct.path; handles.treeNodeStruct.status;...
                handles.treeNodeStruct.isModified; handles.treeNodeStruct.isCompressible; handles.treeNodeStruct.created;...
                handles.treeNodeStruct.modified; handles.treeNodeStruct.saved; length(handles.treeNodeStruct.measurementSessions)});
        end
        %elseif(isfield(handles.treeNodeStruct,'measurements'))
    elseif(length(handles.treeNodeStruct.handle) == 2)
        % type: measurement session
        if(isfield(handles.treeNodeStruct,'measurements'))
            infoStr.column1 = string({"Item type"; "Measurements"});
            infoStr.column2 = string({"Measurement session"; ...
                length(handles.treeNodeStruct.measurements)} );
        else
            % file is new -> no measurement field
            infoStr.column1 = string({"Item type"; "Measurements"});
            infoStr.column2 = string({"Measurement session"; 0});
        end
    else
        if(~isfield(handles.treeNodeStruct,'type'))
            error('Internal error: tree node structure should have ''type'' field.');
        end
        % type can be 'group' or 'measurement'
        if( strcmp(handles.treeNodeStruct.type,'group') )           
            infoStr.column1 = string({"Item type";"Date";"Creator";"Creator revision";...
                "Profile name";"User name";"Host name";"Setup name";...
                "Measurements"});
            infoStr.column2 = string({"Measurement group"; handles.treeNodeStruct.date; handles.treeNodeStruct.creatingMEScVersion;...
                handles.treeNodeStruct.creatingMEScRevision; handles.treeNodeStruct.profileName;...
                handles.treeNodeStruct.userName; handles.treeNodeStruct.hostName; handles.treeNodeStruct.setupName;...
                length(handles.treeNodeStruct.measurements)});
            
        elseif( strcmp(handles.treeNodeStruct.type,'measurement') )
            % handle length >= 3 : measurement unit: group or measurement
            infoStr.column1 = string({"Item type";"Date";"Creator";"Creator revision";...
                "Profile name";"User name";"Host name";"Setup name";...
                "is being recorded";"Measurement type";"Dimensions";"Channels";"Bits per sample";...
                "XY pixel size";"Z from the zero level"});
            
            xyPixelSize = sprintf('%.5f %s x %.5f %s',handles.treeNodeStruct.dimensions(1).conversion.scale,...
                handles.treeNodeStruct.dimensions(1).conversion.unitName, ...
                handles.treeNodeStruct.dimensions(2).conversion.scale,...
                handles.treeNodeStruct.dimensions(2).conversion.unitName);
            zFromZeroLevel = sprintf('%.2f %s',handles.treeNodeStruct.labelingOrigin(3),...
                handles.treeNodeStruct.dimensions(1).conversion.unitName);
            
            dimSize = numel(handles.treeNodeStruct.dimensions);
            dimensions = strcat('%d',repmat(' x %d',1,dimSize-1));
            dimensions = sprintf(dimensions,handles.treeNodeStruct.dimensions(1:dimSize).size);
            %dimensions = sprintf('%d x %d x %d',handles.treeNodeStruct.dimensions(1).size,...
            %    handles.treeNodeStruct.dimensions(2).size,handles.treeNodeStruct.dimensions(3).size);
            
            channelNum = length(handles.treeNodeStruct.channels);
            channelNames = [];
            if(channelNum > 0)
                for i=1:channelNum
                    channelNames = strcat(channelNames, sprintf('%s,',handles.treeNodeStruct.channels(i).data.name));
                end
                %remove ',' from the end
                channelNames(end) = [];
            end
            
            %     channelNames = sprintf('%s,%s,%s',handles.treeNodeStruct.channels(1).name,...
            %         handles.treeNodeStruct.channels(2).name, handles.treeNodeStruct.channels(3).name);
            duration = handles.treeNodeStruct.measurementInfo.duration;
            if(~isnumeric(duration))
                error('Measurement duration must be an integer number.');
            end
            if(duration > 0)
                duration = sprintf('%.1f s',duration/1000);
            else
                duration = "N/A";
            end
            
            bitsPerSample = handles.treeNodeStruct.measurementInfo.bitsPerSample;
            if(~isnumeric(bitsPerSample))
                error('Bits per sample must be a positive numeric value');
            end
            if(bitsPerSample > 0)
                bitsPerSample = sprintf('%d',bitsPerSample);
            else
                bitsPerSample = "N/A";
            end
            
            
%             infoStr.column2 = string({"Measurement"; handles.treeNodeStruct.date; handles.treeNodeStruct.creatingMEScVersion;...
%                 handles.treeNodeStruct.creatingMEScRevision; handles.treeNodeStruct.profileName;...
%                 handles.treeNodeStruct.userName; handles.treeNodeStruct.hostName; handles.treeNodeStruct.setupName;...
%                 "N/A";handles.treeNodeStruct.isBeingRecorded; handles.treeNodeStruct.measurementType; dimensions; ....
%                 channelNames; "N/A"; bitsPerSample;...
%                 xyPixelSize;"N/A"; zFromZeroLevel;...
%                 "N/A";duration});
              infoStr.column2 = string({"Measurement"; handles.treeNodeStruct.date; handles.treeNodeStruct.creatingMEScVersion;...
                handles.treeNodeStruct.creatingMEScRevision; handles.treeNodeStruct.profileName;...
                handles.treeNodeStruct.userName; handles.treeNodeStruct.hostName; handles.treeNodeStruct.setupName;...
                handles.treeNodeStruct.isBeingRecorded; handles.treeNodeStruct.measurementType; dimensions; ....
                channelNames; bitsPerSample;...
                xyPixelSize; zFromZeroLevel});
        end
    end
end

% set text in table
%set(handles.infoTable,'Visible','on');
%colWidth = max(cat(1,infoStr.column1.strlength,infoStr.column2.strlength));
%handles.infoTable.Position(1:3) = [0.0 0.0 colWidth];%handles.infoTable.Extent(3:4);
handles.infoTable.Position = [0.0 0.0 1.0 1.0];%handles.infoTable.Extent(3:4);

%set(handles.infoTable,'ColumnWidth',colWidth);
%set(handles.infoTable,'Data',[cellstr(infoStr.column1) cellstr(infoStr.column2)]);
set(handles.infoTable,'Data',cellstr([infoStr.column1 infoStr.column2]));


guidata(hObject, handles);

% --- Executes during object creation, after setting all properties.
function infoTable_CreateFcn(hObject, eventdata, handles)
% hObject    handle to infoTable (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called
handles.infoTable = gcbo;
set(handles.infoTable,'Visible','on');
set(handles.infoTable,'Units','normalized');
guidata(hObject, handles);


function show_frame(hObject, eventdata, handles)

% do not show anything if clicked handle is not a channel handle

% if(isempty(handles.uitreeObj.SelectedNodes) || ...
%         ~isfield(handles.uitreeObj.SelectedNodes(1).Value.data,'channels'))
%     imagesc(handles.axes1,[]);
%     return;
% end
if(isempty(handles.selectedNodes) || ...
        ~isfield(handles.treeNodeStruct,'channels') || ...
        ~ismember(length(handles.treeNodeStruct.dimensions),[2,3]))
    imagesc(handles.axes1,[]);
    return;
end
%handles.treeNodeStruct = handles.uitreeObj.SelectedNodes(1).Value.data;
%handles.treeNodeStruct = handles.selectedNodes(1).Value.data;
%check if choosen field in the treeView is measurement data
if(isfield(handles.treeNodeStruct,'channels'))
    % get the channel number selected from the popupmenu
    chnum = get(handles.lutChannelsPopupMenu,'Value');
    % for debug
    if(length(handles.treeNodeStruct.channels) < chnum)
        error(['Internal error: The selected channel number should be less'...
            'than or equal to the number of channels']);
    end
    handles.image = readChannelData(handles.mescAPIObj, (handles.treeNodeStruct.channels(chnum).data.handle)',...
        'uint16', {[1:handles.treeNodeStruct.dimensions(1).size], ...
        [1:handles.treeNodeStruct.dimensions(2).size],[handles.frameNum:handles.frameNum] } );
    %     frameNum = get(handles.slider1,'Value');
    %     handles.image = readChannelData(handles.mescAPIObj, (handles.treeNodeStruct.channels(chnum).handle)',...
    %         'uint16', [[1 handles.treeNodeStruct.dimensions(1).size] ...
    %         [1 handles.treeNodeStruct.dimensions(2).size] [frameNum+1  frameNum+1] ] );
    lutObj = LUT(handles.treeNodeStruct.channels(chnum).data.clut);
    image = lutObj.convertChannelToARGB(handles.image);
    imagesc(handles.axes1,image(:,:,2:4));
    %imagesc(handles.axes1,handles.image);
    %     xTicks = fix(linspace(1,handles.treeNodeStruct.dimensions(1).size,5));
    %     yTicks = fix(linspace(1,handles.treeNodeStruct.dimensions(2).size,5));
    %
    set(handles.axes1,'XTick',handles.xTicks, 'XTickLabel',...
        fix(handles.xLabel));
    set(handles.axes1, 'YTick',handles.yTicks, 'YTickLabel',...
        fliplr(fix(handles.yLabel)));
    %
    %     labelX = strcat(handles.treeNodeStruct.dimensions(1).conversion.title,'[',...
    %         handles.treeNodeStruct.dimensions(1).conversion.unitName,...
    %         ']');
    %     labelY = strcat(handles.treeNodeStruct.dimensions(2).conversion.title,'[',...
    %         handles.treeNodeStruct.dimensions(2).conversion.unitName,...
    %         ']');
    xlabel(handles.axes1,handles.xlabelText);
    ylabel(handles.axes1,handles.ylabelText);
end
%imagesc(handles.axes1,handles.image)
guidata(hObject, handles);


function menuActionCallback(source,callbackdata)

    handles = guidata(gcf);
    if(isempty(handles.selectedNodes))
        set(handles.errorMessageText,'String',['Could not batch export curves, '...
            'because no measurement unit is selected.']);
        return;
    end

    % check if all selected nodes are measurement units
    selectedNodes = handles.selectedNodes;
    for i=1:length(selectedNodes)
        if(~isfield(handles.selectedNodes(i).Value,'type') || ~strcmp(handles.selectedNodes(i).Value.type,'measurement'))
            errordlg(strcat(['Could not batch export curves, '...
                'because not all selected items are measurement units.']));
            return;
        end
    end
    
    % gather selected nodes into cell array
%     selectedMUnitNodes = [];
%     for node = handles.selectedNodes
%         if(isempty(selectedMUnitNodes))
%             selectedMUnitNodes = {node.Value.handle};
%         else
%             selectedMUnitNodes = {selectedMUnitNodes node.Value.handle};            
%         end
%     end
    
    selectedMUnitNodes = cell(1,length(selectedNodes));
    for i=1:length(selectedNodes)
        selectedMUnitNodes{i} = selectedNodes(i).Value.handle;
    end
 
    switch source.Label
        case 'Run nrmc'
            nrmc();
        case 'Export measurement metadata...'
            exportMeasurementMetaData(selectedMUnitNodes, handles);
        case 'Export input curves...'
            selectAndExportCurves(selectedMUnitNodes, 'Input', handles);

        case 'Export output curves...'
            selectAndExportCurves(selectedMUnitNodes, 'Output', handles);
    end
    

 function selectAndExportCurves(selectedMUnitNodes, channelType, handles)
    commonCurveMetaDataTable = handles.mescAPIObj.getCommonCurvesMetaDataTable(selectedMUnitNodes,channelType);
    if(~isempty(commonCurveMetaDataTable))
        [absoluteFilePath, filename, ext, selectedChannels] = browser_batch_export_curves(unique(commonCurveMetaDataTable.curveName,'stable'));
        if(~isempty(absoluteFilePath))
            % save files
            %try
                absoluteFilePath = strcat(absoluteFilePath,filename);
                if(strcmp(ext,'.txt'))
                    exportedFileNames = handles.mescAPIObj.batchExportCurvesTxt(commonCurveMetaDataTable,selectedMUnitNodes,selectedChannels,absoluteFilePath);
                elseif(strcmp(ext,'.mat'))
                    exportedFileNames = handles.mescAPIObj.batchExportCurvesMat(commonCurveMetaDataTable,selectedMUnitNodes,selectedChannels,absoluteFilePath);
                else
                    uiwait(errordlg('Could not save curve data to file, because the selected file extension is not supported.'));
                    return;
                end

                uiwait(msgbox({'Curve data from selected measurement units and channels were successfully exported to '; ...
                    sprintf('%s\n',exportedFileNames{:})}));
%             catch ME
%                 uiwait(errordlg({'Error while exporting measurement metadata. Cause: '; ...
%                       sprintf('%s\n',ME.message)}));                  
%             end
        end
    else
       uiwait(msgbox(strcat('No common ', lower(channelType),' channels were found in the selected measurement units.')));
    end
    
    
    
function exportMeasurementMetaData(selectedMUnitNodes, handles)
         
    % file path selector, and enter batch file name for export
    filter = {'*.json'};
    
    [fileName, absolutePath, ~] = uiputfile(filter,'Select path','exported_metadata');
    
    if(fileName ~= 0) % if user hasn't cancelled dialog box
        try
            ext = strrep(filter{1},'*','');
            fileName = strrep(fileName,ext,'');
            absolutePath = strrep(absolutePath,'\','/');
            fileName = strcat(absolutePath,fileName);

            exportedFileNames = handles.mescAPIObj.batchExportMeasurementMetaData(selectedMUnitNodes,fileName);

            uiwait(msgbox({'Measurement metadata json of selected units were successfully exported to file(s) '; ...
                    sprintf('%s\n',exportedFileNames{:})}));
        catch ME
            uiwait(errordlg({'Error while exporting measurement metadata. Cause: '; ...
                    sprintf('%s\n',ME.message)}));            
        end
    end
        
    
    
% --- Executes during object creation, after setting all properties.
function figure1_CreateFcn(hObject, eventdata, handles)
% hObject    handle to figure1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called


% --- Executes on button press in pushbutton3.
function pushbutton3_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
nrmc();
