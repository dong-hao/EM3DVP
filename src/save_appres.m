function save_appres()
% save data in 'plain' data format for the convinience of data exchange
% apparent resistivities and phases from each site are saved
global custom nsite xyz data
ftable=custom.flist;
Nsite=nsite;
nfreq=length(ftable);
[datafile,datapath] = uiputfile({'*.asc',... 
    'ascii Files (*.asc)'; '*.*','All Files (*.*)'},...
    'Save Apparent res and phase file');
if isequal(datafile,0) || isequal(datapath,0)
    disp('user canceled...');
else
    cd(datapath)
    fid=fopen(fullfile(datapath,datafile),'w');%set data file name here
    fprintf(fid,'# x   y  period rhoxx phixx rhoxy phixy rhoyx phiyx rhoyy phiyy\n');
    for isite=1:Nsite
        % calculation from impedance to rho and phi
        freq=data(isite).freq(ftable);
        zxxr=796*data(isite).tf(ftable,1);
        zxxi=-796*data(isite).tf(ftable,2);
        zxyr=796*data(isite).tf(ftable,4);
        zxyi=-796*data(isite).tf(ftable,5);
        zyxr=796*data(isite).tf(ftable,7);
        zyxi=-796*data(isite).tf(ftable,8);
        zyyr=796*data(isite).tf(ftable,10);
        zyyi=-796*data(isite).tf(ftable,11);
        rhoxx=(zxxr.^2+zxxi.^2)./freq./5;
        phsxx=atan(zxxi./zxxr)*180/pi;
        for kki=1:nfreq
            if zxxi(kki)>0 && zxxr(kki)>0
                %phsxx(kki)=phsxx(kki)-180;
            elseif zxxi(kki)<0 && zxxr(kki)<0
                phsxx(kki)=phsxx(kki)-180;
            end
        end
        rhoxy=(zxyr.^2+zxyi.^2)./freq./5;
        phsxy=atan(zxyi./zxyr)*180/pi;
        for kki=1:nfreq
            if zxyi(kki)>0 && zxyr(kki)>0
                %phsxy
            elseif zxyi(kki)<0 && zxyr(kki)<0
                phsxy(kki)=phsxy(kki)-180;
            end
        end
        rhoyx=(zyxr.^2+zyxi.^2)./freq./5;
        phsyx=atan(zyxi./zyxr)*180/pi;
        for kki=1:nfreq
            if zyxi(kki)>0 && zyxr(kki)>0
                %phsyx
            elseif zyxi(kki)<0 && zyxr(kki)<0
                phsyx(kki)=phsyx(kki)-180;
            end
        end
        rhoyy=(zyyr.^2+zyyi.^2)./freq./5;
        phsyy=atan(zyyi./zyyr)*180/pi;
        for kki=1:nfreq
           if zyyi(kki)>0 && zyyr(kki)>0
                %phsyy
           elseif zyyi(kki)<0 && zyyr(kki)<0
                   phsyy(kki)=phsyy(kki)-180;
            end
        end
        for ifreq=1:nfreq % start writing data
            fprintf(fid,'% 8.3f % 8.3f % e % e % 8.3f % e % 8.3f % e % 8.3f % e % 8.3f\n',...
                xyz(isite,1),xyz(isite,2),1/data(isite).freq(ftable(ifreq)),...
                rhoxx(ifreq),phsxx(ifreq),...
                rhoxy(ifreq),phsxy(ifreq),...
                rhoyx(ifreq),phsyx(ifreq),...
                rhoyy(ifreq),phsyy(ifreq));
        end
    end
    fclose(fid);
end
return

