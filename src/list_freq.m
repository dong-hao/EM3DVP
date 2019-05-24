function list_freq(hObject,eventdata)
global custom
ftable=custom.ftable;
ptable=1./ftable';
helpdlg(num2str(ptable),'Period List');
return

