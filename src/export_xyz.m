function export_xyz(hObject, event, filename, Nz, latR, lonR)
% export xyz files for horizontal slices in "LON LAT logRHO" format
% to be used with external programs to plot... (probably GMT)

global model
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
        xyz(3,k)=model.rho(i,j,Nz);
        k=k+1;
    end
end
% convert the model grid back to degrees
[latm,lonm]=utm2deg(xyz(2,:),xyz(1,:),zone1,lonR);
xyzm=xyz;
xyzm(1,:)=lonm;
xyzm(2,:)=latm;
xyzm(3,:)=log10(xyz(3,:));
xyzpath=pwd;
xyzfile=[filename,'.xyz'];
if isequal(xyzfile,0) || isequal(xyzpath,0)
    disp('user canceled...');
else
    disp(['exporting xyz of slice @ layer ' num2str(Nz) '...'])
    fid=fopen(fullfile(xyzpath,xyzfile),'w');
    fprintf(fid,'%f %f %g\n',reshape(xyzm,3*Nx*Ny,1));
    % a little trick to avoid THE LOOP HELL...
    fclose(fid);
end
return

