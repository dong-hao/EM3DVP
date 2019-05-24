function tr=Trotate(t, theta)
tr=t;
ctheta=cos(theta);
stheta=sin(theta);
tr(:,1)=ctheta*(ctheta*t(:,1) - stheta*t(:,3)) - ...
    stheta*(ctheta*t(:,2) - stheta*t(:,4));
tr(:,2)=ctheta*(ctheta*t(:,2) - stheta*t(:,4)) + ...
    stheta*(ctheta*t(:,1) - stheta*t(:,3));
tr(:,3)=ctheta*(ctheta*t(:,3) + stheta*t(:,1)) - ...
    stheta*(ctheta*t(:,4) + stheta*t(:,2));
tr(:,4)=ctheta*(ctheta*t(:,4) + stheta*t(:,2)) + ...
    stheta*(ctheta*t(:,3) + stheta*t(:,1));
return

