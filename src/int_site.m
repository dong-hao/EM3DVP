function sitei=int_site(xi,yi)
% generate fake data by interpolating the surrounding stations
global data xyz
% firstly check if we have enough stations
nsite = length(data);
if nsite < 3
    % we don't have enough data points for interpolation
    sitei = gendata;
    return
end
x = xyz(1:end-1,1);
y = xyz(1:end-1,2);
sitei.nfreq_o=data(1).nfreq;
sitei.freq_o=data(1).freq;
sitei.tf_o=data(1).tf;
sitei.emap_o=data(1).emap;
v = zeros(nsite,1);
for i=1:sitei.nfreq_o
    for j = 1:18;
        for k = 1:nsite
            v (k) = data(k).tf(i,j);
        end
        F=scatteredInterpolant(x, y, v);
        sitei.tf_o(i,j) = F(xi,yi);
    end
%     sitei.tf_o(i,3) = sqrt(sitei.tf_o(i,1)^2+sitei.tf_o(i,2)^2);
%     sitei.tf_o(i,6) = sqrt(sitei.tf_o(i,4)^2+sitei.tf_o(i,5)^2);
%     sitei.tf_o(i,9) = sqrt(sitei.tf_o(i,7)^2+sitei.tf_o(i,8)^2);
%     sitei.tf_o(i,12) = sqrt(sitei.tf_o(i,10)^2+sitei.tf_o(i,11)^2);
%     sitei.tf_o(i,15) = sqrt(sitei.tf_o(i,13)^2+sitei.tf_o(i,14)^2);
%     sitei.tf_o(i,18) = sqrt(sitei.tf_o(i,16)^2+sitei.tf_o(i,17)^2);
end
sitei.nfreq=sitei.nfreq_o;
sitei.freq=sitei.freq_o;
sitei.tf=sitei.tf_o;
sitei.emap=sitei.emap_o;
sitei = calc_rhophs(sitei,1);
return
