function project_sites(hObject,eventdata,handles)
% a simple project script 
% will convert the WGS84 system latitude-longitude coordinates (in degrees)
% to UTM easting-northing coordinates.
% the script deg2utm is needed.
% can "force" projecting WGS84 coordinate to a specified reference
% longitude, which might be useful if you are dealing with a data set
% covering more than one UTM zone.
% name changed to "project_sites" as Matlab seems to have its own project
% function recently.
global nsite location xyz custom;
nsite=size(location,1);
xyz=zeros(nsite,3);   
xyz(:,3)=location(:,3);   % Elevation
lat=location(:,1);
lon=location(:,2);
if (isfield(handles, 'project')) % update the project method
    if get(handles.project(1), 'value') == 1 % fixed
        custom.pauto = 0;
    elseif get(handles.project(2), 'value') == 1 % auto
        custom.pauto = 1; 
    else
        custom.pauto = 1;
    end
end
if custom.pauto == 1 %automatically find a center point for projection
    % first let's check if we are in a small region (i.e. local
    % exploration)
    if max(lon)-min(lon) < 1 || max(lat)-min(lat) < 1 
        latR = median(lat);
        lonR = median(lon);
    else
        latR = round(median(lat));
        lonR = round(median(lon));
    end
    central(1)=latR;
    central(2)=lonR;
	[y,x]=deg2utm(lat,lon,lonR); % force project to lonR
%     disp('UTM coordinates(Easting, Northing)')
%     disp(y')
%     disp(x')
%     disp(zone');
    [y0,x0,zone]=deg2utm(central(1),central(2),lonR);
    custom.pauto = 1;
elseif custom.pauto == 0 %fixed 
    if (isfield(handles, 'project')) % update the central point
        latR = str2double(get(handles.project(3),'string'));
        lonR = str2double(get(handles.project(4),'string')); 
        custom.centre(1) = latR;
        custom.centre(2) = lonR;
    else % just project
        latR = custom.centre(1);
        lonR = custom.centre(2);
    end
    central(1)=latR;
    central(2)=lonR;
    [y,x]=deg2utm(lat,lon,lonR); % force project to lonR
    % for debug
%     disp('UTM coordinates(Easting, Northing)')
%     disp(y')
%     disp(x')
%     disp(zone');
    [y0,x0,zone]=deg2utm(central(1),central(2),lonR);
    %[y0,x0]=deg2tranmerc(central(1),central(2),latR,lonR); % force project to lonR latR
    custom.pauto = 0;
else
    latR = min(lat)+(max(lat)-min(lat))/2;
    lonR = min(lon)+(max(lon)-min(lon))/2;
    central(1)=latR;
    central(2)=lonR;
    [y,x]=deg2utm(lat,lon,lonR); % call deg2utm to project your sites to UTM.
    % for debug 
%     disp('UTM coordinates(Easting, Northing)')
%     disp(y')
%     disp(x')
%     disp(zone');
    [y0,x0,zone]=deg2utm(central(1),central(2),lonR);
    %zone0=median(zone);
    %lonR=(zone0-1)*6+3;
    custom.pauto = 0;
end
zone=num2str(zone);
zone(end+1)=' ';
nzone=(floor((central(1)+90)/8))+65;
% note: 65 is the decimacial ascii code of charactor 'A'
if nzone>72 % omitting the "I" zone
    nzone=nzone+1;
    if nzone>78 % omitting the "O" zone
        nzone=nzone+1;
    end
end
zone(end+1)=char(nzone);
custom.centre=central; %store the central point.
custom.lonR=lonR;
custom.zone=zone;
fprintf('central point coordinates(Easting: %f, Northing: %f)\n',y0,x0);

y=y-y0;
x=x-x0; % set the centre point to zero.
xyz(:,1)=x;
xyz(:,2)=y;
plot_site(hObject,eventdata,handles,'noname')
return;
