function data=gen_data
% generate fake data for fwd
global custom %default
custom.ftable=logspace(4,-1,21)';
data.nfreq_o=length(custom.ftable);
custom.flist=1:data.nfreq_o;
data.freq_o=custom.ftable;
data.tf_o=ones(data.nfreq_o,18);
data.emap_o=data.tf_o;
rho=100; % that is rho generated
percent=0.1; % that is the errorbar generated (0.1 for 10%)
for i=1:data.nfreq_o
    data.tf_o(i,[1 4 8 11])=sqrt(rho*5.*data.freq_o(i)/2);
    data.tf_o(i,[2 5 7 10])=-sqrt(rho*5.*data.freq_o(i)/2);
    data.tf_o(i,[3 6 9 12])=data.tf_o(i,1)*percent;
    data.tf_o(i,[13 14])=1/sqrt(2);
    data.tf_o(i,[16 17])=-1/sqrt(2);
    data.tf_o(i,[15 18])=data.tf_o(i,13)*percent;
end
data.nfreq=data.nfreq_o;
data.freq=data.freq_o;
data.tf=data.tf_o;
data.emap=data.emap_o;
data.rho=zeros(data.nfreq_o,8);
data.phs=zeros(data.nfreq_o,8);
return

% function data=dalloc(ns)
% % preallocate for the data structure
% data=gen_data;
% for i=ns:-1:2
%     data(ns)=data(1);
% end
% return

