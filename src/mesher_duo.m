function mesher_duo(hObject,eventdata,handles)
% ==============CAUTION!=============== %
% THIS MODEL MESHING SCRIPT MAY CONTAIN %
%   BUGS. BE CAREFUL WHEN YOU ARE       %
%   MAKING A GRID OF EVEN NUMBER.       %
% ===================================== %
global xyz;
global custom;
global model;
spacing = 500;
% get customed values
custom.x1=str2num(get(handles.model(1),'string'));
custom.x2=str2num(get(handles.model(2),'string'));
custom.x3=str2num(get(handles.model(3),'string'));
custom.y1=str2num(get(handles.model(4),'string'));
custom.y2=str2num(get(handles.model(5),'string'));
custom.y3=str2num(get(handles.model(6),'string'));
custom.z1=str2num(get(handles.model(7),'string'));
custom.z2=str2num(get(handles.model(8),'string'));
custom.z3=str2num(get(handles.model(9),'string'));
custom.z4=str2num(get(handles.model(10),'string'));
custom.z5=str2num(get(handles.model(11),'string'));
custom.rho=str2num(get(handles.model(12),'string'));
% create cells in x-dir
% get the site coordinate range in x
x1=remesh(xyz(:,1),spacing);
nx1=length(x1);
bw=abs(x1(end)-x1(end-1));
for i=nx1+1 :nx1+custom.x2
    bw=bw*custom.x3;
    x1(i)=x1(i-1)+bw;
end
nx1=length(x1);
x1=flipud(x1);
bw=abs(x1(end)-x1(end-1));
for i=nx1+1:nx1+custom.x2 
    bw=bw*custom.x3;
    x1(i)=x1(i-1)-bw;
end
model.x=flipud(x1);

% create cells in y-dir 
% get the site coordinate range in y
y1=remesh(xyz(:,2),spacing);
bw=abs(y1(end)-y1(end-1));
nx1=length(y1);
for i=nx1+1:nx1+custom.x2
    bw=bw*custom.x3;
    y1(i)=y1(i-1)+bw;
end
nx1=length(y1);
y1=flipud(y1);
bw=abs(y1(end)-y1(end-1));
for i=nx1+1:nx1+custom.x2
    bw=bw*custom.x3;
    y1(i)=y1(i-1)-bw;
end
model.y=flipud(y1);

% create cells in z-dir
z(1)=0;
bw=custom.z1;
z(2)=z(1)-bw;
if bw>50
    for i=3:custom.z3+1
        bw=floor(bw*custom.z2/10+0.5)*10;
        z(i)=z(i-1)-bw;
    end
    for i=custom.z3+2:custom.z3+1+custom.z5
        bw=floor(bw*custom.z4/10+0.5)*10;
        z(i)=z(i-1)-bw; 
    end
else
    for i=3:custom.z3+1
        bw=bw*custom.z2;
        z(i)=z(i-1)-bw;
    end
    for i=custom.z3+2:custom.z3+1+custom.z5
        bw=bw*custom.z4;
        z(i)=z(i-1)-bw;
    end
end
model.z=z';
model.rho=zeros(length(model.x),length(model.y),length(model.z));
model.rho=model.rho(:,:,:)+custom.rho;
model.rho(:,length(model.y),:)=custom.rho+1;
% in case interp3 can not plot same value.
model.fix=zeros(size(model.rho));
model.fix(:,length(model.y),:)=2;
% generate a fix matrix (now it is full of zeros)
[Y X]=meshgrid(model.y,model.x);
pcolor(Y,X,log10(model.rho(:,:,1)));
colormap(flipud(jet(64)));
colorbar('units','normalized','position',[0.61 0.14 0.05 0.25]);
caxis([log10(custom.rhomin),log10(custom.rhomax)]);
axis auto;
daspect([1 1 1]);
plot_site(hObject,eventdata,handles,'noname')
refresh_status(hObject,eventdata,handles);
return;

