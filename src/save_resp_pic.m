function save_resp_pic(hObject,eventdata,handle,opt)
global custom nsite
switch nargin
    case 2
        error('must specify a handle to the object')
    case 3
        opt='current';
    case 4
        if ~any(strcmp(opt,{'all','current'}))
            error(['given argument ''' opt ''' is an unknown command option.'])
        end
end
if strcmp(opt,'current')
    isite=custom.currentsite;
elseif strcmp(opt,'all')
    isite=1:nsite;
end
for i=isite
    picname=num2str(i);
    custom.currentsite=i;
    subplot_site(handle.axis(3),eventdata,handle.axis(3));
    if get(handle.Zbox(1),'value')==1
        plot_resp(hObject,eventdata,handle,'xxyy');
        set(handle.Zbox,'value',0);
        set(handle.Zbox(1),'value',1);
    elseif get(handle.Zbox(2),'value')==1
        plot_resp(hObject,eventdata,handle,'xyyx');
        set(handle.Zbox,'value',0);
        set(handle.Zbox(2),'value',1);
    else 
        plot_resp(hObject,eventdata,handle,'txty');
        set(handle.Zbox,'value',0);
        set(handle.Zbox(3),'value',1);
    end
    set(handle.text,'string',num2str(custom.currentsite));
    copy_pseudo_output(hObject,eventdata,handle,picname);
end
return

