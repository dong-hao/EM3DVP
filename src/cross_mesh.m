function [x,y]=cross_mesh(x1,x2,y1,y2,meshx,meshy)
% a function to determine where the given line (x1,y1)-(x2,y2) cross an
% orthogonal mesh grid (mx,my) on a plane;
% two arrays of the location of crossings (x,y) will be returned  
% x1, y1: starting point of the line
% x2, y2: ending point of the line
% meshx, meshy: x and y coordinate of the mesh nodes.
idx=istrap(meshx,x1,x2);
idy=istrap(meshy,y1,y2);
Nx=length(idx);
Ny=length(idy);
x=zeros(1,Nx+Ny+2);
y=x;
theta=atan2(y2-y1,x2-x1);
tanthe=tan(theta);
x(1)=x1;
y(1)=y1;
icount=1;
for i=1:Nx % now find the crossings in X
    icount=icount+1;
    dx=meshx(idx(i))-x1;
    x(icount)=meshx(idx(i));
    y(icount)=y1+dx*tanthe;
end
for i=1:Ny % now find the crossings in Y
    icount=icount+1;
    dy=meshy(idy(i))-y1;
    x(icount)=x1+dy/tanthe;
    y(icount)=meshy(idy(i));
end
x(end)=x2;
y(end)=y2;
% now try to sort the locations
% since we have a straight line
% we can assume these points are monotone
xy=[x;y];
if x2>x1
    [tmp,I]=sort(xy(1,:));
    nxy=xy(:,I); 
elseif y2>y1
    [tmp,I]=sort(xy(2,:));
    nxy=xy(:,I);
elseif x2<x1
    [tmp,I]=sort(xy(1,:));
    nxy=xy(:,I);
    nxy=fliplr(nxy);
else 
    [tmp,I]=sort(xy(2,:));
    nxy=xy(:,I);
    nxy=fliplr(nxy);    
end
x=nxy(1,:);
y=nxy(2,:);
return

