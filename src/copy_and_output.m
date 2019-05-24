function copy_and_output(hObject,eventdata,handles,picname)
% smile and turn away...
% a function to copy current axis to a new figure and output as a pic
% set font Name and font size here
fname = 'Times';
fsize = 12;
if ~isfield(handles,'selectionbox')
    i=1;
elseif get(handles.selectionbox(1),'value')==1
    i=1;
elseif get(handles.selectionbox(2),'value')==1
    i=2;
elseif get(handles.selectionbox(3),'value')==1
    i=3;
else 
    msgbox('weird...')
    return
end    
fid=figure;
set(fid,'position',[100 100 900 600],'numbertitle','off',...
    'name','Profile','visible','off');
copyobj(handles.axis(i),fid);
hax=gca;
title(hax,picname,'FontSize',fsize,'FontName',fname);
set(hax,'pos',[0.1 0.1 0.8 0.8]);
if isfield(handles,'colorbar')
    set_colormap(hObject,eventdata,handles);
    % h=colorbar;
end
set(get(hax,'xlabel'),'FontSize',fsize,'FontName',fname);
set(get(hax,'ylabel'),'FontSize',fsize,'FontName',fname);
set(get(hax,'zlabel'),'FontSize',fsize,'FontName',fname);
set(hax,'FontSize',fsize,'FontName',fname);
set(hax,'TickDir','out');% set custom ticks
% set(hax,'ZTickLabel',{'-600','','-500','','-400','','-300'...
%     ,'','-200','','-100','','0','','100'});
% label colorbar, did you know that a colorbar could also hava a x label?
% xlabel(h,'log_{10}\Omegam','FontSize',12,'FontName','Times New Roman');
% in most of cases the orient would be a landscape (length>height) style
% orient landscape;
set(gcf,'PaperPositionMode','auto')% print whole paper...
print(gcf,'-dpng','-r96',[picname '.png']);
print(gcf,'-depsc2','-r150',[picname '.eps']);
close(fid);
return

