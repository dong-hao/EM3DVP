function data=gen_data(ftable,errbar)
% generate fake data for fwd
global custom %default
if nargin<1
    custom.ftable=logspace(4,-1,21)';
    ebar = 0.1; % that is the errorbar generated (0.1 for 10%)
elseif nargin<2
    custom.ftable=ftable;
    ebar = 0.1; 
else
    custom.ftable=ftable;
    ebar = errbar;
end
data.nfreq_o=length(custom.ftable);
custom.flist=1:data.nfreq_o;
data.freq_o=custom.ftable;
data.tf_o=ones(data.nfreq_o,18);
data.emap_o=zeros(data.nfreq_o,18);
rho=100; % that is rho generated

for i=1:data.nfreq_o
    data.tf_o(i,[4, 5])=sqrt(rho*5.*data.freq_o(i)/2);
    data.tf_o(i,[7, 8])=-sqrt(rho*5.*data.freq_o(i)/2);
    data.tf_o(i,[1, 2])=sqrt(rho*5.*data.freq_o(i)/2)/100;
    data.tf_o(i,[10,11])=-sqrt(rho*5.*data.freq_o(i)/2)/100;
    data.tf_o(i,[3 6 9 12])=data.tf_o(i,1)*ebar;
    data.tf_o(:,13:14)=0;
    data.tf_o(:,16:17)=0;
    data.tf_o(:,[15 18])=0.05;
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

