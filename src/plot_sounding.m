function plot_sounding(hObject,eventdata,handle,opt)
% this is the ploting function to plot sounding curve in MODEL EDITING
% INTERFACE. for the one in RESULT PLOTING INTERFACE try look for plot_resp
global data custom;
switch nargin
    case 2
        error('must specify a handle to the object')
    case 3
        opt='xyyx';
    case 4
        if ~any(strcmp(opt,{'xyyx','xxyy','txty'}))
            error(['given argument ''' opt ''' is an unknown command option.'])
        end
end
isite=custom.currentsite;
% data(isite)=TFautomask(data(isite));
freq=data(isite).freq(custom.flist);
rhoxx=data(isite).rho(custom.flist,1);
rhoxxe=data(isite).rho(custom.flist,2);
rhoxy=data(isite).rho(custom.flist,3);
rhoxye=data(isite).rho(custom.flist,4);
rhoyx=data(isite).rho(custom.flist,5);
rhoyxe=data(isite).rho(custom.flist,6);
rhoyy=data(isite).rho(custom.flist,7);
rhoyye=data(isite).rho(custom.flist,8);
phsxx=data(isite).phs(custom.flist,1);
phsxxe=data(isite).phs(custom.flist,2);
phsxy=data(isite).phs(custom.flist,3);
phsxye=data(isite).phs(custom.flist,4);
phsyx=data(isite).phs(custom.flist,5);
phsyxe=data(isite).phs(custom.flist,6);
phsyy=data(isite).phs(custom.flist,7);
phsyye=data(isite).phs(custom.flist,8);
txr=data(isite).tf(custom.flist,13);
txi=data(isite).tf(custom.flist,14);
txvar=data(isite).tf(custom.flist,15);
tyr=data(isite).tf(custom.flist,16);
tyi=data(isite).tf(custom.flist,17);
tyvar=data(isite).tf(custom.flist,18);
emap=data(isite).emap(custom.flist,:);
switch opt
    case 'xxyy'
        %=========calculate rho and phase from data=======%
        %please note that the errorbars of resistivities and phases here are
        %calculated using Gary Egbert's formula in Z files.        
        % note that we have std instead of variance here.
        phsxxe=phsxxe*180/pi;
        phsxx=phsxx*180/pi;
        phsyye=phsyye*180/pi;
        phsyy=phsyy*180/pi;
        minrho=min(min(rhoxx),min(rhoyy));
        minrho=minrho/3;
        maxrho=max(max(rhoxx),max(rhoyy));
        maxrho=maxrho*3;
        unmasked=find(emap(:,3)==1);
        hold(handle.axis(1),'off')
        if ~isempty(unmasked)
            errorbar(handle.axis(1),freq(unmasked),rhoxx(unmasked),rhoxxe(unmasked),'ro');
            hold(handle.axis(1),'on')
        end
        masked=find(emap(:,3)~=1);
        %===============paint masked Zxx res=============%
        if ~isempty(masked)
            errorbar(handle.axis(1),freq(masked),rhoxx(masked),rhoxxe(masked),'ko');
            hold(handle.axis(1),'on')
        end
        unmasked=find(emap(:,12)==1);
        if ~isempty(unmasked)
            errorbar(handle.axis(1),freq(unmasked),rhoyy(unmasked),rhoyye(unmasked),'b^');
        end
        masked=find(emap(:,12)~=1);
        %===============paint masked Zyy res=============%
        if ~isempty(masked)
            errorbar(handle.axis(1),freq(masked),rhoyy(masked),rhoyye(masked),'k^');
        end
        set(handle.axis(1),'ylim',[minrho maxrho]);
        hold(handle.axis(2),'off')
        unmasked=find(emap(:,3)==1);
        if ~isempty(unmasked)
            errorbar(handle.axis(2),freq(unmasked),phsxx(unmasked),phsxxe(unmasked),'ro');
            hold(handle.axis(2),'on')
        end
        %===============paint masked Zxx phs=============%
        masked=find(emap(:,3)~=1);
        if ~isempty(masked)
            errorbar(handle.axis(2),freq(masked),phsxx(masked),phsxxe(masked),'ko');
            hold(handle.axis(2),'on')
        end
        unmasked=find(emap(:,12)==1);
        if ~isempty(unmasked)
            errorbar(handle.axis(2),freq(unmasked),phsyy(unmasked),phsyye(unmasked),'b^');
        end
        %===============paint masked Zyy phs=============%
        masked=find(emap(:,12)~=1);
        if ~isempty(masked)
            errorbar(handle.axis(2),freq(masked),phsyy(masked),phsyye(masked),'k^');
        end        
        hold(handle.axis(2),'off');
        set(handle.axis(1),'yscale','log');
    case 'xyyx'
        %=========calculate rho and phase from data=======%
        % note that we have std instead of variance here.
        phsxye=phsxye*180/pi;
        phsxy=phsxy*180/pi;
        phsyxe=phsyxe*180/pi;
        phsyx=phsyx*180/pi;
        if get(handle.Zbox(4),'value')==1
            phsyx=phsyx+180;
        end
        minrho=min(min(rhoxy),min(rhoyx));
        minrho=minrho/3;
        maxrho=max(max(rhoxy),max(rhoyx));
        maxrho=maxrho*3;
        unmasked=find(emap(:,6)==1);
        hold(handle.axis(1),'off')
        if ~isempty(unmasked)
            errorbar(handle.axis(1),freq(unmasked),rhoxy(unmasked),rhoxye(unmasked),'ro');        
            hold(handle.axis(1),'on')
        end
        masked=find(emap(:,6)~=1);
        %===============paint masked Zxy res=============%
        if ~isempty(masked)
            errorbar(handle.axis(1),freq(masked),rhoxy(masked),rhoxye(masked),'ko');
            hold(handle.axis(1),'on')
        end
        unmasked=find(emap(:,9)==1);
        if ~isempty(unmasked)
            errorbar(handle.axis(1),freq(unmasked),rhoyx(unmasked),rhoyxe(unmasked),'b^');
        end
        masked=find(emap(:,9)~=1);
        %===============paint masked Zyx res=============%
        if ~isempty(masked)
            errorbar(handle.axis(1),freq(masked),rhoyx(masked),rhoyxe(masked),'k^');
        end
        set(handle.axis(1),'ylim',[minrho maxrho]);
        hold(handle.axis(1),'off')
        unmasked=find(emap(:,6)==1);
        if ~isempty(unmasked)
            errorbar(handle.axis(2),freq(unmasked),phsxy(unmasked),phsxye(unmasked),'ro');
            hold(handle.axis(2),'on')
        end
        %===============paint masked Zxy phs=============%
        masked=find(emap(:,6)~=1);
        if ~isempty(masked)
            errorbar(handle.axis(2),freq(masked),phsxy(masked),phsxye(masked),'ko');
            hold(handle.axis(2),'on')
        end
        unmasked=find(emap(:,9)==1);
        if ~isempty(unmasked)
            errorbar(handle.axis(2),freq(unmasked),phsyx(unmasked),phsyxe(unmasked),'b^');
        end
        %===============paint masked Zyx phs=============%
        masked=find(emap(:,9)~=1);
        if ~isempty(masked)
            errorbar(handle.axis(2),freq(masked),phsyx(masked),phsyxe(masked),'k^');
        end        
        hold(handle.axis(2),'off');
        set(handle.axis(1),'yscale','log');
    case 'txty'
        %=========calculate tx and ty from data=======%
        rhoxy=txr;
        phsxy=txi;
        rhoxye=txvar;
        phsxye=txvar;
        rhoyx=tyr;
        phsyx=tyi;
        rhoyxe=tyvar;
        phsyxe=tyvar;
        minrho=min(min(rhoyx),min(rhoxy));
        maxrho=max(max(rhoyx),max(rhoxy));
        maxrho=max(abs(minrho),abs(maxrho))+0.1;
        minrho=-maxrho;
        minphs=min(min(phsyx),min(phsxy));
        maxphs=max(max(phsyx),max(phsxy));
        maxphs=max(abs(minphs),abs(maxphs))+0.1;
        minphs=-maxphs;
        %==========now start ploting============%
        %===============paint Tx Real and Imag=============%
        unmasked=find(emap(:,15)==1);
        masked=find(emap(:,15)~=1);
        hold(handle.axis(1),'off')
        if ~isempty(unmasked)
            errorbar(handle.axis(1),freq(unmasked),rhoxy(unmasked),rhoxye(unmasked),'ro');
            hold(handle.axis(1),'on');
        end
        if ~isempty(masked)
            errorbar(handle.axis(1),freq(masked),rhoxy(masked),rhoxye(masked),'ko');
            hold(handle.axis(1),'on');
        end
        hold(handle.axis(2),'off');
        if ~isempty(unmasked)
            errorbar(handle.axis(2),freq(unmasked),phsxy(unmasked),phsxye(unmasked),'ro');
            hold(handle.axis(2),'on');
        end
        if ~isempty(masked)
            errorbar(handle.axis(2),freq(masked),phsxy(masked),phsxye(masked),'ko');
            hold(handle.axis(2),'on');
        end
        %===============paint Ty Real and Imag=============%
        unmasked=find(emap(:,18)==1);
        masked=find(emap(:,18)~=1);
        if ~isempty(unmasked)
            errorbar(handle.axis(1),freq(unmasked),rhoyx(unmasked),rhoyxe(unmasked),'b^');
        end
        if ~isempty(masked)
            errorbar(handle.axis(1),freq(masked),rhoyx(masked),rhoyxe(masked),'k^');
        end
        if ~isempty(unmasked)
            errorbar(handle.axis(2),freq(unmasked),phsyx(unmasked),phsyxe(unmasked),'b^');
        end
        if ~isempty(masked)
            errorbar(handle.axis(2),freq(masked),phsyx(masked),phsyxe(masked),'k^');
        end
        %==========a little setup===============%
        hold(handle.axis(1),'off');
        hold(handle.axis(2),'off');  
        set(handle.axis(1),'ylim',[minrho maxrho])           
        set(handle.axis(2),'ylim',[minphs maxphs])           
end
set(handle.axis(1),'Xdir','reverse');
set(handle.axis(2),'Xdir','reverse');
set(handle.axis(1),'xlim',[min(freq)/3,max(freq)*3])
set(handle.axis(2),'xlim',[min(freq)/3,max(freq)*3])
set(handle.axis(1),'xscale','log');
set(handle.axis(2),'xscale','log');
grid(handle.axis(1),'on');
grid(handle.axis(2),'on');
xlabel(handle.axis(1),'frequency (Hz)',...
    'fontsize',12)
if strcmp(opt,'xxyy') 
    ylabel(handle.axis(1),'log_{10}app. resistivity (\Omegam)');
    ylabel(handle.axis(2),'phase(degree)');
    set(handle.axis(2),'yaxislocation','left','ylim',[-180 180],'ytick',...
    [-180 -135 -90 -45 0 45 90 135 180]);
    legend(handle.axis(1),'XX app. resistivity','YY app. resistivity',...
            'location','NorthWest')
    legend(handle.axis(2),'XX phase','YY phase',...
            'location','NorthWest')
elseif strcmp(opt,'xyyx')
    ylabel(handle.axis(1),'log_{10}apparent resistivity (\Omegam)')
    ylabel(handle.axis(2),'phase(degree)')
    if get(handle.Zbox(4),'value')==1
        set(handle.axis(2),'yaxislocation','left','ylim',[0 90],'ytick',...
        [0 15 30 45 60 75 90]);
    else
        set(handle.axis(2),'yaxislocation','left','ylim',[-180 180],'ytick',...
        [-180 -135 -90 -45 0 45 90 135 180]);
    end
    legend(handle.axis(1),'XY app. resistivity','YX app. resistivity',...
            'location','NorthWest')
    legend(handle.axis(2),'XY phase','YX phase',...
            'location','NorthWest')
else
    ylabel(handle.axis(1),'Real Tipper ')
    ylabel(handle.axis(2),'Imag Tipper')
    legend(handle.axis(1),'TX real','TY real',...
            'location','NorthWest')
    legend(handle.axis(2),'TX imag.','TY imag.',...
            'location','NorthWest')            
    set(handle.axis(1),'ylim',[-1 1])           
    set(handle.axis(2),'ylim',[-1 1])    
end
return

