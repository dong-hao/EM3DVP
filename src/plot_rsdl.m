function plot_rsdl(hObject,eventdata,suffix,f, opt)
% plot data/response/residual files for MT sites used in inversions
% in a format of "LON LAT Data_A Data_B Resp_A Resp_B Residual_A Residual_B" 
% to be used with external programs to plot... (probably GMT)
global nsite xyz data resp
xyv=zeros(nsite,8);
xyv(:,1:3)=xyz; % array to store X Y and responses
% errorfloor=0.05;
for isite=1:nsite
    if (~isfield(data(isite), 'rho')) 
        data(isite)=calc_rhophs(data(isite),1);
    end
    if (~isfield(resp(isite), 'rho')) 
        resp(isite)=calc_rhophs(resp(isite),1);
    end
    switch opt
        case 1 %xx
            Va1=data(isite).rho(f,1);
            Vb1=data(isite).phs(f,1);
            Va2=resp(isite).rho(f,1);
            Vb2=resp(isite).phs(f,1);
        case 2 %yy
            Va1=data(isite).rho(f,7);
            Vb1=data(isite).phs(f,7);
            Va2=resp(isite).rho(f,7);
            Vb2=resp(isite).phs(f,7);
        case 3 %xy
            Va1=data(isite).rho(f,3);
            Vb1=data(isite).phs(f,3);
            Va2=resp(isite).rho(f,3);
            Vb2=resp(isite).phs(f,3);
        case 4 %yx
            Va1=data(isite).rho(f,5);
            Vb1=data(isite).phs(f,5);
            Va2=resp(isite).rho(f,5);
            Vb2=resp(isite).phs(f,5);
        case 5 %tx
            Va1=data(isite).tf(f,13);
            Vb1=data(isite).tf(f,14);
            Va2=resp(isite).tf(f,13);
            Vb2=resp(isite).tf(f,14);
        case 6 %ty
            Va1=data(isite).tf(f,16);
            Vb1=data(isite).tf(f,17);  
            Va2=resp(isite).tf(f,16);
            Vb2=resp(isite).tf(f,17);
        otherwise
            errormsg=['specified mode ' num2str(opt) ' cannot be recognized...'];
            errordlg(errormsg,'Mode error');
            return
    end
    if (opt <5) 
        Va1=log10(Va1);
        Va2=log10(Va2);
        Vb1=Vb1/pi*180;
        Vb2=Vb2/pi*180;        
    end
    Var=(Va1-Va2);
    Vbr=(Vb1-Vb2);
    xyv(isite,3)=Va1;
    xyv(isite,4)=Vb1;
    xyv(isite,5)=Va2;
    xyv(isite,6)=Vb2;
    xyv(isite,7)=Var;
    xyv(isite,8)=Vbr;
%     if Ve > 1E3
%        xyv(isite,[3 4 7 8]) =NaN; 
%     end        
end
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
ndh=3*ndh+1;
ndw=3*ndw+1;
dx=height/(ndh-1);
dy=width/(ndw-1);
xi=linspace(xmin,xmax,ndh);
yi=linspace(ymin,ymax,ndw);
xi(end+1)=xi(end)+dx;
yi(end+1)=yi(end)+dy;
[yi,xi] = meshgrid(yi,xi);
% try to grid data 
[za1]=griddata(xyv(:,2),xyv(:,1),xyv(:,3),yi-dy/2,xi-dx/2,'nearest');
[zb1]=griddata(xyv(:,2),xyv(:,1),xyv(:,4),yi-dy/2,xi-dx/2,'nearest');
[za2]=griddata(xyv(:,2),xyv(:,1),xyv(:,5),yi-dy/2,xi-dx/2,'nearest');
[zb2]=griddata(xyv(:,2),xyv(:,1),xyv(:,6),yi-dy/2,xi-dx/2,'nearest');
[zar]=griddata(xyv(:,2),xyv(:,1),xyv(:,7),yi-dy/2,xi-dx/2,'nearest');
[zbr]=griddata(xyv(:,2),xyv(:,1),xyv(:,8),yi-dy/2,xi-dx/2,'nearest');
X=linspace(xmin,xmax,ndh+1);
Y=linspace(ymin,ymax,ndw+1);
[YI,XI] = meshgrid(Y,X);

ZA1 = interp2(yi,xi,za1,YI,XI);
ZB1 = interp2(yi,xi,zb1,YI,XI);
ZA2 = interp2(yi,xi,za2,YI,XI);
ZB2 = interp2(yi,xi,zb2,YI,XI);
ZAr = interp2(yi,xi,zar,YI,XI);
ZBr = interp2(yi,xi,zbr,YI,XI);

