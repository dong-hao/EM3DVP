function data=calc_rhophs(data,convert)
% function to calculate rho and phase from impedance
% calculating apparent resistivities and phases (and the corresponding
% erros) from impadences.
% disp('start calculating apparent resistivity')

if nargin < 2
    convert = 1;
end
freq=data.freq;
nfreq=data.nfreq;
%angle=str2double(get(h.rotatebox(1),'string'));
TF=data.tf;
data.rho=zeros(nfreq,8);
data.phs=zeros(nfreq,8);
zxxr=TF(1:nfreq,1)*convert;
zxxi=TF(1:nfreq,2)*convert;
dzxx=TF(1:nfreq,3)*convert;
zxyr=TF(1:nfreq,4)*convert;
zxyi=TF(1:nfreq,5)*convert;
dzxy=TF(1:nfreq,6)*convert;
zyxr=TF(1:nfreq,7)*convert;
zyxi=TF(1:nfreq,8)*convert;
dzyx=TF(1:nfreq,9)*convert;
zyyr=TF(1:nfreq,10)*convert;
zyyi=TF(1:nfreq,11)*convert;
dzyy=TF(1:nfreq,12)*convert;
%=========calculate rho and phase from data=======%
% please note that the errorbars of resistivities and phases here are
% calculated using Gary Egbert's formula in Z files.
rhoxx=(zxxr.^2+zxxi.^2)./freq./5;
phsxx=atan2(zxxi,zxxr);
% this is now standard deviation
rhoxxe=1.4142*(zxxr.^2+zxxi.^2).^0.5.*dzxx./freq/5;
phsxxe=abs(asin(dzxx./(zxxr.^2+zxxi.^2).^0.5/1.4142));
rhoyy=(zyyr.^2+zyyi.^2)./freq./5;
phsyy=atan2(zyyi,zyyr);
% this is now standard deviation
rhoyye=1.4142*(zyyr.^2+zyyi.^2).^0.5.*dzyy./freq/5;
phsyye=abs(asin(dzyy./(zyyr.^2+zyyi.^2).^0.5/1.4142));
%=========calculate rho and phase from data=======%
rhoxy=(zxyr.^2+zxyi.^2)./freq./5;
phsxy=atan2(zxyi,zxyr);
% this is now standard deviation
rhoxye=1.4142*(zxyr.^2+zxyi.^2).^0.5.*dzxy./freq/5;% 2*mu_0*|Zij|*dZij/omega;
phsxye=abs(asin(dzxy./(zxyr.^2+zxyi.^2).^0.5/1.4142));% asin(Zij/|Zij|); 
rhoyx=(zyxr.^2+zyxi.^2)./freq./5;
phsyx=atan2(zyxi,zyxr);
% this is now standard deviation
rhoyxe=1.4142*(zyxr.^2+zyxi.^2).^0.5.*dzyx./freq/5;
phsyxe=abs(asin(dzyx./(zyxr.^2+zyxi.^2).^0.5/1.4142));
data.rho(:,1)=rhoxx;
data.rho(:,2)=rhoxxe;
data.rho(:,3)=rhoxy;
data.rho(:,4)=rhoxye;
data.rho(:,5)=rhoyx;
data.rho(:,6)=rhoyxe;
data.rho(:,7)=rhoyy;
data.rho(:,8)=rhoyye;
data.phs(:,1)=phsxx;
data.phs(:,2)=phsxxe;
data.phs(:,3)=phsxy;
data.phs(:,4)=phsxye;
data.phs(:,5)=phsyx;
data.phs(:,6)=phsyxe;
data.phs(:,7)=phsyy;
data.phs(:,8)=phsyye;
return