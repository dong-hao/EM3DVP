function res=aver_bos(data,nsite,depth)
% 
tmpres=zeros(nsite,1);

for isite=1:nsite
    % xy
    data(isite).rho(data(isite).emap(:,6)==0,3)=NaN;
    data(isite).phs(data(isite).emap(:,6)==0,3)=NaN;
    % yx
    data(isite).rho(data(isite).emap(:,9)==0,5)=NaN;
    data(isite).phs(data(isite).emap(:,9)==0,5)=NaN;
    rhoa=sqrt(data(isite).rho(:,3).*data(isite).rho(:,5));
    phs=(data(isite).phs(:,3)+data(isite).phs(:,5))/2;
    freq=data(isite).freq;
    [ires,iz]=bostick(rhoa,phs,1./freq,'Bostick');
    idx=find(iz+depth>0,1);
    ires(ires<0)=0.1;
    ires(ires>100000)=100000;
    if isempty(idx)
        tmpres(isite)=100;
    else
        tmpres(isite)=ires(idx);
    end
end
tmpres=log10(tmpres);
res=trimmean(tmpres,15,'floor');
res=10.^res;
return

