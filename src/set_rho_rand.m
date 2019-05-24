function set_rho_rand(hObject,eventdata,h)
% a simple function to generate shallow and "local" random models to 
% simulate galvanic distortions. 
% and YES, I know that the concept sounds weird to most of you... 
% the options can be a full "random" (mosaic-like) resistivity
% distribution,
% or a "fractal" geometry 
global model xyz custom;
seed=150;
currentlayer=custom.currentZ; % z direction
RandPara=randdlg(size(model.z,1)-1,currentlayer);
if isempty(RandPara) 
    return
end
iU=RandPara(1);
iL=RandPara(2);
Rh=RandPara(3);
Rl=RandPara(4);
height=RandPara(5)-1;
width=RandPara(6)-1;
algo=RandPara(7);
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
range=log10(Rh/Rl);
mbak=model.rho;
switch algo
    case 1 % full random
        for iz=iU:iL
            Rt=Rl*10.^(range*(rand(xn,yn)));
            for ix=x0:height+1:xn
                for iy=y0:width+1:yn
                    model.rho(ix:ix+height,iy:iy+width,iz)=Rt(ix,iy);
                end
            end
        end
    case 2 % fractal geometry
    % start with a random point within the array region
        Nx=xn-x0;
        Ny=yn-y0;
        height=height+1;
        width=width+1;
        xs=x0+floor(rand(1,1)*Nx);
        ys=y0+floor(rand(1,1)*Ny);
        % estimate how many steps we are going to move 
        Ns=round((Nx*Ny)/(height*width))*3;
        % random direction
        Dt=rand(1,Ns);
        % step length
        lstx=ceil(height);
        lsty=ceil(width);
        % random rho
        Rt=Rl*10.^(range*(rand(1,Ns)));
        % now start wandering...
        for istep=1:Ns
            if Dt(istep)<0.125 % going north
                xs=xs+lstx;
                if xs>=xn
                    xs=xn-lstx*2;
                end
            elseif Dt(istep)<0.25 % going east
                ys=ys+lsty;
                if ys>=yn
                    ys=yn-2*lsty;
                end
            elseif Dt(istep)<0.375 % going west
                ys=ys-lsty;
                if ys<=y0
                    ys=y0+2*lsty;
                end
            elseif Dt(istep)<0.5 % going south
                xs=xs-lstx;
                if xs<=x0
                    xs=x0+lstx*2;
                end
            elseif Dt(istep)<0.625 % going NE
                xs=xs+lstx;
                ys=ys+lsty;
                if xs>=xn
                    xs=xn-lstx*2;
                end
                if ys>=yn
                    ys=yn-2*lsty;
                end                
            elseif Dt(istep)<0.75 % going SE
                xs=xs-lstx;
                ys=ys+lsty;
                if xs<=x0
                    xs=x0+lstx*2;
                end
                if ys>=yn
                    ys=yn-2*lsty;
                end                
            elseif Dt(istep)<0.875 % going SW
                xs=xs-lstx;
                ys=ys-lsty;
                if xs<=x0
                    xs=x0+lstx*2;
                end
                if ys<=y0
                    ys=y0+2*lsty;
                end                
            else % going NW
                xs=xs+lstx;
                ys=ys-lsty;
                if xs>=xn
                    xs=xn-lstx*2;
                end
                if ys<=y0
                    ys=y0+2*lsty;
                end                
            end
            model.rho(xs-1:xs+1,ys-1:ys+1,iU:iL)=Rt(istep);
        end
end
model.rho((mbak-0.3)<0.1)=mbak((mbak-0.3)<0.1);
model.rho(end,end,end)=model.rho(end,end,end-1)+1;
d3_view(hObject,eventdata,h);
return

