function dataerror_callback(hObject,eventdata,handles)
% callback for data error settings
% you can either select a fixed errorfloor or use the data error.
global custom
switch get(eventdata.NewValue,'tag')
    case 'set error floor'
        if custom.zxxzyy==1      % Zxx&Zyy data is checked
            set(handles.error(3),'enable','on');
            custom.zxxzyye=str2double(get(handles.error(3),'string'));
        else
            set(handles.error(3),'enable','off');
        end
        if custom.zxyzyx==1      % Zxy&Zyx data is checked
            set(handles.error(4),'enable','on');
            custom.zxyzyxe=str2double(get(handles.error(4),'string'));
        else
            set(handles.error(4),'enable','off');
        end        
        if custom.txty==1      % Tx&Ty data is checked
            set(handles.error(5),'enable','on');
            custom.txtye=str2double(get(handles.error(5),'string'));
        else
            set(handles.error(5),'enable','off');
        end    
        custom.usef=1;
    case 'from data'
        set(handles.error(3),'enable','off');
        set(handles.error(4),'enable','off');
        set(handles.error(5),'enable','off');
        custom.usef=0;
end
return;

