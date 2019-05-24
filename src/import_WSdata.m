function import_WSdata(hObject,eventdata,handles)
% a front end function to import WS data file
global xyz data sitename custom nsite
queststr='Do you really want to proceed? All existing site will be cleared';
yorn=questdlg(queststr,'Import site','yes','no','yes');
if strcmp(yorn,'no')
    disp('user canceled...')
    return;
end
[dname ddir]=uigetfile({'*data*',  'WSINV3D Data files (*data*)';'*.*',  'Any file'}...
        ,'Open WSINV3D data/resp file');
if dname==0; % if we don't have any data, just plot the model...
	disp('user canceled reading data');
    return
else % we have a data file to read
    %=============a little clear works===============%
    data=gen_data;
     % preallocate the data structure
	[data,xyz,sitename]=read_wsdata(ddir,dname,data,'m');
end
zmul=796;% convert WS unit (Ohm m) back to mV/km/nT
nsite=length(xyz);
if findstr(dname,'resp')
    disp('looks like a response file')
    if get(handles.noisebox(1),'value')==0
        disp('keep the TFs untouched...');
    else
        nlevel=str2double(get(handles.noisebox(2),'string'))/100;
        disp('adding white noise to TFs...')
        data=add_noise(data,nsite,nlevel);        
    end    
    if get(handles.noisebox(3),'value')==0
        disp('keep the TF variances untouched...');
    else
        nlevel=str2double(get(handles.noisebox(4),'string'))/100;
        disp('setting fixed TF variance...')
        data=fix_var(data,nsite,nlevel);
    end
elseif findstr(dname,'data')
    queststr='it seems you are loading a data file, do you have an error file to read as well?';
    yorn=questdlg(queststr,'reading error file','yes','no','yes');
    if strcmp(yorn,'no')
        if get(handles.noisebox(3),'value')==0
            disp('keep the TF variances untouched...');
        else
            nlevel=str2double(get(handles.noisebox(4),'string'))/100;
            disp('setting fixed TF variance...')
            data=fix_var(data,nsite,nlevel);
        end
    else
        [dname ddir]=uigetfile({'*error*',  'WSINV3D Error files (*error*)';'*.*',  'Any file'}...
                ,'Open WSINV3D error file');
        if dname==0; % if we don't have any data, just plot the model...
            nlevel=str2double(get(handles.noisebox(4),'string'))/100;
            disp('user canceled reading error')
            disp('setting fixed TF variance...')
            data=fix_var(data,nsite,nlevel);
        else % we have a data file to read
            data=read_wserror(ddir,dname,data);
        end
    end
end
for i=1:nsite
    data(i).freq_o=1./data(i).freq_o;
    data(i).freq=data(i).freq_o;
    data(i).tf_o(:,1:12)=data(i).tf_o(:,1:12)*zmul;
    data(i).tf=data(i).tf_o;
    data(i).nfreq=data(i).nfreq_o;
    data(i).emap=data(i).emap_o;
    data(i)=calc_rhophs(data(i),1);
end
custom.flist=1:data(i).nfreq;
plot_site(hObject,eventdata,handles,'name');
return

