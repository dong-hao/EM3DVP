function set_rho_polygon(hObject,eventdata,h)
% set model resistivity for mesh within a polygon
% first draw a polygon by mouse clicking...
% left click to start and right click to end drawing
% then
% use function inpolygon to determine how many mesh points there are inside
% the polygon.
global model custom
SiteAxis=h.axis;
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
        % end lines when right click the map
        % try to connect the first point and last point
        line([linex(1) linex(end)],[liney(1) liney(end)],'LineWidth',2,'color','r');
        break
    end
end
hold(SiteAxis,'off');
if size(linex,2)<3 % see if we got a closed polygon
	msgbox('use left click to start, right click to end.','ERROR clicking','error');
	return;
end
% check current view plane
if get(h.viewbox(1),'value')==1
    view=1; % x direction
elseif get(h.viewbox(2),'value')==1
    view=2; % y direction
else
    view=3; % z direction
end

% see if there is any meshes inside the polygon...
% meshgrid first
switch view
    case 1
        nx=length(model.x)-1;
        nz=length(model.z)-1;
        midx=zeros(1,nx);
        midz=zeros(1,nz);
        for i=1:nx
            midx(i)=(model.x(i)+model.x(i+1))/2;
        end
        for i=1:nz
            midz(i)=(model.z(i)+model.z(i+1))/2;
        end
        [xx,zz]=meshgrid(midx,midz);
        mwp=inpolygon(xx,zz,linex,liney);% mesh within polygon;
        [indexz,indexx]=find(mwp~=0); % find index for meshes in polygon
        BlockPara=blockdlg(size(model.y,1)-1,custom.currentY);
        for j=1:length(indexx) % i don't like loops, but i have no idea how to use vectors in 3d matrix
            model.rho(indexx(j),BlockPara(1):BlockPara(2),indexz(j))=BlockPara(3);
            % change resistivity of the meshes within the polygon *one by one*
            model.fix(indexx(j),BlockPara(1):BlockPara(2),indexz(j))=2;
            % lock the meshes within the polygon *one by one*
        end
    case 2
        ny=length(model.y)-1;
        nz=length(model.z)-1;
        midy=zeros(1,ny);
        midz=zeros(1,nz);
        for i=1:ny
            midy(i)=(model.y(i)+model.y(i+1))/2;
        end
        for i=1:nz
            midz(i)=(model.z(i)+model.z(i+1))/2;
        end
        [yy,zz]=meshgrid(midy,midz);
        mwp=inpolygon(yy,zz,linex,liney);% mesh within polygon;
        [indexz,indexy]=find(mwp~=0); % find index for meshes in polygon
        BlockPara=blockdlg(size(model.x,1)-1,custom.currentX);
        for j=1:length(indexy) % i don't like loops, but i have no idea how to use vectors in 3d matrix
            model.rho(BlockPara(1):BlockPara(2),indexy(j),indexz(j))=BlockPara(3);
            % change resistivity of the meshes within the polygon *one by
            % one*
            model.fix(BlockPara(1):BlockPara(2),indexy(j),indexz(j))=2;
            % lock the meshes within the polygon *one by one*
        end
    case 3
        nx=length(model.x)-1;
        ny=length(model.y)-1;
        midx=zeros(1,nx);
        midy=zeros(1,ny);
        for i=1:nx
            midx(i)=(model.x(i)+model.x(i+1))/2;
        end
        for i=1:ny
            midy(i)=(model.y(i)+model.y(i+1))/2;
        end
        [yy,xx]=meshgrid(midy,midx);
        mwp=inpolygon(yy,xx,linex,liney);% mesh within polygon;
        [indexy,indexx]=find(mwp~=0); % find index for meshes in polygon
        BlockPara=blockdlg(size(model.z,1)-1,custom.currentZ);
        for j=1:length(indexx) % i don't like loops, but i have no idea how to use vectors in 3d matrix
            model.rho(indexy(j),indexx(j),BlockPara(1):BlockPara(2))=BlockPara(3);
            % change resistivity of the meshes within the polygon *one by
            % one*
            model.fix(indexy(j),indexx(j),BlockPara(1):BlockPara(2))=2;
            % lock the meshes within the polygon *one by one*
        end
end
% model.rho(1,1,BlockPara(1):BlockPara(2))=BlockPara(3);
model.rho(end,end,end)=model.rho(end,end,end-1)+1;% change the last cell by one
% so that matlab won't bother to choke up any errors
% replot...
d3_view(hObject,eventdata,h);
% for debug;
% figure
% plot(linex,liney,'r',yy(mwp),xx(mwp),'r+',yy(~mwp),xx(~mwp),'k.')
% daspect([1 1 1])
% end debug;
return

