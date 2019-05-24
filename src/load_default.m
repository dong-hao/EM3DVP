function load_default(hObject,eventdata,handles)
% load everything (about model meshing and data selection) to default
global default custom;
custom=default;
%{
set(handles.x1,'string',num2str(default.x1));
set(handles.model(2),'string',num2str(default.x2));
set(handles.model(3),'string',num2str(default.x3));
set(handles.model(4),'string',num2str(default.y1));
set(handles.model(5),'string',num2str(default.y2));
set(handles.model(6),'string',num2str(default.y3));
set(handles.model(7),'string',num2str(default.z1));
set(handles.model(8),'string',num2str(default.z2));
set(handles.model(9),'string',num2str(default.z3));
set(handles.model(10),'string',num2str(default.z4));
set(handles.model(11),'string',num2str(default.z5));
set(handles.data(1),'value',default.zxxzyy);
set(handles.data(2),'value',default.zxyzyx);
set(handles.data(3),'value',default.txty);
set(handles.data(4),'string',num2str(default.zxxzyye));
set(handles.data(5),'string',num2str(default.zxyzyxe));
set(handles.data(6),'string',num2str(default.txtye));
set(handles.data(7),'value',0);
set(handles.data(8),'value',1);
set(handles.freq(2),'string',num2str(default.pmin));
set(handles.freq(1),'string',num2str(default.pmax));
set(handles.freq(3),'string',num2str(default.ppd));
set(handles.rholim(1),'string',num2str(default.rhomin));
set(handles.rholim(2),'string',num2str(default.rhomax));
set(handles.expertmode,'value',0);
set(handles.project(1),'value',1);
set(handles.project(2),'value',0);
% disp('callback')
% disp(hObject)
% disp(eventdata)
%}
disp('default loaded')
return;

%function read_edi
