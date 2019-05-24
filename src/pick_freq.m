function idx=pick_freq(freq,i1,ie,fpd)
% find in frequency table for a list of frequencies that satisfy an "fpd"
% frequencies per decade. 
range=log10(freq(i1)/freq(ie));
nfreq=round(range*fpd);
if nfreq>(ie-i1) % use all the data
    idx=i1:ie;
elseif nfreq<1 % just use the two data points
    idx=[i1 ie];
else
    idx=round(i1:(ie-i1)/(nfreq-1):ie);
end
return

