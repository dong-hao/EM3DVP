function [data,xyz,sitename,location,lat,lon]=read_modemdata(fname,fdir,data,unit,s)
% Read Gary's ModEM "list" type data file
%=================check var===================%
if nargin==4
    s=[];
elseif nargin==3
    unit='m';s=[];
elseif nargin<3
    error('not enough input arguments, 2 at least');
end
%===============open data file===================%
fid_data = fopen ([fdir,fname],'r');
% firstly sweep the data file for frequency list
NL = 0;
while(~feof(fid_data))
    line=fgetl(fid_data);
    if strfind(line,'> ')
        NL = NL+1;
    end
    if NL == 6 
        tmp=sscanf(line,'%*s %i %i');
        nfreq=tmp(1);
        nsite=tmp(2);
        flist=zeros(nfreq,1);
        ifreq=0;
        disp(['start searching for ', num2str(nfreq), ' frequncies'])
        NL = NL + 1;
    elseif NL > 6
        newfreq=1/sscanf(line,'%f %*s %*f %*f %*f %*f %*f %*f %*f %*f %*f',1);
        iprev = find(abs(flist./newfreq-1)<0.01,1); %check if we have see this before
        if isempty(iprev) % we have not encounter this frequency before
            disp(['new freq ', num2str(newfreq), ' Hz found'])
            ifreq = ifreq + 1;
            flist(ifreq) = newfreq;
        end
        if ifreq == nfreq %we already found all the listed frequencies
            disp('all freqs located... stop searching')
            disp([num2str(NL),'(!) lines searched']);
            break
        end
    end
