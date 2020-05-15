function [data,location,sitename]=read_edi(name,unit,signs,etype)
% read edi from given "name" and import the site to the "n"th data struct.
% the variances are multiplied by "Xerror" to improve the convergence in
% WSINV3DMT inversion

% impedance edi file is needed. 
% here we assume the unit to be mv/km/nT(which is the standard unit of 
% Pheonix EDI files), the time harmonic sign convention to be exp(i\omega t)
% ========================================================================%
% NOTE: THE VARIANCE OF DATA HAS TO BE CONVERTED TO STD TO BE USED IN MODEM
% ========================================================================%
global custom default
if nargin < 1
    error('not enough input arguments, please provide the filename to read.')
elseif nargin < 2 
    signs=1;
    unit='mV/km/nT';
    etype = 'var';
elseif nargin < 3
    signs=1;
    etype = 'var';
elseif nargin < 4
    etype = 'var';
end
switch unit
    case 'mV/km/nT'
        %do nothing
        zmul=1;
    case 'V/m/T'
        zmul=0.001;
    case 'Ohm'
        zmul=796;
end
fid=fopen(name,'r');
disp(['Reading ',name]);
data=gen_data;
location=zeros(1,3);
errtype = etype; 
for i=1:10000
    if ~feof(fid)
        line=fgetl(fid);
        if strfind(line,'DATAID')
            line=strrep(line,'"','');
            ns=strfind(line,'=');%location of the "="
            sitename={line(ns(1)+1:end)};
        end
        if strfind(line,'REFLAT')
            ctemp=strrep(line,'REFLAT','');
            ctemp=strrep(ctemp,'=','');
            nfield= length(strfind(line,':'));
            ctemp=str2num(strrep(ctemp,':',' ')); %#ok<*ST2NM>
            switch nfield
                case 0
                    if ctemp~=0
                        location(1)=ctemp;
                    end
                case 1
                    if isempty(strfind(line,'-'))
                        location(1)=ctemp(2)/60+ctemp(1);
                    else                
                        location(1)=-(abs(ctemp(2))/60+abs(ctemp(1)));
                    end
                case 2
                    if isempty(strfind(line,'-'))
                        location(1)=ctemp(3)/3600+ctemp(2)/60+ctemp(1);
                    else                
                        location(1)=-(abs(ctemp(3))/3600+abs(ctemp(2))/60+abs(ctemp(1)));
                    end                    
            end
            line=fgetl(fid);
            ctemp=strrep(line,'REFLONG','');
            ctemp=strrep(ctemp,'=','');
            nfield= length(strfind(line,':'));
            ctemp=str2num(strrep(ctemp,':',' ')); %#ok<*ST2NM>
            switch nfield
                case 0
                    if ctemp~=0
                        location(2)=ctemp;
                    end
                case 1
                    if isempty(strfind(line,'-'))
                        location(2)=ctemp(2)/60+ctemp(1);
                    else                
                        location(2)=-(abs(ctemp(2))/60+abs(ctemp(1)));
                    end
                case 2
                    if isempty(strfind(line,'-'))
                        location(2)=ctemp(3)/3600+ctemp(2)/60+ctemp(1);
                    else                
                        location(2)=-(abs(ctemp(3))/3600+abs(ctemp(2))/60+abs(ctemp(1)));
                    end                    
            end
            line=fgetl(fid);   
            if ~isempty(strfind(line,'REFELEV'))
                ctemp=strrep(line,'REFELEV','');
                ctemp=strrep(ctemp,'=','');
                location(3)=str2double(ctemp);% location: lat/lon/elevation
            else
                
            end
        elseif strfind(line,'LAT=')
            ctemp=strrep(line,'LAT=','');
            ctemp=strrep(ctemp,'#','');
            nfield= length(strfind(line,':'));
            ctemp=str2num(strrep(ctemp,':',' ')); %#ok<*ST2NM>
            switch nfield
                case 0
                    if ctemp~=0
                        location(1)=ctemp;
                    end
                case 1
                    if isempty(strfind(line,'-'))
                        location(1)=ctemp(2)/60+ctemp(1);
                    else                
                        location(1)=-(abs(ctemp(2))/60+abs(ctemp(1)));
                    end
                case 2
                    if isempty(strfind(line,'-'))
                        location(1)=ctemp(3)/3600+ctemp(2)/60+ctemp(1);
                    else                
                        location(1)=-(abs(ctemp(3))/3600+abs(ctemp(2))/60+abs(ctemp(1)));
                    end                    
            end
            line=fgetl(fid);
            ctemp=strrep(line,'LONG=','');
            ctemp=strrep(ctemp,'#','');
            nfield= length(strfind(line,':'));
            ctemp=str2num(strrep(ctemp,':',' ')); %#ok<*ST2NM>
            switch nfield
                case 0
                    if ctemp~=0
                        location(2)=ctemp;
                    end
                case 1
                    if isempty(strfind(line,'-'))
                        location(2)=ctemp(2)/60+ctemp(1);
                    else                
                        location(2)=-(abs(ctemp(2))/60+abs(ctemp(1)));
                    end
                case 2
                    if isempty(strfind(line,'-'))
                        location(2)=ctemp(3)/3600+ctemp(2)/60+ctemp(1);
                    else                
                        location(2)=-(abs(ctemp(3))/3600+abs(ctemp(2))/60+abs(ctemp(1)));
                    end                    
            end
            line=fgetl(fid);   
            ctemp=strrep(line,'#','');
            if ~isempty(strfind(ctemp,'ELEV='))
                ctemp=strrep(ctemp,'ELEV=','');
                location(3)=str2double(ctemp);% location: lat/lon/elevation
            else
                location(3)=0;
            end
        elseif strfind(line,'LATITUDE')
            ctemp=strrep(line,'LATITUDE','');
            ctemp=strrep(ctemp,'=','');
            nfield= length(strfind(line,':'));
            ctemp=str2num(strrep(ctemp,':',' ')); %#ok<*ST2NM>
            switch nfield
                case 0
                	location(1)=str2double(line);
                case 1
                    if isempty(strfind(line,'-'))
                        location(1)=ctemp(2)/60+ctemp(1);
                    else                
                        location(1)=-(abs(ctemp(2))/60+abs(ctemp(1)));
                    end
                case 2
                    if isempty(strfind(line,'-'))
                        location(1)=ctemp(3)/3600+ctemp(2)/60+ctemp(1);
                    else                
                        location(1)=-(abs(ctemp(3))/3600+abs(ctemp(2))/60+abs(ctemp(1)));
                    end                    
            end
            line=fgetl(fid);
            ctemp=strrep(line,'LONGITUDE','');
            ctemp=strrep(ctemp,'=','');            
            nfield= length(strfind(line,':'));
            ctemp=str2num(strrep(ctemp,':',' ')); %#ok<*ST2NM>
            switch nfield
                case 0
                	location(2)=str2double(line);
                case 1
                    if isempty(strfind(line,'-'))
                        location(2)=ctemp(2)/60+ctemp(1);
                    else                
                        location(2)=-(abs(ctemp(2))/60+abs(ctemp(1)));
                    end
                case 2
                    if isempty(strfind(line,'-'))
                        location(2)=ctemp(3)/3600+ctemp(2)/60+ctemp(1);
                    else                
                        location(2)=-(abs(ctemp(3))/3600+abs(ctemp(2))/60+abs(ctemp(1)));
                    end                    
            end
            line=fgetl(fid);   
            if ~isempty(strfind(line,'ELEVATION'))
                ctemp=strrep(line,'ELEVATION','');
                ctemp=strrep(ctemp,'=',''); 
                location(3)=str2double(ctemp);% location: lat/lon/elevation
            else
                location(3)=0;
            end
        elseif strfind(line,'SPECTRA')
            disp('this edi might be a spectra edi');
            disp('please convert it to impedance format first')
        elseif strfind(line,'>FREQ')>0
            ns=strfind(line,'//')+2;%starting string
            ne=length(line);%ending string
            data.nfreq_o=str2num(line(ns:ne));  % number of freqs in this edi file
            data.freq_o=fscanf(fid,'%f',[data.nfreq_o,1]); % freq list in this edi file
            data.tf_o=ones(data.nfreq_o,18);
            disp(' frequencies list found...');
            disp([line(ns:ne) ' frequencies in total']);
            if strfind(line,'ORDER=INC')
                disp('frequency order: increasing')
                disp('will flip data order later')
                order='INC';
            else
                order='DEC';
                disp('frequency order: decreasing (default)')
            end
        elseif strfind(line,'>ZXXR')>0
            data.tf_o(1:data.nfreq_o,1)=fscanf(fid,'%f',[data.nfreq_o,1])*zmul;
            disp(' ZXXR found...');
        elseif strfind(line,'>ZXXI')>0
            data.tf_o(1:data.nfreq_o,2)=signs*fscanf(fid,'%f',[data.nfreq_o,1])*zmul;
            disp(' ZXXI found...');
        elseif strfind(line,'>ZXX.VAR')>0
            data.tf_o(1:data.nfreq_o,3)=fscanf(fid,'%f',[data.nfreq_o,1])*zmul;
            disp(' ZXX.VAR found...');
        elseif strfind(line,'>ZXYR')>0
            data.tf_o(1:data.nfreq_o,4)=fscanf(fid,'%f',[data.nfreq_o,1])*zmul;
            disp(' ZXYR found...');
        elseif strfind(line,'>ZXYI')>0
            data.tf_o(1:data.nfreq_o,5)=signs*fscanf(fid,'%f',[data.nfreq_o,1])*zmul;   
            disp(' ZXYI found...');
        elseif strfind(line,'>ZXY.VAR')>0
            data.tf_o(1:data.nfreq_o,6)=fscanf(fid,'%f',[data.nfreq_o,1])*zmul;
            disp(' ZXY.VAR found...');
        elseif strfind(line,'>ZYXR')>0
            data.tf_o(1:data.nfreq_o,7)=fscanf(fid,'%f',[data.nfreq_o,1])*zmul;                    
            disp(' ZYXR found...');
        elseif strfind(line,'>ZYXI')>0
            data.tf_o(1:data.nfreq_o,8)=signs*fscanf(fid,'%f',[data.nfreq_o,1])*zmul;       
            disp(' ZYXI found...');
        elseif strfind(line,'>ZYX.VAR')>0
            data.tf_o(1:data.nfreq_o,9)=fscanf(fid,'%f',[data.nfreq_o,1])*zmul;
            disp(' ZYX.VAR found...');
        elseif strfind(line,'>ZYYR')>0
            data.tf_o(1:data.nfreq_o,10)=fscanf(fid,'%f',[data.nfreq_o,1])*zmul;       
            disp(' ZYYR found...');
        elseif strfind(line,'>ZYYI')>0
            data.tf_o(1:data.nfreq_o,11)=signs*fscanf(fid,'%f',[data.nfreq_o,1])*zmul;
            disp(' ZYYI found...');
        elseif strfind(line,'>ZYY.VAR')>0
            data.tf_o(1:data.nfreq_o,12)=fscanf(fid,'%f',[data.nfreq_o,1])*zmul;
            disp(' ZYY.VAR found...');
        % adding Tipper here
        elseif strfind(line,'>TXR.EXP')>0
            data.tf_o(1:data.nfreq_o,13)=fscanf(fid,'%f',[data.nfreq_o,1]);
            disp(' TXR.EXP found...');
        elseif strfind(line,'>TXI.EXP')>0
            data.tf_o(1:data.nfreq_o,14)=signs*fscanf(fid,'%f',[data.nfreq_o,1]);   
            disp(' TXI.EXP found...');
        elseif strfind(line,'>TXVAR.EXP')>0
            data.tf_o(1:data.nfreq_o,15)=fscanf(fid,'%f',[data.nfreq_o,1]);
            disp(' TXVAR.EXP found...');
        elseif strfind(line,'>TYR.EXP')>0
            data.tf_o(1:data.nfreq_o,16)=fscanf(fid,'%f',[data.nfreq_o,1]);                    
            disp(' TYR.EXP found...');
        elseif strfind(line,'>TYI.EXP')>0
            data.tf_o(1:data.nfreq_o,17)=signs*fscanf(fid,'%f',[data.nfreq_o,1]);       
            disp(' TYI.EXP found...');
        elseif strfind(line,'>TYVAR.EXP')>0
            data.tf_o(1:data.nfreq_o,18)=fscanf(fid,'%f',[data.nfreq_o,1]);
            disp(' TYVAR.EXP found...');
        end
    end
