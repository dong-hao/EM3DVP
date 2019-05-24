function plot_psection(hObject,eventdata,h,sitelst,xdist)
% plot pseudo section for site_viewer
% opt: the type of pseudo section you want to plot,
% impedance, tipper and apparent res is supported.
global data  custom resp
nsite=length(sitelst);
% sort the sites along the profile by distance...
xdist=xdist(sitelst);
% simple (upward) babble sorting
for i=1:nsite
    for j=nsite:-1:i+1
        if xdist(j)<xdist(j-1)
            temp=xdist(j-1);
            xdist(j-1)=xdist(j);
            xdist(j)=temp;
            temp=sitelst(j-1);
            sitelst(j-1)=sitelst(j);
            sitelst(j)=temp;
        end
    end
end
% get the shortest and longest frequency table
minfreq=zeros(1,100);
maxfreq=1;
for i=1:nsite
    ifreq=data(i).freq;
    if length(ifreq)<length(minfreq)
        minfreq=ifreq;
    end
    if length(ifreq)>length(maxfreq)
        maxfreq=ifreq;
    end
end
mag=zeros(length(maxfreq),nsite);
phase=zeros(length(maxfreq),nsite);
xdist=xdist/1000;% convert site distribution to kilometre.
opt=get(h.setbox(1),'value');
switch opt
    case 1%'app. res'
        
        for isite=1:nsite               
            data(sitelst(isite))=calc_rhophs(data(sitelst(isite)),1);
            nfreq=data(sitelst(isite)).nfreq;
            if get(h.setbox(4),'value')==1
                mag(1:nfreq,isite)=log10(data(sitelst(isite)).rho(1:nfreq,1));
                phase(1:nfreq,isite)=data(sitelst(isite)).phs(1:nfreq,1);
            else
                mag(1:nfreq,isite)=log10(data(sitelst(isite)).rho(1:nfreq,3));
                phase(1:nfreq,isite)=data(sitelst(isite)).phs(1:nfreq,3);
            end
        end
    case 2 %'impedance'
        for isite=1:nsite                             
            nfreq=data(sitelst(isite)).nfreq;
            if get(h.setbox(4),'value')==1
                mag(1:nfreq,isite)=sqrt((data(sitelst(isite)).tf(1:nfreq,4)).^2+...
                    (data(sitelst(isite)).tf(1:nfreq,5) ).^2);
                phase(1:nfreq,isite)=atan2(data(sitelst(isite)).tf(1:nfreq,4),...
                    data(sitelst(isite)).tf(1:nfreq,5))/pi*180;
            else
                mag(1:nfreq,isite)=sqrt((data(sitelst(isite)).tf(1:nfreq,7)).^2+...
                    (data(sitelst(isite)).tf(1:nfreq,8) ).^2);
                phase(1:nfreq,isite)=atan2(data(sitelst(isite)).tf(1:nfreq,7),...
                    data(sitelst(isite)).tf(1:nfreq,8))/pi*180;
            end
        end
    case 3 %'rms'
        mag1=mag;
        mag2=mag;
        phase1=phase;
        phase2=phase;
        data=calc_rhophs(data,1);
        resp=calc_rhophs(resp,1);
        for isite=1:nsite                     
            nfreq=data(sitelst(isite)).nfreq;
            if get(h.setbox(4),'value')==1
                mag1(1:nfreq,isite)=log10(data(sitelst(isite)).rho(1:nfreq,1));
                phase1(1:nfreq,isite)=data(sitelst(isite)).phs(1:nfreq,1);
            else
                mag1(1:nfreq,isite)=log10(data(sitelst(isite)).rho(1:nfreq,3));
                phase1(1:nfreq,isite)=data(sitelst(isite)).phs(1:nfreq,3);
            end
            nfreq=data(sitelst(isite)).nfreq;
            if get(h.setbox(4),'value')==1
                mag2(1:nfreq,isite)=log10(resp(sitelst(isite)).rho(1:nfreq,1));
                phase2(1:nfreq,isite)=resp(sitelst(isite)).phs(1:nfreq,1);
            else
                mag2(1:nfreq,isite)=log10(resp(sitelst(isite)).rho(1:nfreq,3));
                phase2(1:nfreq,isite)=resp(sitelst(isite)).phs(1:nfreq,3);
            end
        end
        mag=abs(mag1-mag2)./mag1;
        phase=abs(phase1-phase2./phase1);
    case 4 %'skew'
        for isite=1:nsite
            nfreq=data(isite).nfreq;
            mag(isite,1:nfreq)=data(isite).rho(1,1:nfreq);
            phase(isite,1:nfreq)=data(isite).phs(1,1:nfreq);
        end        
    otherwise
        warning('WarnTests:plotTest',...
            ['data type "' opt '" is not supported in pseudo section...']);
        return
