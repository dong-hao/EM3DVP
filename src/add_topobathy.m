function add_topobathy(hObject,eventdata,h)
% a function to add bathymetry AND topography to 3d models for ModEM 
% it should be noted that the highest elevation of the land is set to zero,
% and any Topography/Bathymetry below will be set to be a MINUS (-) 
% elevation
% 
% the function read elevation grid files(in xyz format) to get the depth 
% and distribution of the topography/bathymetry.
% As WSINV3DMT doesn't support topography officially, this is just an
% experimental feature for the author's own FWD routines and is sealed for
% stability issues. 
% =================== PLEASE USE AT YOUR OWN RISK ========================%
% the function read topography grid files(in xyz format) to get the depth 
% and distribution of the topography/bathymetry,
% then set relevent cells' resistivity to air (1e7 Ohmm) or seawater,
% a typical resistence of seawater might be about 0.3 Ohmm(Ocean)
global model custom
rhoC=custom.sea; % rhoC: the resistence of SEA water
rhoA=custom.air; % rhoA: the resistence of AIR
[cfile,cpath] = uigetfile({'*.xyz','xyz file';...
    '*.*','All Files (*.*)'}...
    ,'load elevation *.xyz file');
if isequal(cfile,0) || isequal(cpath,0)
    disp('user canceled...');
    return
end
% first let us set the model fix to ones
model.fix(:)=1;
model.fix(end,end,end)=2;
% and all res to halfspace;
model.rho(:)=100;
model.rho(end,end,end)=101;
cfilename=[cpath,cfile];
data=load(cfilename); %load the xyzfile of bathymetry
east = data(:,1);
nort = data(:,2);
elev = data(:,3);
% now convert the geological coordinate back into cartesian 
lonR=custom.lonR;
centre=custom.centre;
[y0,x0]=deg2utm(centre(1),centre(2),lonR);
[y,x]=deg2utm(nort,east,lonR);
y=y-y0;
x=x-x0;
xm=zeros(length(model.x)-1,1); % N-S
ym=zeros(length(model.y)-1,1); % E-W
for i=1:length(ym)
    ym(i)=(model.y(i)+model.y(i+1))/2;
end
for i=1:length(xm)
    xm(i)=(model.x(i)+model.x(i+1))/2;
end
[yy,xx] = meshgrid(ym,xm);
eleint = griddata(y,x,elev,yy,xx,'linear');
% find out the NaN cells (this is normally due to the lack of DEM data in
% some part of the model) and fill it with the nearest value
nanidx = isnan(eleint);
nanlist = find(nanidx);
nlist = find(~nanidx);
nnan = length(nanlist);
if nnan > 0
    for i = 1 : nnan
        dy = yy(~nanidx) - yy(nanlist(i));
        dx = xx(~nanidx) - xx(nanlist(i));
        dist = dy.^2 + dx.^2;
        [c, mind] = min(dist);
        eleint(nanlist(i)) = eleint(nlist(mind));
    end
end

emax=max(eleint(:)); % highest point of the data (set to 0);
% store the xyz dat in a matrix.
% =======for debug======= %
% figure; 
% surf(yy,xx,eleint);
% shading flat
% =======for debug======= %
% thick1=-model.z(2);
depth=-model.z;
isea=find(depth>=emax,1); 
custom.zero(3)=-depth(isea); % the sea level depth in the model
for i=1:length(xm)
    for j=1:length(ym)
        % calculate the distance between the ground/seabed and the highest 
        % point of the model
        topo=round((emax-eleint(i,j))/100)*100;
        idx=find(depth>=topo,1)-1;
        if isempty(idx)
            idx=length(depth)-1;
        end
        % debug
%         if i==81&&j==14
%             disp(topo);
%         end
        if topo<=emax % we are still on land...
            model.rho(i,j,1:idx)=rhoA; % change the res.
            model.fix(i,j,1:idx)=0; % for Air.
        else % we are down in the sea...
            model.rho(i,j,1:isea-1)=rhoA;
            model.fix(i,j,1:isea-1)=0; % for Air.
            model.rho(i,j,isea:idx-1)=rhoC; % change the res.
            model.fix(i,j,isea:idx-1)=9; % for Sea water.
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

