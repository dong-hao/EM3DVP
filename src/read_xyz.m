function [location,sitename]=read_xyz(cfilename,cdir)
fid = fopen ([cdir,cfilename],'r');
line=fgetl(fid);
[temp,count]=sscanf(line,'%s');
fclose(fid);
fid = fopen ([cdir,cfilename],'r');
% maxmium 4096 stations.
switch count
    case 2            
        tmp=fscanf(fid,'%f %f',[2,inf]);
        location(1:2)=tmp';
    case 3
        tmp=fscanf(fid,'%*s %f %f',[2,inf]);
        location(1:2,:)=tmp';
    case 4
        tmp=fscanf(fid,'%*s %f %f %f',[3,inf]);
        location=tmp';
    case 5
        tmp=fscanf(fid,'%*s %*f %f %f %f',[3,inf]);
        location=tmp';
        nsite=length(location);
        sitename=cell(nsite,1);
        frewind(fid);
        for isite=1:nsite
            str1=fgetl(fid);
            sitename{isite}=char(sscanf(str1,'%s %*f %*f %*f %*f')');
        end
    otherwise
        disp('file format not recognized...')
        fclose(fid);
        return                    
end
fclose(fid);
nsite=size(location,1);
sitename=cell(nsite,1);
for i=1:nsite
     sitename{i}=['site',num2str(i)];
end
return

