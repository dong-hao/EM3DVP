function set_rho_123(hObject,eventdata,h)
% a simple function to generate 3D structure from one dimensional structure
% calculated from 1D bostik transformation (thus 123)
% and YES, I know that the concept sounds weird to most of you... 
global model xyz custom data nsite;
currentlayer=custom.currentZ; % z direction
BosPara=bosdlg(size(model.z,1)-1,currentlayer);
if isempty(BosPara) 
    return
end
iU=BosPara(1);
iL=BosPara(2);
Alg=BosPara(5);
switch Alg
    case 1
        Alg='linear';
    case 2
        Alg='nearest';
    otherwise
        Alg='natural';
end
sx=xyz(:,1);
xmin=min(sx);xmax=max(sx);
sy=xyz(:,2);
ymin=min(sy);ymax=max(sy);
x0=find(model.x>xmin,1)-1;
if isempty(x0)
    x0=2;
end
xn=find(model.x>xmax,1);
if isempty(xn)
    xn=length(model.x)-1;
end
y0=find(model.y>ymin,1)-1;
if isempty(y0)
    y0=2;
end
yn=find(model.y>ymax,1);
if isempty(yn)
    yn=length(model.y)-1;
end
mx=model.x(x0-2:xn+2);
my=model.y(y0-2:yn+2);
nx=length(mx);
ny=length(my);
% now add the boundary box into the interpretation list
% left boundary
sx=[sx;mx];
sy=[sy;ones(nx,1)*my(1)];
% right boundary
sx=[sx;mx];
sy=[sy;ones(nx,1)*my(end)];
% upper boundary
sy=[sy;my];
sx=[sx;ones(ny,1)*mx(1)];
% lower boundary
sy=[sy;my];
sx=[sx;ones(ny,1)*mx(end)];
% 
[gy,gx] = meshgrid(my,mx);
res=zeros(nsite+2*nx+2*ny,1);
mbak=model.rho;
for iz=iU:iL % for each layer... 
    depth=model.z(iz);
    res(1:nsite)=batch_bos(data,nsite,depth);
    % now add the resistivtiy of the boundary box...
    % left boundary
    res(nsite+1:nsite+nx)=model.rho(x0-2:xn+2,y0,iz);
    % right boundary
    res(nsite+nx+1:nsite+2*nx)=model.rho(x0-2:xn+2,yn,iz);
    % lower boundary
    res(nsite+2*nx+1:nsite+2*nx+ny)=model.rho(x0,y0-2:yn+2,iz)';
    % upper boundary
    res(nsite+2*nx+ny+1:nsite+2*nx+2*ny)=model.rho(xn,y0-2:yn+2,iz)';
    % now interpolate the site resistivity on to this layer...
    rhoi = scatteredInterpolant(sy,sx,res,Alg,'linear');
    model.rho(x0-2:xn+2,y0-2:yn+2,iz)=rhoi(gy,gx);
end
% now recover fixed region...
model.rho((mbak-0.3)<0.1)=mbak((mbak-0.3)<0.1);
model.rho(end,end,end)=model.rho(end,end,end-1)+1;
d3_view(hObject,eventdata,h);
return

