function mesher(hObject,eventdata,handles)
% ==============CAUTION!=============== %
% THIS MODEL MESHING SCRIPT MAY CONTAIN %
%   BUGS. BE CAREFUL WHEN YOU ARE       %
%   MAKING A GRID OF EVEN NUMBER.       %
% ===================================== %
global xyz;
global custom;
global model;
% get customed values
% custom.x1=str2num(get(handles.model(1),'string'));
% custom.x2=str2num(get(handles.model(2),'string'));
% custom.x3=str2num(get(handles.model(3),'string'));
% custom.y1=str2num(get(handles.model(4),'string'));
% custom.y2=str2num(get(handles.model(5),'string'));
% custom.y3=str2num(get(handles.model(6),'string'));
% custom.z1=str2num(get(handles.model(7),'string'));
% custom.z3=str2num(get(handles.model(8),'string'));
% custom.z2=str2num(get(handles.model(9),'string'));
% custom.z5=str2num(get(handles.model(10),'string'));
% custom.z4=str2num(get(handles.model(11),'string'));
% custom.rho=str2num(get(handles.model(12),'string'));
% create cells in x-dir
xmin=min(xyz(:,1));xmax=max(xyz(:,1));
custom.x1=round(custom.x1);
midx=0.5*custom.x1;
% see if there is a site "in the centre of" our mesh
xspan=round((xmax-xmin)/custom.x1);
if  mod(xspan,2)~=0 % we need even number of blocks
	nix1=floor((abs(xmin))/custom.x1)+4;  %South (down) side incore blocks
    nix2=floor((abs(xmax))/custom.x1)+4;  %North (up) side incore blocks
    x1=zeros(nix1+custom.x2+1,1);         %South (down) side grids
    x1(1)=0; 
    for i=2:nix1+1
        x1(i)=x1(i-1)-custom.x1;
    end
    bw=custom.x1;
    for i=nix1+2:nix1+custom.x2+1
        bw=bw*custom.x3;
        x1(i)=x1(i-1)-round(bw);
    end
    x2=zeros(nix2+custom.x2+1,1);          %North (up) side grids
    x2(1)=0;
    for i=2:nix2+1
        x2(i)=x2(i-1)+custom.x1;
    end
    bw=custom.x1;
    for i=nix2+2:nix2+custom.x2+1
        bw=bw*custom.x3;
        x2(i)=x2(i-1)+round(bw);
    end
    model.x=[x1(length(x1):-1:2);x2];
else
    % we need odd number of blocks
    nix1=floor((abs(xmin)-custom.x1/2)/custom.x1)+4;  %South (down) side incore blocks
    nix2=floor((abs(xmax)-custom.x1/2)/custom.x1)+4;  %North (up) side incore blocks
    x1=zeros(nix1+custom.x2+1,1);          %South (down) side grids
    x1(1)=-midx;
    for i=2:nix1+1
        x1(i)=x1(i-1)-custom.x1;
    end
    bw=custom.x1;
    for i=nix1+2:nix1+custom.x2+1
        bw=bw*custom.x3;
        x1(i)=x1(i-1)-round(bw);
    end
    x2=zeros(nix2+custom.x2+1,1);          %North (up) side grids
    x2(1)=midx;
    for i=2:nix2+1
        x2(i)=x2(i-1)+custom.x1;
    end
    bw=custom.x1;
    for i=nix2+2:nix2+custom.x2+1
        bw=bw*custom.x3;
        x2(i)=x2(i-1)+round(bw);
    end
    model.x=[x1(length(x1):-1:1);x2];
end
% create cells in y-dir 
ymin=min(xyz(:,2));ymax=max(xyz(:,2));
custom.y1=round(custom.y1);
midy=0.5*custom.y1;
yspan=round((ymax-ymin)/(custom.y1));
if mod(yspan,2)~=0 % we need even number of blocks
    niy1=floor((abs(ymin))/custom.y1)+4;  %west(left) side incore blocks
    niy2=floor((abs(ymax))/custom.y1)+4;  %east(right) side incore blocks
    y1=zeros(niy1+custom.y2+1,1);         %west(left) side grids
    y1(1)=0;
    for i=2:niy1+1
        y1(i)=y1(i-1)-custom.y1;
    end
    bw=custom.y1;
    for i=niy1+2:niy1+custom.y2+1
        bw=bw*custom.y3;
        y1(i)=y1(i-1)-round(bw);
    end
    y2=zeros(niy2+custom.y2+1,1);          %east(right) side grids
    y2(1)=0;
    for i=2:niy2+1
        y2(i)=y2(i-1)+custom.y1;
    end
    bw=custom.y1;
    for i=niy2+2:niy2+custom.y2+1
        bw=bw*custom.y3;
        y2(i)=y2(i-1)+round(bw);
    end
    model.y=[y1(length(y1):-1:2);y2];
else
    % else we might use a mesh of odd number grids
    niy1=floor((abs(ymin)-custom.y1/2)/custom.y1)+4;  %west(left) side incore blocks
    niy2=floor((abs(ymax)-custom.y1/2)/custom.y1)+4;  %east(right) side incore blocks
    y1=zeros(niy1+custom.y2+1,1);          %west(left) side grids
    y1(1)=-midy;
    for i=2:niy1+1
        y1(i)=y1(i-1)-custom.y1;
    end
    bw=custom.y1;
    for i=niy1+2:niy1+custom.y2+1
        bw=bw*custom.y3;
        y1(i)=y1(i-1)-round(bw);
    end
    y2=zeros(niy2+custom.y2+1,1);          %east(right) side grids
    y2(1)=midy;
    for i=2:niy2+1
        y2(i)=y2(i-1)+custom.y1;
    end
    bw=custom.y1;
    for i=niy2+2:niy2+custom.y2+1
        bw=bw*custom.y3;
        y2(i)=y2(i-1)+round(bw);
    end
    model.y=[y1(length(y1):-1:1);y2];
end
% create cells in z-dir
z(1)=0;
bw=round(custom.z1);
z(2)=z(1)-bw;
if bw>50
    for i=3:custom.z2+1
        bw=floor(bw*custom.z3/10+0.5)*10;
        z(i)=z(i-1)-bw;
    end
    for i=custom.z2+2:custom.z2+1+custom.z4
        bw=floor(bw*custom.z5/10+0.5)*10;
        z(i)=z(i-1)-bw; 
    end
    for i=custom.z2+2+custom.z4:custom.z2+7+custom.z4
        bw=floor(bw*1.5/10+0.5)*10;
        z(i)=z(i-1)-bw; 
    end
else
    for i=3:custom.z2+1
        bw=floor(bw*custom.z3);
        z(i)=z(i-1)-bw;
    end
    for i=custom.z2+2:custom.z2+1+custom.z4
        bw=floor(bw*custom.z5);
        z(i)=z(i-1)-bw;
    end
    for i=custom.z2+2+custom.z4:custom.z2+6+custom.z4
        bw=floor(bw*1.5/10+0.5)*10;
        z(i)=z(i-1)-bw; 
    end
end
model.z=z';
model.rho=zeros(length(model.x),length(model.y),length(model.z));
model.rho=model.rho(:,:,:)+custom.rho;
model.rho(:,length(model.y),:)=custom.rho+1;
% in case interp3 can not plot same value.
model.fix=zeros(size(model.rho));
model.fix(:,end,:)=1;
% generate a fix matrix (now it is full of zeros)
d3_view(hObject,eventdata,handles);
refresh_status(hObject,eventdata,handles);
return;

