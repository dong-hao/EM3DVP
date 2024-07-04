function add_bathymetry(hObject,eventdata,h)
% a function to add ONLY bathymetry to 3d models for ModEM 
% it should be noted that the topography of the land is IGNORED in this
% function. Anything above sea level will be set to zero(top of the model)
% and anything below will be set to be a MINUS (-) elevation
% 
% the function read elevation grid files(in xyz format) to get the depth 
% and distribution of the topography/bathymetry.
% Anything below the sea floor (0 in grid files) will be set up as sea 
% water 
% a typical resistance of seawater might be about 0.3 Ohmm(Ocean)
global model custom
rhoC=custom.sea; % rhoC: the resistance of SEA water
[cfile,cpath] = uigetfile({'*.xyz','xyz file';...
    '*.*','All Files (*.*)'}...
    ,'load elevation *.xyz file');
if isequal(cfile,0) || isequal(cpath,0)
    disp('user canceled...');
    return
end
% first let us set the model fix to zeros
model.fix(:)=1;
model.fix(end,end,end)=2;
% and all res to halfspace;
model.rho(:)=100;
model.fix(end,end,end)=101;
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
emax=0;
% store the xyz dat in a matrix.
% =======for debug======= %
% figure; 
% surf(yy,xx,eleint);
% shading flat
% =======for debug======= %
% thick1=-model.z(2);
depth=-model.z;
custom.zero(3)=emax;
for i=1:length(xm)
    for j=1:length(ym)
        % calculate the distance between the ground/seabed to the top of
        % the model
        topo=round((emax-eleint(i,j))/10)*10;
        if topo<=0 % we are on land... do nothing here
            
        else % we are down in the sea...            
            idx=find(depth>=topo,1)-1;
            if isempty(idx)
                idx=length(depth)-1;
            end
            model.rho(i,j,1:idx)=rhoC; % change the res.
            model.fix(i,j,1:idx)=9; % for Sea water.
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

