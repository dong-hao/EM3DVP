function lock_airnsea(hObject,eventdata,h)
% lock air/sea resisitivity for the whole model
% you have to edit the values before locking them!
% simply find and lock any resistivity value of air/sea
% presuming air has an resisitivity of 1+e8 Ohm*m and sea water has an
% resistivity of 0.3 Ohm*m
global model custom
fix = menu('please select','lock air','lock sea','unlock air/sea','cancel');
switch fix
    case 1 % lock air
        seq= model.rho>=custom.air;
        model.fix(seq)=0;
        model.fix(end,end,end)=1;
    case 2 % lock sea
        seq= model.rho==custom.sea;
        model.fix(seq)=9;
        model.fix(end,end,end)=1;
    case 3 % unlock air/sea
        seq= model.fix==0; % air
        model.fix(seq)=1;
        seq= model.fix==9; % sea
        model.fix(seq)=1;
        model.fix(end,end,end)=2; 
    case 4
        return
end
set(h.button(5),'value',1);
d3_view(hObject,eventdata,h)
if custom.currentZ==1
    hold on;
    plot_site(hObject,eventdata,h,'noname');
    hold off;
end
return

