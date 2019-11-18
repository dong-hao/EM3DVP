function model=read_wsmodel(fdir,fname,unit)
% Read Weerachai's WSINV3D model files which is also ModEM's default model 
% files in 
% either real rho value format or rho index format
%
% NOTE TO SELF: the mesh index will increase as
% S->N =X, W->E =Y, U->D =Z, the X1Y1Z1 cell will be the
% top, left, front mesh cell
%
% USAGE:
% model=read_wsmodel(fdir,fname,unit)
% model: the model data structure containing the mesh node location 
%        and resistivities
% fdir: a string of the directory where the model file lies
% fname: a string of the name of the model file
% unit: should be 'm' or 'km', determines whether the mesh mode is 
%       outputed in metre or kilometre.
%
% EXAMPLE: 
% initmodel=read_wsmodel('~/data/','initmodel.dat','km');
%
% ver 0.2 2013.09 
% DONG Hao
% donghao.cugb@gmail.com
%=================check var===================%
if nargin==2
    unit='m';
elseif nargin<2
    error('not enough input arguments, 2 at least');
end
%=================read model==================%
fid_model = fopen ([fdir,fname],'r');
line=fgetl(fid_model); % skip the first line if we find comment flag in it
if ~isempty(strfind(line,'#'))
    line=fgetl(fid_model);
end
if strfind(line,'LOGE') % gary's LOGE ws file
    option='loge';
elseif strfind(line,'LINEAR') % gary's normal ws file
    option='linear';
else % original WS file
    option='linear';
end
[Nxyz]= sscanf(line,'%i %i %i %i %*s');
Nx = Nxyz(1); Ny = Nxyz(2); Nz = Nxyz(3); Nidx = Nxyz(4);
X0 = fscanf (fid_model ,'%f', Nx);
Y0 = fscanf (fid_model ,'%f', Ny);
Z0 = fscanf (fid_model ,'%f', Nz);
V = zeros(Nx,Ny,Nz);
if Nidx==0 % we have real rho value 
    for k=1:Nz
        for j=1:Ny
            for i=Nx:-1:1
                %V(i,j,k)=log10(fscanf(fid_model,'%f',1));% note that this is log 10 version
                V(i,j,k)=fscanf(fid_model,'%f',1);% normal
            end
        end
    end
else % we have rho indices
    rhoidx=zeros(Nidx,1);
    rho=zeros(Nx,Ny);
    for i=1:Nidx
        rhoidx(i)=fscanf(fid_model,'%f',1);
    end
    i=0;
    while (i<Nz)
        temp=fscanf(fid_model,'%f %f',2);
        l1=temp(1);
        l2=temp(2); 
        for j=Nx:-1:1
            for k=1:Ny
                rho(j,k)=fscanf(fid_model,'%i',1);
                % read a single idx
            end
        end
        for i=l1:l2
            V(:,:,i)=rho;
        end
    end
    for idx=1:Nidx
        V(V==idx)=rhoidx(idx);
    end
end
origin=fscanf(fid_model,'%f %f %f',3);
rotate=fscanf(fid_model,'%f');
switch option
    case 'loge'
        V=exp(V);
    case 'log10' %reserved for future type
        V=10.^V;
    case 'linear'
        % do nothing
end
fclose(fid_model);
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
if isempty(origin)
    origin=[0, 0, 0];
end
if origin(1)==0
    x=x-(max(x)-min(x))/2;
else
    x=x+origin(1);
end
if origin(2)==0
    y=y-(max(y)-min(y))/2;
else
    y=y+origin(2);
end
% extend model so that slice will plot all elements
% Note to self: pcolor (2d) works in the same way
V(Nx+1,:,:)=V(Nx,:,:);
V(:,Ny+1,:)=V(:,Ny,:);
V(:,:,Nz+1)=V(:,:,Nz);
switch unit
    case 'km'
        model.x=x/1000;
        model.y=y/1000;
        model.z=z/1000;
    case 'm'
        model.x=x;
        model.y=y;
        model.z=z;
end
model.rho=V;
model.origin=origin;
model.rotate=rotate;
%in case the model have a same rho
model.rho(end,end,end)=model.rho(end,end,end)+1;
model.fix=ones(size(model.rho)); %create fix matrix
return

