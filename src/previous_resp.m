function previous_resp(hObject,eventdata,handle)
global nsite custom sitename;
if custom.currentsite>1
    custom.currentsite=custom.currentsite-1;
elseif custom.currentsite==1
    custom.currentsite=nsite;
end
subplot_site(hObject,eventdata,handle.axis(3));
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

