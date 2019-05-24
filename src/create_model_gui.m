function create_model_gui
% main gui for modeling
global default custom;  %default settings and customed settings
hfmain=figure;
[screen_pos,font_weight]=check_res();
custom.font_wt=font_weight;
set(hfmain,'units','pixel',...
    'position',screen_pos,...
    'numbertitle','off',...
    'name','model creating interface',...
    'menubar','none');
bcolor=get(hfmain,'color');
disable_color=[0.9 0.9 0.9];
enable_color=[1 1 1];
haa=axes('units','normalized','position',[0.05 0.20 0.68 0.75],'tag','axis1');
% setting colorbars
hcb=colorbar('units','normalized','position',[0.85 0.42 0.04 0.20]);
caxis([log10(default.rhomin),log10(default.rhomax)]);
hrmax=uicontrol(hfmain,'style','edit',...
    'units','normalized',...
    'position',[0.91 0.58 0.05 0.04],...
    'string',num2str(default.rhomax),...
    'backgroundcolor',enable_color,...
    'enable','off');% colorbar max
hrmin=uicontrol(hfmain,'style','edit',...
    'units','normalized',...
    'position',[0.91 0.42 0.05 0.04],...
    'string',num2str(default.rhomin),...
    'backgroundcolor',enable_color,...
    'enable','off');% colorbar min
% the Omega text for colorbar
ht31=uicontrol(hfmain,'style','text','units','normalized','position',...
     [0.96 0.58 0.03 0.03],'string','W',...
     'FontName','Symbol','backgroundcolor',bcolor);
ht32=uicontrol(hfmain,'style','text','units','normalized','position',...
     [0.96 0.42 0.03 0.03],'string','W',...
     'FontName','Symbol','backgroundcolor',bcolor);
colormap(flipud(jet(64)));

% view direction
% button group viewbox
hbgview=uibuttongroup(hfmain,...
    'units','normalized',...
    'position',[0.05 0.02 0.68 0.14],...
    'title','view options',...
    'fontweight','bold',...
    'backgroundcolor',bcolor);
hrviewx=uicontrol(hbgview,'style','radiobutton',...
    'units','normalized',...
    'position',[0.03 0.63 0.15 0.3],...
    'string','view X plane',...
    'tag','xiewx',...
    'backgroundcolor',bcolor,...
    'enable','off');
hrviewy=uicontrol(hbgview,'style','radiobutton',...
    'units','normalized',...
    'position',[0.03 0.12 0.15 0.3],...
    'string','view Y plane',...
    'tag','xiewy',...
    'backgroundcolor',bcolor,...
    'enable','off');
hrviewz=uicontrol(hbgview,'style','radiobutton',...
    'units','normalized',...
    'position',[0.17 0.63 0.15 0.3],...
    'string','view Z plane',...
    'tag','xiewz',...
    'value',1,...
    'backgroundcolor',bcolor,...
    'enable','off');

%next and previous layer
hnext=uicontrol(hbgview,'style','pushbutton','units','normalized','position',...
    [0.82 0.05 0.12 0.35],'string','Next Slice','tag','Next','enable','off');
hprev=uicontrol(hbgview,'style','pushbutton','units','normalized','position',...
    [0.67 0.05 0.12 0.35],'string','Prev. Slice','tag','Prev','enable','off');
htloc=uicontrol(hbgview,'style','text',...
    'units','normalized',...
    'position',[0.65 0.46 0.15 0.4],...
    'string','current location:',...
    'backgroundcolor',bcolor);
htlocm=uicontrol(hbgview,'style','text',...
    'units','normalized',...
    'position',[0.88 0.46 0.10 0.4],...
    'string','(m)',...
    'backgroundcolor',bcolor);
hdepth=uicontrol(hbgview,'style','edit','units','normalized','position',...
    [0.8 0.63 0.1 0.3],'string','0','backgroundcolor',enable_color,...
    'tag','depth','enable','off');
% 3D view
h3d=uicontrol(hbgview,'style','checkbox','units','normalized','position',...
    [0.34 0.64 0.15 0.3],'string','3D View','tag','3D View','enable',...
    'off','backgroundcolor',bcolor);
