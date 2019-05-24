function enable_edit_curve(hObject,eventdata,handle)
if get(hObject,'value')==1
    set(handle.editbox,'enable','on');
    set(handle.editbox(1),'value',1);
    guidata(handle.axis(1),handle);
    set(gcf,'Pointer','crosshair');
    set(gcf, 'windowbuttondownfcn', {@mask_TF,handle});
else
	set(gcf,'pointer','arrow');
    set(handle.editbox,'enable','off');
    uirestore(handle.init);
    guidata(handle.axis(1),handle);
    set(handle.editbox(1),'value',1);
    % disp('interactive_move disabled')
end
return


%%================freq selector ========================%%
%            devoted to change and load frequency table  %
%            for synthetic (and real) data               %
%%======================================================%%
