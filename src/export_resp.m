function export_resp(hObject,eventdata,filename,f,latR,lonR, opt)
% export data/response/residual files for MT sites used in inversions
% in a format of "LON LAT Data_A Data_B Resp_A Resp_B Residual_A Residual_B" 
% to be used with external programs to plot... (probably GMT)
global nsite xyz data resp
% start calculating the normal ones
[y0,x0,zone]=deg2utm(latR,lonR,lonR);
zone=num2str(zone);
zone(end+1)=' ';
nzone=(floor((latR+90)/8))+65;
% note: 65 is the decimacial ascii code of charactor 'A'
if nzone>72 % omitting the "I" zone
    nzone=nzone+1;
    if nzone>78 % omitting the "O" zone
        nzone=nzone+1;
    end
end
zone(end+1)=char(nzone);
zone1='    ';
for i=1:nsite
    zone1(i,:)=zone;
end
xyv=xyz; % array to store X Y and value
xyv(:,1)=1000*xyv(:,1)+x0;
xyv(:,2)=1000*xyv(:,2)+y0;
errorfloor=0.05;
EF1=0.434.*errorfloor;
EF2=0.286.*errorfloor;
for isite=1:nsite
    zxxr=data(isite).tf(f,1);
    zxxi=data(isite).tf(f,2);
    zxyr=data(isite).tf(f,4);
    zxyi=data(isite).tf(f,5);
    zyxr=data(isite).tf(f,7);
    zyxi=data(isite).tf(f,8);
    zyyr=data(isite).tf(f,10);
    zyyi=data(isite).tf(f,11);
    txr=data(isite).tf(f,13);
    txi=data(isite).tf(f,14);
    tyr=data(isite).tf(f,16);
    tyi=data(isite).tf(f,17);
    rxxr=resp(isite).tf(f,1);
    rxxi=resp(isite).tf(f,2);
    rxyr=resp(isite).tf(f,4);
    rxyi=resp(isite).tf(f,5);
    ryxr=resp(isite).tf(f,7);
    ryxi=resp(isite).tf(f,8);
    ryyr=resp(isite).tf(f,10);
    ryyi=resp(isite).tf(f,11);
    rtxr=resp(isite).tf(f,13);
    rtxi=resp(isite).tf(f,14);
    rtyr=resp(isite).tf(f,16);
    rtyi=resp(isite).tf(f,17);
    per=1/data(isite).freq(f);
    switch opt
        case 1 %xx
            Va1=(zxxr.^2+zxxi.^2)*per/5;
            Vb1=atan2(zxxi,zxxr)*180/pi;
            Va2=(rxxr.^2+rxxi.^2)*per/5;
            Vb2=atan2(rxxi,rxxr)*180/pi;
            idx=3;
        case 2 %yy
            Va1=(zyyr.^2+zyyi.^2)*per/5;
            Vb1=atan2(zyyi,zyyr)*180/pi;
            Va2=(ryyr.^2+ryyi.^2)*per/5;
            Vb2=atan2(ryyi,ryyr)*180/pi;
            idx=12;
        case 3 %xy
            Va1=(zxyr.^2+zxyi.^2)*per/5;
            Vb1=atan2(zxyi,zxyr)*180/pi;
            Va2=(rxyr.^2+rxyi.^2)*per/5;
            Vb2=atan2(rxyi,rxyr)*180/pi;
            idx=6;
        case 4 %yx
            Va1=(zyxr.^2+zyxi.^2)*per/5;
            Vb1=atan2(zyxi,zyxr)*180/pi+180;
            Va2=(ryxr.^2+ryxi.^2)*per/5;
            Vb2=atan2(ryxi,ryxr)*180/pi+180;
            idx=9;
        case 5 %tx
            Va1=txr;
            Vb1=txi;
            Va2=rtxr;
            Vb2=rtxi;
            idx=15;
        case 6 %ty
            Va1=tyr;
            Vb1=tyi;
            Va2=rtyr;
            Vb2=rtyi;            
            idx=18;
        otherwise
            errormsg=['specified mode ' num2str(opt) ' cannot be recognized...'];
            errordlg(errormsg,'Mode error');
            return
    end
    Va1=log10(Va1);
    Va2=log10(Va2);
    Var=(Va1-Va2)/EF1;
    Vbr=(Vb1-Vb2)/180/EF2;
    xyv(isite,3)=Va1;
    xyv(isite,4)=Vb1;
    xyv(isite,5)=Va2;
    xyv(isite,6)=Vb2;
    xyv(isite,7)=Var;
    xyv(isite,8)=Vbr;
    if data(isite).tf(f,idx)>1e6
        xyv(isite,[3 4 5 6 7 8])=NaN;
    end
end
% convert the site locations (Northing Easting) back to degrees
[latm,lonm]=utm2deg(xyv(:,2),xyv(:,1),zone1,lonR);
xyvm=xyv;
xyvm(:,1)=lonm;
xyvm(:,2)=latm;
xyvm(:,3:8)=xyv(:,3:8);
xyvpath=pwd;
xyvfile=[filename,'.xyv'];
if isequal(xyvfile,0) || isequal(xyvpath,0)
    disp('user canceled...');
else
    fid=fopen(fullfile(xyvpath,xyvfile),'w');
    switch opt
        case 1
            fprintf(fid,'LON LAT Rhoxxo Phaxxo Rhoxxr Phaxxr Rhores Phares \n');
        case 2
            fprintf(fid,'LON LAT Rhoyyo Phayyo Rhoyyr Phayyr Rhores Phares \n');
        case 3
            fprintf(fid,'LON LAT Rhoxyo Phaxyo Rhoxyr Phaxyr Rhores Phares \n');
        case 4
            fprintf(fid,'LON LAT Rhoyxo Phayxo Rhoyxr Phayxr Rhores Phares \n');
        case 5
            fprintf(fid,'LON LAT Txro Txio Txrr Txir Txrres Txires \n');
        case 6
            fprintf(fid,'LON LAT Tyro Tyio Tyrr Tyir Tyrres Tyires \n');
    end
    fprintf(fid,'%f %f %g %g %g %g %g %g\n',xyvm');
    % a little trick to avoid THE LOOP HELL...
    fclose(fid);
    disp('data file outputed to current directory')
end
return

% function export_xyzv(hObject, event, filename,x,y,z,v)
% % export xyzv files in "X Y Z logRHO" format
% % to be used with external programs to plot... (probably GMT)
% Nx=length(x)-1;
% Ny=length(y)-1;
% Nz=length(z)-1;
% t=1;
% xyzv=zeros(4,Nx*Ny*Nz);
% for k=1:Nz
%     for j=1:Ny
%         for i=Nx:-1:1
%             xyzv(1,t)=-(x(i)+x(i+1))/2;
%             xyzv(2,t)=(y(j)+y(j+1))/2;
%             xyzv(3,t)=(z(k)+z(k+1))/2;
%             xyzv(4,t)=v(i,j,k);
%             t=t+1;
%         end
%     end
% end
% xyzpath=pwd;
% xyzfile=[filename,'.xyzv'];
% if isequal(xyzfile,0) || isequal(xyzpath,0)
%     disp('user canceled...');
% else
%     disp('exporting xyzv...')
%     fid=fopen(fullfile(xyzpath,xyzfile),'w');
%     fprintf(fid,'%f %f %f %g\n',reshape(xyzv,4*Nx*Ny*Nz,1));
%     % a little trick to avoid THE LOOP HELL...
%     fclose(fid);
% end
% return

