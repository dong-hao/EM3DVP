function [min_p1,min_p2,min_d]=min_dist(x,y)
% a simple loop function to get the smallest distance of one point (y) and
% another bunch of scatter points (x). 
n=length(x);
min_d = Inf;
min_p1 = 0;
min_p2 = 0;
for p1 = 1:(n-1)
    for p2 = (p1+1):n
        d = (x(p1)-x(p2))^2+(y(p1)-y(p2))^2;
        if d < min_d
            min_p1=p1;
            min_p2=p2;
            min_d = d;
        end
    end
end
min_d=sqrt(min_d);
return

