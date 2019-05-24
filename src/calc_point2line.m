function [d,ploc]=calc_point2line(x1,y1,x2,y2,x0,y0)
% a simple function to calculate the distance from a given point [a,b] to a
% straight line [x1,y1]-[x2,y2] on a plane
% x1,y1: starting point of the line
% x2,y2: ending point of the line
% x0,y0: an array of the point locations 
% d: distance between the point and the line
% ploc: location of the projection of the point to the line
d=abs((y2-y1)*x0-(x2-x1)*y0+x2*y1-y2*x1);
d12=sqrt((y2-y1)^2+(x2-x1)^2);
d=d/d12;
d01sq=(y1-y0).^2+(x1-x0).^2;
d02sq=(y2-y0).^2+(x2-x0).^2;
ploc01=sqrt(d01sq-d.^2);
ploc02=sqrt(d02sq-d.^2);
ploc=ploc01;
% set the locations projected to the left of the line as negative
idx1=find(ploc02>d12);
idx2=find(ploc02>ploc01);
idx=intersect(idx1,idx2);
ploc(idx)=-ploc(idx);
return 

