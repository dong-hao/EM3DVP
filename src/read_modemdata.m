function [data,xyz,sitename,location]=read_modemdata(fname,fdir,data,unit,s)
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
        else %[mV/km]/nT
            zmul=1;
        end
        TFrotate=fscanf(fid_data,'%*s %f\n',1);
        latlon=fscanf(fid_data,'%*s %f %f\n',2);
        lat=latlon(1);
        lon=latlon(2);
        line=fgetl(fid_data);
        tmp=sscanf(line,'%*s %i %i');
        nfreq=tmp(1);
        Nsite=tmp(2);
        switch option
            case 'fi'
                seqs=0:3;
            case 'ft'
                seqs=4:5;signs=1;zmul=1; % override the sign and multipiler
            case 'oi'
                seqs=[1,2];
        end
        xyz=zeros(Nsite,3);
        location=zeros(Nsite,3);
        sitename=cell(Nsite,1);
        line=fgetl(fid_data);
        for isite=1:Nsite% site loop
            % firstly read some site information...
            str=sscanf(line,'%*f %s %*f %*f %*f %*f %*f %*s %*f %*f %*f');
            num=sscanf(line,'%*f %*s %f %f %f %f %f %*s %*f %*f %*f',5);
            location(isite,1)=num(1);
            location(isite,2)=num(2);
            xyz(isite,1)=num(3);
            xyz(isite,2)=num(4);
            xyz(isite,3)=num(5);
            sname={char(str')};
            presname=sname;% remember the last station's name
            sitename{isite}=sname;
            if block==1
                data(isite).nfreq_o=nfreq;
                data(isite).freq_o=zeros(nfreq,1);
                data(isite).tf_o=ones(nfreq,18);
                data(isite).emap_o=data(isite).tf_o;
            end
            for ifreq=1:nfreq% now loop through periods
                try
                    str=sscanf(line,'%*f %s %*f %*f %*f %*f %*f %*s %*f %*f %*f');
                catch IERR
                    if strcmp(IERR.identifier,string)
                        disp(['missing frequency detected @site ' char(sitename{isite}) ' freq # ' num2str(ifreq)])
                        data(isite).emap_o(ifreq:end,:)=0;
                        break
                    else 
                        rethrow(IERR)
                    end
                end
                sname={char(str')};
                if ~strcmp(presname,sname)
                    disp(['missing frequency detected @site ' char(sitename{isite}) ' freq # ' num2str(ifreq)])
                    data(isite).emap_o(ifreq:end,:)=0;
                    break
                end
                data(isite).freq_o(ifreq)=1/sscanf(line,'%f %*s %*f %*f %*f %*f %*f %*f %*f %*f %*f',1);
                for iresp=seqs% resp loop
                    str=sscanf(line,'%*f %*s %*f %*f %*f %*f %*f %s %*f %*f %*f',9);
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
                        data(isite).emap_o(ifreq,iresp*3+3)=0;
                    else
                        data(isite).tf_o(ifreq,iresp*3+1)=num(1)*zmul;
                        data(isite).tf_o(ifreq,iresp*3+2)=num(2)*zmul*signs;
                        data(isite).tf_o(ifreq,iresp*3+3)=num(3)*zmul;
                        if num(3)>1e+6
                            data(isite).emap_o(ifreq,iresp*3+3)=0;
                        end
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
fclose(fid_data);
disp('file end reached');
return

