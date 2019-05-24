function shift_sites(hObject,eventdata,h)
global xyz sitename custom
parastr={'X (Northing) to shift:(m)',...
    'Y (Easting) to shift:(m)'};
ShiftPara=inputdlg(parastr,'Shift Parameter',1,{'0','0'});
if isempty(ShiftPara)
    disp('User canceled');
    return
end
cx=str2double(ShiftPara{1}); % coord to shift for x
cy=str2double(ShiftPara{2}); % coord to shift for y

xr=xyz(:,1)+cx; % new x coord
yr=xyz(:,2)+cy; % new y coord
xyz(:,1)=xr;
xyz(:,2)=yr;
plot_site(hObject,eventdata,h,'noname');
csite=['current site: ' char(sitename{custom.currentsite})];
set(h.text,'string',csite);
set(h.buttons(1),'enable','on')
return

