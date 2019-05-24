function load_model_only(hObject,eventdata,handles)
global model
%=================read model==================%
[fname fdir]=uigetfile({'*model*',  'Model files (*model*)';'*.*',  'Any file'}...
    ,'Open WSINV3DMT Output File');
if fname==0
    fprintf('user canceled reading model');
    clear;
    return
end
fid_model = fopen ([fdir,fname],'r');
line=fgetl(fid_model);
fig_title=line;
p1=strfind(fig_title,'RMS =');
p2=strfind(fig_title,'LM =');
if isempty(p2)
    fig_title=deblank(fig_title(p1+5:end));
else
    fig_title=deblank(fig_title(p1+5:p2-1));
end
line=fgetl(fid_model);
[Nxyz]= sscanf(line,'%i');
Nx = Nxyz(1); Ny = Nxyz(2); Nz = Nxyz(3);
X0 = fscanf (fid_model ,'%f', Nx);
Y0 = fscanf (fid_model ,'%f', Ny);
Z0 = fscanf (fid_model ,'%f', Nz);
V = zeros(Nx,Ny,Nz);
for k=1:Nz
    for j=1:Ny
        for i=Nx:-1:1
            %V(i,j,k)=log10(fscanf(fid_model,'%f',1));% note that this is log 10 version
            V(i,j,k)=fscanf(fid_model,'%f',1);% normal
        end
    end
end
fclose(fid_model);
%==================make grid=====================%
x=zeros(Nx+1,1); y=zeros(Ny+1,1); z=zeros(Nz+1,1);
% compute x,y,z block locations(at block edges)
for i=1:Nx;
    x(i+1)=x(i)+X0(i);
end
for i=1:Ny;
    y(i+1)=y(i)+Y0(i);
end
for i=1:Nz;
    z(i+1)=z(i)-Z0(i);
end
x=x-(max(x)-min(x))/2;
y=y-(max(y)-min(y))/2;
%x = 35+x*360/(1000*6371*2*pi);
%y = 115+y*360/(1000*6371*2*pi)*acos(mean(x)/180*pi);
% extend model so that slice will plot all elements
% Note to self: pcolor (2d) works in the same way
V(Nx+1,:,:)=V(Nx,:,:);
V(:,Ny+1,:)=V(:,Ny,:);
V(:,:,Nz+1)=V(:,:,Nz);
model.x=x;
model.y=y;
model.z=z;
model.rho=V;
%in case the model have a same rho
model.rho(end,end,end)=model.rho(end,end,end)+1;
model.fix=zeros(size(model.rho));
cut(hObject,eventdata,handles)
return

