function plot_profiles(hObject,eventdata,handles)
% a function determined to draw 2d profile in 3d structures.
% left click the submap to start a profile, right click to end it
global xyz model custom
DAR=str2num(get(handles.setbox(10),'string'));
if get(handles.setbox(1),'value')==1
    outx=str2num(get(handles.setbox(6),'string'));
    outy=str2num(get(handles.setbox(7),'string'));
    outz=str2num(get(handles.setbox(8),'string'));
else 
    outx=1;outy=1;outz=1;
end
% determine the grid size
x=model.y(outy:end-outy+1);
y=model.x(outx:end-outx+1);
z=model.z(1:end-outz+1);
SubNv=log10(model.rho(outy:end-outy+1,outx:end-outx+1,1:end-outz+1));
MainAxis=handles.axis(1);
SiteAxis=handles.axis(2);
% disp(h);
hpline=findobj(SiteAxis,'color','r','-and','type','line'); %find previous lines
hpdot=findobj(SiteAxis,'color','k','-and','type','line','Marker','.');
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
    hold(handles.axis(2),'on');
    plot(SiteAxis,linex(i),liney(i),'k','Markersize',6)
    if length(linex)>1
        line(linex(end-1:end),liney(end-1:end),'LineWidth',2,'color','r');
        % draw lines while clicking the map
    end
    if(button==3)
        break
        % finish lines when right clicking the map
    end
end
hold(SiteAxis,'off');
% check how many sub-profiles we have here
n=size(linex,2);
switch n
    case 1
        msgbox('use left click to start, right click to end.','ERROR clicking','error');
        return;
    case 2 % one straight line
        x1=linex(1);x2=linex(2);y1=liney(1);y2=liney(2);
        if get(handles.set3D(1),'value')==1
            Plength=plot_single_profile(MainAxis,x1,x2,y1,y2,x,y,z,SubNv,...
                xyz(:,1),xyz(:,2),xyz(:,3),DAR);
        else
            [Plength,pid,sid]=plot_single_profile2d(MainAxis,x1,x2,y1,y2,...
                x,y,z,SubNv,xyz(:,1),xyz(:,2),xyz(:,3),DAR);
            % move the surface plot to make the profile start with zero
            move_sfc(pid,0-x1,0-y1,0);
            % and move the sites too
            move_sfc(sid,0-x1,0-y1,0);
        end
        title(['Profile Length ',num2str(Plength),' (km)']...
            ,'FontSize',13,'Color','black');
        set_shading(hObject,eventdata,handles)
        set(MainAxis,'clim',[log10(custom.rhomin),log10(custom.rhomax)]);
        colorbar('units','normalized','position',[0.74 0.05 0.05 0.2]);
        hold(MainAxis,'off');
    otherwise % n>2, we have a profile with multiple sections 
        % length of each section
        Plength=zeros(1,n-1);
        hold(MainAxis,'off');
        if get(handles.set3D(1),'value')==1
            for i=1:n-1
                x1=linex(i);x2=linex(i+1);y1=liney(i);y2=liney(i+1);
                Plength(i)=plot_single_profile(MainAxis,x1,x2,y1,y2,x,y,z,...
                    SubNv,xyz(:,1),xyz(:,2),xyz(:,3),DAR);
                hold(MainAxis,'on');
            end
        else
            poffset=0;
            for i=1:n-1
                x1=linex(i);x2=linex(i+1);y1=liney(i);y2=liney(i+1);
                [Plength(i),pid,sid]=plot_single_profile2d(MainAxis,x1,x2,...
                    y1,y2,x,y,z,SubNv,xyz(:,1),xyz(:,2),xyz(:,3),DAR);
                % move the surface plots to keep them aligned
                move_sfc(pid,poffset-x1,0-y1,0);
                % and move the sites location too
                move_sfc(sid,poffset-x1,0-y1,0);
                % now plot a line between different sections
                poffset=poffset+Plength(i);
                plot3(MainAxis,[poffset poffset],[0 0],[0,z(end)],'k-');
                hold(MainAxis,'on');
            end
        end
        set_shading(hObject,eventdata,handles)
        set(MainAxis,'clim',[log10(custom.rhomin),log10(custom.rhomax)]);
        colorbar('units','normalized','position',[0.74 0.05 0.05 0.2]);
        str='';
        for i=1:n-1
            str=[str,num2str(round(Plength(i))),' (km) '];
        end
        title(['Each  Section  Length is :',str],...
            'FontSize',13,'Color','black')
        hold(MainAxis,'off');
end
if get(handles.set3D(1),'value')==1
    view(MainAxis,-20,20)
    camproj(MainAxis,'perspective')
else
    view(MainAxis,0,0)
    camproj(MainAxis,'orthographic')
end
return 


