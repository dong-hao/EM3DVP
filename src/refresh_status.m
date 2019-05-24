function refresh_status(hObject,eventdata,handles)
% as the name implies, a function to refresh the status displayed in the
% bottom right corner of the model creating interface
global custom nsite model
Nx=length(model.x)-1;
Ny=length(model.y)-1;
Nz=length(model.z)-1;
Nsite=nsite;
nfreq=length(custom.flist);
Nres=0;
if custom.zxxzyy==1
    Nres=Nres+4;
end
if custom.zxyzyx==1
    Nres=Nres+4;
end
if custom.txty==1
    Nres=Nres+4;
end
N=Nsite*nfreq*Nres;
M=Nx*Ny*(Nz+7); % "7" is the number of air layer here
M8=9.6*(N*N+N*M)/2^30;
set(handles.status(1),'string',num2str(Nx));
set(handles.status(2),'string',num2str(Ny));
%please note that here y is E-W direction while x is N-S direction.
set(handles.status(3),'string',num2str(Nz));
set(handles.status(4),'string',num2str(Nsite));
set(handles.status(5),'string',num2str(nfreq));
set(handles.status(6),'string',num2str(Nres));
set(handles.status(7),'string',num2str(M8,'%4.2f'));
return

