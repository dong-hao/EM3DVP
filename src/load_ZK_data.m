function load_ZK_data(hObject,eventdata,handles)
global data sitename xyz
%==============import site=======================%
[fname,fdir]=uigetfile({'*.dat','EM3D data files(*.dat)';...
    '*.*','All files(*.*)'},... 
    'Choose data file for EM3D');
if isequal(fname,0) || isequal(fdir,0)
    disp('user canceled...');
    return
end
[data,sitename]=read_ZKdata(fdir,fname,data);

refresh_status(hObject,eventdata,handles);
return
