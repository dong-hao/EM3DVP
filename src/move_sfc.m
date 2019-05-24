function oid=move_sfc(oid,dx,dy,dz)
% a function to move the selected surface object to a given location [x,y,z]
% Note that the very first mesh element (first in xdata,ydata,zdata) will
% be moved to that location. 
% oid: the handle of the surface object
% dx,dy,dz: the displacement you want the object be. 
xdata=get(oid,'xdata');
ydata=get(oid,'ydata');
zdata=get(oid,'zdata');
xdata=xdata+dx;
ydata=ydata+dy;
zdata=zdata+dz;
set(oid,'xdata',xdata);
set(oid,'ydata',ydata);
set(oid,'zdata',zdata);
return

