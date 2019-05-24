function copy_pseudo(hObject,eventdata,h)
% copy current objs to a new figure to edit or save as you wish.
fid=figure;
set(fid,'position',[100 60 600 900],...
    'numbertitle','off',...
    'name','copied pic');
children=get(h.figure,'Children');
ax=findobj(children,'type','axes');
pos=get(ax(2),'Position');
pos(1)=pos(1)+0.05;
h1=copyobj(h.axis(1),fid);
l1=copyobj(ax(2),fid);
set(l1,'pos',pos)
set(h1,'pos',[0.07 0.55 0.87 0.4]);
pos=get(ax(1),'Position');
pos(1)=pos(1)+0.05;
h2=copyobj(h.axis(2),fid);
l2=copyobj(ax(1),fid);
set(l2,'pos',pos)
set(h2,'pos',[0.07 0.07 0.87 0.4]);
return


