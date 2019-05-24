function enable_edit_site(hObject,eventdata,handles)
% callback to enable site editing activities
global sitename xyz nsite custom
% see if we already have sites generated...
if isempty(sitename)||isempty(xyz)
    queststr='No site seems to exist for now. Do you want to import one?';
    yorn=questdlg(queststr,'Import site','yes','no','yes');
    if strcmp(yorn,'no')
        disp('user canceled...')
        return;
    else
        % begin to insert a dummy site for you...
        index=1;
        x=0;
        y=0;
        sitename=cell(1);
        nsite=0;
        import_site(index,x,y);    
        plot_site(hObject,eventdata,handles,'noname');
        daspect(handles.axis,[1 1 1]);
        set(handles.text,'string',['current site: ' sitename{custom.currentsite}])
    end
end
if get(hObject,'value')==1
    set(handles.editbox,'enable','on');
    guidata(handles.axis(1),handles);
    if get(handles.editbox(1),'value')==1
        add_site(hObject,eventdata,handles,'axy')
    elseif get(handles.editbox(2),'value')==1
        del_site(hObject,eventdata,handles,'axy')
    else 
        move_site(hObject,eventdata,handles,'axy')
    end
    % disp('interactive_move enabled')
    set(handles.propertybox,'enable','on')
else
    if get(handles.editbox(1),'value')==1
        add_site(hObject,eventdata,handles,'off')
    elseif get(handles.editbox(2),'value')==1
        del_site(hObject,eventdata,handles,'off')
    else 
        move_site(hObject,eventdata,handles,'off')
    end
    set(handles.editbox,'enable','off');
    uirestore(handles.init);
    guidata(handles.axis(1),handles);
    % disp('interactive_move disabled')
    set(handles.propertybox,'enable','off')    
end
return


