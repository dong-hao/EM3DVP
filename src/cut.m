function cut(hObject,eventdata,handles)
% cut some slices for the isosurface interface
global model custom xyz
% read model
air=log10(custom.air);
x=model.x;
y=model.y;
z=model.z;
outx=custom.x2;
outy=custom.y2;
outz=custom.z5;
topz=1;
if get(handles.slicebox(8),'value')==1
    x=x(outx:(end-outx+1));
    y=y(outy:(end-outy+1));
    z=z(topz:(end-outz+1));
    V=log10(model.rho(outx:(end-outx+1),outy:(end-outy+1),topz:(end-outz+1)));
    V(V>=air)=NaN;
    V(end,end,end)=V(end,end,end)+0.1; % in case of drawing a homogeneous model.
else 
    V=log10(model.rho);
end
[Y,X,Z]=meshgrid(y,x,z);
% check view mode
sx=str2num(get(handles.slicebox(1),'string'));
sy=str2num(get(handles.slicebox(2),'string'));
sz=str2num(get(handles.slicebox(3),'string'));
fig=slice(handles.axis,Y,X,Z,V,sy,sx,sz);       
set(fig, 'LineStyle', 'none');
isotext=get(handles.isobox(1),'string');
title(handles.axis,['isosurface @ ' isotext ' Ohmm' ]);
axis(handles.axis,[min(y) max(y) min(x) max(x) min(z)-1 max(z)+1]);
xlabel(handles.axis,'y');
ylabel(handles.axis,'x');
zlabel(handles.axis,'z');
set(handles.axis,'clim',[log10(custom.rhomin),log10(custom.rhomax)]);
colorbar('units','normalized','position',[0.73 0.07 0.06 0.25]);
hold(handles.axis,'on');
fsites=plot3(handles.axis,xyz(:,2),xyz(:,1),xyz(:,3)+0.5,'r+');
set(fsites,'markersize',7,'markeredgecolor','r','markerfacecolor',...
    [0.3 0.3 0.3]);
hold(handles.axis,'off');
daspect(handles.axis,[1 1 1]);
falpha=get(handles.transbox(1),'value');
set(fig,'facealpha',falpha)
return

