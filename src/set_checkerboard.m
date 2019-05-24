function set_checkerboard(hObject,eventdata,h)
% a simple function to generate checkerboard models for resolution test
% please note that this function only make a checkerboard for "one layer"
% if one need multiple layers of checkerboard one can simply do it multiple
% times...
% Note to self: better to change the unit from the number of cells to
% kilometre. 
global model xyz custom;
currentlayer=custom.currentZ; % z direction
CheckerPara=checkerdlg(size(model.z,1)-1,currentlayer);
if isempty(CheckerPara) 
    return
end
iU=CheckerPara(1);
iL=CheckerPara(2);
Rh=CheckerPara(3);
Rl=CheckerPara(4);
height=CheckerPara(5)-1;
width=CheckerPara(6)-1;
intX=CheckerPara(7);
intY=CheckerPara(8);
flag=CheckerPara(9);
xmin=min(xyz(:,1));xmax=max(xyz(:,1));
x0=find(model.x>xmin,1)-1;
xn=find(model.x>xmax,1);
ymin=min(xyz(:,2));ymax=max(xyz(:,2));
y0=find(model.y>ymin,1)-1;
yn=find(model.y>ymax,1);
for ix=x0:height+intX+1:xn
    flagx=flag;
    for iy=y0:width+intY+1:yn
        if flag>0
            model.rho(ix:ix+height,iy:iy+width,iU:iL)=Rh;
        else 
            model.rho(ix:ix+height,iy:iy+width,iU:iL)=Rl;
        end
        flag=flag*-1;
    end
    flag=flagx*-1;
end
model.rho(end,end,end)=model.rho(end,end,end-1)+1;
d3_view(hObject,eventdata,h);
return

