function plot_resp4(hObject,eventdata,suffix,f)
% plot data/response/residual files for MT sites used in inversions
% in a format of "LON LAT Data_A Data_B Resp_A Resp_B Residual_A Residual_B" 
% to be used with external programs to plot... (probably GMT)
global nsite xyz data resp
xyv=zeros(nsite,8);
xyv(:,1:3)=xyz; % array to store X Y and responses
% errorfloor=0.05;
% first try to determine the size of the grid
xmin=min(xyz(:,1));
xmax=max(xyz(:,1));
ymin=min(xyz(:,2));
ymax=max(xyz(:,2));
width=ymax-ymin;
height=xmax-xmin;
% now we have the dimension of the display area
% try to give a reasonable discretization
ratio=width/height;
ndh=round(sqrt(nsite/ratio));
ndw=round(ratio*ndh);
ndh=2*ndh+1;
ndw=2*ndw+1;
dx=height/(ndh-1);
dy=width/(ndw-1);
xi=linspace(xmin,xmax,ndh);
yi=linspace(ymin,ymax,ndw);
xi(end+1)=xi(end)+dx;
yi(end+1)=yi(end)+dy;
[yi,xi] = meshgrid(yi,xi);
figure('numbertitle','off','name',suffix)
for opt=1:4
for isite=1:nsite
    zxxr=data(isite).tf(f,1);
    zxxi=-data(isite).tf(f,2);
    zxyr=data(isite).tf(f,4);
    zxyi=-data(isite).tf(f,5);
    zyxr=data(isite).tf(f,7);
    zyxi=-data(isite).tf(f,8);
    zyyr=data(isite).tf(f,10);
    zyyi=-data(isite).tf(f,11);
    rxxr=resp(isite).tf(f,1);
    rxxi=-resp(isite).tf(f,2);
    rxyr=resp(isite).tf(f,4);
    rxyi=-resp(isite).tf(f,5);
    ryxr=resp(isite).tf(f,7);
    ryxi=-resp(isite).tf(f,8);
    ryyr=resp(isite).tf(f,10);
    ryyi=-resp(isite).tf(f,11);
    freq=1./data(isite).freq(f);
    switch opt
        case 1 %xx
            modestr='ZXX';

            Va1=zxxr;
            Vb1=zxxi;
            Va2=rxxr;
            Vb2=rxxi;
        case 2 %xy
            modestr='ZXY';

            Va1=zxyr;
            Vb1=zxyi;
            Va2=rxyr;
            Vb2=rxyi;     
        case 3 %yx
            modestr='ZYX';

            Va1=zyxr;
            Vb1=zyxi;
            Va2=ryxr;
            Vb2=ryxi;             
        case 4 %yx
            modestr='ZYY';

            Va1=zyyr;
            Vb1=zyyi;
            Va2=ryyr;
            Vb2=ryyi;                       
        otherwise
            errormsg=['specified mode ' num2str(opt) ' cannot be recognized...'];
            errordlg(errormsg,'Mode error');
            return
    end
    xyv(isite,3)=Va1;
    xyv(isite,4)=Vb1;
    xyv(isite,5)=Va2;
    xyv(isite,6)=Vb2;
end
% try to grid data 
[za1]=griddata(xyv(:,2),xyv(:,1),xyv(:,3),yi-dy/2,xi-dx/2,'nearest');
[zb1]=griddata(xyv(:,2),xyv(:,1),xyv(:,4),yi-dy/2,xi-dx/2,'nearest');
[za2]=griddata(xyv(:,2),xyv(:,1),xyv(:,5),yi-dy/2,xi-dx/2,'nearest');
[zb2]=griddata(xyv(:,2),xyv(:,1),xyv(:,6),yi-dy/2,xi-dx/2,'nearest');
X=linspace(xmin,xmax,ndh+1);
Y=linspace(ymin,ymax,ndw+1);
[YI,XI] = meshgrid(Y,X);

ZA1 = interp2(yi,xi,za1,YI,XI);
ZB1 = interp2(yi,xi,zb1,YI,XI);
ZA2 = interp2(yi,xi,za2,YI,XI);
ZB2 = interp2(yi,xi,zb2,YI,XI);

% start ploting data and responses
% =======================================================================%
subplot(4,4,(opt-1)*4+1)
picname = [modestr 'r observed'];
pcolor(YI,XI,ZA1);
title(picname);
daspect([1,1,1]);
shading flat
colormap(flipud(jet(32)));
h=colorbar;
temp1=caxis;
xlabel(h,'  Impd.(Ohm)');

subplot(4,4,(opt-1)*4+2)
picname = [modestr 'r response'];
pcolor(YI,XI,ZA2);
title(picname);
daspect([1,1,1]);
shading flat
h=colorbar;
caxis(temp1);
xlabel(h,'  Impd.(Ohm)');

% ======================================================================= %
subplot(4,4,(opt-1)*4+3)
picname=[modestr 'i observed'];
pcolor(YI,XI,ZB1);
title(picname);
daspect([1,1,1]);
shading flat
h=colorbar;
temp2=caxis;
xlabel(h,'  Impd.(Ohm)');

subplot(4,4,(opt-1)*4+4)
picname=[modestr 'i response'];
pcolor(YI,XI,ZB2);
title(picname);
daspect([1,1,1]);
shading flat
h=colorbar;
caxis(temp2);
xlabel(h,'  Impd.(Ohm)');

end
% set(gcf,'PaperPositionMode','auto')% print whole paper...
% print(gcf,'-dpng','-r96',picname);
%print(gcf,'-depsc2','-r150',picname);
return

