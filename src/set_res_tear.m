function set_res_tear(hObject,eventdata,h)
% a function to set a resisitivity tear/boundary to 3d models for ModEM 
% 
% the function read a boundary file (in xyz format) to setup boundary/tear 
% at a certain location, currently just support horizontal(depth)
% boundaries
% =================== PLEASE USE AT YOUR OWN RISK ========================%
% the function read boundary files(in xyz format) to set the resistivity
% above/below the tear 
%
global model custom
[cfile,cpath] = uigetfile({'*.xyz','xyz file';...
    '*.*','All Files (*.*)'}...
    ,'load elevation *.xyz file');
if isequal(cfile,0) || isequal(cpath,0)
    disp('user canceled...');
    return
end
cfilename=[cpath,cfile];
data=load(cfilename); %load the xyzfile of bathymetry
east = data(:,1);
nort = data(:,2);
dpth = data(:,3);
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
depthint = griddata(y,x,dpth,yy,xx,'natural');
currentdepth = -model.z(custom.currentZ);
BondPara=teardlg(currentdepth);
MeDepth = median(depthint(:))*1000;
if BondPara(1)<MeDepth
    opt = 'upper'; 
    boundA = BondPara(1);
elseif BondPara(1)>MeDepth
    opt = 'lower';
    boundB = BondPara(1);
else
    opt = 'unknown';
end
fixL = BondPara(2);
rhoL = BondPara(3);
% store the xyz dat in a matrix.
% =======for debug======= %
figure; 
surf(yy,xx,depthint);
shading flat
% =======for debug======= %
depth=-model.z;
for i=1:length(xm)
    for j=1:length(ym)
        % first calculate the upper/lower bound
        % point of the model
        switch upper(opt)
            case 'UPPER'
                boundB = round(depthint(i,j)*1000);
                idx1=find(depth>=boundA,1);
                idx2=find(depth>=boundB,1)-1;
                if isempty(idx1)
                   	idx1=1;
                end
                idxt = find(model.fix(i,j,:) > 0, 1);
                if idx1 <= idxt
                    idx1 = idxt;
                end
                model.rho(i,j,idx1:idx2)=rhoL;
                model.fix(i,j,idx1:idx2)=fixL;
            case 'LOWER'
                boundA = round(depthint(i,j)*1000);
                idx1=find(depth>=boundA,1);
                idx2=find(depth>=boundB,1)-1;
                if isempty(idx2)
                   	idx2=length(depth)-1;
                end
                model.rho(i,j,idx1:idx2)=rhoL;
                model.fix(i,j,idx1:idx2)=fixL;
            otherwise 
                error('unclear specification of layer setting')
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

