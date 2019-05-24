function [data,sitename]=read_ZKdata(fdir,fname,data)
% Read ZK type data file (without site location)
% the format kind of mimics the 2D Mackie format 
%
% ZK format does not have any location information - 
% the first line indicate number of stations in the file.
% the second line will tell you the number of periods
% and the static shift parameter - not very useful when you have two
% polarizations. 
% then each line will be one period from current station - something like
% period Zxxr Zxxi Z

%===============open data file===================%
fid_data = fopen ([fdir,fname],'r');
line=fgetl(fid_data);
[Np]= sscanf(line,'%i'); % number of stations
Nsite = Np(1);
sitename=cell(Nsite,1);
%===============no site map here====================%
for isite=1:Nsite
    line=fgetl(fid_data);
    [Np]= sscanf(line,'%i'); % number of periods and static shift parameter
    nfreq = Np(1);sshift = Np(2);
    data(isite)=gen_data;
    data(isite).nfreq_o=nfreq;
    data(isite).tf_o=zeros(nfreq,18);
    for ifreq=1:nfreq
        line=fgetl(fid_data);
        tmp=sscanf(line,'%f ');
        data(isite).freq_o(ifreq)=tmp(1);
        data(isite).tf_o(ifreq,[1,2,4,5,7,8,10,11])=tmp(2:9);
        data(isite).tf_o(ifreq,[13,14,16,17])=tmp(10:13);
        data(isite).tf_o(ifreq,[3,6,9,12])=tmp([14 16 18 20]);
        data(isite).tf_o(ifreq,[15,18])=tmp([22 24]);
        flag = tmp(26:37);
    end
end
Nres = sum(flag);
% check if we have original sitename file in current dir
sfid=fopen(fullfile(fdir,'sitename.dat'),'r');
if sfid > 0
    disp('sitename file found, retrieving original site names...')
    for i=1:Nsite
        node=fgetl(sfid);
        sitename{i}=node;
    end
    fclose(sfid);
else
    disp('sitename file not found, using numbers instead...')
    for i=1:Nsite
        sitename{i}=['site',num2str(i)];
    end
end
% start reading data
fclose(fid_data);
disp('file end reached');
for isite=1:Nsite
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
return