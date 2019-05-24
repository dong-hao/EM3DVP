function box_edit_callback(hObject,eventdata,handles)
global custom
content=get(hObject,'tag');
switch content
    case 'zxxzyye'
        custom.zxxzyye=str2double(get(handles.error(3),'string'));        
    case 'zxyzyxe'
        custom.zxyzyxe=str2double(get(handles.error(4),'string'));
    case 'txtye'
        custom.txtye=str2double(get(handles.error(5),'string'));
    case 'nExe'
        custom.nexe=str2double(get(handles.error(3),'string'));
    case 'nEye'
        custom.neye=str2double(get(handles.error(4),'string'));
    case 'nEze'
        custom.neze=str2double(get(handles.error(5),'string'));
    case 'nHxe'
        custom.nhxe=str2double(get(handles.error(6),'string'));
    case 'nHye'
        custom.nhye=str2double(get(handles.error(7),'string'));
    case 'nHze'
        custom.nhze=str2double(get(handles.error(8),'string'));
    otherwise
        error(['the tag ' content ' is not recognized'],'Error');        
end
return