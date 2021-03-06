function auto_mesher(hObject,eventdata,handles)
% Yuki's Auto mesher
% Based on empirical mesh method from Alan G. Jones
% 
default.rhomin=10;
default.rhomax=1000;
default.pmax=10;
default.pmin=0.001;
default.spacing=7500;
default.Lratio=1.2;
default.Cratio=1.5;
default.first=0.1;
default.last=0.5;
hmain=figure;
bcolor=get(hmain,'color');
enable_color=[1 1 1];
set(hmain,'units','pixel','position',[400 300 400 300],'numbertitle','off',...
    'name','Auto mesher');
hrmaxtex=uicontrol(hmain,'style','text','units','normalized','position',...
    [0.05 0.4 0.2 0.1],'string',' Max rho(Ohm m)','backgroundcolor',bcolor);
hrmax=uicontrol(hmain,'style','edit','units','normalized','position',...
    [0.27 0.4 0.15 0.1],'string',num2str(default.rhomax),'backgroundcolor',enable_color);
hrmintex=uicontrol(hmain,'style','text','units','normalized','position',...
    [0.05 0.55 0.2 0.1],'string',' Min rho(Ohm m)','backgroundcolor',bcolor);
hrmin=uicontrol(hmain,'style','edit','units','normalized','position',...
    [0.27 0.55 0.15 0.1],'string',num2str(default.rhomin),'backgroundcolor',enable_color);
hfmaxtex=uicontrol(hmain,'style','text','units','normalized','position',...
    [0.05 0.7 0.2 0.1],'string',' Low freq(Hz)','backgroundcolor',bcolor);
hfmax=uicontrol(hmain,'style','edit','units','normalized','position',...
    [0.27 0.7 0.15 0.1],'string',num2str(default.pmin),'backgroundcolor',enable_color);
hfmintex=uicontrol(hmain,'style','text','units','normalized','position',...
    [0.05 0.85 0.2 0.1],'string',' High freq(Hz)','backgroundcolor',bcolor);
hfmin=uicontrol(hmain,'style','edit','units','normalized','position',...
    [0.27 0.85 0.15 0.1],'string',num2str(default.pmax),'backgroundcolor',enable_color);
hLratiotex=uicontrol(hmain,'style','text','units','normalized','position',...
    [0.45 0.7 0.2 0.1],'string','Layer increasing ratio','backgroundcolor',bcolor);
hLratio=uicontrol(hmain,'style','edit','units','normalized','position',...
    [0.67 0.7 0.15 0.1],'string',num2str(default.Lratio),'backgroundcolor',enable_color);
hCratiotex=uicontrol(hmain,'style','text','units','normalized','position',...
    [0.45 0.85 0.2 0.1],'string','Column increasing ratio','backgroundcolor',bcolor);
hCratio=uicontrol(hmain,'style','edit','units','normalized','position',...
    [0.67 0.85 0.15 0.1],'string',num2str(default.Cratio),'backgroundcolor',enable_color);
hspactex=uicontrol(hmain,'style','text','units','normalized','position',...
    [0.45 0.55 0.2 0.1],'string','min site spacing (m)','backgroundcolor',bcolor);
hspacing=uicontrol(hmain,'style','edit','units','normalized','position',...
    [0.67 0.55 0.15 0.1],'string',num2str(default.spacing),'backgroundcolor',enable_color);
hcalc=uicontrol(hmain,'style','pushbutton','units','normalized','position',...
    [0.82 0.2 0.15 0.1],'string','calculate','backgroundcolor',bcolor);
hquit=uicontrol(hmain,'style','pushbutton','units','normalized','position',...
    [0.82 0.05 0.15 0.1],'string','Quit','tag','Quit','enable','on');

hfirstlayer=uicontrol(hmain,'style','edit','units','normalized','position',...
    [0.27 0.25 0.08 0.1],'string',num2str(default.first),'backgroundcolor',enable_color);
hfirstlayertex1=uicontrol(hmain,'style','text','units','normalized','position',...
    [0.07 0.23 0.15 0.08],'string','firstlayer =','backgroundcolor',bcolor);
hfirstlayertex2=uicontrol(hmain,'style','text','units','normalized','position',...
    [0.40 0.25 0.3 0.1],'string',' of the skin depth of the highest freq'...
    ,'backgroundcolor',bcolor);
hlastlayer=uicontrol(hmain,'style','edit','units','normalized','position',...
    [0.27 0.10 0.08 0.1],'string',num2str(default.last),'backgroundcolor',enable_color);
hlastlayertex1=uicontrol(hmain,'style','text','units','normalized','position',...
    [0.07 0.08 0.15 0.08],'string','lastlayer =','backgroundcolor',bcolor);
hlastlayertex2=uicontrol(hmain,'style','text','units','normalized','position',...
    [0.40 0.10 0.3 0.1],'string',' of the skin depth of the lowest freq'...
    ,'backgroundcolor',bcolor);

handles.rho=[hrmax,hrmin,hrmaxtex,hrmintex];
handles.freq=[hfmax,hfmin,hfmaxtex,hfmintex];
handles.ratio=[hLratio,hCratio,hLratiotex,hCratiotex];
handles.spacing=[hspacing,hspactex];
handles.first=[hfirstlayer,hfirstlayertex1,hfirstlayertex2];
handles.last=[hlastlayer,hlastlayertex1,hlastlayertex2];
handles.figure=hmain;
handles.parent=handles;
set(hcalc,'callback',{@set_mesh_para,handles})
set(hquit,'callback',{@quit_this,handles.figure})
return

