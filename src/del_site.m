function del_site(hObject,eventdata,handles,opt,tool)
global xyz sitename data location nsite
%used to change site location 
switch nargin
case 2
    error('Must Specify a handle to a line object')
case 3
    opt='xy';
case 4
    if ~any(strcmp(opt,{'x','y','xy','axy','a','off'}))
        error(['Second argument ''' opt ''' is an unknown command option.'])
    end
end
h=findobj(handles.axis,'type','line','marker','^');
if nargin<5  % i.e. user-invoked.  
    b=get(h,'tag');
    if ~isempty(b)&&strcmp(b,'del_site')&&(nargin==4||strcmp(opt,'off'))  % function being de-invoked
        k=get(h,'userdata');
        %  acw modified to recall buttondownfcn and restore when turned off
        set(h,'buttondownfcn',k.bdfcn,'markersize',k.ms,'marker',k.m,'markerfacecolor',k.mfc,'userdata','','tag','')
    else % function being invoked
        if ~isempty(get(h,'zdata'))
            error('del_site only works for 2-D graphs')
        end
        if strcmp(opt,'a')
            opt='axy';
        end
        if isempty(b) % only assign original values to marker struct if function is being called the first time
            k.m=get(h,'marker');set(h,'marker','^');
            k.ms=get(h,'markersize');set(h,'markersize',7);
            k.mfc=get(h,'markerfacecolor');set(h,'markerfacecolor',get(h,'color'));
        else
            k=get(h,'userdata');
        end
        k.opt=opt;
        k.bdfcn=get(h,'buttondownfcn'); % save the current buttondownfcn before reset
        set(h,'buttondownfcn',{@del_site,handles,opt,1},'userdata',k,'tag','del_site');
        set(findobj('children',h),'units','pixels')
    end
else  % i.e. self-invoked
    if strcmp(get(gcf,'selectiontype'),'open')
        del_site(hObject,eventdata,h,'off');
    else
        switch tool
        case 1 % line's buttondownfcn invoked
            if ~isempty(get(h,'zdata'))
                del_site(hObject,eventdata,h)
                error('del_site only works for 2-D graphs')
            end
            cp=get(gca,'currentpoint');
            k=get(h,'userdata');
            y=abs(get(h,'ydata')-cp(2,2));x=abs(get(h,'xdata')-cp(1,1)); % determine which point the user clicked on
            % just use the distance function
            d=sqrt(y.^2+x.^2);
            k.index=find(d==min(d));
            k.axesdata=get(gca,'userdata');
            k.doublebuffer=get(gcf,'doublebuffer');
            k.winbmfcn = get(gcf,'windowbuttonmotionfcn');  %  save current window motion function
            k.winbupfcn = get(gcf,'windowbuttonupfcn');  %  save current window up function
            k.winbdfcn = get(gcf,'windowbuttondownfcn');  %  save current window down function

            set(h,'userdata',k);
            set(gca,'userdata',h);
            set(gcf,'windowbuttonupfcn',{@del_site,handles,opt,2});
            %         end    
        case 2 % button up - we're done
            k=get(h,'userdata');
            queststr=['Do you really want to delete this site?',...
                ' it will NOT be recovered'];
            yorn=questdlg(queststr,'Note','yes','no','yes');
            if strcmp(yorn,'yes')
                x=get(h,'xdata');
                y=get(h,'ydata');
                x(k.index:end-1)=x(k.index+1:end);
                x(end)=[];
                y(k.index:end-1)=y(k.index+1:end);
                y(end)=[];
                xyz(k.index:end-1,3)=xyz(k.index+1:end,3);
                xyz(end,:)=[];
                set(h,'xdata',x,'ydata',y)
                xyz(:,2)=x;
                xyz(:,1)=y;
                data(k.index:end-1)=data(k.index+1:end);
                data(end)=[];%delete current data
                sitename(k.index:end-1)=sitename(k.index+1:end);
                sitename(end)=[];%delete current sitename
                location(k.index:end-1,:)=location(k.index+1:end,:);
                location(end,:)=[];%delete current location
                nsite=nsite-1;
            else
                disp('user canceled...')
            end
            set(gca,'userdata',k.axesdata); % restore axes data to its previous value
            set(gcf,'windowbuttonmotionfcn',k.winbmfcn,'windowbuttonupfcn',k.winbupfcn,'doublebuffer',k.doublebuffer);
        end
    end
end
return

