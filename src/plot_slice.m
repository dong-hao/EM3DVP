function plot_slice(hObject,eventdata,handles,opt)
global model custom xyz 
% set data aspect(x/y/z)
% R=[1 0.5 1];
R= custom.ratio;
air= log10(custom.air);
% read model
x=model.x;
y=model.y;
z=model.z;
outx=custom.x2;
outy=custom.y2;
outz=custom.z5;
if get(handles.selectionbox(7),'value')==1&&get(handles.setbox(1),'value')~=1
    % calculate boundary blocks (that you don't want to display) from site
    % profile length
    Lprofile_X=max(xyz(:,1))-min(xyz(:,1));
    Lprofile_Y=max(xyz(:,2))-min(xyz(:,2));
    Nx=length(x);
    for i=1:Nx
        if abs(x(i)-x(end-i))<=Lprofile_X
            ix=i-3;
            break;
        end
    end
    x=x(ix:(end-ix+1));
    Ny=length(y);
    for i=1:Ny
        if abs(y(i)-y(end-i))<=Lprofile_Y
            iy=i-3;
            break;
        end
    end
    y=y(iy:(end-iy+1));
    z=z(1:end-3);
    % please note here Z=(1:end-3)
    V=log10(abs(model.rho(ix:(end-ix+1),iy:(end-iy+1),1:end-3)));
    % in case we have minus resistivity.
    V(end,end,end)=V(end,end,end)+0.1; % in case of drawing a homogeneous model.
    % if current slices get out of the boundery...
    % kick them in...
    if custom.currentX>length(x)
        custom.currentX=length(x);
    end
    if custom.currentY>length(y)
        custom.currentY=length(y);
    end
    if custom.currentZ>length(z)
        custom.currentZ=length(z);
    end
elseif get(handles.selectionbox(7),'value')==1
    % set boundary blocks (that you don't want to display) from the "set
    % boundary" text box
    x=x(outx:(end-outx+1));
    y=y(outy:(end-outy+1));
    z=z(1:(end-outz+1));
    V=log10(abs(model.rho(outx:(end-outx+1),outy:(end-outy+1),1:(end-outz+1))));
    V(end,end,end)=V(end,end,end)+0.1; % in case of drawing a homogeneous model.
    % if current slices get out of the boundery...
    % kick them in...
    if custom.currentX>length(x)-1
        custom.currentX=length(x)-1;
    end
    if custom.currentY>length(y)-1
        custom.currentY=length(y)-1;
    end
    if custom.currentZ>length(z)-1
        custom.currentZ=length(z)-1;
    end
else 
    V=log10(abs(model.rho));
end

[Y,X,Z]=meshgrid(y,x,z);
% check view mode
if get(handles.viewbox(1),'value')==1
    nslice=str2double(get(handles.viewbox(4),'string'))+1;
    sx=min(x)+(max(x)-min(x))/nslice:(max(x)-min(x))/nslice:max(x)-(max(x)-min(x))/nslice;% location of slices, x
    %sx=[-335 -175 0 175 335];
    sxtext='';
    sy=min(y)+(max(y)-min(y))/nslice:(max(y)-min(y))/nslice:max(y)-(max(y)-min(y))/nslice;% location of slices, y
    %sy=[-350 -175 0 175 350];
    sytext='';
    sz=min(z)+(max(z)-min(z))/nslice:(max(z)-min(z))/nslice:max(z)-(max(z)-min(z))/nslice;% location of slices, z
    %sz=[-3 -25 -50 -75 -100];
    sztext='';
    f=0;
elseif get(handles.viewbox(2),'value')==1
    sx=(x(custom.currentX)+x(custom.currentX+1))/2;% location of slices, x
    sxtext=[num2str(x(custom.currentX)), ' to ' num2str(x(custom.currentX+1)), ' km'];
    sy=(y(custom.currentY)+y(custom.currentY+1))/2;% location of slices, y
    sytext=[num2str(y(custom.currentY)), ' to ' num2str(y(custom.currentY+1)), ' km'];
    sz=(z(custom.currentZ)+z(custom.currentZ+1))/2;% location of slices, z
    sztext=[num2str(z(custom.currentZ)), ' to ' num2str(z(custom.currentZ+1)), ' km'];
    f=1;
else
    sx=(x(custom.currentX)+x(custom.currentX+1))/2;% location of slices, x
    sxtext=[num2str(x(custom.currentX)), ' to ' num2str(x(custom.currentX+1)), ' km'];
    sy=(y(custom.currentY)+y(custom.currentY+1))/2;% location of slices, y
    sytext=[num2str(y(custom.currentY)), ' to ' num2str(y(custom.currentY+1)), ' km'];
    sz=(z(custom.currentZ)+z(custom.currentZ+1))/2;% location of slices, z
    sztext=[num2str(z(custom.currentZ)), ' to ' num2str(z(custom.currentZ+1)), ' km'];
    f=2;
end
%air=log10(custom.air);
switch opt
    case 'x'
        i=1;
        hs=slice(handles.axis(i),Y,X,Z,V,[],sx,[]);      
        title(handles.axis(i),['E-W slice ', sxtext]);
        axis(handles.axis(i),[min(y) max(y) min(x) max(x) min(z)-0.1*(max(z)-min(z))...
            max(z)+0.2*(max(z)-min(z))]);
        if f==2;view(handles.axis(i),0,0);end
    case 'y'
        i=2;
        hs=slice(handles.axis(i),Y,X,Z,V,sy,[],[]);
        title(handles.axis(i),['N-S slice ', sytext]);
        axis(handles.axis(i),[min(y) max(y) min(x) max(x) min(z)-0.1*(max(z)-min(z))...
            max(z)+0.2*(max(z)-min(z))]);
        if f==2;view(handles.axis(i),90,0);end
    case 'z'
        i=3;
        hs=slice(handles.axis(i),Y,X,Z,V,[],[],sz);
        title(handles.axis(i),['Horizontal slice ', sztext]);
        axis(handles.axis(i),[min(y) max(y) min(x) max(x) min(z)-0.1*(max(z)-min(z))...
            max(z)+0.2*(max(z)-min(z))]);
        if f==2;view(handles.axis(i),0,90);end
end
xlabel(handles.axis(i),'Easting(km)');
ylabel(handles.axis(i),'Northing(km)');
zlabel(handles.axis(i),'Depth(km)');
set(handles.axis,'clim',[log10(custom.rhomin),log10(custom.rhomax)]);
colorbar('units','normalized','position',[0.78 0.12 0.05 0.2],...
    'fontsize',12);
% plot site locations (or not)
if get(handles.setbox(9),'value')==1
    hold(handles.axis(i),'on');
    % plot sites...
    fsites=[];
%     txyz=xyz;
%     txyz(:,3)=-2-xyz(:,3);
    if get(handles.viewbox(3),'value')==1
        % only plot sites near the profiles...
        switch opt
            case 'x'
                limit=abs(x(floor(length(x)/2))-x(floor(length(x)/2)+1))*1;
                rs=find(abs((xyz(:,1)-sx))<limit);
                if ~isempty(rs)
                    fsites=plot3(handles.axis(i),xyz(rs,2),xyz(rs,1),xyz(rs,3)+...
                    0.05*(max(z)-min(z)),'v');
                end                    
            case 'y'                
                limit=abs(y(floor(length(y)/2))-y(floor(length(y)/2)+1))*2;
                rs=find(abs((xyz(:,2)-sy))<limit);
                if ~isempty(rs)
                    fsites=plot3(handles.axis(i),xyz(rs,2),xyz(rs,1),xyz(rs,3)+...
                    0.05*(max(z)-min(z)),'v');
                end    
            case 'z'
                rs=1:size(xyz,1);
                fsites=plot3(handles.axis(i),xyz(rs,2),xyz(rs,1),xyz(rs,3)+...
                    0.05*(max(z)-min(z)),'v');
        end
    else % plot all the sites...
        rs=1:size(xyz,1);
        fsites=plot3(handles.axis(i),xyz(rs,2),xyz(rs,1),xyz(rs,3)+...
            0.04*(max(z)-min(z)),'v');
    end
    if ~isempty(fsites)
%        snames=sitename;
%        axes(handles.axis(i));
%        text(xyz(rs,2),xyz(rs,1),snames(rs),'rotation',90);
        set(fsites,'markersize',7,'markeredgecolor','b','markerfacecolor',...
            [0.3 0.3 0.3]);
    end
    hold(handles.axis(i),'off');
end
daspect(handles.axis(i),R);
set_shading(hObject,eventdata,handles);% set shadings here
scolor=get(hs,'cdata');
if ~iscell(scolor)
    scolor(scolor>=air)=NaN;
    set(hs,'cdata',scolor);
else
    for k=1:length(scolor)
        scolord=scolor{k};
        scolord(scolord>=air)=NaN;
        set(hs(k),'cdata',scolord);
    end
end
%falpha=get(handles.transbox(1),'value');
%set(fig,'facealpha',falpha)
box(handles.axis(i),'on');
return

