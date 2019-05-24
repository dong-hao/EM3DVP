function add_bathymetry0(hObject,eventdata,h)
% a function to add ONLY bathymetry to 3d models for WSINV3DMT. 
% it should be noted that the default elevation of the land is set to zero,
% and any bathymetry is set to be a MINUS (-) elevation below the sea
% level. And NO topography is concerned here since WSINV3DMT doesn't
% support topography officially. 
% 
% the function read bathymetry grid files(in xyz format) to get the depth 
% and distribution of the sea floor.
% then set relevent cells' resistivity to seawater. 
% 
% a typical resistence of seawater might be about 0.3 Ohmm(Ocean)
% the matlab function utm2deg is needed.
global model custom
rhoC=custom.sea; % rhoC: the resistence of SEA water
[cfile,cpath] = uigetfile({'*.xyz','xyz file';...
    '*.*','All Files (*.*)'}...
    ,'load bathymetry *.xyz file');
if isequal(cfile,0) || isequal(cpath,0)
    disp('user canceled...');
    return
end
cfilename=[cpath,cfile];
data=load(cfilename); %load the xyzfile of bathymetry
lon = data(:,1);
lat = data(:,2);
elev = data(:,3);
% store the xyz dat in a matrix.
ulon = sort(unique(lon));
ulat = sort(unique(lat));
% uelev = zeros(length(ulon),length(ulat));
uelev = flipud(reshape(elev,length(ulon),length(ulat))');
% please note that the uelev matrix start at the lower left(southwest)
% part of the map and count at a sequence of W->E, S->N.
% =======for debug======= %
% [xx,yy]=meshgrid(ulon,ulat);
% surf(xx,yy,uelev);
% shading flat
central=custom.centre;
lonR=custom.lonR;
[y0,x0,zone]=deg2utm(central(1),central(2),lonR);
zone=num2str(zone);
zone(end+1)=' ';
nzone=(floor((central(1)+90)/8))+65;
% note: 65 is the decimacial ascii code of charactor 'A'
if nzone>72 % omitting the "I" zone
    nzone=nzone+1;
    if nzone>78 % omitting the "O" zone
        nzone=nzone+1;
    end
end
zone(end+1)=char(nzone);
zone1='    ';
ym=zeros(length(model.y)-1,1);
xm=zeros(length(model.x)-1,1);
for i=1:length(ym)
    ym(i)=(model.y(i)+model.y(i+1))/2+y0;
end
for i=1:length(xm)
    xm(i)=(model.x(i)+model.x(i+1))/2+x0;
end
Ngrid=length(ym)*length(xm);
for i=1:Ngrid
    zone1(i,:)=zone;
end
gridloc=zeros(Ngrid,2);
for i=1:length(ym)
    for j=1:length(xm)
        gridloc((i-1)*length(xm)+j,:)=[ym(i) xm(j)];
    end
end
% convert the model grid back to degrees
[latm,lonm]=utm2deg(gridloc(:,1),gridloc(:,2),zone1,lonR);
latm_grid = reshape(latm,length(xm),length(ym));
lonm_grid = reshape(lonm,length(xm),length(ym));
flthick=model.z(2); % the depth(thickness) of the first layer
for i=1:length(xm)
    for j=1:length(ym)
        m=find(ulat>latm_grid(i,j),1);
        n=find(ulon>lonm_grid(i,j),1);
        if isempty(m)||isempty(n)
            warning('MATLAB:paramAmbiguous',...
                'model area not included in bathemetry data');
        end
        if uelev(m,n)<flthick/5  % if the sea is deep enough(deeper than the
            % first layer of the model            
%             disp(ulat(m)) for debug
%             disp(ulon(n))
            nl=find(model.z<uelev(m,n),1)-1;
            model.rho(i,j,1:nl)=rhoC; % change the res.
            model.fix(i,j,1:nl)=1; % and fix the model.
        end        
    end
end
% plot the fix model
set(h.button(5),'value',1);
plot_fix(h,'z',custom.currentZ);
if custom.currentZ==1
    hold on;
    plot_site(hObject,eventdata,h,'noname');
    hold off;
end
return;

