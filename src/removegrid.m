function removegrid(hObject,eventdata,handles,opt,tool)
% callback function used to remove 2D grid (x,y, or z mode)
% this callback is added to main axis (handles.axis)
% use opt 'off' to stop callback function
switch nargin
case 2
    error('Must Specify a handle to a line object')
case 3
    opt='x';
case 4
    if ~any(strcmp(opt,{'x','y','z','off'}))
        error(['Second argument ''' opt ''' is an unknown command option.'])
    end
end
h=findobj(handles.axis,'type','surface');
if nargin<5  % i.e. user-invoked.  
    b=get(h,'tag');
    if ~isempty(b)&strcmp(b,'removegrid')&(nargin==1|strcmp(opt,'off'))  % function being de-invoked
        k=get(h,'userdata');
        %  acw modified to recall buttondownfcn and restore when turned off
        set(h,'buttondownfcn',k.bdfcn,'userdata','','tag','');
    else % function being invoked
        if isempty(b)
    %lala
        else 
            k=get(h,'userdata');
        end
        k.opt=opt;
        k.bdfcn=get(h,'buttondownfcn'); % save the current buttondownfcn before reset
        set(h,'buttondownfcn',{@removegrid, handles, opt, 1},'userdata',k,'tag','removegrid');
        set(findobj('children',h),'units','pixels')
    end
else  % i.e. self-invoked
    if strcmp(get(gcf,'selectiontype'),'open')
        k=get(h,'userdata');
        %  acw modified to recall buttondownfcn and restore when turned off
        set(h,'buttondownfcn',k.bdfcn,'userdata','','tag','');
        % ==================BUG=================== %
        % movegird(h,'off'); %it's strange that removegrid can not call itself...
    else
        switch tool
        case 1 % line's buttondownfcn invoked
            cp=get(gca,'currentpoint');
            k=get(h,'userdata');
            newxdata=get(h,'xdata');
            newydata=get(h,'ydata');
            newzdata=get(h,'zdata');
            newcdata=get(h,'cdata');
            %disp(newcdata)
            if size(newxdata,2)<3||size(newydata,1)<3;
                error('too few grids... what the hell are you doing now?');
            end
            switch opt
                case 'y'%EAST-WEST(left-right) direction
                    dx=abs(get(h,'xdata')-cp(1,1));% determine which x grid the user clicked on
                    k.index=find(dx(1,:)==min(dx(1,:)));% the most close grid
                    newxdata(:,k.index:end-1)=newxdata(:,k.index+1:end);
                    newxdata(:,end)=[];
                    newydata(:,k.index:end-1)=newydata(:,k.index+1:end);
                    newydata(:,end)=[];
                    newzdata(:,k.index:end-1)=newzdata(:,k.index+1:end);
                    newzdata(:,end)=[];
                    newcdata(:,k.index:end-1)=newcdata(:,k.index+1:end);  
                    newcdata(:,end)=[];
                case 'x'%NORTH-SOUTH(up-down) direction
                    dy=abs(get(h,'ydata')-cp(2,2));% determine which y grid the user clicked on
                    k.index=find(dy(:,1)==min(dy(:,1)));% the most close grid
                    newxdata(k.index:end-1,:)=newxdata(k.index+1:end,:);
                    newxdata(end,:)=[];
                    newydata(k.index:end-1,:)=newydata(k.index+1:end,:);
                    newydata(end,:)=[];
                    newzdata(k.index:end-1,:)=newzdata(k.index+1:end,:);
                    newzdata(end,:)=[];
                    newcdata(k.index:end-1,:)=newcdata(k.index+1:end,:);  
                    newcdata(end,:)=[];
                case 'z'%TOP-BOTTOM(up-down) direction
                    dz=abs(get(h,'ydata')-cp(2,2));% determine which z grid the user clicked on
                    k.index=find(dz(:,1)==min(dz(:,1)));% the most close grid
                    newxdata(k.index:end-1,:)=newxdata(k.index+1:end,:);
                    newxdata(end,:)=[];
                    newydata(k.index:end-1,:)=newydata(k.index+1:end,:);
                    newydata(end,:)=[];
                    newzdata(k.index:end-1,:)=newzdata(k.index+1:end,:);
                    newzdata(end,:)=[];
                    newcdata(k.index:end-1,:)=newcdata(k.index+1:end,:);  
                    newcdata(end,:)=[];
            end      
            %disp(newxdata) %for debug
            %disp(newydata) %for debug
            %disp(newzdata) %for debug
            %disp(newcdata) %for debug
            k.axesdata=get(gca,'userdata');
            k.doublebuffer=get(gcf,'doublebuffer');
            k.winbmfcn = get(gcf,'windowbuttonmotionfcn');  %  save current window motion function
            k.winbupfcn = get(gcf,'windowbuttonupfcn');  %  save current window up function
            k.winbdfcn = get(gcf,'windowbuttondownfcn');  %  save current window down function
            set(h,'xdata',newxdata,'ydata',newydata,'zdata',newzdata,'cdata',newcdata);
            set(h,'userdata',k);
            set(gcf,'windowbuttonmotionfcn',{@removegrid, handles, opt, 2},'doublebuffer','on');
            set(gca,'userdata',h);
            set(gcf,'windowbuttonupfcn',{@removegrid, handles, opt, 3});
            set(gcf,'Pointer','fullcross');
            %         end    
        case 2 % button motion function
            cp=get(gca,'currentpoint');
            switch opt
                case 'y'%EAST-WEST(left-right) direction
                    title(['E-W: ' num2str(cp(1,1)) ' m']);
                case 'x'%NORTH-SOUTH(up-down) direction            
                    title(['N-S: ' num2str(cp(1,2)) ' m']);
                case 'z'%TOP-BOTTOM(up-down) direction            
                    title(['Depth: ' num2str(cp(1,2)) ' m']);
            end
        case 3 % button up - we're done
            k=get(h,'userdata');
            set(gca,'userdata',k.axesdata); % restore axes data to its previous value
            set(gcf,'windowbuttonupfcn',k.winbupfcn,'doublebuffer',k.doublebuffer);
            set(gcf,'windowbuttonmotionfcn','');% kill the button motion function
            set(gcf,'Pointer','arrow');
        end
    end
end

