function sweepstn(elev,xyz,x,y,z,rho,fix)
% a curious function to patch topography around stations
nsite=length(elev);
for i = 1: nsite
    xi = find(x>xyz(i,1),1)-1;
    yi = find(y>xyz(i,2),1)-1;
    zi = find(-z>=elev(i),1);
    rho0 = rho(xi,yi,zi);
    rho(xi-1:xi+1,yi,zi-1:zi+1) = rho0;
    fix(xi-1:xi+1,yi,zi-1:zi+1) = 0;
    rho(xi,yi-1:yi+1,zi-1:zi+1) = rho0;
    fix(xi,yi-1:yi+1,zi-1:zi+1) = 0;
end
return
