function data=add_noise(data, nsite, nlevel)% for synthetic data only. 
% please note that there is NO "noise" about impedances 
% since impedance is NOT a signal.
% use this function to test inversion robustness
% please note that errors are added with noise too (don't ask me why)
% please use this function with caution 
for i=1:nsite
    data(i).tf_o=data(i).tf_o.*(1+(rand(size(data(i).tf))-0.5)*nlevel);
end
return

