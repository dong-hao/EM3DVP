function [rms, rmsz, rmst] =calc_rms_all(data,resp,nsite)
% =============calculating root mean square misfit (RMS)==================%
% the following method should get the same value as weerachai's formula 
N1=0;temp1=0;
N2=0;temp2=0;
N3=0;temp3=0;
for isite=1:nsite
    if ~isempty(find(data(isite).emap_o(:,6)==1,1))
        dat=data(isite).tf_o(:,[4,5,7,8]);
        res=resp(isite).tf_o(:,[4,5,7,8]);
        rsdl1=dat-res;
        misfit1 = rsdl1./data(isite).tf_o(:,[6,6,9,9]);
        map1 = data(isite).emap_o(:,[6,6,9,9]);
        misfit1 = misfit1.*misfit1;
        misfit1 = sum(misfit1(:));
        dN1 = sum(map1(:));
        temp1 = temp1 + misfit1;
        N1 = N1 + dN1;
    end
    if ~isempty(find(data(isite).emap_o(:,3)==1,1))
        dat=data(isite).tf_o(:,[1,2,10,11]);
        res=resp(isite).tf_o(:,[1,2,10,11]);
        rsdl=dat-res;
        misfit2 = rsdl./data(isite).tf_o(:,[3,3,12,12]);
        map2 = data(isite).emap_o(:,[3,3,12,12]);
        misfit2 = misfit2.*misfit2;
        misfit2 = sum(misfit2(:));
        dN2 = sum(map2(:));
        temp2 = temp2 + misfit2;
        N2 = N2 + dN2;
    end
    if ~isempty(find(data(isite).emap_o(:,15)==1,1))
        dat=data(isite).tf_o(:,[13,14,16,17]);
        res=resp(isite).tf_o(:,[13,14,16,17]);
        rsdl=dat-res;
        misfit3 = rsdl./data(isite).tf_o(:,[15,15,18,18]);
        map3 = data(isite).emap_o(:,[15,15,18,18]);
        misfit3 = misfit3.*misfit3;
        misfit3 = sum(misfit3(:));
        dN3 = sum(map3(:));
        temp3 = temp3 + misfit3;
        N3 = N3 + dN3;
    end
end
rms=sqrt((temp1+temp2+temp3)/(N1+N2+N3));
if N1+N2 ~= 0
    rmsz=sqrt((temp1+temp2)/(N1+N2));
else
    rmsz=0;
end
if N3 ~= 0
    rmst=sqrt(temp3/N3);
else
    rmst=0;
end
return