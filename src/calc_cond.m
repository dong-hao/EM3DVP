function cond=calc_cond(rho,z,upper,lower)
% function to calculate vertical conductance from the resistivity model at
% a given depth range. 
% upper: upper boundary of the conductivity to be calculated
% lower: lower boundary
% rho:   the resistivity model 
% z:     the depth of each layer of the model
if upper<=lower
    error('the upper depth is deeper than the lower depth, please check it')
end
zrange=istrap(z,upper,lower);
if isempty(zrange)
    error('the depth range falls out of the model, please check the range')
else
    cond=zeros(size(rho(:,:,1)));
    nz=length(zrange);
    cond=cond+(upper-z(zrange(1)))*1000./rho(:,:,zrange(1));
    for i=2:nz-1
        cond=cond+(z(zrange(i-1))-z(zrange(i)))*1000./rho(:,:,zrange(i));
    end
    cond=cond+(z(nz)-lower)*1000./rho(:,:,zrange(nz));
end
cond(cond<0)=NaN;
return

