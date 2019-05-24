function view_flist(hObject,eventdata,handles)
% view the current frequence table
% frequencies are showed in index of the default frequency table.
% see the main function EM3D for more infomation.
global custom 
flist=custom.flist;
title=get(handles.figure,'name');
prompt = num2str(custom.ftable(flist),'%8.4e  ');
titles  = ['Number of freqs: ' num2str(length(flist))];
def= {num2str(flist)};
dlg =inputdlg(prompt,titles,3,def);
if isempty(dlg)
    disp('user canceled...')
    return
end
flist=str2num(dlg{1});
custom.flist=flist;
if strcmp(title,'model response viewer')
    disp('no status to refresh here')
    return    
end
refresh_status(hObject,eventdata,handles)
return

