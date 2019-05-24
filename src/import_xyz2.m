function import_xyz2(hObject,eventdata,h)
% import xyz file (lat / lon / elevation) for site location
% and generate fake data for fwd modelling
global location xyz data sitename nsite custom
pname=custom.projectname;
queststr='This will import an xyz file for site location and generate fake data for forward modelling. continue?';
yorn=questdlg(queststr,'Import site location file','yes','no','yes');
if strcmp(yorn,'no')
    disp('user canceled');
    return
end
%==============import site=======================%
[cfilename,cdir]=uigetfile({...
    '*.xyz', 'site location of x y z';...
    '*.*','All files(*.*)'},...
    'Choose a site location file');
if isequal(cfilename,0) || isequal(cdir,0)
    disp('user canceled...');
    return
end
pdir=pwd;
location=read_xyz(cfilename,cdir);
nsite=size(location,1);
Nsite=nsite;
xyz=zeros(nsite,3);
xyz(:,3)=location(:,3);
sitename=cell(nsite,1);
% get centre latitude and longtitude.
% strict projection is not used here
lat = location(:,1);
lon = location(:,2);
latR = round(median(lat));
lonR = round(median(lon));
central(1)=latR;
central(2)=lonR;
custom.centre=central;
[y,x,zone]=deg2utm(lat,lon,lonR); % force project to lonR
disp('UTM coordinates(Easting, Northing)')
disp(y')
disp(x')
disp(zone');
[y0,x0,zone]=deg2utm(latR,lonR,lonR);
disp(zone)
% store the location of the central point 
if Nsite>=1000 % pad 0 up to 4-digits
        pad0=4;
elseif Nsite >= 100
        pad0=3;
elseif Nsite >= 10
        pad0=2;
else 
        pad0=0;
end
data=gen_data;
for isite=1:Nsite
    % see how many zeros do we need
    pad=pad0-ceil(log10(isite)+0.001);
	% try to pad zeros
    pzero=ones(1,pad);
	pzero=pzero*48;% please note that 60 is the decimal ascii code for '0'
	tmp=[pzero num2str(isite)];
	sitename{isite}=[pname,'-',tmp];
    data(isite)=gen_data;
    data(isite)=calc_rhophs(data(isite),1);
end
y=y-y0;
x=x-x0; % set the centre point to zero.
xyz(:,1)=x;
xyz(:,2)=y;
plot_site(hObject,eventdata,h,'name');
cd(pdir)
return

