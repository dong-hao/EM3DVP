function mask_TF(handle,event,h)
% mask Z (and now T) parametre by simply setting corresponding emap to 0
% click a point to mask ( and then click again to unmask) it 
% (for now, in the resistivity plot only)
global data custom;
handles=guidata(h.axis(1));
isite=custom.currentsite;
flist=custom.flist;
out=get(h.axis(1),'CurrentPoint');
if get(h.editbox(1),'value')==1
    hline1=findobj(h.axis(1), 'type','line','marker','o','color','r');
    hline2=findobj(h.axis(1), 'type','line','marker','o','color','k');
    if isempty(hline1) && isempty(hline2) 
        % in the newer version (since 2013?)
        % the errorbar is no longer a line class(?
        hline1=findobj(h.axis(1), 'type','errorbar','marker','o','color','r');
        hline2=findobj(h.axis(1), 'type','errorbar','marker','o','color','k');        
    end
    xyflag=1;
else 
    hline1=findobj(h.axis(1), 'type','line','marker','^','color','b');
    hline2=findobj(h.axis(1), 'type','line','marker','^','color','k');
    if isempty(hline1) && isempty(hline2) 
        % in the newer version (since 2013?)
        % the errorbar is no longer a line class(?
        hline1=findobj(h.axis(1), 'type','errorbar','marker','^','color','b');
        hline2=findobj(h.axis(1), 'type','errorbar','marker','^','color','k');        
    end    
    xyflag=2;
end
handles.xpos0=out(1,1);%--store initial position x
handles.ypos0=out(1,2);%--store initial position y
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
%y=abs(get(hline,'ydata')-out(2,2));
if isempty(hline2)
    x=log10(get(hline1,'xdata')./out(1,1));
    d=abs(x);
elseif isempty(hline1)
    x=log10(get(hline2,'xdata')./out(1,1));
    d=abs(x);
else 
    x1=log10(get(hline1,'xdata')./out(1,1));
    x2=log10(get(hline2,'xdata')./out(1,1));
    x=sort([x1,x2],'descend');
    d=abs(x);
end
% d=sqrt(y.^2+x.^2);
% i came to realize the y is much larger than x in low frequencies so one
% would sometimes find trouble clicking the right point.
% thus now i use x only for the distance "d" 
idx=find(d==min(d));
% index of the "EMAP"
% zxxr zxxi zxxe zxyr zxyi zxye zyxr zyxi zyxe zyyr zyyi zyye
% 1    2    3    4    5    6    7    8    9    10   11   12
% txr  txi  txe  tyr  tyi  tye
% 13   14   15   16   17   18
if get(h.Zbox(1),'value')==1
    if xyflag==1
        zidx=3;
    else 
        zidx=12;
    end
    opt='xxyy';
elseif get(h.Zbox(2),'value')==1
    if xyflag==1
        zidx=6;
    else 
        zidx=9;
    end
    opt='xyyx';
elseif get(h.Zbox(3),'value')==1
    if xyflag==1
        zidx=15;
    else 
        zidx=18;
    end
    opt='txty';
else
    if xyflag==1
        zidx=6;
    else 
        zidx=9;
    end
    opt='xyyx';    
end
if data(isite).emap(flist(idx),zidx)==1
    data(isite).emap(flist(idx),zidx)=0;
else
    data(isite).emap(flist(idx),zidx)=1;
end
set(h.axis(1),'NextPlot','replace')
set(h.axis(2),'NextPlot','replace')
plot_sounding(handle,event,h,opt);
return

