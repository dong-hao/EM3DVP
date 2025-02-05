function save_modemdata(hObject,eventdata,handles)
% Check site first!
global xyz model nsite sitename custom  data location
if check_site(xyz,model,nsite,sitename)>0
    return
else
    % save data in ModEM 'list' data format
    % get a few parameters
    pname = custom.projectname;
    ftable=custom.flist;
    %%debug
    InvType=inv_type();
    Nsite=nsite;
    nfreq=length(ftable);
    elev=zeros(nsite,1);
    fixed=model.fix(1:end-1,1:end-1,1);
    clat = custom.centre(1);
    clon = custom.centre(2);
    if any(fixed(:)~=0)
        % we are running a inversion with topography/bathymetry
        if custom.zero(3)==0 % we don't have topography, only bathymetry
            elev=-xyz(:,3);
            elev=sinkstn(elev,model.x,model.y,model.z,model.rho,model.fix,...
                xyz,custom.air,custom.sea);
            elev(elev<0)=0;
        else % we (probably) have topography.
            elev=-xyz(:,3);
            [elev,rho,fix]=sinkstn(elev,model.x,model.y,model.z,model.rho,model.fix,...
                xyz,custom.air, custom.sea);
            model.rho = rho;
            model.fix = fix;
            %sweepstn(elev,xyz,model.x,model.y,model.z,model.rho,model.fix);
            % elev=elev+custom.zero(3);
            custom.zero(3) = 0; 
        end
    else
        % we are probably not running a inversion with topography
        % set the elev to zeros
    end
    [datafile,datapath] = uiputfile({'*.dat','ModEM data files (*.dat)'; '*.*','All Files (*.*)'},...
        'Save ModEM data file', [pname '.dat']);
    if isequal(datafile,0) || isequal(datapath,0)
        disp('user canceled...');
        return
    else
        % filling the standard deviation matrix
        stderr=ones(Nsite,nfreq,6);
        for isite=1:Nsite
            for ifreq=1:nfreq
                stderr(isite,ifreq,1)=data(isite).tf(ftable(ifreq),3);
                stderr(isite,ifreq,2)=data(isite).tf(ftable(ifreq),6);
                stderr(isite,ifreq,3)=data(isite).tf(ftable(ifreq),9);
                stderr(isite,ifreq,4)=data(isite).tf(ftable(ifreq),12);
                stderr(isite,ifreq,5)=data(isite).tf(ftable(ifreq),15);
                stderr(isite,ifreq,6)=data(isite).tf(ftable(ifreq),18);
            end
        end
        errmat=stderr;
        if custom.usef==0 % use original (standard) error
            disp('use original std error');
        else % use error floor
            varxxyy=custom.zxxzyye/100;
            varxyyx=custom.zxyzyxe/100; 
            vartxty=custom.txtye/100; 
            for isite=1:Nsite
                for ifreq=1:nfreq
                    % zvar=sqrt((data(isite).tf(ifreq,4))^2+(data(isite).tf(ifreq,5))^2+...
                    %    (data(isite).tf(ifreq,7))^2+(data(isite).tf(ifreq,8))^2);
                    zvar1=sqrt((data(isite).tf(ifreq,4))^2+(data(isite).tf(ifreq,5))^2);
                    zvar2=sqrt((data(isite).tf(ifreq,7))^2+(data(isite).tf(ifreq,8))^2);
                    tvar=1; % note that we use an absolute value as error for T
                    % tvar=sqrt((data(isite).tf(ifreq,13))^2+(data(isite).t
                    % f(ifreq,14))^2);
                    if zvar1*varxxyy>stderr(isite,ifreq,1)
                        errmat(isite,ifreq,1)=zvar1*varxxyy;
                    end
                    if zvar1*varxyyx>stderr(isite,ifreq,2)
                        errmat(isite,ifreq,2)=zvar1*varxyyx;
                    end
                    if zvar2*varxyyx>stderr(isite,ifreq,3)
                        errmat(isite,ifreq,3)=zvar2*varxyyx;
                    end
                    if zvar2*varxxyy>stderr(isite,ifreq,4)
                        errmat(isite,ifreq,4)=zvar2*varxxyy;
                    end
                    if tvar*vartxty>stderr(isite,ifreq,5)
                        errmat(isite,ifreq,5)=tvar*vartxty;
                    end
                    if tvar*vartxty>stderr(isite,ifreq,6)
                        errmat(isite,ifreq,6)=tvar*vartxty;
                    end
                end
            end
        end
        emap=ones(Nsite,nfreq,6);
        for isite=1:Nsite
            emap(isite,:,:)=data(isite).emap(:,[3 6 9 12 15 18]);
        end
        errmat(emap==0)=errmat(emap==0).*1e10;
        % errmat(errmat==0)=1e10;
        cd(datapath)
        fid=fopen(fullfile(datapath,datafile),'w');%set data file name here
        %=================write the file header===============%
