function data=TFautomask(data)
% a function to automatically reject data that jumps a lot
% try to fit the data with phase tensor method
rho=log10(data.rho);
phs=data.phs;
nper=data.nfreq;
emap=data.emap;
for nc=1:4 %loop through XX XY YX and YY
    drho=diff(rho(:,2*nc-1));
    dphs=diff(phs(:,2*nc-1));
    d2rho=zeros(1,nper);
    d2phs=d2rho;
    d2rho(1)=drho(1);
    d2rho(end)=drho(end);
    d2phs(1)=dphs(1);
    d2phs(end)=dphs(end);
    for iper=2:nper-1
        d2rho(iper)=drho(iper-1)-drho(iper);
        d2phs(iper)=dphs(iper-1)-dphs(iper);
    end
    idx=mark_outliers(abs(d2rho));
    emap(:,nc*3)=idx;
    %idx=mark_outliers(abs(d2phs));
    %emap(:,nc*3)=idx;
end
data.emap=emap;
return

