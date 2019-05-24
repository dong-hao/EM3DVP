function centre_site(hObject,eventdata,handles)
% keep the sites AT the CENTRE of Meshes.
% according to Weerachai's WSINV3DMT manual, every site should be in the
% centre of the grids.
% NOTE: the new VTF version of of WSINV3DMT doesn't need the site to be
% exactly AT the centre of the grid.
global xyz model nsite
Nsite=nsite;
for i=1:Nsite
    m=find(model.x>xyz(i,1),1);
    xyz(i,1)=(model.x(m)+model.x(m-1))/2;
    n=find(model.y>xyz(i,2),1);
    xyz(i,2)=(model.y(n)+model.y(n-1))/2;
end
oid=findobj(handles.axis,'type','line');
delete(oid);
hold(handles.axis,'on');
fsites=plot(handles.axis,xyz(:,2),xyz(:,1),'^');
set(fsites,'markersize',7,'markeredgecolor','r','markerfacecolor',...
    [0.3 0.3 0.3]);
hold(handles.axis,'off');
return

