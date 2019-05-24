function [data,xyz,sitename]=read_wserror(fdir,fname,data)
% Read Weerachai's WSINV3D type error file
%===============open data file===================%
fid_data = fopen ([fdir,fname],'r');
line=fgetl(fid_data);
[Np]= sscanf(line,'%i');
Nsite = Np(1);nfreq = Np(2);Nres = Np(3);
%===============load site map====================%
fgetl(fid_data);%ugly
siteX = fscanf (fid_data ,'%f', Nsite);
fscanf (fid_data ,'%s',2);%ugly
siteY = fscanf (fid_data ,'%f', Nsite);
% now change site location and data
xyz=zeros(Nsite,3);
sitename=cell(Nsite,1);
xyz(:,1)=siteX;
xyz(:,2)=siteY;
fgetl(fid_data);
PerTable=zeros(nfreq,1);
switch Nres
    case 4
        err_sequence=[6,6,9,9];
    case 8
        err_sequence=[3,3,6,6,9,9,12,12];
    case 12
        err_sequence=[3,3,6,6,9,9,12,12,15,15,18,18];
    otherwise
        error('number of responses not recognized');
end
pcount=0;
while(~feof(fid_data))
    if ~isempty(strfind(line,'#Iteration'))
        break;
    end
    if ~isempty(strfind(line,'ERROR_Period:'))
        pcount=pcount+1;
        ptr=strfind(line,':');
        PerTable(pcount)=sscanf(line(ptr+1:end),'%f',1);
        disp(['period ' num2str(PerTable(pcount)) ' found']);
        for isite=1:Nsite
            data(isite).tf_o(pcount,err_sequence)=fscanf(fid_data,'%g',Nres);
        end
        line=fgetl(fid_data);
    else
        disp('searching...');
        line=fgetl(fid_data);
    end
end
fclose(fid_data);
disp('file end reached');
return

