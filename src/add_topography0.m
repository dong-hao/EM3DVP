function add_topography0(hObject,eventdata,h)
% a function to add topography and bathymetry to 3d models for WSINV3DMT. 
% it should be noted that the highest elevation (summit of mountain?)of the
% modelling region is set to zero and everything below that is set to be a 
% MINUS (-) elevation.
% as WSINV3DMT doesn't support topography officially, this is just an
% experimental feature for the author's own FWD routines and is sealed for
% stablility issues. 
% =================== PLEASE USE AT YOUR OWN RISK ========================%
% the function read topography grid files(in xyz format) to get the depth 
% and distribution of the topography/bathymetry,
% then set relevent cells' resistivity to air (about 1e7 Ohmm) or seawater,
% (about 0.3 Ohmm Ocean)
% a typical resistence of seawater might be about 0.3 Ohmm(Ocean)
% the matlab function utm2deg is needed.
global model custom
rhoA=custom.air; % rhoA: the resistence of air
rhoC=custom.sea; % rhoC: the resistence of sea
[cfile,cpath] = uigetfile({'*.xyz','xyz file';...
    '*.*','All Files (*.*)'}...
    ,'load bathymetry *.xyz file');
if isequal(cfile,0) || isequal(cpath,0)
    disp('user canceled...');
    return
end
cfilename=[cpath,cfile];
data=load(cfilename); %load the xyzfile of topography
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
% convert the model grid location back to degrees
[latm,lonm]=utm2deg(gridloc(:,1),gridloc(:,2),zone1,lonR);
latm_grid = reshape(latm,length(xm),length(ym));
lonm_grid = reshape(lonm,length(xm),length(ym));
elev_grid = zeros(size(latm_grid));
flthick=model.z(2); % the depth(thickness) of the first layer
for i=1:length(xm) % loop with every model grid (W-E)
    for j=1:length(ym)  % loop with every model grid (S-N)
        % find the corresponding topography grid that the model cell lies
        % in.
        % better to find the topography using the nearest data point!
        p=find(ulat>latm_grid(i,j),1);
        q=find(ulon>lonm_grid(i,j),1);        
        if isempty(p)||isempty(q)
            warning('MATLAB:paramAmbiguous',...
                'model area not included in topography data');
            continue
        else
            p=nearest_dist(ulat,latm_grid(i,j));
            q=nearest_dist(ulon,lonm_grid(i,j));
            elev_grid(i,j)=uelev(p,q);
        end
    end
end
maxelev = max(elev_grid(:)); % find the highest point of topo in the area.
for i=1:length(xm)
    for j=1:length(ym)
        if elev_grid(i,j) - maxelev < flthick  % if the air layer is thick enough
            %(thicker than the first layer of the model    
        %     disp(ulat(m)) for debug
        %     disp(ulon(n))
            na=find(model.z<(elev_grid(i,j)-maxelev),1)-1;
            model.rho(i,j,1:na)=rhoA; % change the res.
            model.fix(i,j,1:na)=1; % and fix the model.
            nc=find(model.z<-maxelev,1); % grid of sea level
            if elev_grid(i,j) - maxelev < (model.z(nc)+model.z(nc+1))/2
                model.rho(i,j,nc:na)=rhoC; % change the res.
                model.fix(i,j,nc:na)=1; % and fix the model.
            end
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

