function create_rms_gui(hObject,eventdata)
hrmsmain=figure;
set(hrmsmain,'units','normalized','position',[0.2 0.2 0.7 0.7],'numbertitle','off',...
    'name','iteration RMS viewer');
bcolor=get(hrmsmain,'color');
haa=axes('units','normalized','position',[0.05 0.1 0.7 0.8],'tag','axisa');
hpbload=uicontrol(hrmsmain,'style','pushbutton','units','normalized','position',...
    [0.79 0.03 0.08 0.05],'string','load files','tag','load files');
hpbquit=uicontrol(hrmsmain,'style','pushbutton','units','normalized','position',...
    [0.89 0.03 0.08 0.05],'string','DONE','tag','quit');
hpbcopypic=uicontrol(hrmsmain,'style','pushbutton','units','normalized','position',...
    [0.79 0.10 0.08 0.05],'string','Copy Pic','tag','copy current axis');
htext = uicontrol(hrmsmain,'style','text','units','normalized','position',...
    [0.79 0.20 0.2 0.05],'string','WSINV3D: load all models to see rms variation',...
    'backgroundcolor',bcolor);
htext2 = uicontrol(hrmsmain,'style','text','units','normalized','position',...
    [0.79 0.30 0.2 0.05],'string','ModEM: load .log file to see rms variation',...
    'backgroundcolor',bcolor);
handle.axis=haa;
handle.figure=hrmsmain;
handle.text=[htext htext2];
set(hpbquit,'callback',{@quit_this,hrmsmain});
set(hpbload,'callback',{@load_rms,handle});
set(hpbcopypic,'callback',{@copy_pic,handle})% call the copypic function of main gui...
return

