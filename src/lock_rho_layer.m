function lock_rho_layer(hObject,eventdata,h)
% set model resistivity to given layer(s)
global model custom
if get(h.viewbox(1),'value')==1
    currentlayer=custom.currentX; % x direction
elseif get(h.viewbox(2),'value')==1
    currentlayer=custom.currentY; % y direction
else
    currentlayer=custom.currentZ; % z direction
end
fix = menu('please select','lock layer','unlock layer','cancel');
switch fix
    case 1
        BlockPara=blockdlg_fix(size(model.z,1)-1,currentlayer);
        model.fix(:,:,BlockPara(1):BlockPara(2))=2;
        model.fix(end,end,end)=2;
    case 2
        BlockPara=blockdlg_fix(size(model.z,1)-1,currentlayer);
        model.fix(:,:,BlockPara(1):BlockPara(2))=1;
        model.fix(end,end,end)=2;
    case 3
        return
end
%h=findobj(gcf,'type','surface');
%delete(handle);
set(h.button(5),'value',1);
d3_view(hObject,eventdata,h)
return

