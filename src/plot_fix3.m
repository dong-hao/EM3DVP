function h=plot_fix3(handles,opt,N_layer)
% a might-be function to plot fix area in 3d slices
% reserved for future works.
global model custom
switch nargin
case 0
    error('Must Specify a handle to a axis object')
case 1
    opt='z';N_layer=1;
case 2
    if ~any(strcmp(opt,{'x','y','z'}))
        error(['Second argument ''' opt ''' is an unknown command option.'])
    end
    N_layer=1;
end
V=model.fix*0.7;
h=handles;

cobj=findobj(h.axis,'type','surface');
if cobj~=0
    delete(cobj);
end
hold(h.axis,'on');
switch opt
    case 'x'
        sx=max(model.x);
        sy=[model.y(N_layer),max(model.y)];
        sz=min(model.z);
    case 'y'
        sx=[model.x(N_layer),max(model.x)];
        sy=max(model.y);
        sz=min(model.z);
    case 'z'
        sx=min(model.x);
        sy=min(model.y);
        sz=[min(model.z),model.z(N_layer)];
end
[yy,xx,zz]=meshgrid(model.y,model.x,model.z);
slice(yy,xx,zz,V,sy,sx,sz);
daspect(h.axis,[1 1 1]);
colormap(flipud(gray(64)));
caxis([0,1])
hold(h.axis,'on');
% plotting sites. it is really strange that you can use 2d plot on 3d
% image...
xlabel(h.axis,'E-W(y)');
ylabel(h.axis,'N-S(x)');
zlabel(h.axis,'Depth(z)');
axis auto
switch opt
    case 'x' % view x plane, you are viewing the "currentY"th slice
        depthT=sum(model.y(custom.currentY));
        depthB=sum(model.y(custom.currentY+1));
        title(['Current Location: ' num2str(depthT),' to ',num2str(depthB)...
     ' m; current Layer: ' num2str(custom.currentY)]);
    case 'y' % view y plane, you are viewing the "currentX"th slice   
        depthT=sum(model.x(custom.currentX));
        depthB=sum(model.x(custom.currentX+1));
        title(['Current Location: ' num2str(depthT),' to ',num2str(depthB)...
     ' m; current Layer: ' num2str(custom.currentX)]);
    case 'z' % view z plane, you are viewing the "currentZ"th slice
        depthT=sum(model.z(custom.currentZ));
        depthB=sum(model.z(custom.currentZ+1));
        title(['Current Location: ' num2str(depthT),' to ',num2str(depthB)...
     ' m; current Layer: ' num2str(custom.currentZ)]);
end
% shading flat;
view(3)
return;