% view fix matrix
hfix=uicontrol(hbgview,'style','checkbox','units','normalized','position',...
    [0.51 0.64 0.15 0.3],'string','show fixed','tag','View fix','enable',...
    'off','backgroundcolor',bcolor);
% view profile region
hzoomin=uicontrol(hbgview,'style','checkbox','units','normalized','position',...
    [0.34 0.07 0.15 0.3],'string','hide padding','tag','hide padding meshes','enable',...
    'off','backgroundcolor',bcolor);
% general buttons
% model generation button.
hmgen=uicontrol(hfmain,'units','normalized',...
    'style','pushbutton',...
    'position',[0.77 0.86 0.19 0.05],...
    'string','model generation',...
    'fontweight','bold',...
    'enable','off',...
    'backgroundcolor',bcolor);
% data settings button.
hdset=uicontrol(hfmain,'units','normalized',...
    'style','pushbutton',...
    'position',[0.77 0.93 0.19 0.05],...
    'string','data settings',...
    'fontweight','bold',...
    'enable','off',...
    'backgroundcolor',bcolor);
% source setting
hsset=uicontrol(hfmain,'units','normalized',...
    'style','pushbutton',...
    'position',[0.77 0.79 0.19 0.05],...
    'string','source settings',...
    'fontweight','bold',...
    'enable','off',...    
    'backgroundcolor',bcolor);
hload=uicontrol(hfmain,'style','pushbutton','units','normalized','position',...
    [0.77 0.72 0.09 0.05],'string','Load EDIs','tag','Load EDIs','enable','on');
hedit_site=uicontrol(hfmain,'style','pushbutton','units','normalized','position',...
    [0.87 0.72 0.09 0.05],'string','Site Layout','tag','Site Layout','enable','on');
hdefault=uicontrol(hfmain,'style','pushbutton','units','normalized','position',...
    [0.77 0.42 0.07 0.04],'string','Default','tag','Default','enable','off');

hquit=uicontrol(hfmain,'style','pushbutton','units','normalized','position',...
    [0.87 0.65 0.09 0.05],'string','Quit','tag','Quit','enable','on',...
    'backgroundcolor','r');
hedit=uicontrol(hfmain,'style','pushbutton','units','normalized','position',...
    [0.77 0.65 0.09 0.05],'string','Curve Edit','tag','Curve Edit',...
    'enable','off');
% io buttons
hpopexport=uicontrol(hfmain,'style','popup','units','normalized','position',...
    [0.77 0.48 0.07 0.05],'string',...
    'EXPORT|WinGlink Model|site as edi|Control index|App Res/Phase|WS model|ModEM data|ModEM cov|ZK data|ZK model|ZK startup',...
    'tag','Save',...
    'enable','off',...
    'backgroundcolor',disable_color);
hpopimport=uicontrol(hfmain,'style','popup','units','normalized','position',...
    [0.77 0.56 0.07 0.05],'string',...
    'IMPORT|WinGlink Model|WS Model|WS data|ModEM data|DSM asc|ZK data|ZK model',...
    'tag','Load',...
    'enable','on','backgroundcolor',disable_color);
% botton group model editing
hpedit=uipanel(hfmain,'units','normalized','position',[0.77 0.20 0.21 0.20],...
    'title','model editing','fontweight','bold','backgroundcolor',bcolor);
hpopEdit_Column=uicontrol(hpedit,'style','popup','units','normalized','position',...
    [0.53 0.68 0.41 0.25],'string',...
    'Edit Column|Add column|Delete column|Move column','backgroundcolor',disable_color,...
    'tag','Edit column.','enable','off');
hpopEdit_Row=uicontrol(hpedit,'style','popup','units','normalized','position',...
    [0.53 0.36 0.41 0.25],'string',...
    'Edit Row|Add Row|Delete Row|Move Row','backgroundcolor',disable_color,...
    'tag','Edit Row.','enable','off');
hpopEdit_Layer=uicontrol(hpedit,'style','popup','units','normalized','position',...
    [0.53 0.04 0.41 0.25],'string',...
    'Edit Layer|Add Layer|Delete Layer|Move Layer','backgroundcolor',disable_color,...
    'tag','Edit Layer.','enable','off');
