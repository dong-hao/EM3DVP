function subplot_mesh(hObject,eventdata,haxis)
global xyz custom model;
outx=custom.x2;
outy=custom.y2;
x=model.x(outx:end-outx+1);
y=model.y(outy:end-outy+1);
[xx,yy]=meshgrid(x,y);
fsites=plot(haxis,xyz(:,2),xyz(:,1),'v');
hold(haxis,'on');
plot(haxis,yy,xx,'k-');
plot(haxis,yy',xx','k-');
%Please note that xyz(:,1) is x in wsinv3d(N-S direction which is y in
%matlab)
%Please note that xyz(:,2) is y in wsinv3d(E-W direction which is x in
%matlab)
set(fsites,'markersize',6,'markeredgecolor','b','markerfacecolor',...
    [0.3 0.3 0.3]);
daspect(haxis,[1 1 1]);
hold(haxis,'off');
return


