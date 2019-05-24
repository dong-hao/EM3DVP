function set_sigma_rand(hObject,eventdata,h)
% a simple function to generate a random sigma value for each block for a
% given range of depth
%
% and YES, I know that the concept sounds weird to most of you... 
global model xyz custom;
currentlayer=custom.currentZ; % z direction
RandPara=randdlg(size(model.z,1)-1,currentlayer);
if isempty(RandPara) 
    return
end
iU=RandPara(1);
iL=RandPara(2);
Sh=RandPara(3);
Sl=RandPara(4);
height=RandPara(5)-1;
width=RandPara(6)-1;
xmin=min(xyz(:,1));xmax=max(xyz(:,1));
x0=find(model.x>xmin,1)-2;
if isempty(x0)
    x0=2;
end
xn=find(model.x>xmax,1);
if isempty(xn)
    xn=length(model.x)-1;
end
ymin=min(xyz(:,2));ymax=max(xyz(:,2));
y0=find(model.y>ymin,1)-2;
if isempty(y0)
    y0=2;
end
yn=find(model.y>ymax,1);
if isempty(yn)
    yn=length(model.y)-1;
end
upper=model.z(iU);
lower=model.z(iL+1);
cond=calc_cond(model.rho,model.z/1000,upper/1000,lower/1000);
range=log10(Sh/Sl);
mbak=model.rho;
for iz=iU:iL % loop through layers
    for ix=x0:height+1:xn
        for iy=y0:width+1:yn
            randS=Sl*10.^(rand(length(model.x-1),length(model.y-1))*range);
            ratio=cond(ix,iy)/randS(ix,iy);
            model.rho(ix,iy,iz)=model.rho(ix,iy,iz)/ratio;
        end
    end
end
model.rho((mbak-0.3)<0.1)=mbak((mbak-0.3)<0.1);
% cond2=calc_cond(model.rho,model.z/1000,upper/1000,lower/1000);
model.rho(end,end,end)=model.rho(end,end,end-1)+1;
d3_view(hObject,eventdata,h);
return

