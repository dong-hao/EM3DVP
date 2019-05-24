function [data,xyz,sitename]=read_asc(name,unit,signs)
% read asc from given "name" and import the site to the "n"th data struct.
% impedance edi file is needed
% please note that the Z parametres is divided by 796 to convert the unit 
% from mv/km/nT(which is the standard unit of Pheonix EDI files) to ohmm
global custom default
if nargin == 1
    signs=1;
    unit='mV/km/nT';
elseif nargin == 2
    unit='mV/km/nT';
elseif nargin < 1
    error('not enough input arguments, please provide the filename to read.')
end
switch unit
    case 'mV/km/nT'
        %do nothing
        zmul=1;
    case 'V/m/T'
        zmul=1000;
    case 'Ohm'
        zmul=796;
end
fid=fopen(name,'r');
disp(['Reading ',name]);
data=gen_data;
xyz=zeros(1,3);
data.nfreq_o=18;
data.freq_o=zeros(data.nfreq_o,1);
data.tf_o=ones(data.nfreq_o,18);
for i=1:10
    if ~feof(fid)
        line=fgetl(fid);
        if strfind(line,'sitename')
            line=strrep(line,'"','');
            ns=strfind(line,':');% location of the ':'s
            lm=strfind(line,'m ');
            sitename={line(ns(1)+1:ns(1)+6)};
            xyz(1,2)=str2double(line(ns(2)+1:lm(1)-1));
            xyz(1,1)=str2double(line(ns(3)+1:lm(2)-1));
        elseif isempty(strfind(line,'#'))
            for ifreq=1:data.nfreq_o
                num=sscanf(line,'%f %f %f %f %f %f %f %f %f',9);
                data.freq_o(ifreq)=1/num(1);
                data.tf_o(ifreq,[1 4 7 10])=num([2 4 6 8])*zmul;
                data.tf_o(ifreq,[2 5 8 11])=num([3 5 7 9])*zmul*signs;
                data.tf_o(ifreq,[3 6 9 12])=0;
                line=fgetl(fid);
            end
        end
    end
end
fclose(fid);
data.emap_o=zeros(size(data.tf_o));
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

