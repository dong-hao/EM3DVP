function load_ZK_model(hObject,eventdata,handles)
global model
[fname, fdir]=uigetfile({'*block', 'ZK3D model files';'*.*',  'Any file'}...
    ,'Open ZK model File');
if fname==0
    fprintf('user canceled reading model');
    clear;
    return
end
model=read_ZKmodel(fdir,fname);
d3_view(hObject, eventdata, handles);
refresh_status(hObject,eventdata,handles);
return
