function varargout = maingui(varargin)
% MAINGUI M-file for maingui.fig
%      MAINGUI, by itself, creates a new MAINGUI or raises the existing
%      singleton*.
%
%      H = MAINGUI returns the handle to a new MAINGUI or the handle to
%      the existing singleton*.
%
%      MAINGUI('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in MAINGUI.M with the given input arguments.
%
%      MAINGUI('Property','Value',...) creates a new MAINGUI or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before maingui_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to maingui_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES
 
% Edit the above text to modify the response to help maingui
 
% Last Modified by GUIDE v2.5 20-Apr-2013 20:01:37
 
% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @maingui_OpeningFcn, ...
                   'gui_OutputFcn',  @maingui_OutputFcn, ...
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
 
end
% --- Executes just before maingui is made visible.
function maingui_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to maingui (see VARARGIN)
 
% Choose default command line output for maingui
handles.output = hObject;
 
% Update handles structure
guidata(hObject, handles);
 
% UIWAIT makes maingui wait for user response (see UIRESUME)
% uiwait(handles.figure1);
 
end
% --- Outputs from this function are returned to the command line.
function varargout = maingui_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
 
% Get default command line output from handles structure
varargout{1} = handles.output;
 
end
% --- Executes on button press in load_image.
function load_image_Callback(hObject, eventdata, handles)
% hObject    handle to load_image (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
[filename,pathname]=uigetfile('*.bmp','Select an image File');
image=imread(fullfile(pathname,filename));
handles.image=image;
axes(handles.axes1)
imshow(image);
guidata(hObject,handles);
end
 
 
function weighted_normcorr_Callback(hObject, eventdata, handles)
% hObject    handle to weighted_normcorr (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
n=str2num(get(handles.threshold_editor,'string'));
o=str2num(get(handles.rowmin,'string'));
p=str2num(get(handles.rowmax,'string'));
q=str2num(get(handles.colmin,'string'));
r=str2num(get(handles.colmax,'string'));
image=handles.image;
img=image;
%binarizing the image%
img2=img<(graythresh(img)*255);
%Getting the vertical profile of the image%
vertical_profile=any(img2,2);
%getting the horizontal profile of the image%
horizontal_profile=any(img2,1);
%Obtaining the index of the bounding box%
toprow=find(vertical_profile,1,'first');
bottomrow=find(vertical_profile,1,'last');
leftcol=find(horizontal_profile,1,'first');
rightcol=find(horizontal_profile,1,'last');
%Crop it out of the original image%
croppedimage=img(toprow:bottomrow,leftcol:rightcol);
 
croppedimage2=croppedimage(o:p,q:r);
 
%The image is then normalised using the mean value of 0.3922 which
%is (100/255). This is done so as to even out the brightness of the entire image
i2=croppedimage2;
 
%obtaining the image threshold so as to perform binarization
level=graythresh(i2);
 
%Performing the binarization
i3=im2bw(i2,level);
 
%Performing the sliding neighbourhood operation using the cellular automata
%rules set out in the pearsonweight.m file
i4=nlfilter(i3,[3 3],'pearsonweight');
 
found=0; %Found is a variable that determines whether the statement 'match found' or 'no match found' should be output
for a=101:1:103
    for b=1:1:4
        c=strcat(num2str(a),'_',num2str(b),'.bmp');
        j=imread(c);
        level1=graythresh(j);
        j3=im2bw(j,level1);
        cc=normxcorr2(i4,j3);
        
        
        [max_cc,imax]=max(abs(cc(:)));
        
        
        if max_cc>=n %the threshold for the recognition of a match%
            set(handles.text7,'string',max_cc);
            axes(handles.axes2)
            imshow(j);
            found=1;
            max_cc
            c
            break
          
        end
    end
   if a==103 && found == 0
       axes(handles.axes2)
       imshow('no_match.jpg');
   end
end
 
 
end
 
% --- Executes on button press in weighted_normcorr.
 
function normcorr_Callback(hObject, eventdata, handles)
% hObject    handle to normcorr (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
n=str2num(get(handles.threshold_editor,'string'));
o=str2num(get(handles.rowmin,'string'));
p=str2num(get(handles.rowmax,'string'));
q=str2num(get(handles.colmin,'string'));
r=str2num(get(handles.colmax,'string'));
image=handles.image;
image=double(image);
img=image;
%binarizing the image%
img2=img<(graythresh(img)*255);
%Getting the vertical profile of the image%
vertical_profile=any(img2,2);
%getting the horizontal profile of the image%
horizontal_profile=any(img2,1);
%Obtaining the index of the bounding box%
toprow=find(vertical_profile,1,'first');
bottomrow=find(vertical_profile,1,'last');
leftcol=find(horizontal_profile,1,'first');
rightcol=find(horizontal_profile,1,'last');
%Crop it out of the original image%
croppedimage=img(toprow:bottomrow,leftcol:rightcol);
 
croppedimage2=croppedimage(o:p,q:r);
 
%The image is then normalised using the mean value of 0.3922 which
%is (100/255). This is done so as to even out the brightness of the entire image
i2=croppedimage2;
 
%obtaining the image threshold so as to perform binarization
level=graythresh(i2);
 
%Performing the binarization
i3=im2bw(i2,level);
 
found=0; %Found is a variable that determines whether the statement 'match found' or 'no match found' should be output
for a=101:1:103
    for b=1:1:4
        c=strcat(num2str(a),'_',num2str(b),'.bmp');
        j=imread(c);
        level1=graythresh(j);
        j3=im2bw(j,level1);
        cc1=normxcorr2(i3,j3);
        
        
        [max_cc1,imax1]=max(abs(cc1(:)));
        
        
        if max_cc1>=n %the threshold for the recognition of a match%
            set(handles.text6,'string',max_cc1);
            axes(handles.axes3)
            imshow(j);
            found=1;
            max_cc1
            c
            break
          
        end
    end
   if a==103 && found == 0
       axes(handles.axes3)
       imshow('no_match.jpg');
   end
end
end
% --- Executes on button press in normcorr.
 
 
function threshold_editor_Callback(hObject, eventdata, handles)
% hObject    handle to threshold_editor (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
 
% Hints: get(hObject,'String') returns contents of threshold_editor as text
%        str2double(get(hObject,'String')) returns contents of threshold_editor as a double
 
end
% --- Executes during object creation, after setting all properties.
function threshold_editor_CreateFcn(hObject, eventdata, handles)
% hObject    handle to threshold_editor (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called
 
% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
end
 
 
function rowmax_Callback(hObject, eventdata, handles)
% hObject    handle to rowmax (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
 
% Hints: get(hObject,'String') returns contents of rowmax as text
%        str2double(get(hObject,'String')) returns contents of rowmax as a double
end
 
% --- Executes during object creation, after setting all properties.
function rowmax_CreateFcn(hObject, eventdata, handles)
% hObject    handle to rowmax (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called
 
% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
 
end
 
function rowmin_Callback(hObject, eventdata, handles)
% hObject    handle to rowmin (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
 
% Hints: get(hObject,'String') returns contents of rowmin as text
%        str2double(get(hObject,'String')) returns contents of rowmin as a double
end
 
% --- Executes during object creation, after setting all properties.
function rowmin_CreateFcn(hObject, eventdata, handles)
% hObject    handle to rowmin (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called
 
% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
end
 
 
function colmin_Callback(hObject, eventdata, handles)
% hObject    handle to colmin (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
 
% Hints: get(hObject,'String') returns contents of colmin as text
%        str2double(get(hObject,'String')) returns contents of colmin as a double
 
end
% --- Executes during object creation, after setting all properties.
function colmin_CreateFcn(hObject, eventdata, handles)
% hObject    handle to colmin (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called
 
% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
end
 
 
function colmax_Callback(hObject, eventdata, handles)
% hObject    handle to colmax (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
 
% Hints: get(hObject,'String') returns contents of colmax as text
%        str2double(get(hObject,'String')) returns contents of colmax as a double
end
 
% --- Executes during object creation, after setting all properties.
function colmax_CreateFcn(hObject, eventdata, handles)
% hObject    handle to colmax (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called
 
% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
end
 
% --- Executes on button press in add_image_to_folder.
function add_image_to_folder_Callback(hObject, eventdata, handles)
% hObject    handle to add_image_to_folder (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
close
end

