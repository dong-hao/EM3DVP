function load_freqtable(hObject,eventdata)
global default
[cfilename,cdir]=uigetfile({'*.edi','Impedence edi files(*.edi)';'*.*',...
    'All files(*.*)'},'Choose a sample edi file to get the frequency table');
if cfilename==0
    disp('user canceled...')
    return;
end
cfile=[cdir,cfilename];
fid=fopen(cfile,'r');
disp(['Reading ',cfile,'...'])
for i=1:10000
    if ~feof(fid)
        line=fgetl(fid);
        if  strfind(line,'>FREQ')>0
            ns=strfind(line,'//')+2;%starting string
            ne=length(line);%ending string
            nfreq=str2num(line(ns:ne));
            disp(' frequencies list found...');
            default.ftable=(fscanf(fid,'%f',[nfreq,1]))';
            disp([line(ns:ne) ' frequencies in total']);
            default.flist=1:3:nfreq;
            fclose(fid);
            return
        end
    end
end
msgbox('freqtable not found in the file you provided','?');
return

