function previous_site(hObject,eventdata,h)
% as the name infers, display the previous site.
global nsite custom sitename;
if custom.currentsite>1
    custom.currentsite=custom.currentsite-1;
else if custom.currentsite==1
    custom.currentsite=nsite;
    end
end
subplot_site(hObject,eventdata,h.axis(3));
if  get(h.Zbox(1),'value')==1
    plot_sounding(hObject,eventdata,h,'xxyy');
elseif get(h.Zbox(2),'value')==1
    plot_sounding(hObject,eventdata,h,'xyyx');
elseif get(h.Zbox(3),'value')==1
    plot_sounding(hObject,eventdata,h,'txty');
else
    set(h.Zbox,'value',0);
    set(h.Zbox(2),'value',1);
    plot_sounding(hObject,eventdata,h,'xyyx');
end
set(h.text,'string',sitename{custom.currentsite});
return


