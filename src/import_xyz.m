function import_xyz(hObject,eventdata,h)
% import xyz file (northing / easting / elevation) for site location
% and replace current site location
global xyz sitename nsite data custom location
queststr='This will import an xyz file to replace your current site (projected) locations. continue?';
yorn=questdlg(queststr,'Import site location file','yes','no','yes');
if strcmp(yorn,'no')
    disp('user canceled');
    return
end
%==============import site=======================%
[cfilename,cdir]=uigetfile({...
    '*.loc', 'site name and location';...
    '*.*','All files(*.*)'},...
    'Choose a site location file');
if isequal(cfilename,0) || isequal(cdir,0)
    disp('user canceled...');
    return
end
pdir=pwd;
[txyz,tname]=read_xyz(cfilename,cdir);
% nsite2=size(txyz,1);
% if nsite2~=nsite
%     error('imported site number not matching current sites')
% end
xyz=txyz;
sitename=tname;
nsite=size(txyz,1);
location=zeros(nsite,3);
sitename=cell(nsite,1);
siteX=location(:,1);
siteY=location(:,2);
% get centre latitude and longtitude from the main panel.
lat=custom.centre(1);
lon=custom.centre(2);
% strict projection is not used here
siteX = lat+siteX*360/(1000*6371*2*pi);
siteY = lon+siteY*360/((1000*6371*2*pi)*cos(mean(siteX)/180*pi));
central(1)=lat;
central(2)=lon;
% store the location of the central point 
custom.centre=central;
custom.lonR=lon;
location(:,1)=siteX;
location(:,2)=siteY;
if nsite>=1000 % pad 0 up to 4-digits
        pad0=4;
elseif nsite >= 100
        pad0=3;
elseif nsite >= 10
        pad0=2;
else 
        pad0=0;
end
data=gen_data;
pname=custom.projectname;
for isite=1:nsite
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
plot_site(hObject,eventdata,h,'name');
cd(pdir)
return