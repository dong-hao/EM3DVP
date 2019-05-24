function plot_site(hObject,eventdata,handles,opt)
% plot site location (and name) on a specified handle
global sitename xyz;
switch nargin
case 0
    error('Must Specify a handle to a plot object');
case 1
    opt='name';
case 2
    if ~any(strcmp(opt,{'name','noname','off'}))
        error(['Second argument ''' opt ''' is an unknown command option.'])
    end
end
cobj=findobj(handles.axis,'type','line');
if cobj~=0
    delete(cobj);
end
hold(handles.axis,'on');
switch opt
    case 'name'
        fsites=plot(handles.axis,xyz(:,2),xyz(:,1),'^');
        snames=sitename;   
        text(xyz(:,2),xyz(:,1),snames,'VerticalAlignment','bottom');
    case 'noname'
        fsites=plot(handles.axis,xyz(:,2),xyz(:,1),'^');
    case 'off'
        hold(handles.axis,'off');
        return
end
set(fsites,'markersize',7,'markeredgecolor','r','markerfacecolor',...
    [0.3 0.3 0.3]);
grid(handles.axis, 'on');
hold(handles.axis,'off');
daspect(handles.axis,[1 1 1]);
%refresh_status(hObject,eventdata,handles)
return;

