function [in, on] = insphere(xx,yy,zz,xyz,R)
% a function to tell if points are inside or on a sphere surface.
% IN = INSPHERE(X,Y,Z,XYZ,R)
% IN(p,q,r) = 1 if the point (X(p,q,r),Y(p,q,r),Z(p,q,r)) is either
% strictly inside or on the surface of the sphere
% [IN ON] = INSPHERE(X,Y,Z,XYZ,R) returns a second matrix, ON, which is 
% the size of X, Y and Z.  ON(p,q) = 1 if the point (X(p,q), Y(p,q)) is on 
% the surface of the sphere; otherwise ON(p,q) = 0. 
sx=size(xx);
sy=size(yy);
sz=size(zz);
if sx~=sy|sx~=sz %#ok<OR2>
    error('the x, y and z must be of a same size')
end
dis2 = sqrt((xx-xyz(1)).^2+(yy-xyz(2)).^2+(zz-xyz(3)).^2); % distance between
% the each mesh center and the center of the sphere
in=dis2<R; % points inside the sphere
on=(dis2==R); % points on the sphere surface
return;
