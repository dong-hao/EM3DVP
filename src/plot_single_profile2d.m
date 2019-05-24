function [Plength,pid,sid]=plot_single_profile2d(aid,x1,x2,y1,y2,x,y,z,...
    SubNv,sitex,sitey,sitez,DAR)
% subfunction to plot a single profile section within a 3D model structure
% 
% calculate profile length
Plength=sqrt((x1-x2)^2+(y1-y2)^2);
% Z location of the sites to be plotted
siteup=0.03*(max(z)-min(z));
% find the profile and plot the section
[iX,iY]=cross_mesh(x1,x2,y1,y2,x,y);
pid=oblique_profile2d(aid,x,y,z,SubNv,iX,iY);
set(aid,'TickLength',[0.005 0.005],'TickDir','out');box off;
daspect(aid,[1 DAR 1]);% DAR is the axis aspect x/y
set(aid,'zlim',[min(z)-siteup*3 max(z)+siteup*5]);
hold(aid,'on');
mindist=(x(floor((end+1)/2)+1)-x(floor((end+1)/2)))*2;
[dist,ploc]=calc_point2line(x1,y1,x2,y2,sitey,sitex);
idx1=find(dist<mindist);
idx2=istrap(ploc,0,Plength);
idx=intersect(idx1,idx2);
sid=plot3(aid,x1+ploc(idx),zeros(size(idx)),sitez(idx)+siteup,...
            'kv','MarkerFaceColor','b');
return 

