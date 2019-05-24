function model=read_ZKmodel(fdir,fname,unit)
% Read Zhang Kun's model format
% either real rho value format or rho index format
%
% NOTE TO SELF: the mesh index will increase as
% S->N =X, W->E =Y, U->D =Z, the X1Y1Z1 cell will be the
% top, left, front mesh cell
%
% USAGE:
% model=read_ZKmodel(fdir,fname,unit)
% model: the model data structure containing the mesh node location 
%        and resistivities
% fdir: a string of the directory where the model file lies
% fname: a string of the name of the model file
% unit: should be 'm' or 'km', determines whether the mesh mode is 
%       outputed in metre or kilometre.
%
%=================check var===================%
if nargin==2
    unit='m';
elseif nargin<2
    error('not enough input arguments, 2 at least');
end
%=================read model==================%
fid_model = fopen ([fdir,fname],'r');
line=fgetl(fid_model); 
% if ~isempty(strfind(line,'#'))
%     line=fgetl(fid_model);
% end
% if strfind(line,'LOGE') % gary's LOGE ws file
%     option='loge';
% elseif strfind(line,'LINEAR') % gary's normal ws file
%     option='linear';
% else % original WS file
%     option='linear';
% end
[Nxyz]= sscanf(line,'%i %i %i ');
Nx = Nxyz(1); Ny = Nxyz(2); Nz = Nxyz(3); 
X0 = fscanf (fid_model ,'%f', Nx);
Y0 = fscanf (fid_model ,'%f', Ny);
Z0 = fscanf (fid_model ,'%f', Nz);
Nidx = fscanf (fid_model ,'%f', 1); %whether we use index or real value
V = zeros(Nx,Ny,Nz);
if Nidx==0 % we have real rho value
    for i=1:Nx
        for j=1:Ny
            for k=1:Nz
                V(i,j,k)=fscanf(fid_model,'%f',1);% normal
            end
        end
    end
else % we have rho indices
    for i=1:Nx
        for j=1:Ny
            for k=1:Nz
                V(i,j,k)=fscanf(fid_model,'%f',1);% normal
            end
        end
    end
    rhoidx=fscanf(fid_model,'%f',Nidx);
    for i=1:Nidx
        V(V==i)=rhoidx(i);
    end
end
fclose(fid_model);
x=zeros(Nx+1,1); y=zeros(Ny+1,1); z=zeros(Nz+1,1);
% compute x,y,z block locations(at block edges)
for i=1:Nx
    x(i+1)=x(i)+X0(i);
end
for i=1:Ny
    y(i+1)=y(i)+Y0(i);
end
for i=1:Nz
    z(i+1)=z(i)-Z0(i);
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
model.origin=[0,0,0];
model.rotate=0;
%in case the model have a same rho
model.rho(end,end,end)=model.rho(end,end,end)+1;
model.fix=zeros(size(model.rho)); %create fix matrix
return

