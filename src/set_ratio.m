function set_ratio(hObject,eventdata,handles)
% set horizontal/vertical ratio for 3d/2d graph
% x,y,z here is easting, northing and vertical.
global custom 
ratio=custom.ratio;
prompt = 'set easting, northing, vertical display ratio here';
titles  = 'set h/v display ratio';
def= {num2str(ratio)};
dlg =inputdlg(prompt,titles,3,def);
if isempty(dlg)
    disp('user canceled...')
    return
end
ratio=str2num(dlg{1});
custom.ratio=ratio;
subview(hObject,eventdata,handles);
return


