function subplot_site(hObject,eventdata,haxis)
global xyz custom
isite=custom.currentsite;
fsites=plot(haxis,xyz(:,2),xyz(:,1),'^');
%Please note that xyz(:,1) is x in wsinv3d(N-S direction which is y in
%matlab)
%Please note that xyz(:,2) is y in wsinv3d(E-W direction which is x in
%matlab)
set(fsites,'markersize',7,'markeredgecolor','r','markerfacecolor',...
    [0.3 0.3 0.3]);
hold(haxis,'on');
highlight=plot(haxis,xyz(isite,2),xyz(isite,1),'^');
%Please note that xyz(:,1) is x in wsinv3d(N-S direction which is y in
%matlab)
%Please note that xyz(:,2) is y in wsinv3d(E-W direction which is x in
%matlab)
set(highlight,'markersize',7,'markerfacecolor','b');
grid on;
daspect(haxis,[1 1 1]);
hold(haxis,'off');
return

