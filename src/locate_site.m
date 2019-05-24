function [x,y]=locate_site(xyz,model,nsite)
% a function useful for ZK related data file - 
% it is used to determine which mesh block a site sits in. 
% essential for ZK's code as that does not seems to interpolate data
disp('Check if there are more than one sites in a same block ...')
x=zeros(nsite,1);
y=x;
for i=1:nsite
    x(i)=find(model.x>xyz(i,1),1);
    y(i)=find(model.y>xyz(i,2),1);
end
return

