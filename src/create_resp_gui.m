function create_resp_gui(hObject,eventdata,handles)
global custom sitename;  %default settings and customed settings
%global sitename; %edi sites:number,sitename,location,
                 %freqs,impedence and tipper
hcrmain=figure;
set(hcrmain,'units','normalized','position',[0.2 0.1 0.7 0.8],'numbertitle','off',...
    'name','model response viewer');
bcolor=get(hcrmain,'color');
haa=axes('units','normalized','position',[0.05 0.55 0.7 0.4],'tag','axisa');
hab=axes('units','normalized','position',[0.05 0.07 0.7 0.4],'tag','axisb');
hac=axes('units','normalized','position',[0.8 0.65 0.18 0.3],'tag','axisc');
custom.currentsite=1;

%button group 'DISPLAY'
hbgedit=uibuttongroup(hcrmain,'units','normalized','position',...
    [0.78 0.35 0.2 0.15],'title','display','backgroundcolor',bcolor,...
    'tag','','fontweight','bold');
hcboxresp=uicontrol(hbgedit,'style','checkbox','units','normalized','position',...
    [0.05 0.6 0.6 0.25],'string','display resp','tag','enable resp', ...
    'backgroundcolor',bcolor,'tooltipstring','enable resp');
hcboxerror=uicontrol(hbgedit,'style','checkbox','units','normalized','position',...
    [0.05 0.2 0.6 0.25],'string','display errorbar','tag','enable errorbar', ...
    'backgroundcolor',bcolor,'tooltipstring','enable errorbar');

%button group 'IMPEDANCE'
hbgimpedance=uibuttongroup(hcrmain,'units','normalized','position',...
    [0.78 0.24 0.2 0.1],'title','impedance & tipper','backgroundcolor',bcolor,...
    'tag','','fontweight','bold');
hZxxyy=uicontrol(hbgimpedance,'style','radiobutton','units','normalized','position',...
    [0.05 0.6 0.4 0.25],'string','Zxx & Zyy','tag','plot Zxx & Zyy', ...
    'backgroundcolor',bcolor,'tooltipstring','plot Zxx & Zyy');
hZxyyx=uicontrol(hbgimpedance,'style','radiobutton','units','normalized','position',...
    [0.55 0.6 0.4 0.25],'string','Zxy & Zyx','tag','plot Zxy & Zyx', ...
    'backgroundcolor',bcolor,'tooltipstring','plot Zxy & Zyx');
hTxTy=uicontrol(hbgimpedance,'style','radiobutton','units','normalized','position',...
    [0.35 0.2 0.4 0.25],'string','Tx & Ty','tag','plot Tx & Ty', ...
    'backgroundcolor',bcolor,'tooltipstring','plot Tx & Ty');
%button group 'OUTPUT OPTION'
hbgoutput=uibuttongroup(hcrmain,'units','normalized','position',...
    [0.78 0.10 0.2 0.13],'title','output option','backgroundcolor',bcolor,...
    'tag','','fontweight','bold');
hpbsavecurrent=uicontrol(hbgoutput,'style','pushbutton','units','normalized','position',...
    [0.05 0.6 0.4 0.33],'string','Save current','tag','save current', ...
    'backgroundcolor',bcolor,'tooltipstring','plot Zxx & Zyy');
hpbsaveall=uicontrol(hbgoutput,'style','pushbutton','units','normalized','position',...
    [0.05 0.1 0.4 0.33],'string','Save all','tag','save all', ...
    'backgroundcolor',bcolor,'tooltipstring','plot Zxy & Zyx');
hpbcopypic=uicontrol(hbgoutput,'style','pushbutton','units','normalized','position',...
    [0.55 0.6 0.4 0.33],'string','Copy Pic','tag','copy selected axis');
% other buttons
hpbprevious=uicontrol(hcrmain,'style','pushbutton','units','normalized','position',...
    [0.78 0.51 0.06 0.05],'string','prev','tag','previous site');
hpbnext=uicontrol(hcrmain,'style','pushbutton','units','normalized','position',...
    [0.85 0.51 0.06 0.05],'string','next','tag','next site');
hpbselect=uicontrol(hcrmain,'style','pushbutton','units','normalized','position',...
    [0.92 0.51 0.06 0.05],'string','select','tag','select site');
hpbset_flist=uicontrol(hcrmain,'style','pushbutton','units','normalized','position',...
    [0.79 0.03 0.08 0.05],'string','Set Freq table','tag','next site');
hpbquit=uicontrol(hcrmain,'style','pushbutton','units','normalized','position',...
    [0.89 0.03 0.08 0.05],'string','DONE','tag','next site');


htext=uicontrol(hcrmain,'style','text','units','normalized','position',...
    [0.80 0.58 0.15 0.03],'string','sitename',...
    'backgroundcolor',bcolor);

% put all handles into a structure
handle.axis=[haa,hab,hac];
handle.buttons=[hpbprevious,hpbnext,hpbset_flist,hpbquit,hpbselect];
handle.Zbox=[hZxxyy,hZxyyx,hTxTy];
handle.editbox=[hcboxresp,hcboxerror];
handle.outputbox=[hpbsavecurrent,hpbsaveall];
handle.parent=handles;
handle.text=htext;
handle.init= uisuspend(gcf);
handle.figure=hcrmain;

% set ui callbacks
set(hpbquit,'callback',{@quit_this,hcrmain});
set(hpbset_flist,'callback',{@view_flist,handle});
set(hcboxresp,'callback',{@current_resp,handle});
set(hcboxerror,'callback',{@current_resp,handle});
set(hpbprevious,'callback',{@previous_resp,handle});
set(hpbselect,'callback',{@select_resp,handle});
set(hpbsavecurrent,'callback',{@save_resp_pic,handle,'current'});
set(hpbsaveall,'callback',{@save_resp_pic,handle,'all'});
set(hpbnext,'callback',{@next_resp,handle});
set(hZxxyy,'callback',{@plot_resp,handle,'xxyy'});
set(hZxyyx,'callback',{@plot_resp,handle,'xyyx'});
set(hTxTy,'callback',{@plot_resp,handle,'txty'});
set(hpbcopypic,'callback',{@copy_pseudo,handle})% call the copypic function (for pseudo section!)

% start ploting
set(handle.Zbox,'value',0);
set(handle.Zbox(2),'value',1);
set(handle.editbox(1),'value',1);
set(handle.editbox(2),'value',1);
subplot_site(hObject,eventdata,handle.axis(3));
plot_resp(hObject,eventdata,handle,'xyyx');
set(handle.text,'string',sitename{custom.currentsite});
return

