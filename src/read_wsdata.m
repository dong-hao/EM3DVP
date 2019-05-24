function [data,xyz,sitename]=read_wsdata(fdir,fname,data,unit)
% Read Weerachai's WSINV3D type data (and resp) file
%=================check var===================%
if nargin==3
    unit='m';
elseif nargin<3
    error('not enough input arguments, 3 at least');
end
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
pcount=0;
switch Nres
    case 4
        res_sequence=[4,5,7,8];
    case 8
        res_sequence=[1,2,4,5,7,8,10,11];
    case 12
        res_sequence=[1,2,4,5,7,8,10,11,13,14,16,17];
    otherwise
        error('number of responses not recognized')
end
% check if we have original sitename file in current dir
sfid=fopen(fullfile(fdir,'sitename.dat'),'r');
if sfid > 0
    disp('sitename file found, retrieving original site names...')
    for i=1:Nsite
        node=fgetl(sfid);
        sitename{i}=node;
        data(i)=gen_data;
        data(i).nfreq_o=nfreq;
    end
    fclose(sfid);
else
    disp('sitename file not found, using numbers instead...')
    for i=1:Nsite
        sitename{i}=['site',num2str(i)];
        data(i)=gen_data;
        data(i).nfreq_o=nfreq;
    end
end
% start reading data
while(~feof(fid_data))
    line=fgetl(fid_data);
    if ~isempty(strfind(line,'#Iteration'))||~isempty(strfind(line,'ERROR_Period:'))...
        ||~isempty(strfind(line,'               '))
        break;
    end
    if ~isempty(strfind(line,'DATA_Period:'))
        pcount=pcount+1;
        ptr=strfind(line,':');
        PerTable(pcount)=sscanf(line(ptr+1:end),'%f',1);
        disp(['period ' num2str(PerTable(pcount)) ' found']);
        for isite=1:Nsite
            data(isite).tf_o(pcount,res_sequence)=fscanf(fid_data,'%g',Nres);
        end
        line=fgetl(fid_data); %#ok<NASGU>
    else
        disp('searching')        
    end
end
fclose(fid_data);
disp('file end reached');
for isite=1:Nsite
    data(isite).freq_o=PerTable;
    data(isite).emap_o=zeros(size(data(isite).tf_o));
    switch Nres
        case 4
            emap_sequence=4:9;
        case 8
            emap_sequence=1:12;
        case 12
            emap_sequence=1:18;
        otherwise
            error('number of responses not recognized')
    end 
    data(isite).emap_o(:,emap_sequence)=1;
    data(isite).nfreq=data(isite).nfreq_o;
    data(isite).freq=data(isite).freq_o;
    data(isite).tf=data(isite).tf_o;
    data(isite).emap=data(isite).emap_o;
end
switch unit
    case 'km'
        xyz=xyz./1000;
    case 'm'
        %do nothing
end
return

