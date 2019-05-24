function popload(hObject,eventdata,handles)
% callback for a series of loading command
todo=get(handles.io(2),'value');
switch todo
    case 1
        disp('do nothing');
    case 2
        load_WinG_model(hObject,eventdata,handles)
    case 3
        load_WS_model(hObject,eventdata,handles)
    case 4
        load_wsdata(hObject,eventdata,handles)
    case 5
        load_modemdata(hObject,eventdata,handles)
    case 6
        load_asc(hObject,eventdata,handles)
    case 7
        load_ZK_data(hObject,eventdata,handles)
    case 8
        load_ZK_model(hObject,eventdata,handles)
end
set(handles.io(2),'value',1);
return

