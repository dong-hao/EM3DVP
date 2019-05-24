function expertmode(hObject,eventdata,handles)
% the expert mode, ahem, is just about model mesh editing
% check this to enable the model editing mode
% well you don't have to be an expert to use this
if get(hObject,'value')==1
    queststr=['You can ADD,DELETE and ADJUST columns,rows and layers as well',...
        ' as SET resisitivity and FIX model resisitivity. This function is',...
        ' NOT recommended, just because there are too many bugs...',...
        ' Do you really want to use?'];
    yorn=questdlg(queststr,'Enable Edit','yes','no','yes');
    if strcmp(yorn,'yes')
        set(hObject,'value',1);
    else
        set(hObject,'value',0);
    end
else
    queststr=['You are leaving Edit Mode, your editings will be saved,',...
        ' Do you really want to leave?'];
    yorn=questdlg(queststr,'Disable Edit','yes','no','yes');
    if strcmp(yorn,'yes')
        set(hObject,'value',0);
        k=get(gcf,'userdata');
        if ~isempty(k)
            if isfield(k.bdfcn)
            %acw modified to recall buttondownfcn and restore when turned off
            set(gcf,'buttondownfcn',k.bdfcn,'userdata','','tag','');
            end
        end
    else
        set(hObject,'value',1);
    end
end
if get(hObject,'value')==1
    for i=1:length(handles)
        set(handles(i),'enable','on');
    end
else
    for i=1:length(handles)
        set(handles(i),'enable','off');
    end
end
set(gcf, 'windowbuttondownfcn', '');
set(gcf, 'windowbuttonmotionfcn', '');
set(gcf, 'windowbuttonupfcn', '');
return;

