function z=zconvert(z0,signs,cvt)
% a simple function to convert Hao's data.tf struct
% to different Units
% signs: sign of exp(i*omega*t)
% cvt: convert multiplier between different units
% ====================stub=======================%
nfreq=size(z0,1);
m=ones(size(z0));
m1=[1*cvt,signs*cvt,1*cvt,...
    1*cvt,signs*cvt,1*cvt,...
    1*cvt,signs*cvt,1*cvt,...
    1*cvt,signs*cvt,1*cvt,...
    1,1,1,1,1,1];
for i=1:nfreq
    m(i,:)=m1;
end
z=z0.*m;
return