%         lon=custom.lonR;
%         lat=custom.latR;
        fprintf(fid,'# %s ModEM INITIAL DATA WRITTEN BY EM3DVP @ %s \n',...
            pname,date);
        fprintf(fid,'# Period(s) Code GG_Lat GG_Lon X(m) Y(m) Z(m) Component Real Imag Error \n');
        switch InvType
            case 1
                fprintf(fid,'> Full_Impedance \n'); %xyyx + xxyy
            case 2
                fprintf(fid,'> Off_Diagonal_Impedance \n'); %xyyx
            case 3
                fprintf(fid,'> Full_Vertical_Components\n'); %txty
            case 4
                fprintf(fid,'> Off_Diagonal_Impedance \n'); % xyyx + txty
            case 5
                fprintf(fid,'> Full_Impedance \n'); % xyyx + xxyy + txty
        end
        fprintf(fid,'> exp(+i\\omega t)\n');
        fprintf(fid,'> [mV/km]/[nT] \n');
        fprintf(fid,'> 0.00 \n');
        fprintf(fid,'> %5.2f %5.2f \n', clon, clat); %geographic (Lon Lat) coodinate 
        fprintf(fid,'> %i %i\n',nfreq,Nsite);
        %=================start writing impedances===============%
        for s=1:Nsite % site loop
            if sum(emap(s,:,:)) < 1
                fprintf('ERROR: all transfer functions for site %s are missing!\n',sitename{s});
                error('please consider removing this site, if not needed')
            end
            for f=1:nfreq % freq loop
                if InvType==2||InvType==4 % only off-diagonal elements are needed for Z
                    if emap(s,f,2) == 0 
                        disp(['skipping masked data @ site #',num2str(s),' freq #',num2str(f)])
                    else
                        fprintf(fid,'%12.4E \t %s \t %f \t %f \t %f \t %f \t %f \t ZXY \t %12.4E \t %12.4E \t %12.4E \n',...
                            1/data(s).freq(ftable(f)), char(sitename{s}), location(s,1),location(s,2),...
                            xyz(s,1),xyz(s,2),elev(s),data(s).tf(ftable(f),[4 5]),errmat(s,ftable(f),2));
                    end
                    if emap(s,f,3) == 0 
                        disp(['skipping masked data @ site #',num2str(s),' freq #',num2str(f)])
                    else
                        fprintf(fid,'%12.4E \t %s \t %f \t %f \t %f \t %f \t %f \t ZYX \t %12.4E \t %12.4E \t %12.4E \n',...
                            1/data(s).freq(ftable(f)), char(sitename{s}), location(s,1),location(s,2),...
                            xyz(s,1),xyz(s,2),elev(s),data(s).tf(ftable(f),[7 8]),errmat(s,ftable(f),3));
                    end
                elseif InvType==1||InvType==5 % full impedance for Z
                    if emap(s,f,1) == 0 
                        disp(['skipping masked data @ site #',num2str(s),' freq #',num2str(f)])
                    else
                        fprintf(fid,'%12.4E \t %s \t %f \t %f \t %f \t %f \t %f \t ZXX \t %12.4E \t %12.4E \t %12.4E \n',...
                            1/data(s).freq(ftable(f)), char(sitename{s}), location(s,1),location(s,2),...
                            xyz(s,1),xyz(s,2),elev(s),data(s).tf(ftable(f),[1 2]),errmat(s,ftable(f),1));
                    end
                    if emap(s,f,2) == 0 
                        disp(['skipping masked data @ site #',num2str(s),' freq #',num2str(f)])
                    else
                        fprintf(fid,'%12.4E \t %s \t %f \t %f \t %f \t %f \t %f \t ZXY \t %12.4E \t %12.4E \t %12.4E \n',...
                            1/data(s).freq(ftable(f)), char(sitename{s}), location(s,1),location(s,2),...
                            xyz(s,1),xyz(s,2),elev(s),data(s).tf(ftable(f),[4 5]),errmat(s,ftable(f),2));
                    end
                    if emap(s,f,3) == 0 
                        disp(['skipping masked data @ site #',num2str(s),' freq #',num2str(f)])
                    else
                        fprintf(fid,'%12.4E \t %s \t %f \t %f \t %f \t %f \t %f \t ZYX \t %12.4E \t %12.4E \t %12.4E \n',...
                            1/data(s).freq(ftable(f)), char(sitename{s}), location(s,1),location(s,2),...
                            xyz(s,1),xyz(s,2),elev(s),data(s).tf(ftable(f),[7 8]),errmat(s,ftable(f),3));
                    end
                    if emap(s,f,4) == 0 
                        disp(['skipping masked data @ site #',num2str(s),' freq #',num2str(f)])
                    else
                        fprintf(fid,'%12.4E \t %s \t %f \t %f \t %f \t %f \t %f \t ZYY \t %12.4E \t %12.4E \t %12.4E \n',...
                            1/data(s).freq(ftable(f)), char(sitename{s}), location(s,1),location(s,2),...
                            xyz(s,1),xyz(s,2),elev(s),data(s).tf(ftable(f),[10 11]),errmat(s,ftable(f),4));
                    end
                end
            end
        end
        if InvType==3  % start writing tippers
            for s=1:Nsite % site loop
                for f=1:nfreq % freq loop
                    if emap(s,f,5) == 0 
                        disp(['skipping masked data @ site #',num2str(s),' freq #',num2str(f)])
                    else
                        fprintf(fid,'%12.4E \t %s \t %f \t %f \t %f \t %f \t %f \t TX \t %12.4E \t %12.4E \t %12.4E \n',...
                            1/data(s).freq(ftable(f)), char(sitename{s}), location(s,1),location(s,2),...
                            xyz(s,1),xyz(s,2),elev(s),data(s).tf(ftable(f),13),data(s).tf(ftable(f),14),errmat(s,ftable(f),5));
                    end
                    if emap(s,f,6) == 0 
                        disp(['skipping masked data @ site #',num2str(s),' freq #',num2str(f)])
                    else
                        fprintf(fid,'%12.4E \t %s \t %f \t %f \t %f \t %f \t %f \t TY \t %12.4E \t %12.4E \t %12.4E \n',...
                            1/data(s).freq(ftable(f)), char(sitename{s}), location(s,1),location(s,2),...
                            xyz(s,1),xyz(s,2),elev(s),data(s).tf(ftable(f),16),data(s).tf(ftable(f),17),errmat(s,ftable(f),6));
                    end
                end
            end
        elseif InvType>=4 % we have tipper head to write.
            %=================write the file header (for tipper)===============%
            fprintf(fid,'# %s ModEM INITIAL DATA WRITTEN BY EM3DVP @ %s\n',pname,date);
            fprintf(fid,'# Period(s) Code GG_Lat GG_Lon X(m) Y(m) Z(m) Component Real Imag Error\n');
            fprintf(fid,'> Full_Vertical_Components\n'); %Tipper
            fprintf(fid,'> exp(+i\\omega t)\n');
            fprintf(fid,'> []\n');
            fprintf(fid,'> 0.00\n');
            fprintf(fid,'> %5.2f %5.2f \n', clon, clat); %geographic (Lon Lat) coodinate 
            fprintf(fid,'> %i %i\n',nfreq,Nsite);
            %=================start writing tippers===============%
            for s=1:Nsite % site loop
                for f=1:nfreq % freq loop
                    if emap(s,f,5) == 0 
                        disp(['skipping masked data @ site #',num2str(s),' freq #',num2str(f)])
                    else
                        fprintf(fid,'%12.4E \t %s \t %f \t %f \t %f \t %f \t %f \t TX \t %12.4E \t %12.4E \t %12.4E \n',...
                            1/data(s).freq(ftable(f)), char(sitename{s}), location(s,1),location(s,2),...
                            xyz(s,1),xyz(s,2),elev(s),data(s).tf(ftable(f),13),data(s).tf(ftable(f),14),errmat(s,ftable(f),5));
                    end
                    if emap(s,f,6) == 0 
                        disp(['skipping masked data @ site #',num2str(s),' freq #',num2str(f)])
                    else
                        fprintf(fid,'%12.4E \t %s \t %f \t %f \t %f \t %f \t %f \t TY \t %12.4E \t %12.4E \t %12.4E \n',...
                            1/data(s).freq(ftable(f)), char(sitename{s}), location(s,1),location(s,2),...
                            xyz(s,1),xyz(s,2),elev(s),data(s).tf(ftable(f),16),data(s).tf(ftable(f),17),errmat(s,ftable(f),6));
                    end
                end
            end
        end
    end
    fclose(fid);
    disp('ModEM data file written successfully...')
end
return

