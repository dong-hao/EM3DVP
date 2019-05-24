function make_p_profile(hObject,eventdata,handles)
% a function determined to draw 2d profile in sitemap
% left click the submap to start a profile, right click to end it
% p.s. could contain several bugs...
global xyz
SiteAxis=handles.axis(3);
axes(SiteAxis); %#ok<MAXES>
hpline=findobj(gca,'color','r','-and','type','line'); %find previous lines
hpdot=findobj(gca,'color','k','-and','type','line','Marker','.');
if ~isempty(hpline)
    delete(hpline);% clean previous lines
end
if ~isempty(hpdot)
    delete(hpdot) % clean previous dots
end
i=0;linex=[];liney=[];
while 1
    [xtemp ytemp button] = ginput(1);
    i=i+1;linex=[linex,xtemp];liney=[liney,ytemp];
    hold(SiteAxis,'on');
    plot(linex(i),liney(i),'k.','Markersize',6)
    if length(linex)>1
        line(linex(end-1:end),liney(end-1:end),'LineWidth',2,'color','r');
        % draw lines while you click the map
    end
    if(button==3)
        break
        % end lines when right click the map
    end
end
hold(SiteAxis,'off');
if size(linex,2)<2 % see if we got the profile position
	msgbox('use left click to start, right click to end.','ERROR clicking','error');
	return;
end
    nsite=length(xyz);
% here comes the hard task...
% we have to pick up the sites along the profile...
xdist=zeros(1,length(xyz));
% setting up a threshold of distance for the function to pick up sites
% along the profile. 
mindist=max(abs(diff(xyz(:,1))));
for isite=1:nsite
    dx=(xyz(:,1)-xyz(isite,1)).^2;
    dy=(xyz(:,2)-xyz(isite,2)).^2;
    tmin=min((dx([1:isite-1 isite+1:nsite])+dy([1:isite-1 isite+1:nsite])).^.5);
    if tmin<mindist
        mindist=tmin;
    end
end
mindist=mindist/2;
for i=1:nsite % browsing through every site.
    for j=1:length(linex)-1
        alpha=atan2(xyz(i,1)-liney(j),xyz(i,2)-linex(j));
        % angle from the site to "x axis"
        beta=atan2(liney(j+1)-liney(j),linex(j+1)-linex(j));
        % angle from profile to "x axis"
        gamma= alpha - beta;
        % calculate how far the distance from the site to profile 
        distance=abs(sin(gamma)*sqrt((xyz(i,1)-liney(j))^2+...
            ((xyz(i,2)-linex(j))^2)));
        ilength=sqrt((liney(j+1)-liney(j))^2+(linex(j+1)-linex(j))^2);
        if distance<=mindist
            xdist(i)=cos(gamma)*sqrt((xyz(i,1)-liney(j))^2+...
            ((xyz(i,2)-linex(j))^2));            
            if xdist(i)>ilength||xdist(i)<0
                xdist(i)=-1;
            else
                break 
                % in case the site is picked up more than once by diffrent sub profiles.
            end
        else
            xdist(i)=-1;
        end
    end
end
sitelst=find(xdist~=-1);
if length(sitelst)<2
    errormsg=['only ' num2str(length(sitelst)) ' site(s) attached on profile...' ...
        'please try again'];
    errordlg(errormsg,'too few sites on profile');
    return
end
plot_psection(hObject,eventdata,handles,sitelst,xdist)
return

