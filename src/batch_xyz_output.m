function batch_xyz_output(hObject,eventdata,h)
% a silly script to batch output xyz files from 3D slices
% edit this script if you want to output a lot of slices for comparation
global model custom
% get the model dimensions
z = model.z;
outx=custom.x2;
outy=custom.y2;
outz=custom.z5;
% outx=9;
% outy=9;
% outz=14;
% set some parameters to plot here
set(h.setbox(1),'value',1);
set(h.setbox(6),'string',num2str(outx));% x skip padding grid
set(h.setbox(7),'string',num2str(outy));% y skip padding grid
set(h.setbox(8),'string',num2str(outz));% z skip padding grid
set(h.setbox(9),'value',1);
set(h.viewbox(3),'value',1);
set(h.selectionbox(1),'value',1);
set(h.selectionbox(7),'value',1);
% set(h.rholim(2),'string','10000');%max rho
% set(h.rholim(1),'string','1');%min rho
% x=x(outx:(end-outx+1));
% y=y(outy:(end-outy+1));
z=z(1:(end-outz+1));
% set default slice locations here
% xslices=floor(min(x)+(max(x)-min(x))/5:(max(x)-min(x))/5:max(x)-(max(x)-min(x))/5);% location of slices, x
% yslices=floor(min(y)+(max(y)-min(y))/5:(max(y)-min(y))/5:max(y)-(max(y)-min(y))/5);% location of slices, y
%zslices=floor(min(z)+(max(z)-min(z))/5:(max(z)-min(z))/5:max(z));% location of slices, z
zslices=z;
set_boundary(hObject,eventdata,h);
set_colorbar(hObject,eventdata,h);
prompt = {'Enter the center lat',...
    'Enter the center lon',...
    'Enter Z (Horizontal direction) slice locations:'};
dlg_title = 'Specify the slices you want to output';
num_lines = 3;
def = {'38','108.5',num2str(zslices)};
answer = inputdlg(prompt,dlg_title,num_lines,def);% dialog to input slice locations
if isempty(answer)
    disp('user canceled...')
    return
end
latR=str2double(answer{1});
lonR=str2double(answer{2});
zslices=str2num(answer{3});
% zslices=model.z;
set(h.selectionbox(3),'value',1);
prefix='Horizontal';
for i=1:length(zslices)
    Nz=find(model.z<zslices(i),1)-1;
    set(h.selectionbox(6),'string',num2str(zslices(i)));
    set_slice_location(h.selectionbox(6),eventdata,h,'z')
    export_xyz(hObject,eventdata,[prefix num2str(zslices(i)) 'km'],Nz,latR,lonR);
end
return
% -1 -5 -10 -20 -30 -40 -50 -60 -70 -80 -90 -100 -110 -120 -130 -140 -150 -175 -200 -250 -350 -450

