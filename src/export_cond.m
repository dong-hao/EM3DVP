function export_cond(filename,latR,lonR,upper,lower,cf)
% a dummy function to request information to export a conductivity map at a
% given depth range.
% function calc_cond is called
global model custom
% C=1.47;
% n=1.3;
outz=custom.z5;
z=model.z(1:(end-outz+1));
rho=model.rho(:,:,1:(end-outz+1));
cond=calc_cond(rho,z,upper,lower);
% depth=(25)*1000;
% ffrac=(cond/depth/C/cf).^(1/n)*100;
figure;
pcolor(log10(cond));
caxis([1.5 4.5]);
colormap(jet(16));
shading flat
Nx=length(model.x)-1;
Ny=length(model.y)-1;
Ngrid=Nx*Ny;
[y0,x0,zone]=deg2utm(latR,lonR,lonR);
zone=num2str(zone);
zone(end+1)=' ';
nzone=(floor((latR+90)/8))+65;
% note: 65 is the decimacial ascii code of charactor 'A'
if nzone>72 % omitting the "I" zone
    nzone=nzone+1;
    if nzone>78 % omitting the "O" zone
        nzone=nzone+1;
    end
end
zone(end+1)=char(nzone);
zone1='    ';
for i=1:Ngrid
    zone1(i,:)=zone;
end
k=1;
xyz=zeros(3,Nx*Ny);
for i=1:Nx
    for j=1:Ny
        xyz(1,k)=1000*(model.x(i)+model.x(i+1))/2+x0;
        xyz(2,k)=1000*(model.y(j)+model.y(j+1))/2+y0;
        xyz(3,k)=cond(i,j);
        k=k+1;
    end
end
% convert the model grid back to degrees
[latm,lonm]=utm2deg(xyz(2,:),xyz(1,:),zone1,lonR);
xyzm=xyz;
xyzm(1,:)=lonm;
xyzm(2,:)=latm;
xyzm(3,:)=xyz(3,:);
xyzpath=pwd;
xyzfile=[filename,'.xyz'];
if isequal(xyzfile,0) || isequal(xyzpath,0)
    disp('user canceled...');
else
    disp(['exporting conductivity map @ ' num2str(upper) ' to ' num2str(lower) 'km...'])
    fid=fopen(fullfile(xyzpath,xyzfile),'w');
    fprintf(fid,'%f %f %g\n',reshape(xyzm,3*Nx*Ny,1));
    % a little trick to avoid THE LOOP HELL...
    fclose(fid);
end
return

