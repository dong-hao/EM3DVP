function save_ZK_data(hObject,eventdata,handles)
% save data in Zhang Kun's 'data' format 
global custom nsite xyz data sitename model
% check if there's more than one sites in a single block first...
if check_site(xyz,model,nsite,sitename)>0
    return
end
% [x,y]=locate_site(xyz,model,nsite);
zmul=796; % convert from mv/Km/nT to Ohm
pname = custom.projectname;
ftable=custom.flist;
Nsite=nsite;
nfreq=length(ftable);
flags=[0 0 0 0 0 0 0 0 0 0 0 0];
if custom.zxxzyy==1
    flags([1 2 7 8])=1;
end
if custom.zxyzyx==1
    flags([3 4 5 6])=1;
end
if custom.txty==1
    flags([9 10 11 12])=1;
end
[datafile,datapath] = uiputfile([pname '.dat'],'Save ZK data file');
if isequal(datafile,0) || isequal(datapath,0)
    disp('user canceled...');
else
    cd(datapath)
    varxxyy=custom.zxxzyye/100;
    varxyyx=custom.zxyzyxe/100; 
    vartxty=custom.txtye/100; 
    fid=fopen(fullfile(datapath,datafile),'w');%set data file name here
    %=================write the file header===============%
    fprintf(fid,'%i \n',Nsite);
%     fprintf(fid,'%i ',x);
%     fprintf(fid,'\n');
%     fprintf(fid,'%i ',y);
%     fprintf(fid,'\n');
    %===============write data=============%
    for j = 1:Nsite
        fprintf(fid,'%i %i \n', nfreq,1);
        for i=1:nfreq
            fprintf(fid,'%8.5e ',1/data(j).freq(ftable(i)));
            if custom.usef==0
                fprintf(fid,'%+12.4e ',data(j).tf(ftable(i),[1 2 4 5 7 8 10 11])./zmul);
                fprintf(fid,'%+12.4e ',data(j).tf(ftable(i),[13 14 16 17]));
                fprintf(fid,'%+12.4e ',data(j).tf(ftable(i),[3 3 6 6 9 9 12 12])./zmul);
                fprintf(fid,'%+12.4e ',data(j).tf(ftable(i),[15 15 18 18]));
                fprintf(fid,'%i ', flags);
                fprintf(fid,'\n');
            else
                % take a varxxyy or varxyyx or vartxty percent variance. 
                zvar1=(data(j).tf(ftable(i),4))^2+(data(j).tf(ftable(i),5))^2;
                zvar2=(data(j).tf(ftable(i),7))^2+(data(j).tf(ftable(i),8))^2;
                zvarx=sqrt(zvar1)./zmul;zvary=sqrt(zvar2)./zmul;
                tvar=sqrt((data(j).tf(ftable(i),13))^2+(data(j).tf(ftable(i),14))^2);
                fprintf(fid,'%+12.4e ',data(j).tf(ftable(i),[1 2 4 5 7 8 10 11])./zmul); 
                fprintf(fid,'%+12.4e ',data(j).tf(ftable(i),[13 14 16 17]));
                vars=[ zvarx*varxxyy, zvarx*varxxyy, zvarx*varxyyx, zvarx*varxyyx, zvary*varxyyx,...
                       zvary*varxyyx, zvary*varxxyy, zvary*varxxyy, tvar*vartxty, tvar*vartxty,...
                       tvar*vartxty, tvar*vartxty];
                fprintf(fid,'%+12.4e ',vars);
                fprintf(fid,'%i ', flags);
                fprintf(fid,'\n');
            end
        end
    end
    fclose(fid);
    disp('data file written successfully...')
    sfid=fopen(fullfile(datapath,'sitename.dat'),'w');
    for i=1:nsite
        node=char(sitename{i});
        fprintf(sfid,'%s\n',node);
    end
    fclose(sfid);
    disp('site name file written successfully...')
end
refresh_status(hObject,eventdata,handles)
return

