function set_boundary(hObject,eventdata,h)
%set model boundary blocks (number of blocks out of the profile area) 
global default custom
if get(h.setbox(1),'value')==1
    xboundary=str2double(get(h.setbox(6),'string'));
    yboundary=str2double(get(h.setbox(7),'string'));
    zboundary=str2double(get(h.setbox(8),'string'));
    custom.x2=xboundary;
    custom.y2=yboundary;
    custom.z5=zboundary;
else
    custom.x2=default.x2;
    custom.y2=default.y2;
    custom.z5=default.z5;
end
if length(h.axis)>2 % determine (stupidly) if we need the subview function
    subview(hObject,eventdata,h);
end
return

