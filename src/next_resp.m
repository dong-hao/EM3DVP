function next_resp(hObject,eventdata,handle)
global nsite custom sitename;
if custom.currentsite<nsite
    custom.currentsite=custom.currentsite+1;
else if custom.currentsite==nsite
    custom.currentsite=1;
    end
end

subplot_site(handle.axis(3),eventdata,handle.axis(3));
if get(handle.Zbox(1),'value')==1
    plot_resp(hObject,eventdata,handle,'xxyy');
    set(handle.Zbox,'value',0);
    set(handle.Zbox(1),'value',1);
elseif get(handle.Zbox(2),'value')==1
    plot_resp(hObject,eventdata,handle,'xyyx');
    set(handle.Zbox,'value',0);
    set(handle.Zbox(2),'value',1);
else
    plot_resp(hObject,eventdata,handle,'txty');
    set(handle.Zbox,'value',0);
    set(handle.Zbox(3),'value',1);
end
set(handle.text,'string',sitename{custom.currentsite});
return

