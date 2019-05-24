function data=calc_rhophs(data,convert)
% function to calculate rho and phase from impedance
% calculating apparent resistivities and phases from impadences.
%disp('start calculating apparent resistivity')
% data
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
zxxvar=TF(1:nfreq,3)*convert;
zxyr=TF(1:nfreq,4)*convert;
zxyi=TF(1:nfreq,5)*convert;
zxyvar=TF(1:nfreq,6)*convert;
zyxr=TF(1:nfreq,7)*convert;
zyxi=TF(1:nfreq,8)*convert;
zyxvar=TF(1:nfreq,9)*convert;
zyyr=TF(1:nfreq,10)*convert;
zyyi=TF(1:nfreq,11)*convert;
zyyvar=TF(1:nfreq,12)*convert;
%=========calculate rho and phase from data=======%
% please note that the errorbars of resistivities and phases here are
% calculated using Gary Egbert's formula in Z files.
rhoxx=(zxxr.^2+zxxi.^2)./freq./5;
phsxx=atan2(zxxi,zxxr);
rhoxxe=sqrt(zxxvar.^2./freq.*rhoxx*2/5);
phsxxe=sqrt(zxxvar.^2/2./(zxxr.^2+zxxi.^2).^0.5);
rhoyy=(zyyr.^2+zyyi.^2)./freq./5;
phsyy=atan2(zyyi,zyyr);
rhoyye=sqrt(zyyvar.^2./freq.*rhoyy*2/5);
phsyye=sqrt(zyyvar.^2/2./(zyyr.^2+zyyi.^2).^0.5);
%=========calculate rho and phase from data=======%
rhoxy=(zxyr.^2+zxyi.^2)./freq./5;
phsxy=atan(zxyi./zxyr);
rhoxye=sqrt(zxyvar.^2./freq.*rhoxy*2/5);
phsxye=sqrt(zxyvar.^2/2./(zxyr.^2+zxyi.^2).^0.5);
rhoyx=(zyxr.^2+zyxi.^2)./freq./5;
phsyx=atan(zyxi./zyxr)-pi;
rhoyxe=sqrt(zyxvar.^2./freq.*rhoyx*2/5);
phsyxe=sqrt(zyxvar.^2/2./(zyxr.^2+zyxi.^2).^0.5);
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