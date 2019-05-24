function set_trans(hObject,eventdata,handles)
% used to set tranparency parameter
% sealed for good
subview(hObject,eventdata,handles)
falpha=get(handles.transbox(1),'value');
set(handles.transbox(2),'string',num2str(falpha));
return

