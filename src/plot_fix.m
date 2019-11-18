function h=plot_fix(handles,opt,N_layer)
% plot "fixed" (or locked) model 
% use function 'meshgrid'
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
V=model.fix;
h=handles;
cobj=findobj(h.axis,'type','surface');
if cobj~=0
    delete(cobj);
end
hold(h.axis,'on');
switch opt
    case 'z'
        [yy,xx]=meshgrid(model.y,model.x);
        pcolor(h.axis,yy,xx,V(:,:,N_layer));
    case 'x'
        [xx,zz]=meshgrid(model.x,model.z);
        pcolor(h.axis,xx,zz,squeeze(V(:,N_layer,:))');
    case 'y'
        [yy,zz]=meshgrid(model.y,model.z);
        pcolor(h.axis,yy,zz,squeeze(V(N_layer,:,:))');
end
hold(h.axis,'off')
colormap(h.axis,flipud(gray(8)));
caxis(h.axis,[0,2.5])
%{
fsites=plot(xyz(:,1),xyz(:,2),'^');
hold on;
set(fsites,'markersize',7,'markeredgecolor','r','markerfacecolor',...
    [0.3 0.3 0.3]);
%}
%colormap(flipud(gray(64)));
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
view(2);
return;

