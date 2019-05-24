function export_rms(hObject, event, filename, freq, latR, lonR)
% export xyz files of rms distribution for sites in "LON LAT RMS" format
% to be used with external programs to plot... (probably GMT)

global nsite xyz sitename
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
xyr=xyz; % array to store X Y and RMS
xyr(:,1)=1000*xyr(:,1)+x0;
xyr(:,2)=1000*xyr(:,2)+y0;
for k=1:nsite
        xyr(k,3)=calc_rms(k, freq, 'xyyx');
end

% convert the site locations (Northing Easting) back to degrees
[latm,lonm]=utm2deg(xyr(:,2),xyr(:,1),zone1,lonR);
xyrm=xyr;
xyrm(:,1)=lonm;
xyrm(:,2)=latm;
xyrm(:,3)=xyr(:,3);
xyrpath=pwd;
xyrfile=[filename,'.xyr'];
if isequal(xyrfile,0) || isequal(xyrpath,0)
    disp('user canceled...');
else
    fid=fopen(fullfile(xyrpath,xyrfile),'w');
    for i = 1:nsite
        fprintf(fid,'%s %f %f %g\n',char(sitename{i}),xyrm(i,1),xyrm(i,2),xyrm(i,3));
    end
    % a little trick to avoid THE LOOP HELL...
    fclose(fid);
    disp('RMS file outputed to current directory')
end
return

%%======================plot results====================%%
%      devoted to plot pseudo sections                   %
%%======================================================%%
