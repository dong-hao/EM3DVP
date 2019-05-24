function group_mask_TF(handle,event,h)
% mask Z parametre by simply setting corresponding emap to 0
% click a point to mask and unmask it 
% (for now, in the resistivity plot only)
global data custom;
handles=guidata(h.axis(1));
isite=custom.currentsite;
flist=custom.flist;
out=get(h.axis(1),'CurrentPoint');
% plot a dashed line to mark the boundary.
handles.xpos0=out(1,1);%--store initial position x
handles.ypos0=out(1,2);%--store initial position y
set(h.axis(1),'NextPlot','add')
xl=get(h.axis(1),'XLim');yl=get(h.axis(1),'YLim');
if ((handles.xpos0 > xl(1) && handles.xpos0 < xl(2)) && ...
        (handles.ypos0 > yl(1) && handles.ypos0 < yl(2)))
    %--disable if you click outside of axes
    handles.currentTitle=get(get(h.axis(1), 'Title'), 'String');
	guidata(h.axis(1),handles)      
	title(['[' num2str(out(1,1)) ',' num2str(out(1,2)) ']']);
else
	uirestore(h.init);
    guidata(h.axis(1),handles);
    % disp('interactive_move disabled')
    set(h.editbox,'enable','off');
    set(h.check,'value',0);
    return
end
plot(h.axis(1),[handles.xpos0 handles.xpos0],yl,'g-');
dline=findobj(h.axis(1), 'type','line','color','g');
if length(dline)<2
    % just plot the first line
    return
elseif length(dline)>2
    delete(dline);% clean previous lines
    return
else
    % we have two lines here, time to work!
    p0=get(dline(1),'xdata');
    p0=p0(1);
    p1=get(dline(2),'xdata');
    p1=p1(1);
    if p0>p1
        temp=p0;
        p0=p1;
        p1=temp;
    end
end
if get(h.editbox(3),'value')==1 % group mask X
    hline1=findobj(h.axis(1), 'type','line','marker','o','color','r');
    hline2=findobj(h.axis(1), 'type','line','marker','o','color','k');
    if isempty(hline1) && isempty(hline2) 
        % in the newer version (since 2013?)
        % the errorbar is no longer a line class(?
        hline1=findobj(h.axis(1), 'type','errorbar','marker','o','color','r');
        hline2=findobj(h.axis(1), 'type','errorbar','marker','o','color','k');        
    end    
    xyflag=1;
elseif get(h.editbox(4),'value')==1 % grounp mask Y
    hline1=findobj(h.axis(1), 'type','line','marker','^','color','b');
    hline2=findobj(h.axis(1), 'type','line','marker','^','color','k');
    if isempty(hline1) && isempty(hline2) 
        % in the newer version (since 2013?)
        % the errorbar is no longer a line class(?
        hline1=findobj(h.axis(1), 'type','errorbar','marker','^','color','b');
        hline2=findobj(h.axis(1), 'type','errorbar','marker','^','color','k');        
    end  
    xyflag=2;
else % mask all
    hline1=findobj(h.axis(1), 'type','line','marker','o','color','r');
    hline2=findobj(h.axis(1), 'type','line','marker','o','color','k');
    if isempty(hline1) && isempty(hline2) 
        % in the newer version (since 2013?)
        % the errorbar is no longer a line class(?
        hline1=findobj(h.axis(1), 'type','errorbar','marker','o','color','r');
        hline2=findobj(h.axis(1), 'type','errorbar','marker','o','color','k');        
    end    
    xyflag=3;    
end
if isempty(hline2)
    x=get(hline1,'xdata');
elseif isempty(hline1)
    x=get(hline2,'xdata');
else
    x1=get(hline1,'xdata');
    x2=get(hline2,'xdata');
    x=sort([x1,x2],'descend');
end
% i came to realize the y is much larger than x in low frequencies so one
% would sometimes find trouble clicking the right point.
% thus now i use x only for the distance "d" 
idx=find(x>=p0 & x<=p1);
% index of the "EMAP"
% zxxr zxxi zxxe zxyr zxyi zxye zyxr zyxi zyxe zyyr zyyi zyye
% 1    2    3    4    5    6    7    8    9    10   11   12
% txr  txi  txe  tyr  tyi  tye
% 13   14   15   16   17   18
if get(h.Zbox(1),'value')==1
    if xyflag==1
        zidx=3;
    elseif xyflag==2
        zidx=12;
    else 
        zidx=[3 12];
    end
    opt='xxyy';
elseif get(h.Zbox(2),'value')==1
    if xyflag==1
        zidx=6;
    elseif xyflag==2
        zidx=9;
    else 
        zidx=[6 9];
    end
    opt='xyyx';
elseif get(h.Zbox(3),'value')==1
    if xyflag==1
        zidx=15;
    elseif xyflag==2
        zidx=18;
    else 
        zidx=[15 18];
    end
    opt='txty';
else
    if xyflag==1
        zidx=6;
    elseif xyflag==2
        zidx=9;
    else 
        zidx=[6 9];
    end
    opt='xyyx';
end
for i=1:length(idx)
    if data(isite).emap(flist(idx(i)),zidx)~=0
        data(isite).emap(flist(idx(i)),zidx)=0;
    else
        data(isite).emap(flist(idx(i)),zidx)=1;
    end
end
set(h.axis(1),'NextPlot','replace')
set(h.axis(2),'NextPlot','replace')
plot_sounding(handle,event,h,opt);
return

%%======================plot results====================%%
%      devoted to plot result and model(2D & 3D)         %
%%======================================================%%
