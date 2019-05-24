function edit_freqtable(hObject,eventdata)
global default
ftable=default.ftable;
ptable=1./ftable;
nfreq=num2str(length(ftable));
prompt = 'Please manually set frequencies/periods tables here';
titles  = ['Number of freqs: ' nfreq];
def= {num2str(ptable)};
dlg =inputdlg(prompt,titles,3,def);
if isempty(dlg)
    disp('user canceled...')
    return
end
ptable=str2num(dlg{1});
ftable=1./ptable;
nfreq=length(ftable);
default.ftable=ftable;
default.flist=1:3:nfreq;
return

