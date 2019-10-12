function Zr=TFrotate(Z, alpha)
% a silly function to rotate impedances and tipper by an angle of alpha
% Z is a nfreq by 12 vector (or a nfreq by 18 vector if tipper is
% included.)
% Z: zxxr, zxxi, zxxe, zxyr, zxyi, zxye, zyxr, zyxi, zyxe zyyr, zyyi, zyye
% alpha: the rotation angle in arc.
% a positive alpha would rotates the Z tensor clockwise

Zr=Z;
if mod(alpha,2*pi)<0.0001
    return
end
nfreq=length(Z);
t=zeros(nfreq,4);
t(:,1)=complex(Z(:,1),Z(:,2));
t(:,2)=complex(Z(:,4),Z(:,5));
t(:,3)=complex(Z(:,7),Z(:,8));
t(:,4)=complex(Z(:,10),Z(:,11));
e(:,1)=Z(:,3);
e(:,2)=Z(:,6);
e(:,3)=Z(:,9);
e(:,4)=Z(:,12);
t=Trotate(t,alpha);
e=Trotate(e,alpha);
% disp(['rotating ' num2str(alpha) ' arc'])
Zr(:,1)=real(t(:,1));
Zr(:,2)=imag(t(:,1));
Zr(:,3)=e(:,1);
Zr(:,4)=real(t(:,2));
Zr(:,5)=imag(t(:,2));
Zr(:,6)=e(:,2);
Zr(:,7)=real(t(:,3));
Zr(:,8)=imag(t(:,3));
Zr(:,9)=e(:,3);
Zr(:,10)=real(t(:,4));
Zr(:,11)=imag(t(:,4));
Zr(:,12)=e(:,4);
if size(Z,2)==18
    % if we have tipper in Z matrix
    Zr(:,13)=Z(:,13)*cos(alpha)-Z(:,16)*sin(alpha);
    Zr(:,14)=Z(:,14)*cos(alpha)-Z(:,17)*sin(alpha);
    Zr(:,15)=Z(:,15)*cos(alpha)-Z(:,18)*sin(alpha);
    Zr(:,16)=Z(:,16)*cos(alpha)+Z(:,13)*sin(alpha);
    Zr(:,17)=Z(:,17)*cos(alpha)+Z(:,14)*sin(alpha);
    Zr(:,18)=Z(:,18)*cos(alpha)+Z(:,15)*sin(alpha);
else
    return
end
return

