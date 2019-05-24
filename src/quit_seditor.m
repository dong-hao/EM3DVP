function quit_seditor(h,eventdata,handles)
global sitename xyz data custom
    queststr='leaving site editing mode, are you sure?';
    yorn=questdlg(queststr,'Note','yes','no','yes');
    if strcmp(yorn,'yes')
        delete(handles.figure);
        handles=handles.parent;% get the main interface handle
        if ~isempty(sitename)&&~isempty(xyz)&&~isempty(data)&&custom.init==0
            mesher(h,eventdata,handles)
            GUI_init(handles);
            custom.init=1;
        elseif ~isempty(xyz)&&~isempty(data)
            custom.currentX=1;
            custom.currentY=1;
            custom.currentZ=1;
            d3_view(h,eventdata,handles);
            refresh_status(h,eventdata,handles);
        end
    else
        return;
    end
return

