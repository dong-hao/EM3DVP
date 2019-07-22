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
        xmask=data(isite).emap(:,3);
        ymask=data(isite).emap(:,12);
        phsxxe=phsxxe*180/pi;
        phsxx=phsxx*180/pi;
        phsyye=phsyye*180/pi;
        phsyy=phsyy*180/pi;
        rhoxx(xmask==0)=NaN;
        rhoyy(ymask==0)=NaN;
        phsxx(xmask==0)=NaN;
        phsyy(ymask==0)=NaN;
        minrho=min(min(rhoxx),min(rhoyy));
        minrho=minrho/3;
        maxrho=max(max(rhoxx),max(rhoyy));
        maxrho=maxrho*3;
        if flagresp==1
            phsrxx=phsrxx*180/pi;
            phsryy=phsryy*180/pi;
            rhorxx(xmask==0)=NaN;
            rhoryy(ymask==0)=NaN;
            phsrxx(xmask==0)=NaN;
            phsryy(ymask==0)=NaN;
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
        xmask=data(isite).emap(:,6);
        ymask=data(isite).emap(:,9);
        phsxy=phsxy*180/pi;
        phsxye=phsxye*180/pi; 
        phsyx=phsyx*180/pi;
        phsyxe=phsyxe.*180/pi; 
        if get(handle.editbox(3),'value')==1
            phsyx=phsyx+180;
        end
        rhoxy(xmask==0)=NaN;
        rhoyx(ymask==0)=NaN;
        phsxy(xmask==0)=NaN;
        phsyx(ymask==0)=NaN;
        minrho=min(min(rhoxy),min(rhoyx));
        minrho=minrho/3;
        maxrho=max(max(rhoxy),max(rhoyx));
        maxrho=maxrho*3;
        if flagresp==1
            phsrxy=phsrxy*180/pi;
            phsryx=phsryx*180/pi;
            if get(handle.editbox(3),'value')==1
                phsryx=phsyx+180;
            end
            rhorxy(xmask==0)=NaN;
            rhoryx(ymask==0)=NaN;
            phsrxy(xmask==0)=NaN;
            phsryx(ymask==0)=NaN;
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
        xmask=data(isite).emap(:,15);
        ymask=data(isite).emap(:,18);
        rhoxy=txr;
        phsxy=txi;
        rhoxye=txvar;
        phsxye=txvar;
        rhoyx=tyr;
        phsyx=tyi;
        rhoyxe=tyvar;
        phsyxe=tyvar;
        rhoxy(xmask==0)=NaN;
        rhoyx(ymask==0)=NaN;
        phsxy(xmask==0)=NaN;
        phsyx(ymask==0)=NaN;
        %=========calculate rho and phase from resp=======%
        if flagresp==1
            rhorxy=rtxr;
            phsrxy=rtxi;
            rhoryx=rtyr;
            phsryx=rtyi;
            rhorxy(xmask==0)=NaN;
            rhoryx(ymask==0)=NaN;
            phsrxy(xmask==0)=NaN;
            phsryx(ymask==0)=NaN;
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
        minrho=-1;
        maxrho=1;
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


