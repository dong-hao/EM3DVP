function TFinterp(index,ftable,pmin,pmax,fpd)
% try to decimate data from original ones to get fewer freq points and
% more "uniformly" distributed freq table.
% the function is initially aimed to deal with data with different 
% frequency tables (for example data from phoenix MTU-5 and LEMI 417). it 
% is not really recommended before i have time to fully test it.
global data
if isempty(ftable)
    bands=log10(pmax/pmin);
    nfreq=round(bands*fpd)+1;
    ptable=logspace(log10(pmin),log10(pmax),nfreq);% generate period table
    ftable=1./ptable';% convert to frequency...
end
nresp=size(data(index).tf_o,2);
nfreq=length(ftable);
data(index).nfreq=nfreq;
data(index).freq=ftable;
data(index).tf=zeros(nfreq,nresp);
data(index).emap=ones(nfreq,nresp);
% first try to reject poor data (e.g. data that "jump" a lot)
% SEALED for good
% try to interpolate data...
% by spline method 
disp('interpolating data...')
for i=1:nresp
    data(index).tf(:,i)=interp1(log10(data(index).freq_o),...
        data(index).tf_o(:,i),log10(ftable),'spline'); 
end
flast=find(data(index).freq <= data(index).freq_o(end),1); %find the last "valid" data point
if ~isempty(flast)% the error map for each "complex data" (e.g. Zxyi and Zxyr)
    for i=1:nresp
        data(index).tf(flast:end,i)=(data(index).tf_o(end-1,i)+data(index).tf_o(end,i))/2;
        for j=flast+1:nfreq
            data(index).tf(j,i)=data(index).tf(j,i)*sqrt(ftable(j)/data(index).freq_o(end));
        end
    end
	data(index).emap(flast:end,:)=0;
end
return

