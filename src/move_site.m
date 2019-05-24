function move_site(hObject,eventdata,handles,opt,tool)
global xyz sitename
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
    if ~isempty(b)&&strcmp(b,'move_site')&&(nargin==4||strcmp(opt,'off'))  % function being de-invoked
        k=get(h,'userdata');
        %  acw modified to recall buttondownfcn and restore when turned off
        set(h,'buttondownfcn',k.bdfcn,'markersize',k.ms,'marker',k.m,'markerfacecolor',k.mfc,'userdata','','tag','')
    else % function being invoked
        if ~isempty(get(h,'zdata'))
            error('move_site only works for 2-D graphs')
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
        set(h,'buttondownfcn',{@move_site,handles,opt,1},'userdata',k,'tag','move_site');
        set(findobj('children',h),'units','pixels')
    end
else  % i.e. self-invoked
    if strcmp(get(gcf,'selectiontype'),'open')
        move_site(hObject,eventdata,h,'off');
    else
        switch tool
        case 1 % line's buttondownfcn invoked
            if ~isempty(get(h,'zdata'))
                move_site(hObject,eventdata,h)
                error('move_site only works for 2-D graphs')
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
            set(gcf,'windowbuttonmotionfcn',{@move_site,handles,opt,2},'doublebuffer','on');
            set(gca,'userdata',h);
            set(gcf,'windowbuttonupfcn',{@move_site,handles,opt,3});
            set(gcf,'Pointer','fullcross');
            %         end    
        case 2 % button motion function
            k=get(h,'userdata');
            cp=get(gca,'currentpoint');
            x=get(h,'xdata');
            y=get(h,'ydata');
            switch opt
            case 'x'
                x(k.index)=cp(1,1);
            case 'y'
                y(k.index)=cp(2,2);
            case {'xy','axy'}
                x(k.index)=cp(1,1);
                y(k.index)=cp(2,2);
            end
            if (~strcmp(opt,'axy')&&~strcmp(opt,'x'))
                if k.index>1&&x(k.index)<x(k.index-1)
                    x(k.index)=x(k.index-1);
                    %disp('lala');%for debug
                end
                if k.index<length(x)&&x(k.index)>x(k.index+1)
                    x(k.index)=x(k.index+1);
                    %disp('lala');%for debug
                end
            end
            xyz(k.index,2)=x(k.index);
            xyz(k.index,1)=y(k.index);
            %xyz(k.index,3)=z(k.index);
            set(h,'xdata',x,'ydata',y)
            % test to see if it moved off the screen - update limits
            fgx=get(gca,'xlim');
            fgy=get(gca,'ylim');
            if any(opt=='y')&&cp(2,2)>fgy(2)
                set(gca,'ylim',[fgy(1) cp(2,2)])
            end
            if any(opt=='y')&&cp(2,2)<fgy(1)
                set(gca,'ylim',[cp(2,2) fgy(2)])
            end
            if any(opt=='x')&&cp(1,1)>fgx(2)
                set(gca,'xlim',[fgx(1) cp(1,1)])
            end
            if any(opt=='x')&&cp(1,1)<fgx(1)
                set(gca,'xlim',[cp(1,1) fgx(2)])
            end
            title(['[' num2str(cp(1,1)) ',' num2str(cp(1,2)) ']']);
        case 3 % button up - we're done
            k=get(h,'userdata');
            set(handles.propertybox(1),'string',sitename{k.index})
            set(handles.propertybox(2),'string',num2str(xyz(k.index,1)))
            set(handles.propertybox(3),'string',num2str(xyz(k.index,2)))
            set(handles.propertybox(4),'string',num2str(xyz(k.index,3)))
            set(gca,'userdata',k.axesdata); % restore axes data to its previous value
            set(gcf,'windowbuttonmotionfcn',k.winbmfcn,...
		'windowbuttonupfcn',k.winbupfcn,...
		'doublebuffer',k.doublebuffer);
            set(gcf,'Pointer','arrow');
        end
    end
end
return

