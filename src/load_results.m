function load_results(hObject,eventdata,handles)
% load model and data from Weerachai's WSINV3D invertion files
% or Gary's ModEM inversion files
global model nsite xyz data resp sitename location
%=================read model==================%
[mname, mdir]=uigetfile({'*model*',  'Model files (*model*)';'*.rho',  'Model files (*.rho)';'*.*',  'Any file'}...
    ,'Open WSINV3DMT or ModEM Output File');
if mname==0;
    fprintf('user canceled reading model');
    clear;
    return
end
model=read_wsmodel(mdir,mname,'km');
cd(mdir);
if ~isempty(strfind(mname,'rho'))||~isempty(strfind(mname,'ws')) % probably Gary's format
    %==================read ModEM data =================%
    [dname, ddir]=uigetfile({'*.dat',  'ModEM Data files (*.dat)';'*.*',  'Any file'}...
        ,'Open ModEM Data File');
    if dname==0; % if we don't have any data, just plot the model...
        disp('user canceled reading data');
        disp('try to plot model only');
    else % we have a data file to read
        data=gen_data;
        [data,xyz,sitename,location]=read_modemdata(dname,ddir,data,'km');    
        nsite=length(sitename);
        %==================read ModEM resp=====================%
        % try to use the same name as the "dat" file
        fname=strrep(mname,'rho','dat');
        resp=gen_data;
        resp=read_modemdata(fname,mdir,resp,'km');
        for isite=1:nsite 
            data(isite)=calc_rhophs(data(isite),1);
            resp(isite)=calc_rhophs(resp(isite),1);
        end
    end
elseif ~isempty(strfind(mname,'model')) %probably Weerachai's format
    %==================read WSINV3D data =================%
    [dname, ddir]=uigetfile({'*data*',  'WSINV3D Data files (*data*)';'*.*',  'Any file'}...
        ,'Open WSINV3D Data File');
    if dname==0 % if we don't have any data, just plot the model...
        disp('user canceled reading data');
        disp('try to plot model only');
    else % we have a data file to read
        % preallocate the data structure
        data=gen_data;
        [data,xyz,sitename]=read_wsdata(ddir,dname,data,'km');
        %==================read WSINV3D resp=====================%
        % try to use the same name as the "model" file
        fname=strrep(mname,'model','resp');
        resp=gen_data;
        resp=read_wsdata(mdir,fname,resp,'km');
        %==================read WSINV3D error====================%
        % try to use the same name as the "data" file
        fname=strrep(dname,'data','error');
        data=read_wserror(ddir,fname,data);
        nsite=length(sitename);
        for isite=1:nsite
            data(isite).tf_o=zconvert(data(isite).tf_o,-1,796);% try to convert data
            data(isite)=calc_rhophs(data(isite),1);
            resp(isite).tf_o=zconvert(resp(isite).tf_o,-1,796);% and responds
            resp(isite)=calc_rhophs(resp(isite),1);
        end
    end
else % reserved for other formats
    %for now, we just plot the model
end
% =============now start calculating Z location of the stations===========%
% here we use a 'sink station' technique as intruduced by Randie's 2D code 
% and Weerachai's 3d code. 
for isite=1:nsite
    % find which grid mesh the station lies in 
    xi=find(model.x>xyz(isite,1),1)-1;
    yi=find(model.y>xyz(isite,2),1)-1;
    if model.rho(xi,yi,1)>=1e7 % please note we only sink stations with topography (air)
        zi=find(model.rho(xi,yi,:)<1e7,1);
        sink=model.z(zi);
        fprintf('%8.0f ',(sink-model.z(2))*1000);
        xyz(isite,3)=xyz(isite,3)+sink;
    end
    rms1=calc_rms(isite, 1:data(isite).nfreq, 'z');
    rms2=calc_rms(isite, 1:data(isite).nfreq, 'txty');
    disp(['site ' char(sitename{isite}), ' impedance rms = ',...
        num2str(rms1), ' tipper rms = ', num2str(rms2)]);
end
% ======================a few settings here ==============================%
subview(hObject,eventdata,handles);
set(handles.rholim,'enable','on')
set(handles.viewbox,'enable','on')
set(handles.setbox,'enable','on')
set(handles.buttons,'enable','on')
rms=calc_rms_all(data,resp,nsite);
disp(['overall rms=' num2str(rms)]);
set(handles.text(1),'string',['rms=' num2str(rms)]);
return
%}


