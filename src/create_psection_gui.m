function create_psection_gui(hObject,eventdata,handles)
% gui function for plotting pseudo sections
global custom % default settings stored here
hpsmain=figure;
enable_color=[1 1 1];
set(hpsmain,'units','normalized','position',[0.1 0.1 0.8 0.8],'numbertitle','off',...
    'name','plot psection(DEMO)');
bcolor=get(hpsmain,'color');
haa=axes('units','normalized','position',[0.05 0.55 0.6 0.4],'tag','axisa');
hab=axes('units','normalized','position',[0.05 0.07 0.6 0.4],'tag','axisb');
hasite=axes('units','normalized','position',[0.72 0.6 0.25 0.35],'tag','axissite');
%plot grid before colorbar emerges
subplot_mesh(hObject,eventdata,hasite)
%================colorbar=================%
colormap(flipud(jet(64)));
hcb=colorbar('units','normalized','position',[0.74 0.05 0.05 0.2]);
caxis([log10(custom.rhomin),log10(custom.rhomax)]);
hrmax=uicontrol(hpsmain,'style','edit','units','normalized','position',...
    [0.81 0.22 0.04 0.03],'string',num2str(custom.rhomax),'backgroundcolor',...
    enable_color,'enable','off');
hrmin=uicontrol(hpsmain,'style','edit','units','normalized','position',...
    [0.81 0.05 0.04 0.03],'string',num2str(custom.rhomin),'backgroundcolor',...
    enable_color,'enable','off');

%button group 'Settings'
hbgset=uibuttongroup(hpsmain,'units','normalized','position',...
    [0.73 0.28 0.22 0.25],'title','settings','backgroundcolor',bcolor,...
    'tag','','fontweight','bold');
hrbset_xy= uicontrol(hbgset,'style','radiobutton','units','normalized','position',...
    [0.05 0.85 0.4 0.15],'string','xy mode','tag','xy mode', ...
    'backgroundcolor',bcolor,'tooltipstring','xy mode');
hrbset_yx= uicontrol(hbgset,'style','radiobutton','units','normalized','position',...
    [0.5 0.85 0.4 0.15],'string','yx mode','tag','yx mode', ...
    'backgroundcolor',bcolor,'tooltipstring','yx mode');
httype_text = uicontrol(hbgset,'style','text','units','normalized','position',...
    [0.05 0.41 0.3 0.15],'string','data type','backgroundcolor',bcolor);
hpoptype = uicontrol(hbgset,'Style', 'popup','units','normalized',...
       'String', 'app. res|impedance|rms|skew',...
       'Position', [0.45 0.43 0.4 0.15]);
htmap_text = uicontrol(hbgset,'style','text','units','normalized','position',...
    [0.05 0.23 0.3 0.15],'string','color map','backgroundcolor',bcolor);
hpopmap = uicontrol(hbgset,'Style', 'popup','units','normalized',...
       'String', 'reversed jet|hsv|gray|jet|reversed HSV|jet w/ topo',...
       'Position', [0.45 0.25 0.4 0.15]);
htshade_text = uicontrol(hbgset,'style','text','units','normalized','position',...
    [0.05 0.05 0.4 0.15],'string','shading','backgroundcolor',bcolor);
hpopshade = uicontrol(hbgset,'Style', 'popup','units','normalized',...
       'String', 'interp|flat|faceted',...
       'Position',  [0.45 0.07 0.3 0.15]);
% other buttons
hpbcopypic=uicontrol(hpsmain,'style','pushbutton','units','normalized','position',...
    [0.87 0.10 0.07 0.04],'string','Copy Pic','tag','copy selected axis');
hpbquit=uicontrol(hpsmain,'style','pushbutton','units','normalized','position',...
    [0.87 0.05 0.07 0.04],'string','DONE','tag','quit');
hpbplot_profile=uicontrol(hpsmain,'style','pushbutton','units','normalized','position',...
    [0.87 0.15 0.07 0.04],'string','NEW','tag','plot profile', ...
    'backgroundcolor',bcolor,'tooltipstring','plot profile');
hpbsavexyz=uicontrol(hpsmain,'style','pushbutton','units','normalized','position',...
    [0.87 0.20 0.07 0.04],'string','Save XYZ','tag','save selected axis in XYZ');
htext=uicontrol(hpsmain,'style','text','units','normalized','position',...
    [0.75 0.54 0.08 0.03],'string','text','backgroundcolor',bcolor);

m_toggle = uimenu( 'Parent', hpsmain, 'Label', 'toggle' );
m_toggle_pseudo = uimenu('Parent',m_toggle,'Label','toggle pseudo mode');

% put all handles into a structure
handles.axis=[haa,hab,hasite];
handles.buttons=[hpbcopypic,hpbplot_profile,hpbquit,hpbsavexyz];
handles.setbox=[hpoptype, hpopmap, hpopshade, hrbset_xy, hrbset_yx, htmap_text, htshade_text,...
    httype_text];
handles.parent=handles;
handles.text=htext;
handles.colorbar=hcb;
handles.rholim=[hrmin,hrmax];
handles.figure=hpsmain;

% set ui callbacks
set(hpbquit,'callback',{@quit_this,handles})
set(hrmax,'callback',{@set_colorbar,handles})
set(hrmin,'callback',{@set_colorbar,handles})
set(hpbplot_profile,'callback',{@make_p_profile,handles})
set(hpopshade,'callback',{@set_shading,handles})
set(hpbcopypic,'callback',{@copy_pseudo,handles})
set(hpopmap,'callback',{@set_profile_map,handles});
set(hpbsavexyz,'callback',{@save_xyz,handles});
set(m_toggle_pseudo,'callback',{@toggle_pseudo,handles});
% a little initial works
set(handles.setbox,'enable','on')
set(handles.buttons,'enable','on')
set(handles.rholim,'enable','on')
return


