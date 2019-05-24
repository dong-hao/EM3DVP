function oid=oblique_profile2d(aid,Mx,My,Mz,Mv,lx,ly)
% a function to plot oblique x-z profiles within a 3D data mesh Mv. 
% as the name implies, the profiles will be ploted in 2D (x-z) plane
% i.e. one views the section from an angle perpendicular to the profile
% the profile location is given by a line (lx,ly) in X-Y plane.
% a surface location of the profile is generated to allow slice function to
% plot it.  
% aid:      the axis id to work with
% Mx,My,Mz: x, y, z mesh nodes location of the data structure
% Mv:       x by y by z data value
% =========================================================================
% number of x grids of the final plot
Nx=length(lx);
% number of z grids of the final plot
Nz=length(Mz);
xdata=zeros(Nx,Nz);
ydata=xdata;
zdata=xdata;
% meshgrid
[xx,yy,zz] = meshgrid(Mx,My,Mz);
% now fill the data with (hopefully) right location information
for i=1:Nz
    xdata(:,i)=lx;
    ydata(:,i)=ly;
end
for i=1:Nx
    zdata(i,:)=Mz;
end
% now try to plot the slice/profile
oid=slice(aid,xx,yy,zz,Mv,xdata,ydata,zdata);
% now start rotating the slice to orthogonal (y-axis it will be) direction
% calculate the angle between the profile and y-axis
theta=-atan2(ly(end)-ly(1),lx(end)-lx(1));
centre=[lx(1),ly(1),0];
zdir = [0 0 1];
rotate(oid,zdir,theta/pi*180,centre);
return

