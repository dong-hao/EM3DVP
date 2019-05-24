function set_mesh_para(hObject,eventdata,h)
rhomax=str2double(get(h.rho(1),'string'));
rhomin=str2double(get(h.rho(2),'string'));
fmax=str2double(get(h.freq(1),'string'));
fmin=str2double(get(h.freq(2),'string'));
Lratio=str2double(get(h.ratio(1),'string'));
Cratio=str2double(get(h.ratio(2),'string'));
spacing=str2double(get(h.spacing(1),'string'));
first=str2double(get(h.first(1),'string'));
last=str2double(get(h.first(1),'string'));
[Calpha, Cratio, j, Lalpha, Lratio, i]=calc_mesh(rhomax, rhomin, fmax,...
    fmin, Lratio, Cratio, spacing, first, last);
set(h.parent.model(1),'string',num2str(Calpha));
set(h.parent.model(4),'string',num2str(Calpha));
set(h.parent.model(3),'string',num2str(Cratio));
set(h.parent.model(6),'string',num2str(Cratio));
set(h.parent.model(2),'string',num2str(j));
set(h.parent.model(5),'string',num2str(j));
set(h.parent.model(7),'string',num2str(Lalpha));
set(h.parent.model(8),'string',num2str(Lratio));
set(h.parent.model(10),'string','1.5');
set(h.parent.model(9),'string',num2str(i));
set(h.parent.model(11),'string','0');
return