end
tx=xdist; dx=diff(xdist);
% shift everything half dx to the left
tx(1)=xdist(1)-dx(1)/2;
tx(2:nsite)=xdist(1:nsite-1)+dx/2;
tx(nsite+1)=xdist(nsite)+dx(end)/2;
% extent the rho/phase matrix so that pcolor will plot all elements
flist=flipud(minfreq);% use the shortest frequency list as y;
flist=log10(flist);
flist(end+1)=flist(end)*flist(end)/flist(end-1);
if opt==1 
    % extend the phase and magnitude matrix
    phase(:,nsite+1)=phase(:,nsite);
    phase=phase(1:length(minfreq),:);
    phase(end+1,:)=phase(end,:);% use the shortest frequency list as y;
    mag(:,nsite+1)=mag(:,nsite);
    mag=mag(1:length(minfreq),:);    
    mag(end+1,:)=mag(end,:);
    elev=(min(flist)-0.2)*ones(1,nsite);
    % set the site 'elevation' in frequency domain
    % meshgrid
    [xx,yy]=meshgrid(tx',flist);
    pcolor(h.axis(1),xx,yy,mag);
    set_shading(hObject,eventdata,h)
    set(h.axis(1),'clim',[log10(custom.rhomin),log10(custom.rhomax)]);    
    hold(h.axis(1),'on');
    plot(h.axis(1),xdist,elev,'bv','markersize',7,'markeredgecolor',...
        'k','markerfacecolor','b');
    set(h.axis(1),'ydir','reverse','ylim',[min(flist)-0.5 max(flist)+0.5])
    xlabel(h.axis(1),'Distance (km)')
    ylabel(h.axis(1),'log_{10} period (second)')
    hold(h.axis(1),'off');
    %{
    if exist('freezeColors.m','file')
        freezeColors(h.axis(1));        
    end
    if exist('cbfreeze.m','file')
        cbfreeze(hc1,'on');
    end
    %}
    pcolor(h.axis(2),xx,yy,phase);    
    set_shading(hObject,eventdata,h)
    hold(h.axis(2),'on');
    plot(h.axis(2),xdist,elev,'bv','markersize',7,'markeredgecolor',...
        'k','markerfacecolor','b');
    set(h.axis(2),'ydir','reverse','ylim',[min(flist)-0.5 max(flist)+0.5])
    xlabel(h.axis(2),'Distance (km)')
    ylabel(h.axis(2),'log_{10} period (second)')
    if get(h.setbox(4),'value')==1
        set(h.axis(2),'clim',[0,90]);  
    else
        set(h.axis(2),'clim',[-180,-90]);
    end
    hold(h.axis(2),'off');
elseif opt==2
    % extend the phase and magnitude matrix
    phase(:,nsite+1)=phase(:,nsite);
    phase=phase(1:length(minfreq),:);
    phase(end+1,:)=phase(end,:);% use the shortest frequency list as y;
    mag(:,nsite+1)=mag(:,nsite);
    mag=mag(1:length(minfreq),:);    
    mag(end+1,:)=mag(end,:);
    elev=(min(flist)-0.2)*ones(1,nsite);
    % set the site 'elevation' in frequency domain
    % meshgrid
    [xx,yy]=meshgrid(tx',flist);
    pcolor(h.axis(1),xx,yy,mag);
    set_shading(hObject,eventdata,h)
    set(h.axis(1),'clim',[log10(custom.rhomin),log10(custom.rhomax)]);    
    hold(h.axis(1),'on');
    plot(h.axis(1),xdist,elev,'bv','markersize',7,'markeredgecolor',...
        'k','markerfacecolor','b');
    set(h.axis(1),'ydir','reverse','ylim',[min(flist)-0.5 max(flist)+0.5])
    xlabel(h.axis(1),'Distance (km)')
    ylabel(h.axis(1),'log_{10} period (second)')
    hold(h.axis(1),'off');
    %{
    if exist('freezeColors.m','file')
        freezeColors(h.axis(1));        
    end
    if exist('cbfreeze.m','file')
        cbfreeze(hc1,'on');
    end
    %}
    pcolor(h.axis(2),xx,yy,phase);    
    set_shading(hObject,eventdata,h)
    hold(h.axis(2),'on');
    plot(h.axis(2),xdist,elev,'bv','markersize',7,'markeredgecolor',...
        'k','markerfacecolor','b');
    set(h.axis(2),'ydir','reverse','ylim',[min(flist)-0.5 max(flist)+0.5])
    xlabel(h.axis(2),'Distance (km)')
    ylabel(h.axis(2),'log_{10} period (second)')
    if get(h.setbox(4),'value')==1
        set(h.axis(2),'clim',[0,180]);  
    else
        set(h.axis(2),'clim',[-180,0]);
    end
    hold(h.axis(2),'off');
elseif opt==3
    % extend the phase and magnitude matrix
    phase(:,nsite+1)=phase(:,nsite);
    phase=phase(1:length(minfreq),:);
    phase(end+1,:)=phase(end,:);% use the shortest frequency list as y;
    mag(:,nsite+1)=mag(:,nsite);
    mag=mag(1:length(minfreq),:);    
    mag(end+1,:)=mag(end,:);
    elev=(min(flist)-0.2)*ones(1,nsite);
    % set the site 'elevation' in frequency domain
    % meshgrid
    [xx,yy]=meshgrid(tx',flist);
    pcolor(h.axis(1),xx,yy,mag);
    set_shading(hObject,eventdata,h)
    set(h.axis(1),'clim',[0,1]);    
    hold(h.axis(1),'on');
    plot(h.axis(1),xdist,elev,'bv','markersize',7,'markeredgecolor',...
        'k','markerfacecolor','b');
    set(h.axis(1),'ydir','reverse','ylim',[min(flist)-0.5 max(flist)+0.5])
    xlabel(h.axis(1),'Distance (km)')
    ylabel(h.axis(1),'log_{10} period (second)')
    hold(h.axis(1),'off');
    %{
    if exist('freezeColors.m','file')
        freezeColors(h.axis(1));        
    end
    if exist('cbfreeze.m','file')
        cbfreeze(hc1,'on');
    end
    %}
    pcolor(h.axis(2),xx,yy,phase);    
    set_shading(hObject,eventdata,h)
    hold(h.axis(2),'on');
    plot(h.axis(2),xdist,elev,'bv','markersize',7,'markeredgecolor',...
        'k','markerfacecolor','b');
    set(h.axis(2),'ydir','reverse','ylim',[min(flist)-0.5 max(flist)+0.5])
    xlabel(h.axis(2),'Distance (km)')
    ylabel(h.axis(2),'log_{10} period (second)')
    set(h.axis(2),'clim',[0,180]);  
    hold(h.axis(2),'off');
elseif opt==4
    % add in future
else
    % add in future
end
return


