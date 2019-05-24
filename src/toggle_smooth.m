function toggle_smooth(hObject,eventdata,handles)
% -----------------------------------------
% toggle between using original or smoothed data
global custom
if get(handles.smooth(1),'value')==1 % switch to smoothed
    custom.origin=0; 
    set_flist2(hObject,eventdata,handles)
else % switch to original
    custom.origin=1;
    set_flist2(hObject,eventdata,handles)
end
return

