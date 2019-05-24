function batch_xyzv_output(hObject,eventdata,h)
global model custom
% get the model dimensions
x = model.x;
y = model.y;
z = model.z;
v = model.rho;
outx=custom.x2;
outy=custom.y2;
outz=custom.z5;
% set some parameters to plot here
set(h.setbox(1),'value',1);
set(h.setbox(6),'string',num2str(outx));% x skip padding grid
set(h.setbox(7),'string',num2str(outy));% y skip padding grid
set(h.setbox(8),'string',num2str(outz));% z skip padding grid
set(h.setbox(9),'value',1);
set(h.viewbox(3),'value',1);
set(h.selectionbox(1),'value',1);
set(h.selectionbox(7),'value',1);
x=x(outx:(end-outx+1));
y=y(outy:(end-outy+1));
z=z(1:(end-outz+1));
v=v(outx:(end-outx+1),outy:(end-outy+1),1:(end-outz+1));
v(end,end,end)=v(end,end,end)+0.1; % in case of drawing a homogeneous model.
set(h.selectionbox(3),'value',1);
prompt = {'Enter the center lat',...
    'Enter the center lon'};
dlg_title = 'Specify the slices you want to output';
num_lines = 2;
def = {'38','111.5'};
answer = inputdlg(prompt,dlg_title,num_lines,def);% dialog to input slice locations
if isempty(answer)
    disp('user canceled...')
    return
end
latR=str2double(answer{1});
lonR=str2double(answer{2});
prefix='tbt_for_voxtel';
disp('start exporting model into 4D ascii xyzv format...')
disp('this may take years to finish... if you have a really large model');
%export_xyzv(hObject,eventdata,prefix,x,y,z,v);
export_xyzv_utm(hObject,eventdata,prefix,latR,lonR,x,y,z,v);
disp('done...')
return

