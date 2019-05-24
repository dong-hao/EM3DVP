function h=plot_mesh(handles,opt,N_layer)
% plot model grid and resistivity
% use function 'meshgrid'
global model custom
switch nargin
case 0
    error('Must Specify a handle to an axis object')
case 1
    opt='z';N_layer=1;
case 2
    if ~any(strcmp(opt,{'x','y','z'}))
        error(['Second argument ''' opt ''' is an unknown command option.'])
    end
    N_layer=1;
end
V=model.rho;
h=handles;

cobj=findobj(h.axis,'type','surface');
if cobj~=0
    delete(cobj);
end
hold(h.axis,'on');
switch opt
    case 'x' % view x plane, please note you are actually viewing x and z mesh
        [xx,zz]=meshgrid(model.x,model.z);
        pcolor(h.axis,xx,zz,log10(squeeze(V(:,N_layer,:))'));
        xlabel(h.axis,'N-S(x)/meter');
        ylabel(h.axis,'Depth(z)/meter');
    case 'y' % view y plane, please note you are actually viewing y and z mesh
        [yy,zz]=meshgrid(model.y,model.z);
        pcolor(h.axis,yy,zz,log10(squeeze(V(N_layer,:,:))'));
        xlabel(h.axis,'E-W(y)/meter');
        ylabel(h.axis,'Depth(z)/meter');
    case 'z' % view z plane, please note you are actually viewing x and y mesh
        [yy,xx]=meshgrid(model.y,model.x);
        pcolor(h.axis,yy,xx,log10(V(:,:,N_layer)));
        xlabel(h.axis,'E-W(y)/meter');
        ylabel(h.axis,'N-S(x)/meter');
end

hold(h.axis,'off')
%{
fsites=plot(xyz(:,1),xyz(:,2),'^');
hold on;
set(fsites,'markersize',7,'markeredgecolor','r','markerfacecolor',...
    [0.3 0.3 0.3]);
%}
%%debug
%colorbar('units','normalized','position',[0.85 0.42 0.04 0.20]);
colormap(h.axis,flipud(jet(64)));
caxis(h.axis,[log10(custom.rhomin),log10(custom.rhomax)])
switch opt
    case 'x' % view x plane, you are viewing the "currentY"th slice
        depthT=sum(model.y(custom.currentY));
        depthB=sum(model.y(custom.currentY+1));
        title(h.axis,['Current Location: ' num2str(depthT),' to ',num2str(depthB)...
     ' m; current Layer: ' num2str(custom.currentY)]);
    case 'y' % view y plane, you are viewing the "currentX"th slice     
        depthT=sum(model.x(custom.currentX));
        depthB=sum(model.x(custom.currentX+1));
        title(h.axis,['Current Location: ' num2str(depthT),' to ',num2str(depthB)...
     ' m; current Layer: ' num2str(custom.currentX)]);
    case 'z' % view z plane, you are viewing the "currentZ"th slice 
        depthT=sum(model.z(custom.currentZ));
        depthB=sum(model.z(custom.currentZ+1));
        title(h.axis,['Current Location: ' num2str(depthT),' to ',num2str(depthB)...
     ' m; current Layer: ' num2str(custom.currentZ)]);
end
view(h.axis,2);
return;

