function rms=calc_rms_all(data,resp,nsite)
% =============calculating root mean square misfit (RMS)==================%
% the following method should get the same value as weerachai's formula 
N=0;temp=0;
for isite=1:nsite
    nresp=0;
    if ~isempty(find(data(isite).emap_o(:,6)==1,1))
        nresp=nresp+4;
        dat=data(isite).tf_o(:,[4,5,7,8]);
        res=resp(isite).tf_o(:,[4,5,7,8]);
        rsdl=dat-res;
        misfit=rsdl./data(isite).tf_o(:,[6,6,9,9]);
    end
    if ~isempty(find(data(isite).emap_o(:,3)==1,1))
        nresp=nresp+4;
        dat=data(isite).tf_o(:,[1,2,4,5,7,8,10,11]);
        res=resp(isite).tf_o(:,[1,2,4,5,7,8,10,11]);
        rsdl=dat-res;
        misfit=rsdl./data(isite).tf_o(:,[3,3,6,6,9,9,12,12]);
    end
    if ~isempty(find(data(isite).emap_o(:,15)==1,1))
        nresp=nresp+4;
        dat=data(isite).tf_o(:,[1,2,4,5,7,8,10,11,13,14,16,17]);
        res=resp(isite).tf_o(:,[1,2,4,5,7,8,10,11,13,14,16,17]);
        rsdl=dat-res;
        misfit=rsdl./data(isite).tf_o(:,[3,3,6,6,9,9,12,12,15,15,18,18]);
    end
    misfit=misfit.*misfit;
    misfit=sum(misfit(:));
    temp=temp+misfit;
    N=N+resp(isite).nfreq_o*nresp;
end
rms=sqrt(temp/N);
return

