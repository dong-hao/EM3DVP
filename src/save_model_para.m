function save_model_para(custom)
% a function to save the parameters of model and data configuration for EM3D 
% script bundle. The default name of the file is EM3D.cfg
% some would find it useful to save the parameters for a certain inversion
% configuration and load it for future use. 
% 
fid=fopen('EM3D.cfg','w');
fprintf(fid, 'x block width: %i \n', custom.x1);
fprintf(fid, 'x padding blocks: %i \n', custom.x2);
fprintf(fid, 'x padding step: %f \n', custom.x3);
fprintf(fid, 'y block width: %i \n', custom.y1);
fprintf(fid, 'y padding blocks: %i \n', custom.y2);
fprintf(fid, 'y padding step: %f \n', custom.y3);
fprintf(fid, 'z first layer thickness: %i \n', custom.z1);
fprintf(fid, 'z incore step: %f \n', custom.z2);
fprintf(fid, 'z incore layers: %i \n', custom.z3);
fprintf(fid, 'z padding step: %f \n', custom.z4);
fprintf(fid, 'z padding layers: %i \n', custom.z5);
fprintf(fid, 'min period: %f \n', custom.pmin);
fprintf(fid, 'max period: %f \n', custom.pmax);
default.pmin=0.01;  % please note that the "fmax" here actually refers 
                    % to a minimum period (in seconds)
default.pmax=1000; % while this "fmin" refers to the longest period
default.ppd=4;
default.zxxzyy=1;   % use off-diagonal impedance
default.zxyzyx=1;   % use diagonal impedance
default.txty=1;     % use tipper
default.zxxzyye=20; % error of off-diagonal impedance
default.zxyzyxe=10; % error of diagonal impedance
default.txtye=20;   % error of tipper
default.rhomin=1;   % min resistivity in colormap
default.rhomax=10000; % max resistivity in colormap 
default.rho=100;    % default model resistivity
default.currentX=1; % current x index
default.currentY=1; % current y index
default.currentZ=1; % current z index
default.currentsite=1; % current site
default.projectname='default';
default.init=0;
default.font_weight='normal';
% default.flist=[18 22 26 30 34 38 42 46 50 54 58 62 66 70 74 80];
default.ratio=[1 1 1]; % set h/v ratio here for daspect.;
default.rotate=0;
default.centre=[35,115];
default.lonR=115;
return 

