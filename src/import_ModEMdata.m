function import_ModEMdata(hObject,eventdata,handles)
% a dummy function to call read_modemdata to read Gary's ModEM "list" type
% response file
% 
global location xyz data sitename nsite custom 
queststr='Do you really want to proceed? All existing site will be cleared';
yorn=questdlg(queststr,'Import site','yes','no','yes');
if strcmp(yorn,'no')
    disp('user canceled...')
    return;
end
%==============import site=======================%
[cfilename,cdir]=uigetfile({'*.dat','ModEM type resp files(*.dat)';...
        '*.resp','ModEM type resp files(*.resp)';...    
        '*.*','All files(*.*)'},... 
    'Choose a ModEM response file');
if isequal(cfilename,0) || isequal(cdir,0)
    disp('user canceled loading file...');
    return
end
data=gen_data;
[data,xyz,sitename,location]=read_modemdata(cfilename,cdir,data);
nsite=length(sitename);
custom.ftable=data(1).freq_o;
custom.flist=1:data(1).nfreq_o;
custom.origin=1;
cx=round((max(location(:,1))+min(location(:,1)))/2);
cy=round((max(location(:,2))+min(location(:,2)))/2);
custom.centre=[cx,cy];
if get(handles.noisebox(3),'value')==0
	disp('keep the TF variances untouched...');
else
	nlevel=str2double(get(handles.noisebox(4),'string'))/100;
	disp('setting fixed TF variance...')
	data=fix_var(data,nsite,nlevel);
end
for i = 1: nsite
    % load original data 
    data(i).nfreq=data(i).nfreq_o;
    data(i).freq=data(i).freq_o;
    data(i).tf=data(i).tf_o;
    data(i).emap=data(i).emap_o;
    data(i)=calc_rhophs(data(i),1);
end
custom.flist=1:data(1).nfreq;
plot_site(hObject,eventdata,handles,'noname');
return


