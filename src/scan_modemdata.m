function [perlist,sitelist,complist,signs,clat,clon,rotate,zmul]=scan_modemdata(fname,fdir)
% Scan Gary's ModEM "list" type data file, and find out how the number of
% site, frequency, and response of the data file 
% this is a major update to deal with extremely poorly arranged data files 
% from users of freedom (a.k.a. my students)  
%===============open data file===================%
fid_data = fopen ([fdir,fname],'r');
% firstly sweep the data file for frequency list
NL = 0;
block = 0;
perlist = cell(2,1);
sitelist = perlist;
complist = perlist;
ndata = perlist;
while(~feof(fid_data))
    line=fgetl(fid_data);
    if strfind(line,'#') %try to skip any comments
        continue
    elseif strfind(line,'>') %now we have something to look at 
        NL = NL + 1;
        switch NL 
            case 1
                block = block + 1;
                switch lower(strtrim(line(2:end)))
                    case 'full_impedance'
                        code=['ZXX'; 'ZXY'; 'ZYX'; 'ZYY'];
                    case 'full_vertical_components'
                        code=['TX'; 'TY'];
                    case 'off_diagonal'
                        code=['ZXY'; 'ZYX'];
                    otherwise
                        error('this type of data is not yet supported');
                end
            case 2
                if strfind(line,'+')
                    signs = 1;
                elseif strfind(line,'-')
                    signs = -1;
                else % assume plus sign
                    signs = 1;
                end
            case 3
                if ~isempty(strfind(line,'[V/m]/[A/m]')) %Ohm
                    zmul=796;
                elseif ~isempty(strfind(line,'[V/m]/[T]')) %V/m/nT
                    zmul=0.001;
                elseif ~isempty(strfind(line,'Ohm')) % still Ohm (only found in old ModEM examples)
                    zmul = 796;
                else %[mV/km]/nT
                    zmul=1;
                end
            case 4
                rotate=sscanf(line,'%*s %f',1);
            case 5
                latlon=sscanf(line,'%*s %f %f',2);
                clat=latlon(1);
                clon=latlon(2);
            case 6
                tmp=sscanf(line,'%*s %i %i');
                nfreq=tmp(1);
                nsite=tmp(2);
                NL = 0;
            otherwise
        end
        continue
    else % see how many sites/resp/frequencies do we really have 
        temp = textscan(fid_data,'%f %s %f %f %f %f %f %s %f %f %f');
        ndata{block} = size(temp{1},1);
        perlist{block} = unique(temp{1});
        sitelist{block} = sortrows(strtrim(char(unique(temp{2}))));
        complist{block} = sortrows(strtrim(char(unique(temp{8}))));
        n = nfreq*nsite*size(code,1);
        pct = (1 - ndata{block}/n) * 100;
        fprintf('Note: %d data points expected, %d points read, %3.2f %% missing\n',...
            n, ndata{block}, pct); 
    end
end
% now find out how many sites do we have in total

fclose(fid_data);