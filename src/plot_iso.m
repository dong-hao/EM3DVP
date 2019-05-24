function oid=plot_iso(hObject,eventdata,handles)
% plot isosurface at given resistivity
global model custom
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
    V(end,end,end)=V(end,end,end)+0.1; % in case of drawing a homogeneous model.
else 
    V=log10(model.rho);
end
rho= log10(str2num(get(handles.isobox(1),'string')));
for i=1:length(rho)
    face=isosurface(y,x,z,V,rho(i));
    %isonormals(x,y,z,V,face);
    rhomin=log10(str2num(get(handles.rholim(1),'string')));
    rhomax=log10(str2num(get(handles.rholim(2),'string')));
    oid=patch(face);
    set(oid,'FaceColor',get_Colorindex(rho(i),rhomax,rhomin),...
        'EdgeColor','none');
end
lighting phong
if get(handles.isobox(5),'value')==1
    camlight('headlight')
else
    light_id=findobj(gca,'type','light');
    delete(light_id);
end    
return


