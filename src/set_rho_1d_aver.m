function set_rho_1d_aver(hObject,eventdata,h)
% a simple function to generate 1D structure from averaged 1d structure
% calculated from 1D bostik transformation 
% and YES, I know that the concept sounds weird to most of you... 
global model custom data nsite;
currentlayer=custom.currentZ; % z direction
BosPara=bosdlg(size(model.z,1)-1,currentlayer);
if isempty(BosPara) 
    return
end
iU=BosPara(1);
iL=BosPara(2);
mbak=model.rho;
dbak=data;
for iz=iU:iL % for each layer... 
    depth=model.z(iz);
    res=aver_bos(dbak,nsite,depth);
    model.rho(:,:,iz)=res;
end
% now recover fixed region...
model.rho((mbak-0.3)<0.1)=mbak((mbak-0.3)<0.1);
model.rho(end,end,end)=model.rho(end,end,end-1)+1;
d3_view(hObject,eventdata,h);
return

