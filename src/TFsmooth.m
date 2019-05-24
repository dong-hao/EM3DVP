function sdata=TFsmooth(data,ftable,pmin,pmax,fpd)
% try to get smooth data to make a more "uniformly" distributed freq table 
% and fewer freq points from original ones 
% the function is initially aimed to deal with data with different 
% frequency tables (for example data from phoenix MTU-5 and LEMI 417). it 
% is not, however, really recommended before i have time to fully test it.
% this function violate the default data periods and should be only
% used by experienced users
%
% concept contributed by John R. Booker 
% the impedances are prewhitened (assuming the impedance decreases with the
% 1/sqrt(T) ratio) before smoothing. the Tzs are not prewhitened.

sdata=data;
if isempty(ftable)
    % generate period table
    bands=log10(pmax/pmin);
    nfreq=round(bands*fpd)+1;
    PERIODS=logspace(log10(pmin),log10(pmax),nfreq)';
else
    PERIODS=1./ftable';
end
NPER=length(PERIODS);
TF_o=sdata.tf_o;
periods=1./sdata.freq_o;
logper=log10(periods);
[nper,nc]=size(TF_o);
% calculating the half bandwidth of the smoothed data points
logPER=log10(PERIODS);
loghbw=sum(diff(logPER))/(NPER-1);% in log space
hbw=10.^loghbw;% in linear space
% calculating the starting and ending data points of the smoothed data
pstart=find(PERIODS>=periods(1)*hbw,1);
pend=find(PERIODS>=periods(nper)/hbw,1);
if isempty(pstart)
   pstart=1;
end
if isempty(pend)
    pend=NPER;
end
% pre-whiten the impedances and their errors
nc0=nc;
if nc>12 
    nc=12; % do not pre-whiten the TZs
end
for k=1:nc 
   TF_o(:,k)= TF_o(:,k).* sqrt(periods);
end
% now try to make windows      
% allocate arrays for smoothed transfer functions
TF=zeros(NPER,nc0);
emap=ones(NPER,nc0);
for iPER=pstart:pend   % loop through every period
     % smooth the impedances (if they exist)
     % smooth TZs (if they exist); no-prewhitening
     j=find(logper>logPER(iPER)-loghbw,1);
     k=find(logper>logPER(iPER)+loghbw,1)-1;
     if isempty(k) % we are arriving at the end of the periods
         k=length(logper);
     end
     % mod(m,3)==1: real TF mod(m,3)==2: imag TF mod(m,3)==0: var of TF
     for m=1:nc0
        TF(iPER,m)=makewin(logPER(iPER),logper(j:k),loghbw,'s')*TF_o(j:k,m);
        offset=mod(m,3);
        if offset~=0 
            if TF(iPER,m)==0
                emap(iPER,m+3-offset)=0;
            end
        end
     end
end
for iPER=1:pstart-1 % note this is right ONLY with boxcar windows.
    if logPER(iPER)>=logper(1)
        k=find(logper>logPER(iPER)+loghbw,1)-1;
        for m=1:nc0
            TF(iPER,m)=makewin(logPER(iPER),logper(1:k),loghbw,'s')*TF_o(1:k,m);
            offset=mod(m,3);
            if offset~=0 
                if TF(iPER,m)==0
                    emap(iPER,m+3-offset)=0;
                end
            end
        end
    else
        TF(iPER,:)=TF(pstart,:);
        emap(iPER,:)=0;
    end
end
for iPER=pend+1:NPER
    if logPER(iPER)<=logper(end)
        j=find(logper>logPER(iPER)-loghbw,1);
        for m=1:nc0
            TF(iPER,m)=makewin(logPER(iPER),logper(j:end),loghbw,'s')*TF_o(j:end,m);
            offset=mod(m,3);
            if offset~=0 
                if TF(iPER,m)==0
                    emap(iPER,m+3-offset)=0;
                end
            end
        end
    else
        TF(iPER,:)=TF(pend,:);
        emap(iPER,:)=0;
    end
end
% rescale impedances to remove pre-whitening
for k=1:nc
   TF(:,k)=TF(:,k)./sqrt(PERIODS);
end
sdata.tf=TF;
sdata.freq=1./PERIODS; 
sdata.nfreq=NPER;
sdata.emap=emap;
% disp('smoothing data...');
return


