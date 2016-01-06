function varargout = gui_v2(varargin)
% GUI_V2 MATLAB code for gui_v2.fig
%      GUI_V2, by itself, creates a new GUI_V2 or raises the existing
%      singleton*.
%
%      H = GUI_V2 returns the handle to a new GUI_V2 or the handle to
%      the existing singleton*.
%
%      GUI_V2('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in GUI_V2.M with the given input arguments.
%
%      GUI_V2('Property','Value',...) creates a new GUI_V2 or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before gui_v2_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to gui_v2_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help gui_v2

% Last Modified by GUIDE v2.5 31-Aug-2015 12:43:04

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @gui_v2_OpeningFcn, ...
                   'gui_OutputFcn',  @gui_v2_OutputFcn, ...
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


% --- Executes just before gui_v2 is made visible.
function gui_v2_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to gui_v2 (see VARARGIN)

% Choose default command line output for gui_v2
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes gui_v2 wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = gui_v2_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


%% Summary Table

function checkboxSummaryTable_Callback(hObject, eventdata, handles)
handles.options.output.summary.format = get(hObject,'Value');
guidata(hObject,handles)

function editSummaryTableFolder_Callback(hObject, eventdata, handles)
handles.options.output.summary.dir = get(hObject,'String');
guidata(hObject,handles)
function editSummaryTableFolder_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

function editSummaryTableFile_Callback(hObject, eventdata, handles)
handles.options.output.summary.fileName = get(hObject,'String');
guidata(hObject,handles)
function editSummaryTableFile_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

function popupmenuSummaryTableFormat_Callback(hObject, eventdata, handles)
handles.options.output.summary.format = contents{get(hObject,'Value')};
guidata(hObject,handles)
function popupmenuSummaryTableFormat_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

%% Spheroids Table

function checkboxSpheroidsTable_Callback(hObject, eventdata, handles)
handles.options.output.msrAll.format = get(hObject,'Value');
guidata(hObject,handles)

function editSpheroidsTableFolder_Callback(hObject, eventdata, handles)
handles.options.output.msrAll.dir = get(hObject,'String');
guidata(hObject,handles)
function editSpheroidsTableFolder_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

function editSpheroidsTableFile_Callback(hObject, eventdata, handles)
handles.options.output.msrAll.fileName = get(hObject,'String');
guidata(hObject,handles)
function editSpheroidsTableFile_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

function popupmenuSpheroidsTableFormat_Callback(hObject, eventdata, handles)
handles.options.output.msrAll.format = contents{get(hObject,'Value')};
guidata(hObject,handles)
function popupmenuSpheroidsTableFormat_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


%% Spots Table

function checkboxSpotsTable_Callback(hObject, eventdata, handles)
handles.options.output.spotsAll.format = get(hObject,'Value');
guidata(hObject,handles)

function editSpotsTableFolder_Callback(hObject, eventdata, handles)
handles.options.output.spotsAll.dir = get(hObject,'String');
guidata(hObject,handles)
function editSpotsTableFolder_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

function editSpotsTableFile_Callback(hObject, eventdata, handles)
handles.options.output.spotsAll.fileName = get(hObject,'String');
guidata(hObject,handles)
function editSpotsTableFile_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

function popupmenuSpotsTableFormat_Callback(hObject, eventdata, handles)
handles.options.output.spotsAll.format = contents{get(hObject,'Value')};
guidata(hObject,handles)
function popupmenuSpotsTableFormat_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

%% Images

%% Image spots

function editImgSpotsPattern_Callback(hObject, eventdata, handles)
% hObject    handle to editImgSpotsPattern (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of editImgSpotsPattern as text
%        str2double(get(hObject,'String')) returns contents of editImgSpotsPattern as a double


% --- Executes during object creation, after setting all properties.
function editImgSpotsPattern_CreateFcn(hObject, eventdata, handles)
% hObject    handle to editImgSpotsPattern (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on selection change in popupmenuImgSpotsFormat.
function popupmenuImgSpotsFormat_Callback(hObject, eventdata, handles)
% hObject    handle to popupmenuImgSpotsFormat (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns popupmenuImgSpotsFormat contents as cell array
%        contents{get(hObject,'Value')} returns selected item from popupmenuImgSpotsFormat


% --- Executes during object creation, after setting all properties.
function popupmenuImgSpotsFormat_CreateFcn(hObject, eventdata, handles)
% hObject    handle to popupmenuImgSpotsFormat (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in checkboxImgSpots.
function checkboxImgSpots_Callback(hObject, eventdata, handles)
% hObject    handle to checkboxImgSpots (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of checkboxImgSpots



function editImgSpotsFolder_Callback(hObject, eventdata, handles)
% hObject    handle to editImgSpotsFolder (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of editImgSpotsFolder as text
%        str2double(get(hObject,'String')) returns contents of editImgSpotsFolder as a double


% --- Executes during object creation, after setting all properties.
function editImgSpotsFolder_CreateFcn(hObject, eventdata, handles)
% hObject    handle to editImgSpotsFolder (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function editImgSpheroidsPattern_Callback(hObject, eventdata, handles)
% hObject    handle to editImgSpheroidsPattern (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of editImgSpheroidsPattern as text
%        str2double(get(hObject,'String')) returns contents of editImgSpheroidsPattern as a double


% --- Executes during object creation, after setting all properties.
function editImgSpheroidsPattern_CreateFcn(hObject, eventdata, handles)
% hObject    handle to editImgSpheroidsPattern (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in checkboxImgSpheroids.
function checkboxImgSpheroids_Callback(hObject, eventdata, handles)
% hObject    handle to checkboxImgSpheroids (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of checkboxImgSpheroids



function editImgSpheroidsFolder_Callback(hObject, eventdata, handles)
% hObject    handle to editImgSpheroidsFolder (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of editImgSpheroidsFolder as text
%        str2double(get(hObject,'String')) returns contents of editImgSpheroidsFolder as a double


% --- Executes during object creation, after setting all properties.
function editImgSpheroidsFolder_CreateFcn(hObject, eventdata, handles)
% hObject    handle to editImgSpheroidsFolder (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function editOverlayTopPattern_Callback(hObject, eventdata, handles)
% hObject    handle to editOverlayTopPattern (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of editOverlayTopPattern as text
%        str2double(get(hObject,'String')) returns contents of editOverlayTopPattern as a double


% --- Executes during object creation, after setting all properties.
function editOverlayTopPattern_CreateFcn(hObject, eventdata, handles)
% hObject    handle to editOverlayTopPattern (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in checkboxOverlayTop.
function checkboxOverlayTop_Callback(hObject, eventdata, handles)
% hObject    handle to checkboxOverlayTop (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of checkboxOverlayTop



function editOverlayTopFolder_Callback(hObject, eventdata, handles)
% hObject    handle to editOverlayTopFolder (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of editOverlayTopFolder as text
%        str2double(get(hObject,'String')) returns contents of editOverlayTopFolder as a double


% --- Executes during object creation, after setting all properties.
function editOverlayTopFolder_CreateFcn(hObject, eventdata, handles)
% hObject    handle to editOverlayTopFolder (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function editOverlaySidePattern_Callback(hObject, eventdata, handles)
% hObject    handle to editOverlaySidePattern (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of editOverlaySidePattern as text
%        str2double(get(hObject,'String')) returns contents of editOverlaySidePattern as a double


% --- Executes during object creation, after setting all properties.
function editOverlaySidePattern_CreateFcn(hObject, eventdata, handles)
% hObject    handle to editOverlaySidePattern (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in checkboxOverlaySide.
function checkboxOverlaySide_Callback(hObject, eventdata, handles)
% hObject    handle to checkboxOverlaySide (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of checkboxOverlaySide



function editOverlaySideFolder_Callback(hObject, eventdata, handles)
% hObject    handle to editOverlaySideFolder (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of editOverlaySideFolder as text
%        str2double(get(hObject,'String')) returns contents of editOverlaySideFolder as a double


% --- Executes during object creation, after setting all properties.
function editOverlaySideFolder_CreateFcn(hObject, eventdata, handles)
% hObject    handle to editOverlaySideFolder (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function editContourPattern_Callback(hObject, eventdata, handles)
% hObject    handle to editContourPattern (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of editContourPattern as text
%        str2double(get(hObject,'String')) returns contents of editContourPattern as a double


% --- Executes during object creation, after setting all properties.
function editContourPattern_CreateFcn(hObject, eventdata, handles)
% hObject    handle to editContourPattern (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in checkboxContour.
function checkboxContour_Callback(hObject, eventdata, handles)
% hObject    handle to checkboxContour (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of checkboxContour



function editContourFolder_Callback(hObject, eventdata, handles)
% hObject    handle to editContourFolder (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of editContourFolder as text
%        str2double(get(hObject,'String')) returns contents of editContourFolder as a double


% --- Executes during object creation, after setting all properties.
function editContourFolder_CreateFcn(hObject, eventdata, handles)
% hObject    handle to editContourFolder (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function editContourSpots2DPattern_Callback(hObject, eventdata, handles)
% hObject    handle to editContourSpots2DPattern (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of editContourSpots2DPattern as text
%        str2double(get(hObject,'String')) returns contents of editContourSpots2DPattern as a double


% --- Executes during object creation, after setting all properties.
function editContourSpots2DPattern_CreateFcn(hObject, eventdata, handles)
% hObject    handle to editContourSpots2DPattern (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in checkboxContourSpots2D.
function checkboxContourSpots2D_Callback(hObject, eventdata, handles)
% hObject    handle to checkboxContourSpots2D (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of checkboxContourSpots2D



function editContourSpots2DFolder_Callback(hObject, eventdata, handles)
% hObject    handle to editContourSpots2DFolder (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of editContourSpots2DFolder as text
%        str2double(get(hObject,'String')) returns contents of editContourSpots2DFolder as a double


% --- Executes during object creation, after setting all properties.
function editContourSpots2DFolder_CreateFcn(hObject, eventdata, handles)
% hObject    handle to editContourSpots2DFolder (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on selection change in popupmenuImgSpheroidsFormat.
function popupmenuImgSpheroidsFormat_Callback(hObject, eventdata, handles)
% hObject    handle to popupmenuImgSpheroidsFormat (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns popupmenuImgSpheroidsFormat contents as cell array
%        contents{get(hObject,'Value')} returns selected item from popupmenuImgSpheroidsFormat


% --- Executes during object creation, after setting all properties.
function popupmenuImgSpheroidsFormat_CreateFcn(hObject, eventdata, handles)
% hObject    handle to popupmenuImgSpheroidsFormat (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on selection change in popupmenuOverlayTopFormat.
function popupmenuOverlayTopFormat_Callback(hObject, eventdata, handles)
% hObject    handle to popupmenuOverlayTopFormat (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns popupmenuOverlayTopFormat contents as cell array
%        contents{get(hObject,'Value')} returns selected item from popupmenuOverlayTopFormat


% --- Executes during object creation, after setting all properties.
function popupmenuOverlayTopFormat_CreateFcn(hObject, eventdata, handles)
% hObject    handle to popupmenuOverlayTopFormat (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on selection change in popupmenuOverlaySideFormat.
function popupmenuOverlaySideFormat_Callback(hObject, eventdata, handles)
% hObject    handle to popupmenuOverlaySideFormat (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns popupmenuOverlaySideFormat contents as cell array
%        contents{get(hObject,'Value')} returns selected item from popupmenuOverlaySideFormat


% --- Executes during object creation, after setting all properties.
function popupmenuOverlaySideFormat_CreateFcn(hObject, eventdata, handles)
% hObject    handle to popupmenuOverlaySideFormat (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on selection change in popupmenuContourFormat.
function popupmenuContourFormat_Callback(hObject, eventdata, handles)
% hObject    handle to popupmenuContourFormat (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns popupmenuContourFormat contents as cell array
%        contents{get(hObject,'Value')} returns selected item from popupmenuContourFormat


% --- Executes during object creation, after setting all properties.
function popupmenuContourFormat_CreateFcn(hObject, eventdata, handles)
% hObject    handle to popupmenuContourFormat (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on selection change in popupmenuContourSpots2DFormat.
function popupmenuContourSpots2DFormat_Callback(hObject, eventdata, handles)
% hObject    handle to popupmenuContourSpots2DFormat (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns popupmenuContourSpots2DFormat contents as cell array
%        contents{get(hObject,'Value')} returns selected item from popupmenuContourSpots2DFormat


% --- Executes during object creation, after setting all properties.
function popupmenuContourSpots2DFormat_CreateFcn(hObject, eventdata, handles)
% hObject    handle to popupmenuContourSpots2DFormat (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function editContourSpots3DPattern_Callback(hObject, eventdata, handles)
% hObject    handle to editContourSpots3DPattern (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of editContourSpots3DPattern as text
%        str2double(get(hObject,'String')) returns contents of editContourSpots3DPattern as a double


% --- Executes during object creation, after setting all properties.
function editContourSpots3DPattern_CreateFcn(hObject, eventdata, handles)
% hObject    handle to editContourSpots3DPattern (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in checkboxContourSpots3D.
function checkboxContourSpots3D_Callback(hObject, eventdata, handles)
% hObject    handle to checkboxContourSpots3D (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of checkboxContourSpots3D



function editContourSpots3DFolder_Callback(hObject, eventdata, handles)
% hObject    handle to editContourSpots3DFolder (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of editContourSpots3DFolder as text
%        str2double(get(hObject,'String')) returns contents of editContourSpots3DFolder as a double


% --- Executes during object creation, after setting all properties.
function editContourSpots3DFolder_CreateFcn(hObject, eventdata, handles)
% hObject    handle to editContourSpots3DFolder (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on selection change in popupmenuContourSpots3DFormat.
function popupmenuContourSpots3DFormat_Callback(hObject, eventdata, handles)
% hObject    handle to popupmenuContourSpots3DFormat (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns popupmenuContourSpots3DFormat contents as cell array
%        contents{get(hObject,'Value')} returns selected item from popupmenuContourSpots3DFormat


% --- Executes during object creation, after setting all properties.
function popupmenuContourSpots3DFormat_CreateFcn(hObject, eventdata, handles)
% hObject    handle to popupmenuContourSpots3DFormat (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on selection change in popupmenuImgSpotsColor.
function popupmenuImgSpotsColor_Callback(hObject, eventdata, handles)
% hObject    handle to popupmenuImgSpotsColor (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns popupmenuImgSpotsColor contents as cell array
%        contents{get(hObject,'Value')} returns selected item from popupmenuImgSpotsColor


% --- Executes during object creation, after setting all properties.
function popupmenuImgSpotsColor_CreateFcn(hObject, eventdata, handles)
% hObject    handle to popupmenuImgSpotsColor (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on selection change in popupmenuImgSpotsBitDepth.
function popupmenuImgSpotsBitDepth_Callback(hObject, eventdata, handles)
% hObject    handle to popupmenuImgSpotsBitDepth (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns popupmenuImgSpotsBitDepth contents as cell array
%        contents{get(hObject,'Value')} returns selected item from popupmenuImgSpotsBitDepth


% --- Executes during object creation, after setting all properties.
function popupmenuImgSpotsBitDepth_CreateFcn(hObject, eventdata, handles)
% hObject    handle to popupmenuImgSpotsBitDepth (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on selection change in popupmenuImgSpheroidsColor.
function popupmenuImgSpheroidsColor_Callback(hObject, eventdata, handles)
% hObject    handle to popupmenuImgSpheroidsColor (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns popupmenuImgSpheroidsColor contents as cell array
%        contents{get(hObject,'Value')} returns selected item from popupmenuImgSpheroidsColor


% --- Executes during object creation, after setting all properties.
function popupmenuImgSpheroidsColor_CreateFcn(hObject, eventdata, handles)
% hObject    handle to popupmenuImgSpheroidsColor (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on selection change in popupmenuImgSpheroidsBitDepth.
function popupmenuImgSpheroidsBitDepth_Callback(hObject, eventdata, handles)
% hObject    handle to popupmenuImgSpheroidsBitDepth (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns popupmenuImgSpheroidsBitDepth contents as cell array
%        contents{get(hObject,'Value')} returns selected item from popupmenuImgSpheroidsBitDepth


% --- Executes during object creation, after setting all properties.
function popupmenuImgSpheroidsBitDepth_CreateFcn(hObject, eventdata, handles)
% hObject    handle to popupmenuImgSpheroidsBitDepth (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on selection change in popupmenuOverlayTopColor.
function popupmenuOverlayTopColor_Callback(hObject, eventdata, handles)
% hObject    handle to popupmenuOverlayTopColor (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns popupmenuOverlayTopColor contents as cell array
%        contents{get(hObject,'Value')} returns selected item from popupmenuOverlayTopColor


% --- Executes during object creation, after setting all properties.
function popupmenuOverlayTopColor_CreateFcn(hObject, eventdata, handles)
% hObject    handle to popupmenuOverlayTopColor (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on selection change in popupmenuOverlayTopBitDepth.
function popupmenuOverlayTopBitDepth_Callback(hObject, eventdata, handles)
% hObject    handle to popupmenuOverlayTopBitDepth (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns popupmenuOverlayTopBitDepth contents as cell array
%        contents{get(hObject,'Value')} returns selected item from popupmenuOverlayTopBitDepth


% --- Executes during object creation, after setting all properties.
function popupmenuOverlayTopBitDepth_CreateFcn(hObject, eventdata, handles)
% hObject    handle to popupmenuOverlayTopBitDepth (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on selection change in popupmenuOverlaySideColor.
function popupmenuOverlaySideColor_Callback(hObject, eventdata, handles)
% hObject    handle to popupmenuOverlaySideColor (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns popupmenuOverlaySideColor contents as cell array
%        contents{get(hObject,'Value')} returns selected item from popupmenuOverlaySideColor


% --- Executes during object creation, after setting all properties.
function popupmenuOverlaySideColor_CreateFcn(hObject, eventdata, handles)
% hObject    handle to popupmenuOverlaySideColor (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on selection change in popupmenuOverlaySideBitDepth.
function popupmenuOverlaySideBitDepth_Callback(hObject, eventdata, handles)
% hObject    handle to popupmenuOverlaySideBitDepth (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns popupmenuOverlaySideBitDepth contents as cell array
%        contents{get(hObject,'Value')} returns selected item from popupmenuOverlaySideBitDepth


% --- Executes during object creation, after setting all properties.
function popupmenuOverlaySideBitDepth_CreateFcn(hObject, eventdata, handles)
% hObject    handle to popupmenuOverlaySideBitDepth (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on selection change in popupmenuContourColor.
function popupmenuContourColor_Callback(hObject, eventdata, handles)
% hObject    handle to popupmenuContourColor (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns popupmenuContourColor contents as cell array
%        contents{get(hObject,'Value')} returns selected item from popupmenuContourColor


% --- Executes during object creation, after setting all properties.
function popupmenuContourColor_CreateFcn(hObject, eventdata, handles)
% hObject    handle to popupmenuContourColor (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on selection change in popupmenuContourBitDepth.
function popupmenuContourBitDepth_Callback(hObject, eventdata, handles)
% hObject    handle to popupmenuContourBitDepth (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns popupmenuContourBitDepth contents as cell array
%        contents{get(hObject,'Value')} returns selected item from popupmenuContourBitDepth


% --- Executes during object creation, after setting all properties.
function popupmenuContourBitDepth_CreateFcn(hObject, eventdata, handles)
% hObject    handle to popupmenuContourBitDepth (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on selection change in popupmenuContourSpots2DColor.
function popupmenuContourSpots2DColor_Callback(hObject, eventdata, handles)
% hObject    handle to popupmenuContourSpots2DColor (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns popupmenuContourSpots2DColor contents as cell array
%        contents{get(hObject,'Value')} returns selected item from popupmenuContourSpots2DColor


% --- Executes during object creation, after setting all properties.
function popupmenuContourSpots2DColor_CreateFcn(hObject, eventdata, handles)
% hObject    handle to popupmenuContourSpots2DColor (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on selection change in popupmenuContourSpots2DBitDepth.
function popupmenuContourSpots2DBitDepth_Callback(hObject, eventdata, handles)
% hObject    handle to popupmenuContourSpots2DBitDepth (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns popupmenuContourSpots2DBitDepth contents as cell array
%        contents{get(hObject,'Value')} returns selected item from popupmenuContourSpots2DBitDepth


% --- Executes during object creation, after setting all properties.
function popupmenuContourSpots2DBitDepth_CreateFcn(hObject, eventdata, handles)
% hObject    handle to popupmenuContourSpots2DBitDepth (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on selection change in popupmenuContourSpots3DColor.
function popupmenuContourSpots3DColor_Callback(hObject, eventdata, handles)
% hObject    handle to popupmenuContourSpots3DColor (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns popupmenuContourSpots3DColor contents as cell array
%        contents{get(hObject,'Value')} returns selected item from popupmenuContourSpots3DColor


% --- Executes during object creation, after setting all properties.
function popupmenuContourSpots3DColor_CreateFcn(hObject, eventdata, handles)
% hObject    handle to popupmenuContourSpots3DColor (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on selection change in popupmenuContourSpots3DBitDepth.
function popupmenuContourSpots3DBitDepth_Callback(hObject, eventdata, handles)
% hObject    handle to popupmenuContourSpots3DBitDepth (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns popupmenuContourSpots3DBitDepth contents as cell array
%        contents{get(hObject,'Value')} returns selected item from popupmenuContourSpots3DBitDepth


% --- Executes during object creation, after setting all properties.
function popupmenuContourSpots3DBitDepth_CreateFcn(hObject, eventdata, handles)
% hObject    handle to popupmenuContourSpots3DBitDepth (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function editPlotOverlaySidePattern_Callback(hObject, eventdata, handles)
% hObject    handle to editPlotOverlaySidePattern (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of editPlotOverlaySidePattern as text
%        str2double(get(hObject,'String')) returns contents of editPlotOverlaySidePattern as a double


% --- Executes during object creation, after setting all properties.
function editPlotOverlaySidePattern_CreateFcn(hObject, eventdata, handles)
% hObject    handle to editPlotOverlaySidePattern (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on selection change in popupmenuPlotOverlaySideFormat.
function popupmenuPlotOverlaySideFormat_Callback(hObject, eventdata, handles)
% hObject    handle to popupmenuPlotOverlaySideFormat (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns popupmenuPlotOverlaySideFormat contents as cell array
%        contents{get(hObject,'Value')} returns selected item from popupmenuPlotOverlaySideFormat


% --- Executes during object creation, after setting all properties.
function popupmenuPlotOverlaySideFormat_CreateFcn(hObject, eventdata, handles)
% hObject    handle to popupmenuPlotOverlaySideFormat (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in checkbox11.
function checkbox11_Callback(hObject, eventdata, handles)
% hObject    handle to checkbox11 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of checkbox11



function editPlotOverlaySideFolder_Callback(hObject, eventdata, handles)
% hObject    handle to editPlotOverlaySideFolder (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of editPlotOverlaySideFolder as text
%        str2double(get(hObject,'String')) returns contents of editPlotOverlaySideFolder as a double


% --- Executes during object creation, after setting all properties.
function editPlotOverlaySideFolder_CreateFcn(hObject, eventdata, handles)
% hObject    handle to editPlotOverlaySideFolder (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in pushbuttonOK.
function pushbuttonOK_Callback(hObject, eventdata, handles)
% hObject    handle to pushbuttonOK (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes on button press in pushbuttonSave.
function pushbuttonSave_Callback(hObject, eventdata, handles)
% hObject    handle to pushbuttonSave (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
disp(handles.options)
