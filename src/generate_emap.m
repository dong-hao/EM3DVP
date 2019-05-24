function emap=generate_emap(z,threshold)
% simple script to generate "masked" matrice from the error of the data.
% will list as data with a extremely large error (> threshold) as "masked"
% usage: z=generate_emap(z,threshold)
if nargin==1
    threshold=1E6;
elseif nargin<1
    error('not enough input arguments, 1 at least');
end
nfreq=size(z,1);
if size(z,2)==4
    iresp=[3 6];
    emap=ones(nfreq,6);
elseif size(z,2)==8
    iresp=[3 6 9 12];
    emap=ones(nfreq,12);
else 
    iresp=[3 6 9 12 15 18];
    emap=ones(nfreq,18);
end
index=(z(:,iresp)<=threshold);
emap(:,iresp)=index;
return

