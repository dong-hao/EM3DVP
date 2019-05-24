function subview(hObject,eventdata,handles)
% use plot_slice to display slice in 3 directions.
if get(handles.viewbox(1),'value')==1
    set(handles.selectionbox,'enable','off')
    set(handles.selectionbox(7),'enable','on')
elseif get(handles.viewbox(2),'value')==1
    set(handles.selectionbox,'enable','on')
elseif get(handles.viewbox(3),'value')==1
    set(handles.selectionbox,'enable','on')
end
plot_slice(hObject,eventdata,handles,'x');
plot_slice(hObject,eventdata,handles,'y');
plot_slice(hObject,eventdata,handles,'z');
return

