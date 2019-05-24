function rotate_sites(hObject,eventdata,h)
global nsite xyz data sitename custom
parastr={'X (Northing) coordinate of the rotation center:',...
    'Y (Easting) coordinate of the rotation center:',...
    'Rotation angle (in degree):'};
RotatePara=inputdlg(parastr,'Rotate Parameter',1,{'0','0','45'});
cx=str2double(RotatePara{1}); % center coord of x
cy=str2double(RotatePara{2}); % center coord of y
alpha=str2double(RotatePara{3})*pi/180; % rotation angle (convert to grad)
xr=(xyz(:,1)-cx)*cos(-alpha)+(xyz(:,2)-cy)*sin(-alpha); % new x coord
yr=(xyz(:,1)-cx)*(-sin(-alpha))+(xyz(:,2)-cy)*cos(-alpha); % new y coord
for isite=1:nsite
    Z=data(isite).tf;
    Z=TFrotate(Z, alpha);
    data(isite).tf=Z;
    data(isite)=calc_rhophs(data(isite),1);
end
xyz(:,1)=xr;
xyz(:,2)=yr;
plot_site(hObject,eventdata,h,'noname');
csite=['current site: ' char(sitename{custom.currentsite})];
set(h.text,'string',csite);
set(h.buttons(1),'enable','on')
return

