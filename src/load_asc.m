function load_asc(hObject,eventdata,handles)
% a dummy function to call read_asc to read DSM1 asc type data
global nsite location data sitename xyz;
global custom;
yorn=questdlg('This will CLEAR current model and settings,do you really want to continue?',...
    'LOAD EDIs','yes','no','no');
if strcmp(yorn,'no')
    return;
end
% Open edis
[cfilename,cdir]=uigetfile({'*.asc','Impedence asc files(*.asc)';'*.*',...
    'All files(*.*)'},'Choose impedence format asc files to load',...
    'multiselect','on');
if ~iscell(cfilename)
    errordlg('Please, load more than one site...');
    return;
end
%read impedence format edi file beginning
nsite=length(cfilename);
pmin=str2num(get(handles.freq(2),'string'));
pmax=str2num(get(handles.freq(1),'string'));
fpd=str2num(get(handles.freq(3),'string'));% frequencies per decade
ftable=[];
data=gen_data;
sitename=cell(nsite,1);
xyz=zeros(nsite,3);
for i=1:nsite
    cfile=[cdir,char(cfilename{i})];
    [data(i),xyz(i,:),sitename(i)]=read_asc(cfile,'Ohm',-1);
    data(i)=TFsmooth(data(i),ftable,pmin,pmax,fpd);
    data(i)=calc_rhophs(data(i),1);
end
location=zeros(nsite,3);
custom.origin=0;
custom.flist=1:data(1).nfreq;
custom.ftable=data(1).freq;
%now project the sites
disp('all files loaded...');
[p1,p2,spacing]=min_dist(xyz(:,1),xyz(:,2));
disp(['minimum site spacing found between site ' sitename{p1} ' and ' sitename{p2}])
disp(['minimum site distance is ' num2str(spacing) 'm'])
disp('generating mesh automatically...')
[Calpha, Cratio, j, Lalpha, Lratio, i]=calc_mesh(1000, 10, 0.1,...
    100, 1.2, 1.5, spacing, 0.2, 0.5);
if Calpha > 200
    set(handles.model(1),'string',num2str(Calpha));
    set(handles.model(4),'string',num2str(Calpha));
    set(handles.model(3),'string',num2str(Cratio));
    set(handles.model(6),'string',num2str(Cratio));
    set(handles.model(2),'string',num2str(j));
    set(handles.model(5),'string',num2str(j));
    set(handles.model(7),'string',num2str(Lalpha));
    set(handles.model(8),'string',num2str(Lratio));
    set(handles.model(10),'string','1.5');
    set(handles.model(9),'string',num2str(i));
    set(handles.model(11),'string','0');
    mesher(hObject,eventdata,handles);
else 
    warning('minimum distance too small','please check the site layout');
end
disp('...done!')
if custom.init~=1
    GUI_init(handles);
    custom.init=1;
end
return;

