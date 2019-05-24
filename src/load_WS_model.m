function load_WS_model(hObject, eventdata, handles)
global model;
% dummy function to call read_wsmodel and read Weerachai and Gary's model
% file
[fname, fdir]=uigetfile({'*model*', 'WSINV3D model files';'*.ws',  'ModEM Model files (*.ws)';'*.*',  'Any file'}...
    ,'Open ModEM model File');
if fname==0
    fprintf('user canceled reading model');
    clear;
    return
end
model=read_wsmodel(fdir,fname);
d3_view(hObject, eventdata, handles);
refresh_status(hObject,eventdata,handles);
return


