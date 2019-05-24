function enable_trans(hObject,eventdata,handles)
% used to set tranparency of the slices
% by setting figure facealpha
% sealed for good
if get(handles.transbox(3),'value')==1
    set(handles.transbox(1),'enable','on')
    set(handles.transbox(2),'enable','on')
    subview(hObject,eventdata,handles)
    falpha=get(handles.transbox(1),'value');
    set(handles.transbox(2),'string',num2str(falpha));
else
    set(handles.transbox(1),'value',1)
    set(handles.transbox(1),'enable','off')
    set(handles.transbox(2),'enable','off')
    set(handles.transbox(2),'string',1);
    subview(hObject,eventdata,handles)
end
return

