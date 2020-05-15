function export_1Dmodel(hObject,event,handles)
% export z-v files for in "depth logRHO" format
% r: radius of the 1D sample (in meshes)
global model
if isempty(model)
    error('model not initialized yet - load a model first!');
end
prompt = {'Enter the center x location',...
    'Enter the center y location',...
    'Enter Z (Horizontal direction) slice locations:',...
    'Enter radius (in cells) to average'};
dlg_title = 'Specify the spot you want to output';
num_lines = 3;
def = {'0','0','0 -300','2'};
answer = inputdlg(prompt,dlg_title,num_lines,def);% dialog to input slice locations
if isempty(answer)
    disp('user canceled...')
    return
end
x=str2double(answer{1});
y=str2double(answer{2});
depths=str2num(answer{3});% get the depth range
r=str2double(answer{4}); % get radius (in cells)
zmin=min(depths);
zmax=max(depths);
i0=find(model.x>x,1);
j0=find(model.y>y,1);
if i0 - r < 1 || i0 +r > length(model.x)
    error('ERROR: selected region out of the model!');
elseif j0 - r < 1 || j0 +r > length(model.y)
    error('ERROR: selected region out of the model!');
end
k1=find(model.z<zmin,1)-1;
k0=find(model.z<zmax,1)-1;
rho=zeros(k1-k0+1,1);
rhol=rho;
rhou=rho;
klayer=1;
for k=k0:k1
    rhoall=model.rho(i0-r:i0+r,j0-r:j0+r,k);
    rhot = mean(log10(rhoall(:)));
    rhot = 10^rhot;
    rhomax = max(rhoall(:));
    rhomin = min(rhoall(:));
    rho(klayer)=rhot;
    rhou(klayer)=rhomax;
    rhol(klayer)=rhomin;
    klayer=klayer+1;
end
layer=model.z(k0:k1);
h=plot_layer(layer,rho,rhol,rhou);
title(h,['1D layered model derived from location ', ...
    num2str(x), '(x) and ', num2str(y), '(y) km']);
fid = fopen([num2str(x) '+' num2str(y) 'km.dat'], 'w');
for k = 1:klayer-1
    fprintf(fid, '%8.3f, %8.3f, %8.3f, %8.3f\n',layer(k),rho(k),rhol(k),rhou(k));
end
fclose(fid);
return

