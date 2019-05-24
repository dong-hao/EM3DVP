function popsave(hObject,eventdata,handles)
% callback for a series of saving command
todo=get(handles.io(1),'value');
switch todo
    case 1
        disp('do nothing');
    case 2
        save_WinG_model;
    case 3
        save_edi(hObject,eventdata,handles);
    case 4
        save_idx;
    case 5
        save_appres;
    case 6
        save_model;
    case 7
        save_modemdata(hObject,eventdata,handles);
    case 8
        save_cov();
    case 9
        save_ZK_data(hObject,eventdata,handles);
    case 10
        save_ZK_model(hObject,eventdata,handles);
    case 11
        save_ZK_startup(hObject,eventdata,handles);
end
set(handles.io(1),'value',1);
return

