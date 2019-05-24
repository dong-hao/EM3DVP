function load_WinG_model(hObject, eventdata, handles)
global model;
% Read Randy Mackie's mesh output file (winglink format model)
% Please Note that winglink uses coordinates different from
% Weerachai's coordindate.
% i.e. N->S =Y, W->E =X, U->D =Z, the X1Y1Z1 cell will be the
% top, left, rear mesh cell
[fname,fpath] = uigetfile({'*.out'},'load winglink *.out file');
if fname==0
    fprintf('user canceled reading model');
    clear;
    return
end
fid=fopen ([fpath,fname],'r');
[Nxyza]=fscanf(fid,'%d %d %d %d');
Nx=Nxyza(1);Ny=Nxyza(2);Nz=Nxyza(3);Na=Nxyza(4);
void=fscanf(fid,'%s',1);% this string should be "VALUE"
X=fscanf(fid,'%f',Nx);
Y=fscanf(fid,'%f',Ny);
Z=round(fscanf(fid,'%f',Nz));
V=zeros(Nx,Ny,Nz);
for layer=1:Nz
    void=fscanf(fid,'%f',1); %ugly
    Vi=reshape(fscanf(fid,'%g',Nx*Ny),Nx,Ny); %resistivity of a single layer.
    V(:,:,layer)=Vi;
end
for tails=1:5
    void=fgetl(fid);%ugly
end
rotation=fscanf(fid,'%f',1); %not really used in current version, just read it
void=fscanf(fid,'%s',1);% this string should be "(rotation)"
elevation=fscanf(fid,'%f',1);%not really used in current version, just read it
disp(rotation)
disp(elevation)
fclose(fid);
%assign values for current model.
x=zeros(Nx+1,1); y=zeros(Ny+1,1); z=zeros(Nz+1,1);
% compute x,y,z block locations(at block edges)
for i=1:Nx
    x(i+1)=x(i)+X(i);
end
for i=1:Ny
    y(i+1)=y(i)+Y(i);
end
for i=1:Nz
    z(i+1)=z(i)-Z(i);
end
x=x-(max(x)-min(x))/2;
y=y-(max(y)-min(y))/2;
V(Nx+1,:,:)=V(Nx,:,:);
V(:,Ny+1,:)=V(:,Ny,:);
V(:,:,Nz+1)=V(:,:,Nz);
V2=zeros(Ny+1,Nx+1,Nz+1);
for i=1:Nz
    V2(:,:,i)=flipud(V(:,:,i)');
end
model.x=y;
model.y=x;
model.z=z;
model.rho=V2;
%in case the model have a same rho
model.rho(end,end,end)=model.rho(end,end,end)+1;
model.fix=zeros(size(model.rho)); %create fix matrix
d3_view(hObject, eventdata, handles);
refresh_status(hObject,eventdata,handles);
return

