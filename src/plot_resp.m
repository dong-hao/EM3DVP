%{
function plot_resp(hObject,eventdata,handle,opt)
global data resp custom 
switch nargin
    case 2
        error('must specify a handle to the object')
    case 3
        opt='xyyx';
    case 4
        if ~any(strcmp(opt,{'xxyy','xyyx','txty'}))
            error(['given argument ''' opt ''' is an unknown command option.'])
        end
end
flagresp=get(handle.editbox(1),'value');
flagerrorbar=get(handle.editbox(2),'value');
% flagmask=get(handle.editbox(3),'value');
isite=custom.currentsite;
% load original data 
zxxr=data(isite).z_o(:,1);
zxxi=data(isite).z_o(:,2);
zxxvar=data(isite).z_o(:,3);
zxyr=data(isite).z_o(:,4);
zxyi=data(isite).z_o(:,5);
zxyvar=data(isite).z_o(:,6);
zyxr=data(isite).z_o(:,7);
zyxi=data(isite).z_o(:,8);
zyxvar=data(isite).z_o(:,9);
zyyr=data(isite).z_o(:,10);
zyyi=data(isite).z_o(:,11);
zyyvar=data(isite).z_o(:,12);
txr=data(isite).z_o(:,13);
txi=data(isite).z_o(:,14);
txvar=data(isite).z_o(:,15);
tyr=data(isite).z_o(:,16);
tyi=data(isite).z_o(:,17);
tyvar=data(isite).z_o(:,18);
nfreq=data(isite).nfreq_o;
freq=1./data(isite).freq_o;
if flagresp==1
    %load response
    rxxr=resp(isite).z_o(:,1);
    rxxi=resp(isite).z_o(:,2);
    rxyr=resp(isite).z_o(:,4);
    rxyi=resp(isite).z_o(:,5);
    ryxr=resp(isite).z_o(:,7);
    ryxi=resp(isite).z_o(:,8);
    ryyr=resp(isite).z_o(:,10);
    ryyi=resp(isite).z_o(:,11);
    rtxr=resp(isite).z_o(:,13);
    rtxi=resp(isite).z_o(:,14);
    rtyr=resp(isite).z_o(:,16);
    rtyi=resp(isite).z_o(:,17);
    rfreq=1./resp(isite).freq_o;
end
% zxxr=data(isite).z(:,1);
% zxxi=data(isite).z(:,2);
% zxxvar=data(isite).z(:,3);
% zxyr=data(isite).z(:,4);
% zxyi=data(isite).z(:,5);
% zxyvar=data(isite).z(:,6);
% zyxr=data(isite).z(:,7);
% zyxi=data(isite).z(:,8);
% zyxvar=data(isite).z(:,9);
% zyyr=data(isite).z(:,10);
% zyyi=data(isite).z(:,11);
% zyyvar=data(isite).z(:,12);
% txr=data(isite).z(:,13);
% txi=data(isite).z(:,14);
% txvar=data(isite).z(:,15);
% tyr=data(isite).z(:,16);
% tyi=data(isite).z(:,17);
% tyvar=data(isite).z(:,18);
% nfreq=data(isite).nfreq_o;
% freq=1./data(isite).freq_o;
% if flagresp==1
%     %load response
%     rxxr=resp(isite).z(:,1);
%     rxxi=resp(isite).z(:,2);
%     rxyr=resp(isite).z(:,4);
%     rxyi=resp(isite).z(:,5);
%     ryxr=resp(isite).z(:,7);
%     ryxi=resp(isite).z(:,8);
%     ryyr=resp(isite).z(:,10);
%     ryyi=resp(isite).z(:,11);
%     rtxr=resp(isite).z(:,13);
%     rtxi=resp(isite).z(:,14);
%     rtyr=resp(isite).z(:,16);
%     rtyi=resp(isite).z(:,17);
%     rfreq=1./resp(isite).freq;
% end
switch opt
    case 'xxyy'
        %=========calculate rho and phase from data=======%
        %please note that the errorbars of resistivities and phases here are
        %calculated using Gary Egbert's formula in Z files.        
        rhoxx=(zxxr.^2+zxxi.^2)./freq./5;
        phsxx=atan(zxxi./zxxr)*180/pi;
        for kki=1:nfreq
            if zxxi(kki)>0 && zxxr(kki)>0
                %phsxx
            elseif zxxi(kki)>0 && zxxr(kki)<0
                phsxx(kki)=phsxx(kki)+180;
            elseif zxxi(kki)<0 && zxxr(kki)>0
                %phsxx
            elseif zxxi(kki)<0 && zxxr(kki)<0
                phsxx(kki)=phsxx(kki)-180;
            end
        end
        rhoxxe=2*zxxvar./((zxxr.^2+zxxi.^2).^0.5);
        phsxxe=zxxvar./((zxxr.^2+zxxi.^2).^0.5);
        rhoxx=log10(rhoxx);
%        rhoxxe=rhoxxe.*rhoxx.*0.4343;
        phsxxe=phsxxe*180/pi;
        rhoyy=(zyyr.^2+zyyi.^2)./freq./5;
        phsyy=atan(zyyi./zyyr)*180/pi;
        for kki=1:nfreq
           if zyyi(kki)>0 && zyyr(kki)>0
                %phsyy
           elseif zyyi(kki)>0 && zyyr(kki)<0
                phsyy(kki)=phsyy(kki)+180;
           elseif zyyi(kki)<0 && zyyr(kki)>0
                %phsyy
           elseif zyyi(kki)<0 && zyyr(kki)<0
                   phsyy(kki)=phsyy(kki)-180;
           end
        end
        rhoyye=2*zyyvar./((zyyr.^2+zyyi.^2).^0.5);
        phsyye=zyyvar./((zyyr.^2+zyyi.^2).^0.5);
        rhoyy=log10(rhoyy); 
        phsyye=phsyye*180/pi;         
        minrho=min(min(rhoxx),min(rhoyy));
        minrho=floor(minrho-0.5);
        maxrho=max(max(rhoxx),max(rhoyy));
        maxrho=round(maxrho+1);
        %=========calculate rho and phase from resp=======%
        if flagresp==1
        rhorxx=(rxxr.^2+rxxi.^2)./rfreq./5;
        phsrxx=atan(rxxi./rxxr)*180/pi;
        for kki=1:nfreq
           if rxxi(kki)>0 && rxxr(kki)>0
               %phsrxx
           elseif rxxi(kki)>0 && rxxr(kki)<0
                phsrxx(kki)=phsrxx(kki)+180;
           elseif rxxi(kki)<0 && rxxr(kki)>0
                %phsrxx
           elseif rxxi(kki)<0 && rxxr(kki)<0
                phsrxx(kki)=phsrxx(kki)-180;
           end
        end
        rhorxx=log10(rhorxx);
        rhoryy=(ryyr.^2+ryyi.^2)./rfreq./5;
        phsryy=atan(ryyi./ryyr)*180/pi;
        for kki=1:nfreq
            if ryyi(kki)>0 && ryyr(kki)>0
                %phsyy
            elseif ryyi(kki)>0 && ryyr(kki)<0
                phsryy(kki)=phsryy(kki)+180;
            elseif ryyi(kki)<0 && ryyr(kki)>0
                %phsryy            
            elseif ryyi(kki)<0 && ryyr(kki)<0
                phsryy(kki)=phsryy(kki)-180;
            end
        end
        rhoryy=log10(rhoryy);  
        minrrho=min(min(rhorxx),min(rhoryy));
        minrrho=floor(minrrho-0.5);
        maxrrho=max(max(rhorxx),max(rhoryy));
        maxrrho=round(maxrrho+1);
        %==========determine axes limits========%
        maxrho=max(maxrho,maxrrho);
        minrho=min(minrho,minrrho);
        end
        %==========now start ploting============%
        if flagerrorbar~=0            
            errorbar(handle.axis(1),freq,rhoxx,rhoxxe,'r^');
            errorbar(handle.axis(2),freq,phsxx,phsxxe,'r^');
        else
            plot(handle.axis(1),freq,rhoxx,'r^');
            plot(handle.axis(2),freq,phsxx,'r^');
        end
        hold(handle.axis(1),'on');
        hold(handle.axis(2),'on');
        if flagerrorbar~=0
            errorbar(handle.axis(1),freq,rhoyy,rhoyye,'bo');
            errorbar(handle.axis(2),freq,phsyy,phsyye,'bo');
        else
            plot(handle.axis(1),freq,rhoyy,'bo');
            plot(handle.axis(2),freq,phsyy,'bo');
        end
        if flagresp==1
        plot(handle.axis(1),rfreq,rhorxx,'r');
        plot(handle.axis(2),rfreq,phsrxx,'r');
        plot(handle.axis(1),rfreq,rhoryy,'b');
        plot(handle.axis(2),rfreq,phsryy,'b');
        end
        %==========a little setup===============%        
        legend(handle.axis(1),'xx apparent resistivity','yy apparent resistivity',...
            'location','NorthWest')
        legend(handle.axis(2),'xx phase','yy phase',...
            'location','NorthWest')
        hold(handle.axis(1),'off');
        hold(handle.axis(2),'off');
    case 'xyyx'
        %=========calculate rho and phase from data=======%
        rhoxy=(zxyr.^2+zxyi.^2)./freq./5;
        phsxy=atan(zxyi./zxyr)*180/pi;
%         for kki=1:nfreq
%             if zxyi(kki)>0 && zxyr(kki)>0
%                 %phsxy
%             elseif zxyi(kki)<0 && zxyr(kki)<0
%                 phsxy(kki)=phsxy(kki)-180;
%             end
%         end
        rhoxye=2*zxyvar./((zxyr.^2+zxyi.^2).^0.5);
        phsxye=zxyvar./((zxyr.^2+zxyi.^2).^0.5);
        rhoxy=log10(rhoxy);
        rhoxye=rhoxye.*rhoxy.*0.4343;
        phsxye=phsxye*180/pi; 
        rhoyx=(zyxr.^2+zyxi.^2)./freq./5;
        phsyx=atan(zyxi./zyxr)*180/pi;
%         for kki=1:nfreq
%             if zyxi(kki)>0 && zyxr(kki)>0
%                 %phsyx
%             elseif zyxi(kki)<0 && zyxr(kki)<0
%                 phsyx(kki)=phsyx(kki)-180;
%             end
%         end
        rhoyxe=2*zyxvar./((zyxr.^2+zyxi.^2).^0.5);
        phsyxe=zyxvar./((zyxr.^2+zyxi.^2).^0.5);
        rhoyx=log10(rhoyx);
        rhoyxe=rhoyxe.*rhoyx.*0.4343;
        phsyxe=phsyxe.*180/pi; 
        minrho=min(min(rhoyx),min(rhoxy));
        minrho=floor(minrho-0.5);
        maxrho=max(max(rhoyx),max(rhoxy));
        maxrho=round(maxrho+1);
        %=========calculate rho and phase from resp=======%
        if flagresp==1
        rhorxy=(rxyr.^2+rxyi.^2)./rfreq./5;
        phsrxy=atan(rxyi./rxyr)*180/pi;
%         for kki=1:nfreq
%             if rxyi(kki)>0 && rxyr(kki)>0
%                 %phsxy
%             elseif zxyi(kki)<0 && zxyr(kki)<0
%                 phsrxy(kki)=phsrxy(kki)-180;
%             end
%         end
        rhorxy=log10(rhorxy);
        rhoryx=(ryxr.^2+ryxi.^2)./rfreq./5;
        phsryx=atan(ryxi./ryxr)*180/pi;
%         for kki=1:nfreq
%             if ryxi(kki)>0 && ryxr(kki)>0
%                 %phsyx
%             elseif ryxi(kki)<0 && ryxr(kki)<0
%                 phsryx(kki)=phsryx(kki)-180;
%             end
%         end
        rhoryx=log10(rhoryx);  
        minrrho=min(min(rhorxy),min(rhoryx));
        minrrho=floor(minrrho-0.5);
        maxrrho=max(max(rhorxy),max(rhoryx));
        maxrrho=round(maxrrho+1);
        %==========determine axes limits========%
        maxrho=max(maxrho,maxrrho);
        minrho=min(minrho,minrrho);
        end
        %==========now start ploting============%
        if flagerrorbar~=0
            errorbar(handle.axis(1),freq,rhoxy,rhoxye,'r^');
            errorbar(handle.axis(2),freq,phsxy,phsxye,'r^');
        else
            plot(handle.axis(1),freq,rhoxy,'r^');
            plot(handle.axis(2),freq,phsxy,'r^');
        end
        hold(handle.axis(1),'on');
        hold(handle.axis(2),'on');
        if flagerrorbar~=0
            errorbar(handle.axis(1),freq,rhoyx,rhoyxe,'bo');
            errorbar(handle.axis(2),freq,phsyx,phsyxe,'bo');
        else
            plot(handle.axis(1),freq,rhoyx,'bo');
            plot(handle.axis(2),freq,phsyx,'bo');
        end

        if flagresp==1
            plot(handle.axis(1),rfreq,rhorxy,'r');
            plot(handle.axis(2),rfreq,phsrxy,'r');
            plot(handle.axis(1),rfreq,rhoryx,'b');
            plot(handle.axis(2),rfreq,phsryx,'b');
        end
        %==========a little setup===============%
        legend(handle.axis(1),'xy apparent resistivity','yx apparent resistivity',...
            'location','NorthWest')
        legend(handle.axis(2),'xy phase','yx phase',...
            'location','NorthWest')
        hold(handle.axis(1),'off');
        hold(handle.axis(2),'off');
 case 'txty'
        %=========calculate rho and phase from data=======%
        rhoxy=txr;
        phsxy=txi;
        rhoxye=txvar.^0.5.*cos(atan2(txi,txr));
        phsxye=txvar.^0.5.*sin(atan2(txi,txr));
        rhoyx=tyr;
        phsyx=tyi;

        rhoyxe=tyvar.^0.5.*cos(atan2(tyi,tyr));
        phsyxe=tyvar.^0.5.*sin(atan2(tyi,tyr));
        minrho=min(min(rhoyx),min(rhoxy));
        minrho=floor(minrho-0.1);
        maxrho=max(max(rhoyx),max(rhoxy));
        maxrho=round(maxrho+0.1);
        %=========calculate rho and phase from resp=======%
        if flagresp==1
        rhorxy=rtxr;
        phsrxy=rtxi;
        rhoryx=rtyr;
        phsryx=rtyi;

        minrrho=min(min(rhorxy),min(rhoryx));
        minrrho=floor(minrrho-0.1);
        maxrrho=max(max(rhorxy),max(rhoryx));
        maxrrho=round(maxrrho+1);
        %==========determine axes limits========%
        maxrho=max(maxrho,maxrrho);
        minrho=min(minrho,minrrho);
        end
        %==========now start ploting============%
        if flagerrorbar~=0
            errorbar(handle.axis(1),freq,rhoxy,rhoxye,'r^');
            errorbar(handle.axis(2),freq,phsxy,phsxye,'r^');
        else
            plot(handle.axis(1),freq,rhoxy,'r^');
            plot(handle.axis(2),freq,phsxy,'r^');
        end
        hold(handle.axis(1),'on');
        hold(handle.axis(2),'on');
        if flagerrorbar~=0
            errorbar(handle.axis(1),freq,rhoyx,rhoyxe,'bo');
            errorbar(handle.axis(2),freq,phsyx,phsyxe,'bo');
        else
            plot(handle.axis(1),freq,rhoyx,'bo');
            plot(handle.axis(2),freq,phsyx,'bo');
        end
        if flagresp==1
            plot(handle.axis(1),rfreq,rhorxy,'r');
            plot(handle.axis(2),rfreq,phsrxy,'r');
            plot(handle.axis(1),rfreq,rhoryx,'b');
            plot(handle.axis(2),rfreq,phsryx,'b');
        end
        %==========a little setup===============%
        legend(handle.axis(1),'Tx real tippers','Ty real tippers')
        legend(handle.axis(2),'Tx imag','Ty imag')
        hold(handle.axis(1),'off');
        hold(handle.axis(2),'off');
end
set(handle.axis(1),'ylim',[minrho maxrho])
set(handle.axis(1),'xlim',[min(freq)/3,max(freq)*3])
set(handle.axis(2),'xlim',[min(freq)/3,max(freq)*3])
set(handle.axis(1),'Xdir','reverse');
set(handle.axis(2),'Xdir','reverse');
set(handle.axis(1),'xscale','log');
set(handle.axis(2),'xscale','log');
grid(handle.axis(1),'on');
grid(handle.axis(2),'on');
if strcmp(opt,'txty') 
    ylabel(handle.axis(1),'Tippers(Re.)')
    ylabel(handle.axis(2),'Tippers(Imag.)')
    set(handle.axis(2),'ylim',[minrho maxrho])
elseif strcmp(opt,'xyyx')
    ylabel(handle.axis(1),'log_{10}apparent resistivity (\Omegam)')
    ylabel(handle.axis(2),'phase(degree)')
    set(handle.axis(2),'yaxislocation','left','ylim',[0 90],'ytick',...
    [0 15 30 45 60 75 90]);
else
    ylabel(handle.axis(1),'log_{10}apparent resistivity (\Omegam)')
    ylabel(handle.axis(2),'phase(degree)')
    set(handle.axis(2),'yaxislocation','left','ylim',[-180 180],'ytick',...
    [-180 -135 -90 -45 0 45 90 135 180]);
end
xlabel(handle.axis(1),'Frequency (Hz)')
xlabel(handle.axis(2),'Frequency (Hz)')
ifreq=1:length(freq);
disp(['rms=' num2str(calc_rms(isite, ifreq, opt))]);
return
%}
function plot_resp(hObject,eventdata,handle,opt)
global data resp custom 
switch nargin
    case 2
        error('must specify a handle to the object')
    case 3
        opt='xyyx';
    case 4
        if ~any(strcmp(opt,{'xxyy','xyyx','txty'}))
            error(['given argument ''' opt ''' is an unknown command option.'])
        end
end
flagresp=get(handle.editbox(1),'value');
flagerrorbar=get(handle.editbox(2),'value');
% flagmask=get(handle.editbox(3),'value');
isite=custom.currentsite;
% load original data 
freq = data(isite).freq;
rhoxx=data(isite).rho(:,1);
rhoxxe=data(isite).rho(:,2);
rhoxy=data(isite).rho(:,3);
rhoxye=data(isite).rho(:,4);
rhoyx=data(isite).rho(:,5);
rhoyxe=data(isite).rho(:,6);
rhoyy=data(isite).rho(:,7);
rhoyye=data(isite).rho(:,8);
phsxx=data(isite).phs(:,1);
phsxxe=data(isite).phs(:,2);
phsxy=data(isite).phs(:,3);
phsxye=data(isite).phs(:,4);
phsyx=data(isite).phs(:,5);
phsyxe=data(isite).phs(:,6);
phsyy=data(isite).phs(:,7);
phsyye=data(isite).phs(:,8);
txr=data(isite).tf(:,13);
txi=data(isite).tf(:,14);
txvar=data(isite).tf(:,15);
tyr=data(isite).tf(:,16);
tyi=data(isite).tf(:,17);
tyvar=data(isite).tf(:,18);
if flagresp==1
    %load response
    rhorxx=resp(isite).rho(:,1);
    rhorxy=resp(isite).rho(:,3);
    rhoryx=resp(isite).rho(:,5);
    rhoryy=resp(isite).rho(:,7);
    phsrxx=resp(isite).phs(:,1);
    phsrxy=resp(isite).phs(:,3);
    phsryx=resp(isite).phs(:,5);
    phsryy=resp(isite).phs(:,7);
    rtxr=resp(isite).tf(:,13);
    rtxi=resp(isite).tf(:,14);
    rtyr=resp(isite).tf(:,16);
    rtyi=resp(isite).tf(:,17);
    rfreq=resp(isite).freq_o;
end
switch opt
    case 'xxyy'
        phsxxe=phsxxe*180/pi;
        phsxx=phsxx*180/pi;
        phsyye=phsyye*180/pi;
        phsyy=phsyy*180/pi;
        minrho=min(min(rhoxx),min(rhoyy));
        minrho=minrho/3;
        maxrho=max(max(rhoxx),max(rhoyy));
        maxrho=maxrho*3;
        if flagresp==1
            phsrxx=phsrxx*180/pi;
            phsryy=phsryy*180/pi;
            minrrho=min(min(rhorxx),min(rhoryy));
            minrrho=minrrho/3;
            maxrrho=max(max(rhorxx),max(rhoryy));
            maxrrho=maxrrho*3;
            %==========determine axes limits========%
            maxrho=max(maxrho,maxrrho);
            minrho=min(minrho,minrrho);
        end
        %==========now start ploting============%
        if flagerrorbar~=0            
            errorbar(handle.axis(1),freq,rhoxx,rhoxxe,'r^');
            errorbar(handle.axis(2),freq,phsxx,phsxxe/5,'r^');
        else
            plot(handle.axis(1),freq,rhoxx,'r^');
            plot(handle.axis(2),freq,phsxx,'r^');
        end
        hold(handle.axis(1),'on');
        hold(handle.axis(2),'on');
        if flagerrorbar~=0
            errorbar(handle.axis(1),freq,rhoyy,rhoyye,'bo');
            errorbar(handle.axis(2),freq,phsyy,phsyye/5,'bo');
        else
            plot(handle.axis(1),freq,rhoyy,'bo');
            plot(handle.axis(2),freq,phsyy,'bo');
        end
        if flagresp==1
            plot(handle.axis(1),rfreq,rhorxx,'r');
            plot(handle.axis(2),rfreq,phsrxx,'r');
            plot(handle.axis(1),rfreq,rhoryy,'b');
            plot(handle.axis(2),rfreq,phsryy,'b');
        end
        %==========a little setup===============%        
        legend(handle.axis(1),'xx apparent resistivity','yy apparent resistivity',...
            'location','NorthWest')
        legend(handle.axis(2),'xx phase','yy phase',...
            'location','NorthWest')
        hold(handle.axis(1),'off');
        hold(handle.axis(2),'off');
    case 'xyyx'
        phsxy=-phsxy*180/pi;
        phsxye=phsxye*180/pi; 
        phsyx=-phsyx*180/pi;
        phsyxe=phsyxe.*180/pi; 
        phsyx=phsyx-180;
        minrho=min(min(rhoxy),min(rhoyx));
        minrho=minrho/3;
        maxrho=max(max(rhoxy),max(rhoyx));
        maxrho=maxrho*3;
        if flagresp==1
            phsrxy=-phsrxy*180/pi;
            phsryx=-phsryx*180/pi;
            phsryx=phsryx-180;
            minrrho=min(min(rhorxy),min(rhoryx));
            minrrho=minrrho/3;
            maxrrho=max(max(rhorxy),max(rhoryx));
            maxrrho=maxrrho*3;
            %==========determine axes limits========%
            maxrho=max(maxrho,maxrrho);
            minrho=min(minrho,minrrho);
        end
        %==========now start ploting============%
        if flagerrorbar~=0
            errorbar(handle.axis(1),freq,rhoxy,rhoxye,'r^');
            errorbar(handle.axis(2),freq,phsxy,phsxye/5,'r^');
        else
            plot(handle.axis(1),freq,rhoxy,'r^');
            plot(handle.axis(2),freq,phsxy,'r^');
        end
        hold(handle.axis(1),'on');
        hold(handle.axis(2),'on');
        if flagerrorbar~=0
            errorbar(handle.axis(1),freq,rhoyx,rhoyxe,'bo');
            errorbar(handle.axis(2),freq,phsyx,phsyxe/5,'bo');
        else
            plot(handle.axis(1),freq,rhoyx,'bo');
            plot(handle.axis(2),freq,phsyx,'bo');
        end
        if flagresp==1
            plot(handle.axis(1),rfreq,rhorxy,'r');
            plot(handle.axis(2),rfreq,phsrxy,'r');
            plot(handle.axis(1),rfreq,rhoryx,'b');
            plot(handle.axis(2),rfreq,phsryx,'b');
        end
        %==========a little setup===============%
        legend(handle.axis(1),'xy apparent resistivity','yx apparent resistivity',...
            'location','NorthWest')
        legend(handle.axis(2),'xy phase','yx phase',...
            'location','NorthWest')
        hold(handle.axis(1),'off');
        hold(handle.axis(2),'off');
        set(handle.axis(1),'yscale','log');
 case 'txty'
        %=========calculate rho and phase from data=======%
        rhoxy=txr;
        phsxy=txi;
        rhoxye=txvar;
        phsxye=txvar;
        rhoyx=tyr;
        phsyx=tyi;
        rhoyxe=tyvar;
        phsyxe=tyvar;
        minrho=min(min(rhoyx),min(rhoxy));
        minrho=floor(minrho-0.1);
        maxrho=max(max(rhoyx),max(rhoxy));
        maxrho=round(maxrho+0.1);
        %=========calculate rho and phase from resp=======%
        if flagresp==1
        rhorxy=rtxr;
        phsrxy=rtxi;
        rhoryx=rtyr;
        phsryx=rtyi;
        minrrho=min(min(rhorxy),min(rhoryx));
        minrrho=minrrho/3;
        maxrrho=max(max(rhorxy),max(rhoryx));
        maxrrho=maxrrho*3;
        %==========determine axes limits========%
        maxrho=max(maxrho,maxrrho);
        minrho=min(minrho,minrrho);
        end
        %==========now start ploting============%
        if flagerrorbar~=0
            errorbar(handle.axis(1),freq,rhoxy,rhoxye,'r^');
            errorbar(handle.axis(2),freq,phsxy,phsxye,'r^');
        else
            plot(handle.axis(1),freq,rhoxy,'r^');
            plot(handle.axis(2),freq,phsxy,'r^');
        end
        hold(handle.axis(1),'on');
        hold(handle.axis(2),'on');
        if flagerrorbar~=0
            errorbar(handle.axis(1),freq,rhoyx,rhoyxe,'bo');
            errorbar(handle.axis(2),freq,phsyx,phsyxe,'bo');
        else
            plot(handle.axis(1),freq,rhoyx,'bo');
            plot(handle.axis(2),freq,phsyx,'bo');
        end
        if flagresp==1
            plot(handle.axis(1),rfreq,rhorxy,'r');
            plot(handle.axis(2),rfreq,phsrxy,'r');
            plot(handle.axis(1),rfreq,rhoryx,'b');
            plot(handle.axis(2),rfreq,phsryx,'b');
        end
        %==========a little setup===============%
        legend(handle.axis(1),'Tx real tippers','Ty real tippers')
        legend(handle.axis(2),'Tx imag','Ty imag')
        hold(handle.axis(1),'off');
        hold(handle.axis(2),'off');
end
set(handle.axis(1),'xlim',[min(freq)/3,max(freq)*3])
set(handle.axis(2),'xlim',[min(freq)/3,max(freq)*3])
set(handle.axis(1),'Xdir','reverse');
set(handle.axis(2),'Xdir','reverse');
set(handle.axis(1),'xscale','log');
set(handle.axis(2),'xscale','log');
grid(handle.axis(1),'on');
grid(handle.axis(2),'on');
if strcmp(opt,'txty') 
    ylabel(handle.axis(1),'Tippers(Re.)')
    ylabel(handle.axis(2),'Tippers(Imag.)')
    set(handle.axis(2),'ylim',[minrho maxrho])
elseif strcmp(opt,'xyyx')
    ylabel(handle.axis(1),'apparent resistivity (\Omegam)')
    set(handle.axis(1),'yscale','log');
    ylabel(handle.axis(2),'phase(degree)')
    set(handle.axis(2),'yaxislocation','left','ylim',[0 90],'ytick',...
    [0 15 30 45 60 75 90]);
else
    ylabel(handle.axis(1),'apparent resistivity (\Omegam)')
    set(handle.axis(1),'yscale','log');
    ylabel(handle.axis(2),'phase(degree)')
    set(handle.axis(2),'yaxislocation','left','ylim',[-180 180],'ytick',...
    [-180 -135 -90 -45 0 45 90 135 180]);
end
set(handle.axis(1),'ylim',[minrho maxrho])
xlabel(handle.axis(1),'Frequency (Hz)')
xlabel(handle.axis(2),'Frequency (Hz)')
ifreq=1:length(freq);
disp(['rms=' num2str(calc_rms(isite, ifreq, opt))]);
return


