function popLock_Model(hObject,eventdata,h)
% callback for Model resistivity fixing
todo=get(h.edit(5),'value');
switch todo
    case 1
        disp('do nothing');
    case 2
        lock_rho_area(hObject,eventdata,h)        
    case 3
        lock_rho_layer(hObject,eventdata,h)
    case 4
        lock_rho_hfspace(hObject,eventdata,h)
    case 5
        lock_airnsea(hObject,eventdata,h)
end
set(h.edit(5),'value',1);
return

