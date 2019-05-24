function export_xyzv_utm(hObject, event, filename,latR,lonR,x,y,z,v)
% export xyzv files in "LON LAT DEPTH logRHO" format
% to be used with external programs to plot... (probably voxler)
Nx=length(x)-1;
Ny=length(y)-1;
Nz=length(z)-1;
Ngrid=Nx*Ny*Nz;

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
zone1=ones(Ngrid,4);
for i=1:Ngrid
    zone1(i,:)=zone;
end

t=1;
xyzv=zeros(4,Nx*Ny*Nz);
for k=1:Nz
    for j=1:Ny
        for i=Nx:-1:1
            xyzv(1,t)=1000*(x(i)+x(i+1))/2+x0;
            xyzv(2,t)=1000*(y(j)+y(j+1))/2+y0;
            xyzv(3,t)=(z(k)+z(k+1))/2/100;
            xyzv(4,t)=log10(v(i,j,k));
            t=t+1;
        end
    end
end

% convert the model grid back to degrees
[latm,lonm]=utm2deg(xyzv(2,:),xyzv(1,:),zone1,lonR);
xyzv(1,:)=lonm;
xyzv(2,:)=latm;

xyzpath=pwd;
xyzfile=[filename,'.xyzv'];
if isequal(xyzfile,0) || isequal(xyzpath,0)
    disp('user canceled...');
else
    disp('exporting xyzv...')
    fid=fopen(fullfile(xyzpath,xyzfile),'w');
    fprintf(fid,'%f %f %f %g\n',reshape(xyzv,4*Nx*Ny*Nz,1));
    % a little trick to avoid THE LOOP HELL...
    fclose(fid);
end
return


