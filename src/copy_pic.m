function copy_pic(hObject,eventdata,handles)
% a function to copy current axis to a new figure (so that you can save
% or edit it)
% set font Name and font size here
fname = 'Arial';
fsize = 16;
if ~isfield(handles,'selectionbox')
    i=1;
    figtitle=get(get(gca,'title'),'string');
elseif get(handles.selectionbox(1),'value')==1
    i=1;
    figtitle='E-W direction Slices';
elseif get(handles.selectionbox(2),'value')==1
    i=2;
    figtitle='N-S direction Slices';
elseif get(handles.selectionbox(3),'value')==1
    i=3;
    figtitle='Horizontal Slices';
else 
    msgbox('weird...')
    return
end    
fid=figure;
set(fid,'position',[100 0 800 600],'numbertitle','off')
set(fid,'name',figtitle);%,'visible','off');
copyobj(handles.axis(i),fid);
hax=gca;
title(hax,figtitle,'FontSize',fsize,'FontName',fname);
set(hax,'pos',[0.1 0.1 0.75 0.8]);
if isfield(handles,'colorbar')
    set_colormap(hObject,eventdata,handles);
    h = colorbar('ver',...
          'YTick',[0,0.5,1,1.5,2,2.5,3, 3.5],...
          'FontSize',fsize,...
          'FontName',fname,...
          'Position',[0.875 0.385 0.03 0.23],...
          'YTickLabel',{'1','3','10','30','100','300','1000', '3000'});
    % label colorbar, did you know that a colorbar could also hava a x label?
    xlabel(h,'Res.(\Omegam)','FontSize',fsize,'FontName',fname);
end
set(get(hax,'xlabel'),'FontSize',fsize,'FontName',fname);
set(get(hax,'ylabel'),'FontSize',fsize,'FontName',fname);
set(get(hax,'zlabel'),'FontSize',fsize,'FontName',fname);
set(hax,'FontSize',fsize,'FontName',fname);
% in most of cases the orient would be a landscape (length>height) style
orient landscape;
% set(gcf,'PaperPositionMode','auto') %print the whole paper
% print(gcf,'-dpng','-r96',picname);
%print(gcf,'-depsc2','-r150','lala.eps');
%close(fid);
return

