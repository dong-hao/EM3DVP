function load_wsdata(hObject,eventdata,handles)
% load a "full" Weerachai's WSINV3D data file
% i.e. the input data file you use for inversions
global location xyz data sitename nsite custom model
%==============import site=======================%
[cfilename,cdir]=uigetfile({'*data*','Wsinv3d type data files(*data*)';...
    '*.*','All files(*.*)'},... 
    'Choose a COMPLETE data file(i.e. those you used for inversion)');
if isequal(cfilename,0) || isequal(cdir,0)
    disp('user canceled...');
    return
end
zmul=796; % convert from mv/Km/nT to Ohm
%=============a little clear works===============%
data=gen_data;
%===============open data file===================%
fid_data = fopen ([cdir,cfilename],'r');
line=fgetl(fid_data);
[Np]= sscanf(line,'%i');
Nsite = Np(1);nfreq = Np(2);Nres = Np(3);
%===============load site map====================%
fgetl(fid_data);%ugly
siteX = fscanf (fid_data ,'%f', Nsite);
fscanf (fid_data ,'%s',2);%ugly
siteY = fscanf (fid_data ,'%f', Nsite);
%now change site location and data
nsite=Nsite;
xyz=zeros(Nsite,3);
location=zeros(Nsite,3);
sitename=cell(Nsite,1);
xyz(:,1)=siteX;
xyz(:,2)=siteY;
% get centre latitude and longtitude from the main panel.
lat=str2double(get(handles.project(3),'string'));
lon=str2double(get(handles.project(4),'string'));
siteX = lat+siteX*360/(1000*6371*2*pi);
siteY = lon+siteY*360/((1000*6371*2*pi)*cos(mean(siteX)/180*pi));
location(:,1)=siteX;
location(:,2)=siteY;
fgetl(fid_data)
PerTable=zeros(nfreq,1);
for isite=1:Nsite
	sitename{isite}=['site',num2str(isite)];
    data(isite)=gen_data;
end
pcount=0; % number of periods
switch Nres
    case 4
        res_sequence=[4,5,7,8];
    case 8
        res_sequence=[1,2,4,5,7,8,10,11];
    case 12
        res_sequence=[1,2,4,5,7,8,10,11,13,14,16,17];
    otherwise
        error('number of responses not recognized')
end
% start reading data
while(~feof(fid_data))
    line=fgetl(fid_data);
    if ~isempty(strfind(line,'#Iteration'))||~isempty(strfind(line,'ERROR_Period:'))...
        ||~isempty(strfind(line,'               '))
        break;
    end
    if ~isempty(strfind(line,'DATA_Period:'))
        pcount=pcount+1;
        ptr=strfind(line,' ');
        PerTable(pcount)=sscanf(line(ptr:end),'%f',1);
        disp(['period ' num2str(PerTable(pcount)) ' found']);
        for isite=1:Nsite
            data(isite).tf_o(pcount,res_sequence)=fscanf(fid_data,'%g',Nres)*zmul;
        end        
        line=fgetl(fid_data);
    else
        disp('searching')        
    end
end
pcount=0;
switch Nres
    case 4
        err_sequence=[6,6,9,9];
    case 8
        err_sequence=[3,3,6,6,9,9,12,12];
    case 12
        err_sequence=[3,3,6,6,9,9,12,12,15,15,18,18];
    otherwise
        error('number of responses not recognized')
end
% start reading data error
while(~feof(fid_data))
    if ~isempty(strfind(line,'#Iteration'))||~isempty(strfind(line,'ERMAP_Period:'))
        break;
    end
    if ~isempty(strfind(line,'ERROR_Period:'))
        pcount=pcount+1;
        disp(['period ' num2str(PerTable(pcount)) ' found']);
        for isite=1:Nsite
            data(isite).tf_o(pcount,err_sequence)=fscanf(fid_data,'%g',Nres);            
        end      
        line=fgetl(fid_data);
    else
        disp('searching...')   
        line=fgetl(fid_data);
    end
end
% start reading error map
pcount=0;
while(~feof(fid_data))
    if ~isempty(strfind(line,'#Iteration'))
        break;
    end
    if ~isempty(strfind(line,'ERMAP_Period:'))
        pcount=pcount+1;
        disp(['period ' num2str(PerTable(pcount)) ' found']);
        for isite=1:Nsite
            data(isite).emap_o(pcount,err_sequence)=fscanf(fid_data,'%g',Nres);
        end
        line=fgetl(fid_data);
    else
        disp('searching...')
        line=fgetl(fid_data);
    end
end
disp('file end reached');
custom.ftable=1./PerTable;
for i=1:Nsite
    data(i).freq_o=custom.ftable;
    data(i).nfreq_o=length(custom.ftable);    
    data(i).nfreq=data(i).nfreq_o;
    data(i).freq=data(i).freq_o;
    data(i).tf=data(i).tf_o;
    data(i).emap=data(i).emap_o;
    data(i)=calc_rhophs(data(i),1);
end
custom.flist=1:nfreq;
custom.origin=1;
fclose(fid_data);
% some initial settings for GUI
if custom.init~=1
    GUI_init(handles);
    custom.init=1;
end
% see if we already have a model file
if ~isfield(model, 'rho')
    generate_model(hObject,eventdata,handles);
end
% plot and refresh status
custom.currentZ=1;
d3_view(hObject,eventdata,handles);
refresh_status(hObject,eventdata,handles);
return