end
fclose(fid_data);
% Benjamin-proof implementation 
flist = sort(flist,'descend');
% now re-open the data file
fid_data = fopen ([fdir,fname],'r');
block=0;% flag to identify how many blocks of data we have read
while(~feof(fid_data))
    line=fgetl(fid_data);
    if strfind(line,'#') %try to skip any comments
        continue
    elseif strfind(line,'>') %now we have something to look at        
        if ~isempty(strfind(line,'Full_Impedance'))
            option='fi';
        elseif ~isempty(strfind(line,'Vertical'))
            option='ft';
        elseif ~isempty(strfind(line,'Off_Diagonal'))
            option='oi';
        else 
            error('this type of data is not yet supported');
        end
        block=block+1;
        line=fgetl(fid_data);
        if isempty(s)
            if strfind(line,'+')
                signs = 1;
            elseif strfind(line,'-')
                signs = -1;
            else % assume plus sign
                signs = 1;
            end
        else
            signs=s;
        end
        line=fgetl(fid_data);
        if ~isempty(strfind(line,'[V/m]/[A/m]')) %Ohm
            zmul=796;
        elseif ~isempty(strfind(line,'[V/m]/[T]')) %V/m/nT
            zmul=0.001;
        elseif ~isempty(strfind(line,'Ohm')) % still Ohm (only found in old ModEM examples)
            zmul = 796;
        else %[mV/km]/nT
            zmul=1;
        end
        rotate=fscanf(fid_data,'%*s %f\n',1);
        latlon=fscanf(fid_data,'%*s %f %f\n',2);
        lat=latlon(1);
        lon=latlon(2);
        fgetl(fid_data); %skip the nfreq and nsite parameters
        switch option
            case 'fi'
                seqs=0:3;
            case 'ft'
                seqs=4:5;zmul=1; % override the multipiler
            case 'oi'
                seqs=[1,2];
        end
        xyz=zeros(nsite,3);
        location=zeros(nsite,3);
        sitename=cell(nsite,1);
        line=fgetl(fid_data);
        for isite=1:nsite% site loop
            % firstly read some site information...
            try
                % see if we even have this site - should say I have seen too 
                % many peculiar data files from our users
                num=sscanf(line,'%*f %*s %f %f %f %f %f %*s %*f %*f %*f',5);
            catch IERR
                if strfind(IERR.identifier,'badstring')>0
                    disp(['missing site found at site #' num2str(isite) ...
                        ', total ' num2str(nsite) ' sites expected!'])
                    % data(isite).emap_o(ifreq:end,(seqs+1)*3)=0;
                    error('missing site encountered, please check your data file')
                else 
                    rethrow(IERR)
                end
            end
            str=sscanf(line,'%*f %s %*f %*f %*f %*f %*f %*s %*f %*f %*f');
            location(isite,1)=num(1);
            location(isite,2)=num(2);
            xyz(isite,1)=num(3);
            xyz(isite,2)=num(4);
            xyz(isite,3)=num(5);
            sname={char(str')};
            presname=sname;% remember the last station's name
            sitename{isite}=sname;
            if block==1
                data(isite)=gen_data(flist,5);
            end
            for ifreq=1:nfreq% now loop through periods
                try
                    str=sscanf(line,'%*f %s %*f %*f %*f %*f %*f %*s %*f %*f %*f');
                catch IERR
                    if strfind(IERR.identifier,'badstring')>0
                        disp(['missing frequency detected @site ' char(sitename{isite}) ' freq # ' num2str(ifreq)])
                        % data(isite).emap_o(ifreq:end,(seqs+1)*3)=0;
                        break
                    else 
                        rethrow(IERR)
                    end
                end
                sname={char(str')};
                if ~strcmp(presname,sname)% we run into another site
                    disp(['missing frequency detected @site ' char(sitename{isite}) ' freq # ' num2str(ifreq)])
                    %data(isite).emap_o(ifreq:end,(seqs+1)*3)=0;
                    break
                end
                % we are still in the same site
                newfreq=1/sscanf(line,'%f %*s %*f %*f %*f %*f %*f %*f %*f %*f %*f',1);
                % find the right freq
                iprev = find(abs(flist./newfreq-1)<0.01,1);
                for iresp=seqs% resp loop
                    try
                        str=sscanf(line,'%*f %*s %*f %*f %*f %*f %*f %s %*f %*f %*f',9);
                    catch IERR
                        if strfind(IERR.identifier,'badstring')>0
                            disp(['missing resp detected @site ' char(sitename{isite}) ' freq # ' num2str(ifreq)])
                            % data(isite).emap_o(ifreq:end,(seqs+1)*3)=0;
                            break
                        else 
                            rethrow(IERR)
                        end
                    end
                    num=sscanf(line,'%*f %*s %*f %*f %*f %*f %*f %*s %f %f %f',3);
                    mode=char(str');
                    switch mode
                        case 'ZXX'
                            tresp=0;
                        case 'ZXY'
                            tresp=1;
                        case 'ZYX'
                            tresp=2;
                        case 'ZYY'
                            tresp=3;
                        case 'TX'
                            tresp=4;
                        case 'TY'
                            tresp=5;
                    end
                    if tresp~=iresp % something is not right!
                        disp(['missing response detected @site ' char(sitename{isite}) ' freq # ' num2str(ifreq)])
                        % data(isite).emap_o(iprev,iresp*3+3)=0;
                    else
                        data(isite).tf_o(iprev,iresp*3+1)=num(1)*zmul;
                        data(isite).tf_o(iprev,iresp*3+2)=num(2)*zmul*signs;
                        data(isite).tf_o(iprev,iresp*3+3)=num(3)*zmul; 
%                         if num(3)<1e+5
                            data(isite).emap_o(iprev,iresp*3+3)=1;
%                         end
                        line=fgetl(fid_data);
                    end
                end
            end
            data(isite).nfreq=data(isite).nfreq_o;
            data(isite).freq=data(isite).freq_o;
            data(isite).tf=data(isite).tf_o;
            data(isite).emap=data(isite).emap_o;
        end
    end
end
switch unit
    case 'km'
        xyz=xyz./1000;
    case 'm'
        %do nothing
end
disp(['TF rotation: ' num2str(rotate)]);
disp(['lat: ' num2str(lat)]);
disp(['lon: ' num2str(lon)]);
fclose(fid_data);
disp('file end reached');
return

