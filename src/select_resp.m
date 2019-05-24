function select_resp(hObject,eventdata,handles,opt,button)
global nsite custom sitename;
switch nargin
case 2
    error('Must Specify a handle to a plot object')
case 3
    opt='user';
end
h=findobj(handles.axis(3),'type','line','marker','^','markeredgecolor','r');
if strcmp(opt,'user')  % i.e. user-invoked.  
    b=get(h,'tag');
    if ~isempty(b)&&strcmp(opt,'off')  % function being de-invoked
        k=get(h,'userdata');
        %  acw modified to recall buttondownfcn and restore when turned off
        set(h,'buttondownfcn',k.bdfcn,'markersize',k.ms,'marker',k.m,'markerfacecolor',k.mfc,'userdata','','tag','')
    else % function being invoked
        if ~isempty(get(h,'zdata'))
            error('select_resp only works for 2-D graphs')
        end
        if isempty(b) % only assign original values to marker struct if function is being called the first time
            k.m=get(h,'marker');set(h,'marker','^');
            k.ms=get(h,'markersize');set(h,'markersize',7);
            k.mfc=get(h,'markerfacecolor');set(h,'markerfacecolor',get(h,'color'));
        else
            k=get(h,'userdata');
        end
        k.bdfcn=get(h,'buttondownfcn'); % save the current buttondownfcn before reset
        set(h,'buttondownfcn',{@select_resp,handles,'self',1},'userdata',k,'tag','select_resp');
        set(findobj('children',h),'units','pixels')
        set(gcf,'pointer','crosshair');
    end
else  % i.e. self-invoked
    if strcmp(get(gcf,'selectiontype'),'open')
        del_site(hObject,eventdata,h,'off');
    else
        switch button
        case 1 % line's buttondownfcn invoked
            if ~isempty(get(h,'zdata'))
                del_site(hObject,eventdata,h)
                error('select site only works for 2-D graphs')
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
            set(gcf,'windowbuttonupfcn',{@select_resp,handles,opt,2});
        case 2 % button up - we're done
            k=get(h,'userdata');
            if k.index>nsite||k.index<1
                custom.currentsite=1;
            else
                custom.currentsite=k.index;
            end
            set(gca,'userdata',k.axesdata); % restore axes data to its previous value
            % restore saved button functions.
            set(gcf,'windowbuttonmotionfcn',k.winbmfcn,...
            'windowbuttonupfcn',k.winbupfcn,...
            'doublebuffer',k.doublebuffer);
            set(gcf,'pointer','arrow');
            % start ploting...
            subplot_site(hObject,eventdata,handles.axis(3));
            if get(handles.Zbox(1),'value')==1
                plot_resp(hObject,eventdata,handles,'xxyy');
                set(handles.Zbox,'value',0);
                set(handles.Zbox(1),'value',1);
            elseif get(handles.Zbox(2),'value')==1
                plot_resp(hObject,eventdata,handles,'xyyx');
                set(handles.Zbox,'value',0);
                set(handles.Zbox(2),'value',1);
            else
                plot_resp(hObject,eventdata,handles,'txty');
                set(handles.Zbox,'value',0);
                set(handles.Zbox(3),'value',1);
            end
            set(handles.text,'string',sitename{custom.currentsite});
        end
    end
end
return

