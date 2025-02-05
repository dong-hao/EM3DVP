function [data,xyz,sitename,location,clat,clon]=read_modemdata(fname,fdir,data,unit,s)
% Read Gary's ModEM "list" type data file
%=================check var===================%
if nargin==4
    s=[];
elseif nargin==3
    unit='m';s=[];
elseif nargin<3
    error('not enough input arguments, 2 at least');
end
%===============pre-read the data file for parameters ===================%
haveAzi = 0; % flag to test if the data file has the Azimuth info
[perlist,sitelist,complist,signs,clat,clon,rotate,zmul,haveAzi]=scan_modemdata(fname,fdir);
if ~isempty(s) %overiding the sign from the data file
    signs = s;
end
blocks = length(perlist);
sitesize = size(sitelist{1},2);
compsize = size(complist{1},2);
tlst = [];
slst = [];
% clst = [];
for i = 1:blocks
    tlst = [tlst; perlist{i}];
    slst = [slst; sitelist{i}];
    %clst = [clst; complist{i}];
end
% Aumar-proof implementation 
% overriding the clist 
clist = ['ZXX'; 'ZXY'; 'ZYX'; 'ZYY'; 'TX '; 'TY '];
% Benjamin-proof implementation 
plist = unique(tlst);
plist = sort(plist,'ascend');
% Zhang Kun-proof implementation
slist = unique(slst,'rows');
% see how many sites/freqs do we have in total 
nsite = size(slist,1);
nfreq = size(plist,1);
ncomp = size(clist,1);
fprintf('Totally %d sites, %d freqs and %d components found\n', nsite,nfreq,ncomp);
xyz=zeros(nsite,3);
location=zeros(nsite,3);
sitename=cell(nsite,1);
% pre-allocate the main structure
for isite = 1:nsite
    sitename{isite} = strtrim(slist(isite,:));
    data(isite) = gen_data(1./plist,5);
end
% now re-open the data file
fid_data = fopen ([fdir,fname],'r');
iblock=0;
while(~feof(fid_data))
    line=fgetl(fid_data);
    if strfind(line,'#') %try to skip any comments
        continue
    elseif strfind(line,'>') %now we have something to look at        
        % skip 5 lines
        for i = 1:5
            fgetl(fid_data);
        end
        iblock = iblock +1; 
        fprintf('reading block # %d ...\n', iblock);
        presite = -1;
        % essentially we find a TF slot to throw the data in
        if haveAzi % have Azimuth - new type of data
            temp = textscan(fid_data,'%f %s %f %f %f %f %f %s %f %f %f %f %f %f %f');
        else % don't have Azimuth - older type of data
            temp = textscan(fid_data,'%f %s %f %f %f %f %f %s %f %f %f');
        end
        ndata = size(temp{1},1);
        for idata = 1:ndata
            [sitestr]=temp{2}{idata};
            [compstr]=temp{8}{idata};
            per= temp{1}(idata);
            len = length(sitestr);
            sitestr = [sitestr ones(1,sitesize-len)*32];
            len = length(compstr);
            compstr = [compstr ones(1,compsize-len)*32];
            isite = strmatch(sitestr,slist);
            icomp = strmatch(compstr,clist);
            ifreq = find(plist==per,1);
            if presite ~= isite
                location(isite,1)=temp{3}(idata);
                location(isite,2)=temp{4}(idata);
                xyz(isite,1)=temp{5}(idata);
                xyz(isite,2)=temp{6}(idata);
                xyz(isite,3)=temp{7}(idata);
                presite = isite;
            end
            if icomp >= 5
                mlt = 1; %overide the zmul for tippers
            else
                mlt = zmul;
            end
            data(isite).tf_o(ifreq,(icomp-1)*3+1) = temp{9}(idata)*mlt;
            data(isite).tf_o(ifreq,(icomp-1)*3+2) = temp{10}(idata)*mlt*signs;
            data(isite).tf_o(ifreq,(icomp-1)*3+3) = temp{11}(idata)*mlt;
            data(isite).emap_o(ifreq,(icomp-1)*3+3)=1; % set the "mask" flag
        end
    end
end
fprintf('file end reached\n');
% finishing set-ups
for isite = 1:nsite
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
disp(['TF rotation: ' num2str(rotate)]);
disp(['lat: ' num2str(clat)]);
disp(['lon: ' num2str(clon)]);
fclose(fid_data);

return