function [Calpha,Cratio,j,Lalpha,Lratio,i]=calc_mesh(rhomax, rhomin, fmax, fmin, Lratio, Cratio, spacing, first, last)
Lalpha=first*503*sqrt(1/fmin*rhomin);
Lomega=last*503*sqrt(1/fmax*rhomax);
Calpha=1/3*(spacing);
Comega=1/2*Lomega;
layer=zeros(200,1);
column=zeros(200,1);
layer(1)=Lalpha;
i=1;
while (layer(i)<Comega && i<=200)
    i=i+1;
    layer(i)=layer(i-1)*Lratio;
end
%disp(layer(1:i))
column(1)=Calpha;
j=1;
while (column(j)<Lomega &&j<=200)
    j=j+1;
    column(j)=column(j-1)*Cratio;
end
%disp(column(1:j))
return
