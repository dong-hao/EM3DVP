function popEdit_Res(hObject,eventdata,h)
% callback for resistivity editing
todo=get(h.edit(4),'value');
switch todo
    case 1
        disp('do nothing');
    case 2
        set_rho_area(hObject,eventdata,h)
    case 3
        set_rho_layer(hObject,eventdata,h)
    case 4
        set_rho_hfspace(hObject,eventdata,h)
    case 5
        set_rho_polygon(hObject,eventdata,h)
    case 6
        set_rho_sphere(hObject,eventdata,h)
    case 7
        set_checkerboard(hObject,eventdata,h)
    case 8
        add_bathymetry(hObject,eventdata,h)
    case 9
        add_topobathy(hObject,eventdata,h)
    case 10
        set_rho_rand(hObject,eventdata,h)
    case 11
        set_sigma_rand(hObject,eventdata,h)
    case 12
        set_rho_123(hObject,eventdata,h)        
    case 13
        set_rho_1d_aver(hObject,eventdata,h) 
    case 14
        set_anis_area(hObject,eventdata,h)          
end
set(h.edit(4),'value',1);
return

