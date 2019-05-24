function export_1Dmodel(hObject,event,handles)
% export z-v files for in "depth logRHO" format
% r: radius of the 1D sample (in meshes)
global model
prompt = {'Enter the center x location',...
    'Enter the center y location',...
    'Enter Z (Horizontal direction) slice locations:',...
    'Enter radius to average (still working on that!)'};
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
zmin=min(depths);
zmax=max(depths);
i0=find(model.x>x,1);
j0=find(model.y>y,1);
k1=find(model.z<zmin,1)-1;
k0=find(model.z<zmax,1)-1;
rho=zeros(k1-k0+1,1);
klayer=1;
for k=k0:k1
    rhot=(model.rho(i0+1,j0,k)+model.rho(i0,j0,k)+model.rho(i0-1,j0,k)+...
        model.rho(i0,j0+1,k)+model.rho(i0,j0-1,k)+model.rho(i0+1,j0+1,k)+...
        model.rho(i0-1,j0-1,k)+model.rho(i0-1,j0+1,k)+model.rho(i0+1,j0-1,k))/9;
    rho(klayer)=rhot;
    klayer=klayer+1;
end
layer=model.z(k0:k1);
h=plot_layer(rho,layer);
title(h,['1D layered model derived from location ', ...
    num2str(x), '(x) and ', num2str(y), 'km(y)']);
return

