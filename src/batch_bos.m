function res=batch_bos(data,nsite,depth)
% 
res=zeros(nsite,1);
for isite=1:nsite
    rhoa=sqrt(data(isite).rho(:,3).*data(isite).rho(:,5));
    phs=(data(isite).phs(:,3)+data(isite).phs(:,5))/2;
    freq=data(isite).freq;
    [ires,iz]=bostick(rhoa,phs,1./freq,'Bostick');
    ires(isnan(ires))=100;
    ires(ires<0)=0.1;
    ires(ires>100000)=100000;
    idx=find(iz+depth>0,1);
    if isempty(idx)
        res(isite)=100;
    else
        res(isite)=ires(idx);
    end
end
return

