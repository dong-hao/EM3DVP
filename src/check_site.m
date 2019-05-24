function dcount=check_site(xyz,model,nsite,sitename)
% Check if there's only one site within on block of mesh
% NOTE: while it seems OK to have more than one site (the program runs
% normally), it could result in some WEIRD result for the inversion.
disp('Check if there are more than one sites in a same block ...')
Nsite=nsite;
b=zeros(Nsite,3);
for i=1:Nsite
    b(i,1)=find(model.x>xyz(i,1),1);
    b(i,2)=find(model.y>xyz(i,2),1);
    b(i,3)=i;
end
% if nargin > 0
%     xs=b(isite,1);
%     ys=b(isite,2);
%     return
% end
dcount=0;
% do a bubble check to test if there are sites in a same block
for j=1:Nsite-1
    for k=j+1:Nsite
        if b(j,1)-b(k,1)==0&&b(j,2)-b(k,2)==0
            s1=char(sitename{b(j,3)});
            s2=char(sitename{b(k,3)});
            disp(['The site ' s1 ' and ' s2 ...
                ' are in the same block of the mesh.'])
            dcount=dcount+1;
        end
    end
end
if dcount>0
    warndlg({'More than one sites found in a single block.'...
        'Please check Command Window for detail'},'Warning');
else
    disp('done.')
end
return

