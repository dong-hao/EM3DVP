function set_rho_hfspace(hObject,eventdata,h)
% set model resistivity to one same value(half space )
global model
rho0 = inputdlg('input background resistivity','Half Space',1,{'100'});
rho0 = str2num(char(rho0));
model.rho(:)=rho0;
model.rho(end,end,end)=rho0+1;
%h=findobj(gcf,'type','surface');
%delete(handle);
d3_view(hObject,eventdata,h);
return