hpopEdit_Res=uicontrol(hpedit,'style','popup','units','normalized','position',...
    [0.06 0.36 0.41 0.25],'string',...
    'Edit Resist.|Area res.|Layer res.|Half space|Polygon res.|Sphere res.|Checker Board|Add Bathy.|Add Topo+Bathy.|Random layer|Random sigma|123|1d average|area Anis.',...
    'backgroundcolor',disable_color,...
    'tag','Set Resist.',...
    'enable','off');
hpopLock_Model=uicontrol(hpedit,'style','popup','units','normalized','position',...
    [0.06 0.04 0.41 0.25],'string',...
    'lock Model.|Area lock.|Layer lock.|Half Space.|Lock Air/Sea',...
    'backgroundcolor',disable_color,...
    'tag','Fix_Model.','enable','off');
hexpert=uicontrol(hpedit,'style','checkbox','units','normalized','position',...
    [0.05 0.72 0.35 0.20],'string','Enable Edit','tag','Enable Edit',...
    'backgroundcolor',bcolor,'tooltipstring','Enable Edit','enable','off');
% button group status
hfstatus=uipanel(hfmain,'units','normalized','title','status','position',...
    [0.77 0.02 0.21 0.16],'fontweight','bold','backgroundcolor',[0.5 0.5 1]);
% Number of blocks in x (N-S)
htNx=uicontrol(hfstatus,'style','text','units','normalized','position',...
    [0.05 0.8 0.2 0.15],'string','Nx: ','horizontalalignment',...
    'left','backgroundcolor',[0.5 0.5 1]);
hvNx=uicontrol(hfstatus,'style','text','units','normalized','position',...
    [0.25 0.8 0.15 0.15],'string','0','horizontalalignment',...
    'left','backgroundcolor',[0.5 0.5 1]);
% Number of blocks in y (E-W)
htNy=uicontrol(hfstatus,'style','text','units','normalized','position',...
    [0.35 0.8 0.2 0.15],'string','Ny: ','horizontalalignment',...
    'left','backgroundcolor',[0.5 0.5 1]);
hvNy=uicontrol(hfstatus,'style','text','units','normalized','position',...
    [0.57 0.8 0.15 0.15],'string','0','horizontalalignment',...
    'left','backgroundcolor',[0.5 0.5 1]);
% Number of blocks in z (U-D)
htNz=uicontrol(hfstatus,'style','text','units','normalized','position',...
    [0.65 0.8 0.2 0.15],'string','Nz: ','horizontalalignment',...
    'left','backgroundcolor',[0.5 0.5 1]);
hvNz=uicontrol(hfstatus,'style','text','units','normalized','position',...
    [0.85 0.8 0.15 0.15],'string','0','horizontalalignment',...
    'left','backgroundcolor',[0.5 0.5 1]);
% Number of sites
htNsite=uicontrol(hfstatus,'style','text','units','normalized','position',...
    [0.05 0.6 0.2 0.15],'string','Nsite: ','horizontalalignment',...
    'left','backgroundcolor',[0.5 0.5 1]);
hvNsite=uicontrol(hfstatus,'style','text','units','normalized','position',...
    [0.25 0.6 0.1 0.15],'string','0','horizontalalignment',...
    'left','backgroundcolor',[0.5 0.5 1]);
% Number of period
htNperiod=uicontrol(hfstatus,'style','text','units','normalized','position',...
    [0.35 0.6 0.2 0.15],'string','Nperiod: ','horizontalalignment',...
    'left','backgroundcolor',[0.5 0.5 1]);
hvNperiod=uicontrol(hfstatus,'style','text','units','normalized','position',...
    [0.57 0.6 0.1 0.15],'string','0','horizontalalignment',...
    'left','backgroundcolor',[0.5 0.5 1]);
% Number of response (4 or 8 or 12)
htNres=uicontrol(hfstatus,'style','text','units','normalized','position',...
    [0.65 0.6 0.2 0.15],'string','Nres: ','horizontalalignment',...
    'left','backgroundcolor',[0.5 0.5 1]);
hvNres=uicontrol(hfstatus,'style','text','units','normalized','position',...
    [0.85 0.6 0.1 0.15],'string','0','horizontalalignment',...
    'left','backgroundcolor',[0.5 0.5 1]);
% memory requirement calculation
htMem=uicontrol(hfstatus,'style','text','units','normalized','position',...
    [0.05 0.3 0.7 0.15],'string','Memory requirement: ','horizontalalignment',...
    'left','backgroundcolor',[0.5 0.5 1]);
