function lock_rho_hfspace(hObject,eventdata,h)
% set model resistivity to one same value(half space )
global model custom
fix = menu('please select','lock halfspace','unlock halfspace','cancel');
switch fix
    case 1
        model.fix(:)=2;
        model.fix(end,end,end)=2;
    case 2
        model.fix(:)=1;
        model.fix(end,end,end)=2;
    case 3
        return
end
%h=findobj(gcf,'type','surface');
%delete(handle);
if get(h.viewbox(1),'value')==1
    view=1; % x direction
elseif get(h.viewbox(2),'value')==1
    view=2; % y direction
else
    view=3; % z direction
end
switch view
    case 1
        plot_mesh(h,'x',custom.currentX);
    case 2
        plot_mesh(h,'y',custom.currentY);
    case 3
        plot_mesh(h,'z',custom.currentZ);
end
set(h.button(5),'value',1);
d3_view(hObject,eventdata,h)
return

