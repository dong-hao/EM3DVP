function set_rho_layer(hObject,eventdata,h)
% set model resistivity to given layer(s)
global model custom
if get(h.viewbox(1),'value')==1
    currentlayer=custom.currentX; % x direction
elseif get(h.viewbox(2),'value')==1
    currentlayer=custom.currentY; % y direction
else
    currentlayer=custom.currentZ; % z direction
end
BlockPara=blockdlg(size(model.z,1)-1,currentlayer);
model.rho(:,:,BlockPara(1):BlockPara(2))=BlockPara(3);
model.rho(end,end,end)=model.rho(end,end,end-1)+1;
%h=findobj(gcf,'type','surface');
%delete(handle);
d3_view(hObject,eventdata,h);
return

