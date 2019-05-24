function set_colorbar(hObject,eventdata,handles)
% a callback for color range setting
global default custom;
rhomin=str2num(get(handles.rholim(1),'string'));
rhomax=str2num(get(handles.rholim(2),'string'));
if rhomin>=rhomax
    warnstr=['Maximum resistivity must be greater than the minmum one, ',...
        'DEFAULT settings is loaded...']; 
    warndlg(warnstr);
    set(handles.rholim(1),'string',num2str(default.rhomin));
    set(handles.rholim(2),'string',num2str(default.rhomax));
    set(handles.axis,'clim',[default.rhomin,default.rhomax]);
else
    custom.rhomin=rhomin;custom.rhomax=rhomax;
    set(handles.axis,'clim',[log10(rhomin),log10(rhomax)]);
end
return;

