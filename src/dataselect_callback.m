function dataselect_callback(hObject,eventdata,handles)
% callback for the data selection 
% 
% 8 for impedances only and 12 for impedances and tipper
% Zxx&Zyy Zxy&Zyx Tx&Ty
global custom;
if get(handles.data(1),'value')==1    % Zxx&Zyy data is checked
    if get(handles.error(1),'value')==1
        set(handles.error(3),'enable','on');
    end
    custom.zxxzyy=1;
else
    set(handles.error(3),'enable','off');
    custom.zxxzyy=0;
end
if get(handles.data(2),'value')==1      % Zxy&Zyx data is checked
    if get(handles.error(1),'value')==1
        set(handles.error(4),'enable','on');
    end
    custom.zxyzyx=1;
else
    set(handles.error(4),'enable','off');
    custom.zxyzyx=0;  
end    
if get(handles.data(3),'value')==1      % Tx&Ty data is checked
    if get(handles.error(1),'value')==1
        set(handles.error(5),'enable','on');
    end
    custom.txty=1;
else
    set(handles.error(5),'enable','off');
    custom.txty=0; 
end    
refresh_status(hObject,eventdata,handles.parent)
return;