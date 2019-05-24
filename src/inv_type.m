function InvType=inv_type()
global custom
% a simple function to tell which inversion type we have.
%            description for different components in different InvType
%            InvType = 1,6 : Zxx, Zxy, Zyx, Zyy
%            InvType = 2,7 : Zxy, Zyx
%            InvType = 3,8 : Tzx, Tzy
%            InvType = 4,9 : Zxy, Zyx, Tzx, Tzy
%            InvType = 5,10 : Zxx, Zxy, Zyx, Zyy, Tzx, Tzy
%------------------------------------------------------------------------%
xxyy=custom.zxxzyy;
xyyx=custom.zxyzyx;
txty=custom.txty;
if xyyx*xxyy*txty==1
    InvType=5;
elseif xyyx*txty==1
    InvType=4;
elseif xyyx*xxyy==1
    InvType=1;
elseif xyyx==1
    InvType=2;
elseif txty==1
    InvType=3;
else
    InvType=1;
end
return