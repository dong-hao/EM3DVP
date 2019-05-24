function set_isotrans(hObject,eventdata,handles)
% used to set isosfcviewer tranparency parameter
%subview(hObject,eventdata,handles)
falpha=get(handles.transbox(1),'value');
set(handles.transbox(2),'string',num2str(falpha));
cut(hObject,eventdata,handles);
return