% make a red to green colorbar
rgmap=[    1       0       0; 1       0.0667  0.0667; 1       0.1333  0.1333;...
    1       0.2000  0.2000; 1       0.2667  0.2667; 1       0.3333  0.3333;...
    1       0.4000  0.4000; 1       0.4667  0.4667; 1       0.5333  0.5333;...
    1       0.6000  0.6000; 1       0.6667  0.6667; 1       0.7333  0.7333;...
    1       0.8000  0.8000; 1       0.8667  0.8667; 1       0.9333  0.9333;...
    1       1       1;  1       1       1;...
    0.9333  1       0.9333;  0.8667  1       0.8667;...
    0.8000  1       0.8000; 0.7333  1       0.7333; 0.6667  1       0.6667;...
    0.6000  1       0.6000; 0.5333  1       0.5333; 0.4667  1       0.4667;...
    0.4000  1       0.4000; 0.3333  1       0.3333; 0.2667  1       0.2667;...
    0.2000  1       0.2000; 0.1333  1       0.1333; 0.0667  1       0.0667;...
    0       1       0   ];

% start ploting data, responses, and residuals
% ======================================================================= %

picname = ['a-res observed' suffix];
figure('numbertitle','off','name', picname);
pcolor(YI,XI,ZA1);
title(picname);
daspect([1,1,1]);
shading flat
colormap(flipud(jet(32)));
h=colorbar('ver',...
          'YTick',[0,0.5,1,1.5,2,2.5,3,3.5],...
          'YTickLabel',{'1','3','10','30','100','300','1000','3000'});
xlabel(h,'Res.(\Omegam)');
caxis([0,3.5]);
set(gcf,'PaperPositionMode','auto')% print whole paper...
% print(gcf,'-dpng','-r96',picname);
print(gcf,'-depsc2','-r150',picname);
% ======================================================================= %
picname=['phase observed' suffix];
figure('numbertitle','off','name', picname);
pcolor(YI,XI,ZB1);
title(picname);
daspect([1,1,1]);
shading flat
colormap(jet(32));
caxis([0,90]);
h=colorbar('ver',...
          'YTick',[0, 15, 30, 45, 60, 75, 90],...
          'YTickLabel',{'0','15','30','45','60','75','90'});
xlabel(h,'Phase (degree)');
set(gcf,'PaperPositionMode','auto')% print whole paper...
% print(gcf,'-dpng','-r96',picname);
print(gcf,'-depsc2','-r150',picname);
% ======================================================================= %
picname=['a-res response' suffix];
figure('numbertitle','off','name', picname);
pcolor(YI,XI,ZA2);
title(picname);
daspect([1,1,1]);
shading flat
caxis([0,3.5]);
colormap(flipud(jet(32)));
h=colorbar('ver',...
          'YTick',[0,0.5,1,1.5,2,2.5,3,3.5],...
          'YTickLabel',{'1','3','10','30','100','300','1000','3000'});
      
xlabel(h,'Res.(\Omegam)');
set(gcf,'PaperPositionMode','auto')% print whole paper...
% print(gcf,'-dpng','-r96',picname);
print(gcf,'-depsc2','-r150',picname);
% ======================================================================= %
picname=['phase response' suffix];
figure('numbertitle','off','name', picname);
pcolor(YI,XI,ZB2);
title(picname);
daspect([1,1,1]);
shading flat
colormap(jet(32));
caxis([0,90]);
h=colorbar('ver',...
          'YTick',[0, 15, 30, 45, 60, 75, 90],...
          'YTickLabel',{'0','15','30','45','60','75','90'});
xlabel(h,'Phase (degree)');
set(gcf,'PaperPositionMode','auto')% print whole paper...
% print(gcf,'-dpng','-r96',picname);
print(gcf,'-depsc2','-r150',picname);
% ======================================================================= %
picname=['a-res residual' suffix];
figure('numbertitle','off','name',picname);
pcolor(YI,XI,ZAr);
title(picname);
daspect([1,1,1]);
shading flat
colormap(rgmap);
caxis([-1,1]);
h=colorbar('ver',...
          'YTick',[-1, -0.75, -0.5, -0.25,  0, 0.25, 0.5, 0.75,  1],...
          'YTickLabel',{'-1','-0.75','-0.5','-0.25','0','0.25','0.5','0.75','1'});
xlabel(h,'Resid.(log_1_0 \Omegam)');
set(gcf,'PaperPositionMode','auto')% print whole paper...
% print(gcf,'-dpng','-r96',picname);
% print(gcf,'-depsc2','-r150',picname);
% ======================================================================= %
picname=['phase residual' suffix];
figure('numbertitle','off','name', picname);
pcolor(YI,XI,ZBr);
title(picname);
daspect([1,1,1]);
shading flat
colormap(rgmap);
caxis([-45,45]);
h=colorbar('ver',...
          'YTick',[-45, -30, -15, 0, 15, 30, 45],...
          'YTickLabel',{'-45','-30','-15','0','15','30','45'});
xlabel(h,'Resid.(degree)');
set(gcf,'PaperPositionMode','auto')% print whole paper...
% print(gcf,'-dpng','-r96',picname);
% print(gcf,'-depsc2','-r150',picname);
return

