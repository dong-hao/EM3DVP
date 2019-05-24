function sdata=TFsmooth2(data,ftable1,pmin1,pmax1,fpb1,ftable2,pmin2,pmax2,fpb2)
% this function calls TFsmooth for twice to create data with 
% piecewise period list
sdata1=TFsmooth(data,ftable1,pmin1,pmax1,fpb1);
sdata2=TFsmooth(data,ftable2,pmin2,pmax2,fpb2);
if pmin1>=pmax2 % swap the two if per1 is longer than per2
    tmp=sdata1;
    sdata1=sdata2;
    sdata2=tmp;
end
nfreq1=sdata1.nfreq;
nfreq2=sdata2.nfreq;
if pmax1==pmin2 % we have one-period-overlap
    sdata=sdata1;
    sdata.tf(end:end+nfreq2-1,:)=sdata2.tf;
    sdata.freq(end:end+nfreq2-1)=sdata2.freq;
    sdata.nfreq=nfreq1+nfreq2-1;
    sdata.emap(end:end+nfreq2-1,:)=sdata2.emap;
else
    sdata=sdata1;
    sdata.tf=[sdata1.tf;sdata2.tf];
    sdata.freq=[sdata1.freq;sdata2.freq]; 
    sdata.nfreq=nfreq1+nfreq2;
    sdata.emap=[sdata1.emap;sdata2.emap]; 
end
return