end
% try to delete poor data (error bigger than data magnitude)
fclose(fid);
data.emap_o=ones(size(data.tf_o));
switch upper(order)
    case 'DEC' % high -> low freq, default
        % do nothing
        if data.freq_o(2)>data.freq_o(1)
            % it turns out to be increasing!
            % try to change the order of the data
            data.freq_o=flipud(data.freq_o);
            data.tf_o=flipud(data.tf_o);
        end
    case 'INC' % low -> high freq
        % try to change the order of the data
        data.freq_o=flipud(data.freq_o);
        data.tf_o=flipud(data.tf_o);
end
switch upper(errtype)
    case 'VAR'
        disp('converting variances to stds...')
        data.tf_o(:,[3 6 9 12 15 18]) = sqrt(data.tf_o(:,[3 6 9 12 15 18]));
    case 'STD'
        disp('using Standard deviation for errors...')
        % do nothing
    otherwise
        error('errtype not recognized, please check the read_edi options')
end
if custom.origin~=1
    return
end
if data.nfreq_o<length(default.ftable) %see if this site have enough freqs
    for i=1:18 %if not, fake data will be generated according to previous freqs (with emap set to 0).
        data.tf_o(data.nfreq_o+1:end,i)=...
        (data.tf_o(data.nfreq_o-2,i)+data.tf_o(data.nfreq_o-1,i)+...
        data.tf_o(data.nfreq_o,i))/3;
        for j=data.nfreq_o+1:length(custom.ftable)
            data.tf_o(j,i)=data.tf_o(j-1,i)*sqrt(custom.ftable(j)/custom.ftable(data.nfreq_o-1));
        end
        if rem(i,3)==0 % the error map for each "complex data" (e.g. Zxyi and Zxyr)
            data.emap_o(data.nfreq_o+1:end,i)=0;
        end
    end
end
return;