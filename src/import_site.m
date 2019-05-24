function r=import_site(index,x,y)
% add new site to the map
% use edi single site file for data or simply create fake data. 
% WARNING: if a edi file is not passed, this will call an untesed function 
%          "int_site" to interpolate the transfer function using values 
%          from surrounding stations, use this with extreme care as the 
%          transfer function of the newly added site will almost certain 
%          go wild.
global nsite xyz location sitename data custom
s_prompt = {'New site name:','Latitude:','Longitude:','Elevation:'...
    ,'X:','Y:'};
s_titles  = 'Setup new site';
lonR = custom.centre(1);
latR = custom.centre(2);
s_def= {'new site',num2str(lonR),num2str(latR),'0',num2str(x),num2str(y)};
sitedlg =inputdlg(s_prompt,s_titles,1,s_def);
if isempty(sitedlg)
    disp('user canceled...')
    r=0;
    return
end
sitename(index)=sitedlg(1);
xyz(index,1)=str2double(sitedlg{5});
xyz(index,2)=str2double(sitedlg{6});
xyz(index,3)=str2double(sitedlg{4});
location(index,1)=str2double(sitedlg{2});
location(index,2)=str2double(sitedlg{3});
location(index,3)=str2double(sitedlg{4});
nsite=nsite+1;
[cfilename,cdir]=uigetfile({'*.edi','Impedence edi files(*.edi)';'*.*',...
    'All files(*.*)'},'Choose impedence format edi files to invert');
if cfilename==0
    msgbox('Note that this site will be filled with fake data','Caution');
    xi = xyz(index,1);
    yi = xyz(index,2);
    latR = custom.centre(1);
    lonR = custom.centre(2);
    [y0,x0]=deg2utm(latR,lonR,lonR);
    data(index)=int_site(xyz(index,1),xyz(index,2));
    [location(index,1), location(index,2)] = utm2deg(yi+y0,xi+x0, custom.zone, lonR);
    r=1;
    return;
end
cfile=[cdir,cfilename];
disp(['      Reading ',cfile,'...']);
[data,location,sitename]=read_edi(cfile,'mV/km/nT');
r=0;
return;