hvMem=uicontrol(hfstatus,'style','text','units','normalized','position',...
    [0.05 0.1 0.2 0.15],'string','0','horizontalalignment',...
    'left','backgroundcolor',[0.5 0.5 1]);
htGB=uicontrol(hfstatus,'style','text','units','normalized','position',...
    [0.3 0.1 0.6 0.15],'string','GB ','horizontalalignment',...
    'left','backgroundcolor',[0.5 0.5 1]);
% hvMem8=uicontrol(hfstatus,'style','text','units','normalized','position',...
%     [0.55 0.1 0.2 0.15],'string','0','horizontalalignment',...
%     'left','backgroundcolor',[0.5 0.5 1]);
% htGB8=uicontrol(hfstatus,'style','text','units','normalized','position',...
%     [0.7 0.1 0.3 0.15],'string','GB for 8 Res.','horizontalalignment',...
%     'left','backgroundcolor',[0.5 0.5 1]);
% put all handles in one structure
handles.data=[hdset];
handles.model=[hmgen];
handles.source=[hsset];
handles.edit=[hpopEdit_Column,hpopEdit_Row,hpopEdit_Layer,hpopEdit_Res,hpopLock_Model];
handles.axis=haa;
handles.rholim=[hrmin,hrmax];
handles.generalbutton=[hload,hdefault,hedit_site,hquit,hedit];
handles.button=[hnext,hprev,h3d,hdepth,hfix];
handles.io=[hpopexport,hpopimport];
% handles.model=[hmfx1,hmfx2,hmfx3,hmfy1,hmfy2,hmfy3,hmfz1,hmfz2,hmfz3,...
%     hmfz4,hmfz5,hmfrho,hgenerate,hauto];
handles.viewbox=[hrviewx,hrviewy,hrviewz,h3d,hzoomin];
handles.status=[hvNx,hvNy,hvNz,hvNsite,hvNperiod,hvNres,hvMem];
handles.useless=[ht31,ht32,htMem,htloc,htlocm...
    ,htNx,htNy,htNz,htNsite,htNperiod,htNres,htGB];%mostly text handles
handles.expertmode=hexpert;
handles.colorbar=hcb;
handles.figure=hfmain;

% set callback for controls
% set(hmpchk,'callback',{@check_site,handles});

set(hnext,'callback',{@next_layer,handles});
set(hprev,'callback',{@prev_layer,handles});
set(h3d,'callback',{@d3_view,handles});
set(hfix,'callback',{@d3_view,handles});
set(hzoomin,'callback',{@d3_view,handles});
set(hload,'callback',{@load_edi,handles});
set(hdefault,'callback',{@load_default,handles});
set(hmgen,'callback',{@model_gen_dialog,handles});
set(hdset,'callback',{@data_dialog,handles});
set(hsset,'callback',{@source_dialog,handles});
% set(hauto,'callback',{@auto_mesher,handles});
set(hedit_site,'callback',{@create_site_editor_gui,handles});
set(hquit,'callback',{@quit_this,handles.figure});
set(hedit,'callback',{@create_curveditor_gui,handles});
set(hexpert,'callback',{@expertmode,handles.edit});
set(hrmin,'callback',{@set_colorbar,handles});
set(hrmax,'callback',{@set_colorbar,handles});
%================from here===================%
set(hpopEdit_Column,'callback',{@popEdit_Column,handles})
set(hpopEdit_Row,'callback',{@popEdit_Row,handles});
set(hpopEdit_Layer,'callback',{@popEdit_Layer,handles})
set(hpopEdit_Res,'callback',{@popEdit_Res,handles})
set(hpopLock_Model,'callback',{@popLock_Model,handles})
set(hpopexport,'callback',{@popsave,handles})
set(hpopimport,'callback',{@popload,handles})
set(hdepth,'callback',{@set_depth,handles})
set(hrviewx,'callback',{@d3_view,handles})
set(hrviewy,'callback',{@d3_view,handles})
set(hrviewz,'callback',{@d3_view,handles})
%================to here===================%
figtoolbar(handles);
%set(handles.figure,'toolbar','figure');
custom.projectname=set_project_name();
return;

