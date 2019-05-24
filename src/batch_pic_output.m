function batch_pic_output(hObject,eventdata,h)
% a silly script to batch output slices from 3D datasets
% edit this script if you want to output a lot of pics for comparation
global model custom
% get the model dimensions
x = model.x;
y = model.y;
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
% set(h.setbox(9),'value',1);
set(h.viewbox(3),'value',1);
set(h.selectionbox(1),'value',1);
set(h.selectionbox(7),'value',1);
% set(h.rholim(2),'string','10000');%max rho
% set(h.rholim(1),'string','1');%min rho
x=x(outx:(end-outx+1));
y=y(outy:(end-outy+1));
z=z(1:(end-outz+1));
% set default slice locations here
xslices=floor(min(x)+(max(x)-min(x))/5:(max(x)-min(x))/5:max(x)-(max(x)-min(x))/5);% location of slices, x
yslices=floor(min(y)+(max(y)-min(y))/5:(max(y)-min(y))/5:max(y)-(max(y)-min(y))/5);% location of slices, y
zslices=floor(min(z)+(max(z)-min(z))/5:(max(z)-min(z))/5:max(z));% location of slices, z
set_boundary(hObject,eventdata,h);
set_colorbar(hObject,eventdata,h);
prompt = {'Enter the title suffix',...
    'Enter X (N-S direction) slice locations:',...
    'Enter Y (E-W direction) slice locations:',...
    'Enter Z (Horizontal direction) slice locations:'};
dlg_title = 'Specify the slices you want to plot';
num_lines = 4;
def = {' Apparent Resistivity Section',...
    num2str(xslices),num2str(yslices),num2str(zslices)};
answer = inputdlg(prompt,dlg_title,num_lines,def);% dialog to input slice locations
if isempty(answer)
    disp('user canceled...')
    return
end
suffix=answer{1}; 
xslices=str2num(answer{2});% get these slice locations
yslices=str2num(answer{3});
zslices=str2num(answer{4});
set(h.selectionbox(1),'value',1);
prefix='E-W-slices@';
for i=1:length(xslices)
    set(h.selectionbox(4),'string',num2str(xslices(i)));
    set_slice_location(h.selectionbox(4),eventdata,h,'x')
    sxtext=[num2str(x(custom.currentX)), '-' num2str(x(custom.currentX+1)), 'km'];
    copy_and_output(hObject,eventdata,h,[prefix sxtext suffix]);
end
set(h.selectionbox(2),'value',1);
prefix='N-S-slices@';
for i=1:length(yslices)
    set(h.selectionbox(5),'string',num2str(yslices(i)));
    set_slice_location(h.selectionbox(5),eventdata,h,'y')
    sytext=[num2str(y(custom.currentY)), '-' num2str(y(custom.currentY+1)), 'km'];
    copy_and_output(hObject,eventdata,h,[prefix sytext suffix]);
end
set(h.selectionbox(3),'value',1);
prefix='Horizontal-slices@';
for i=1:length(zslices)
    set(h.selectionbox(6),'string',num2str(zslices(i)));
    set_slice_location(h.selectionbox(6),eventdata,h,'z')
    sztext=[num2str(z(custom.currentZ)), '-' num2str(z(custom.currentZ+1)), 'km'];
    copy_and_output(hObject,eventdata,h,[prefix sztext suffix]);
end
return

