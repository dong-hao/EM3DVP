function toggle_pseudo(hObject,eventdata,handles)
% -----------------------------------------
% toggle from pseudo section and profile section.
title=get(handles.figure,'name');
if strcmp(title,'plot psection(DEMO)')
    create_profileviewer_gui(hObject,eventdata,handles)
    close(handles.figure);
else strcmp(title,'plot profile')
    create_psection_gui(hObject,eventdata,handles)
    close(handles.figure);
end

