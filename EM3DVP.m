% EM3DVP: a Visual Package for 3D Electromagnetic modeling and inversion
% Release Date:    2019-05-19
% Release Version: 2019beta1
% EM3D is a package of Matlab scripts. 
% The primary goal is to provide the users of EM methods an easy-to-use and
% (hopefully) comprehensive GUI to prepare the input model, data and 
% parameter files for the 3D inversion codes, as well as an interface to 
% plot the result models and responses. 
%
%--------------------something like a disclaimer-------------------------%
% I wrote this script just for the convenience of myself and people in our
% group. Those who want to try this script are free to use it on academic/
% educational case.  
% But of course, I cannot guarantee the script to be working properly and
% calculating correctly (although I wish so)
% `
% Have you any questions or suggestions, please feel free to contact me.
% (but don't you expect I will reply quickly!)
%------------------------------------------------------------------------%
%                               DONG Hao                                 %
%                          donghao@cugb.edu.cn                           %
%              China University of Geosciences, Beijing                  %
%------------------------------------------------------------------------%
% UNITS:     currently the internal unit here is the 'practical' one, as 
%            used in most survey files (mV/km/nT) for E/B
%            to convert to Ohm (used by Weerachai's code) one need to
%            multiply the values by ~796
%            to convert to V/m/T (used by ModEM) one need to multiply the
%            values by 0.001 
% SIGN:      currently the internal time harmonic sign convention is 
%            plus (+), or exp(i\omega t). Be careful when you
%            need to deal with data with (-) convention. 
% ERRORS:    currently the internal error here is standard deviation, it
%            worths noting that most of the time the survey files use 
%            variance 
%            
% note:      I decided to use a new system of version as the package name
%            keeps going longer... Now I simply call it EM3DVP...
%            Also, I tried to remove any rude words within my comments...
%            If you found some part of the comments uncomfortable, please
%            let me know.
%            
% updates:   fixed the gui call back problem in matlab 2013 and after -
%            hopefully the Mathworks won't come up with another witty
%            update that breaks my code again. 
%
%            added a new function to generate 'anistropic' structure by 
%            creating conductive/resistive stripes along x, y, or z axis.
%
%            added new functions to output "ZK" format model and data files
%------------------------------------------------------------------------%

function EM3DVP
% main menu selection script for EM3D
% you can only access the model editing and result ploting parts currently
% this will clear all existing data in current workspace
% 
clear;close all;
global default custom platform
% check the current platform
% Note: haven't tested this on Mac OSX yet.
%       If you have time reading this, test it!
cdir = pwd;
if ispc
    platform='windows';
    addpath(genpath([cdir '\src']),'-end');
elseif isunix
    platform='unixoid';
    addpath(genpath([cdir '/src']),'-end');
else
    platform='unknown';
    addpath(genpath([cdir '/src']),'-end');
end

ScriptVersion='EM3D2019beta1';
% set default settings for model parameters here
% i think i had better throw all those default settings into an
% configuration file(.cfg) to avoid the mess.
default.pwd=''; % store the current path location
default.x1=5000;% x initial length
default.x2=6;
default.x3=1.5;% x increasing step
default.y1=5000;% y initial length
default.y2=6;
default.y3=1.5;% y increasing step
default.z1=100;% z initial length
default.z2=20;% z increasing step
default.z3=1.1;
default.z4=10;
default.z5=1.5;
default.pmin=0.01;  % the minimum period to be used (in seconds)
default.pmax=1000;  % the longest period to be used (in seconds)
default.ppd=4;      % number of periods per decade
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
default.zone='31 N';
default.pauto=1;
default.lonR=115;
default.origin=0; % set flag for using origin or interploted data.
default.zero=[0 0 0]; % the zero reference point of the model
% set your default frequency tables here...
% here we use the Pheonix MTU-5 frequency table with 50 Hz filter.
% please use your own frequency table when needed.
default.ftable=...
[3.200001e+02  2.650000e+02  2.290000e+02  1.940000e+02  1.590000e+02  1.320000e+02 ...
 1.150000e+02  9.699999e+01  7.900001e+01  6.600000e+01  5.700000e+01  4.900000e+01 ...
 4.000000e+01  3.300000e+01  2.750000e+01  2.250000e+01  1.880000e+01  1.620000e+01 ...
 1.370000e+01  1.120000e+01  9.400000e+00  8.100000e+00  6.900000e+00  5.600000e+00 ...
 4.700000e+00  4.100000e+00  3.400000e+00  2.810000e+00  2.340000e+00  2.030000e+00 ...
 1.720000e+00  1.410000e+00  1.170000e+00  1.020000e+00  8.600000e-01  7.000000e-01 ...
 5.900000e-01  5.100000e-01  4.300000e-01  3.500000e-01  2.930000e-01  2.540000e-01 ...
 2.150000e-01  1.760000e-01  1.460000e-01  1.270000e-01  1.070000e-01  8.800000e-02 ...
 7.300000e-02  6.300001e-02  5.400000e-02  4.400000e-02  3.700000e-02  3.200000e-02 ...
 2.690000e-02  2.200000e-02  1.830000e-02  1.590000e-02  1.340000e-02  1.100000e-02 ...
 9.199999e-03  7.900001e-03  6.700001e-03  5.500000e-03  4.600001e-03  4.000001e-03 ...
 3.400000e-03  2.750000e-03  2.290000e-03  1.980000e-03  1.680000e-03  1.370000e-03 ...
 1.140000e-03  9.900002e-04  8.399999e-04  6.900000e-04  5.700000e-04  5.000001e-04 ...
 4.200000e-04  3.400000e-04  2.860000e-04  2.480000e-04  2.100000e-04  1.720000e-04 ...
 1.430000e-04  1.240000e-04  1.050000e-04  8.599997e-05  7.200003e-05  6.200001e-05 ...
 5.200001e-05  4.300002e-05  3.600000e-05  3.100000e-05  2.619999e-05  2.150000e-05]';
% currently 96 frequencies (for Dublin secret model)
% default.ftable=[100,...
%     55.5555555555556,31.25,17.8571428571429,10,...
%     5.55555555555556,3.125,1.78571428571429,1,...
%     0.555555555555556,0.3125,0.178571428571429,0.1,...
%     0.0555555555555556,0.03125,0.0178571428571429,0.01,...
%     0.00555555555555556,0.003125,0.00178571428571429,0.001,...
%     0.000555555555555556,0.0003125,0.000178571428571429,0.0001];
default.flist = 1:4:length(default.ftable);
default.sea = 0.3;
default.air = 1.0E10;
default.emax=0;
default.emin=0;
default.dselect=[1 1 1];
default.usef=0; % whether to use error floor
default.sloc0=[500 -1000 0];
default.sloc1=[-500 -1000 0];
default.stype='E';
default.scurrent=10;
default.sbackground=100;
choice=menu(ScriptVersion,'Generate input files','Plot results','Run!','Exit');
if choice==1
	%import data and generate input files for WSINV3DMT
    custom=default;
	create_model_gui;
	%set(gcf,'visible','on');
elseif choice==2
	%plot inversion results
    custom=default;
    create_resultviewer_gui;
elseif choice==3 % try running the fortran code
    
    if strcmp(platform, 'windows')
        [cfilename,cdir]=uigetfile({'*.exe','binary executable file(*.exe)';'*.*',...
            'All files(*.*)'},'Choose the executable for EM3D');
    else
        [cfilename,cdir]=uigetfile({'*.*',...
            'All files(*.*)'},'Choose the executable for EM3D');
    end
        if cfilename==0
            disp('user canceled...')
            return;
        end
        disp(['trying to hookup ',cfilename,'...'])
        cfile=[cdir,cfilename];
        disp('success!')
        disp('now starting forward/inversion process...')
        system(cfile)
        disp('calculation finished - we are all set.');    
    return
elseif choice==6 % sealed here
    create_freqeditor_gui();
    custom=default;
    choice2=menu('Select','Generate input files','Plot results','Exit');
    if choice2==1
        create_model_gui;
    elseif choice2==2
        create_resultviewer_gui;
    else
        return;
    end
else
    return;
end
return 

