function set_rho_sphere(hObject,eventdata,h)
global model
nx=length(model.x)-1;
ny=length(model.y)-1;
nz=length(model.z)-1;
midx=zeros(1,nx);
midy=zeros(1,ny);
midz=zeros(1,nz);
for i=1:nx
    midx(i)=(model.x(i)+model.x(i+1))/2;
end
for i=1:ny
    midy(i)=(model.y(i)+model.y(i+1))/2;
end
for i=1:nz
    midz(i)=(model.z(i)+model.z(i+1))/2;
end
[yy,xx,zz]=meshgrid(midy,midx,midz);
SpherePara = spheredlg;% reading spheredlg
xyz=zeros(1,3);
xyz(1)=SpherePara(1);
xyz(2)=SpherePara(2);
xyz(3)=SpherePara(3);
R=SpherePara(4);
rho=SpherePara(5);
mws=insphere(yy,xx,zz,xyz,R);% mesh within sphere;
%[indexy,indexx]=find(mws(:,:,1)~=0); % find index for meshes in sphere
[indexy,indexx,indexz] = ind2sub(size(mws),find(mws ~= 0)); % find index for meshes in sphere

for j=1:length(indexx) % i don't like loops, but i have no idea how to use vectors in 3d matrix
    model.rho(indexy(j),indexx(j),indexz(j))=rho;
    % change resistivity of the meshes within the sphere *one by one*
end
model.rho(end,end,end)=model.rho(end,end,end-1)+1;% change the last cell by one
% so that matlab won't bother to choke up any errors

% replot...
d3_view(hObject,eventdata,h);
% for debug;
% figure
% plot(linex,liney,'r',yy(mwp),xx(mwp),'r+',yy(~mwp),xx(~mwp),'k.')
% daspect([1 1 1])
% end debug;
return

