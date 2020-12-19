function load_edi(hObject,eventdata,handles)
% load edis for site importing
global nsite location data sitename xyz;
global custom;
yorn=questdlg('This will CLEAR current model and settings,do you really want to continue?',...
    'LOAD EDIs','yes','no','no');
if strcmp(yorn,'no')
    return;
end
% Setting default(not necessary)
% load_default(hObject,eventdata,handles);
% Open edis
[cfilename,cdir]=uigetfile({'*.edi','Impedence edi files(*.edi)';'*.*',...
    'All files(*.*)'},'Choose impedence format edi files to load',...
    'multiselect','on');
if ~iscell(cfilename)
    errordlg('Please, load more than one site...');
    return;
end
%read impedence format edi file beginning
nsite=length(cfilename);
fo=fopen('load_edi.log','w');
btime=clock;
cbtime=['Beginning date: ',num2str(btime(1)),'-',num2str(btime(2)),'-',...
    num2str(btime(3)),'  ',num2str(btime(4)),':',num2str(btime(5)),':',...
    num2str(btime(6))];
fprintf(fo,'%s\n',cbtime);
fprintf(fo,'%s\n',['    number of sites: ',num2str(nsite)]);
pmin = custom.pmin;
pmax = custom.pmax;
ppd = custom.ppd;
% pmin=str2num(get(handles.freq(2),'string'));
% pmax=str2num(get(handles.freq(1),'string'));
% ppd=str2num(get(handles.freq(3),'string'));
ftable=[];
data=gen_data;
sitename=cell(nsite,1);
location=zeros(nsite,3);
for i=1:nsite
    cfile=[cdir,char(cfilename{i})];
    fprintf(fo,'%s\n',['      Reading ',cfile,'...']);
    [data(i),location(i,:),sitename(i)]=read_edi(cfile,'mV/km/nT');%,-1);
    %TFinterp(i,ftable,pmin,pmax,ppd);
    data(i)=TFsmooth(data(i),ftable,pmin,pmax,ppd);
    data(i)=calc_rhophs(data(i),1);
    %data(i)=TFautomask(data(i));
end
custom.origin=0;
custom.flist=1:data(1).nfreq;
custom.ftable=data(1).freq;
etime=clock;
cetime=['End date: ',num2str(etime(1)),'-',num2str(etime(2)),'-',...
    num2str(etime(3)),'  ',num2str(etime(4)),':',num2str(etime(5)),':',...
    num2str(etime(6))];
fprintf(fo,'%s\n\n\n',cetime);
fclose(fo);
%{
%boring dialog
queststr=['Read edi files finished, Do you want to view log?'];
yorn=questdlg(queststr,'view log','View','Discard','View');
if strcmp(yorn,'View')
    open('load_edi.log');
end
%}
%now project the sites
fprintf('totally %d files loaded: \n', nsite);
for isite = 1:nsite
    fprintf('%s: %f, %f \n',sitename{isite}, location(isite,1), location(isite,2));
end
cx=round(median(location(:,1)));
cy=round(median(location(:,2)));
custom.centre=[cx,cy];
% start projecting sites on map
project_sites(hObject,eventdata,handles);
% start meshing model
[p1,p2,spacing]=min_dist(xyz(:,1),xyz(:,2));
disp(['minimum site spacing found between site ' sitename{p1} ' and ' sitename{p2}])
disp(['minimum site distance is ' num2str(spacing) 'm'])
disp('generating mesh automatically...')
[Calpha, Cratio, j, Lalpha, Lratio, i]=calc_mesh(1000, 10, 0.1,...
    100, 1.2, 1.5, spacing, 0.2, 0.5);
if Calpha > 100
    custom.x1=Calpha;
    custom.y1=Calpha;
    custom.x3=Cratio;
    custom.y3=Cratio;
    custom.x2=j;
    custom.y2=j;
    custom.z1=Lalpha;
    custom.z2=i;
    custom.z3=Lratio;
    custom.z4=0;
    custom.z5=1.5;
    mesher(hObject,eventdata,handles);
else 
    warning('minimum distance too small','please check the site layout');
    mesher(hObject,eventdata,handles);
end
disp('...done!')
if custom.init~=1
    GUI_init(handles);
    custom.init=1;
end
return;

