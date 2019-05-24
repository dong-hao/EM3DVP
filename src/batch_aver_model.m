function batch_aver_model(hObject,eventdata,h)
global model
[fname fdir]=uigetfile({'*.ws',  'WS Model files (*.ws)'; ...
    '*.rho',  'ModEM Model files (*.rho)';'*.*',  'Any file'}...
    ,'Batch Open Model Files','multiselect','on');
if ~iscell(fname)
    errordlg('Please, load more than one model...');
    return;
end
%read impedence format edi file beginning
nmodel=length(fname);
trho=zeros(size(model.rho));
for i=1:nmodel
    tmodel=read_wsmodel(fdir,char(fname{i}));
    trho=trho+log10(tmodel.rho);
end
trho=trho./nmodel;
model.rho=10.^trho;
subview(hObject,eventdata,h);
set(h.rholim,'enable','on')
set(h.viewbox,'enable','on')
set(h.setbox,'enable','on')
set(h.buttons,'enable','on')
return

