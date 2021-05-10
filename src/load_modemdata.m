function load_modemdata(hObject,eventdata,handles)
% a dummy function to call read_modemdata to read Gary's ModEM "list" type
% data file
global location xyz data sitename nsite custom model
%==============import site=======================%
[cfilename,cdir]=uigetfile({'*dat','ModEM type data files(*dat)';...
    '*.*','All files(*.*)'},... 
    'Choose a ModEM data file');
if isequal(cfilename,0) || isequal(cdir,0)
    disp('user canceled loading file...');
    return
end
data=gen_data;
[data,xyz,sitename,location,lat,lon]=read_modemdata(cfilename,cdir,data);
nsite=length(location);
custom.ftable=data(1).freq_o;
custom.flist=1:data(1).nfreq_o;
custom.origin=1;
if lat == 0 || lon == 0
    cx=round((max(location(:,1))+min(location(:,1)))/2);
    cy=round((max(location(:,2))+min(location(:,2)))/2);
else
    cx = lat;
    cy = lon;
end
custom.centre=[cx,cy];
% set(handles.project(3),'string',num2str(cx));
% set(handles.project(4),'string',num2str(cy));
% start projecting sites on map
% project(hObject,eventdata,handles);
% start meshing model
if isempty(model)
    mesher(hObject,eventdata,handles);
else % do not make a new model if we already have one
    custom.currentZ=1;
    d3_view(hObject,eventdata,handles);
end
% try to interpret data from the original one
pmin=custom.pmin;
pmax=custom.pmax;
ppd=custom.ppd;
for i = 1: nsite
    if find(data(i).emap_o==0)
        % do nothing
    else
       data(i).emap_o=generate_emap(data(i).tf_o);
    end
    % load original data 
    % see if we want to use original data
    if custom.origin==1
        data(i).nfreq=data(i).nfreq_o;
        data(i).freq=data(i).freq_o;
        data(i).tf=data(i).tf_o;
        data(i).emap=data(i).emap_o;
        data(i)=calc_rhophs(data(i),1);
    else 
        TFsmooth(i,[],pmin,pmax,ppd);
    end
end
% some initial settings for GUI
if custom.init~=1
    GUI_init(handles);
    custom.init=1;
end
% % plot and refresh status
refresh_status(hObject,eventdata,handles);
return

