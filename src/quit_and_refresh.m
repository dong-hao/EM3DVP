function quit_and_refresh(hObject,eventdata,handles)
% 
% an (almost) universal quit dialog function
% after quiting current gui, it will try to refresh the status panel in the
% master gui
queststr=get(handles.figure,'name');
yorn=questdlg('Are you sure to leave?',queststr,'yes','no','yes');
if strcmp(yorn,'yes')
    refresh_status(hObject,eventdata,handles.parent);
    close(handles.figure);
else
    return;
end

return;