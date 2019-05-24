function Zedit(hObject,eventdata,handle,opt)
% enable Z edit mode
switch opt
    case 'maskx'
        if get(hObject,'value')==1
            handles = guidata(handle.axis(1));
            %handles.lineObj = findobj(h.axis, 'Type', 'line');
            handles.lineObj=[findobj(handle.axis(1), 'Type', 'line');
                findobj(handle.axis(1), 'Type', 'patch')];
            guidata(handle.axis(1),handles);
            % disp('interactive_move enabled')
            set(gcf,'Pointer','cross');
            set(gcf, 'windowbuttondownfcn', {@mask_TF,handle});
        end
    case 'masky'
        if get(hObject,'value')==1
            handles = guidata(handle.axis(1));
            %handles.lineObj = findobj(h.axis, 'Type', 'line');
            handles.lineObj=[findobj(handle.axis(1), 'Type', 'line');
                findobj(handle.axis(1), 'Type', 'patch')];
            guidata(handle.axis(1),handles);
            % disp('interactive_move enabled')
            set(gcf,'Pointer','cross');
            set(gcf, 'windowbuttondownfcn', {@mask_TF,handle});
        end
    case 'gmaskx'
        if get(hObject,'value')==1
            handles = guidata(handle.axis(1));
            %handles.lineObj = findobj(h.axis, 'Type', 'line');
            handles.lineObj=[findobj(handle.axis(1), 'Type', 'line');
                findobj(handle.axis(1), 'Type', 'patch')];
            guidata(handle.axis(1),handles);
            % disp('interactive_move enabled')
            set(gcf,'Pointer','cross');
            set(gcf, 'windowbuttondownfcn', {@group_mask_TF,handle});
        end
    case 'gmasky'
        if get(hObject,'value')==1
            handles = guidata(handle.axis(1));
            %handles.lineObj = findobj(h.axis, 'Type', 'line');
            handles.lineObj=[findobj(handle.axis(1), 'Type', 'line');
                findobj(handle.axis(1), 'Type', 'patch')];
            guidata(handle.axis(1),handles);
            % disp('interactive_move enabled')
            set(gcf,'Pointer','cross');
            set(gcf, 'windowbuttondownfcn', {@group_mask_TF,handle});
        end
    case 'gmaskall'
        if get(hObject,'value')==1
            handles = guidata(handle.axis(1));
            handles.lineObj=[findobj(handle.axis(1), 'Type', 'line');
                findobj(handle.axis(1), 'Type', 'patch')];
            guidata(handle.axis(1),handles);
            % disp('interactive_move enabled')
            set(gcf,'Pointer','cross');
            set(gcf, 'windowbuttondownfcn', {@group_mask_TF,handle});
        end
end

