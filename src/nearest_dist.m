function [min_p1,min_p2,min_d]=nearest_dist(a,x)
% a simple loop function to get the smallest distance within two bunches of 
% scatter points (a and x). 
m=length(a);
n=length(x);
min_d = Inf;
min_p1 = 0;
min_p2 = 0;
for p1 = 1:m
    for p2 = 1:n
        d = (a(p1)-x(p2))^2;
        if d < min_d
            min_p1=p1;
            min_p2=p2;
            min_d=d;
        end
    end
end
min_d=sqrt(min_d);
return

