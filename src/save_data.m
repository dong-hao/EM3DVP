function save_data(hObject,eventdata,handles)
% save data in WSINV3DMT 'data' format as explained in the WSINV3DMT manual
global custom nsite xyz data sitename model
% check if there's more than one sites in a single block first...
if check_site(xyz,model,nsite,sitename)>0
    return
end
zmul=796; % convert from mv/Km/nT to Ohm
pname = custom.projectname;
ftable=custom.flist;
N_tensor=0;
if get(handles.data(1),'value')==1
    N_tensor=N_tensor+4;
end
if get(handles.data(2),'value')==1
    N_tensor=N_tensor+4;
end
if get(handles.data(3),'value')==1
    N_tensor=N_tensor+4;
end
Nsite=nsite;
nfreq=length(ftable);
[datafile,datapath] = uiputfile([pname 'data'],'Save data file');
if isequal(datafile,0) || isequal(datapath,0)
    disp('user canceled...');
else
    cd(datapath)
    fid=fopen(fullfile(datapath,datafile),'w');%set data file name here
    %=================write the file header===============%
%   fprintf(fid,'# WSINVMT3D INITIAL DATA WRITTEN BY EM3D @ %s\n',date);
    fprintf(fid,' %i %i %i\n',Nsite,nfreq,N_tensor);
    fprintf(fid,'%s\n','Station_Location: N-S');
    for s=1:Nsite
        fprintf(fid,'%g ',xyz(s,1));
        if mod(s,10)==0||s==Nsite; fprintf(fid,'\n'); end;
    end
    fprintf(fid,'%s\n','Station_Location: E-W');
    for s=1:Nsite
        fprintf(fid,'%g ',xyz(s,2));
        if mod(s,10)==0||s==Nsite; fprintf(fid,'\n'); end;
    end
    if N_tensor==12
        %===============write data=============%
        for i = 1:nfreq
            fprintf(fid,'DATA_Period: %12.4g\n', 1/data(1).freq(ftable(i)));
            for j=1:Nsite       
                fprintf(fid,'%12.4e ',data(j).tf(ftable(i),[1 2 4 5 7 8 10 11 13 14 16 17])./zmul);
                fprintf(fid,'\n');
            end
        end
        %===============write data error=============%
        for i = 1:nfreq
            fprintf(fid,'ERROR_Period: %12.4g\n',1/data(1).freq(ftable(i)));
            for j=1:Nsite
            if get(handles.data(8),'value')==1
               fprintf(fid,'%12.4e ',data(j).tf(ftable(i),[3 3 6 6 9 9 12 12 15 15 18 18])./zmul);% keep the var
            elseif get(handles.data(7),'value')==1
                varxxyy=str2num(get(handles.data(4),'string'))/100;                
                varxyyx=str2num(get(handles.data(5),'string'))/100; 
                vartxty=str2num(get(handles.data(6),'string'))/100; 
                % take a varxxyy or varxyyx or vartxty percent variance.
                zvar1=(data(j).tf(ftable(i),4))^2+(data(j).tf(ftable(i),5))^2;
                zvar2=(data(j).tf(ftable(i),7))^2+(data(j).tf(ftable(i),8))^2;
                % zvar=sqrt(zvar1+zvar2)./zmul;
                zvarx=sqrt(zvar1)./zmul;zvary=sqrt(zvar2)./zmul;
                tvar=sqrt((data(j).tf(ftable(i),13))^2+(data(j).tf(ftable(i),14))^2);
                fprintf(fid,'%12.4e %12.4e %12.4e %12.4e %12.4e %12.4e %12.4e %12.4e %12.4e %12.4e %12.4e %12.4e',...
                    zvarx*varxxyy, zvarx*varxxyy, zvarx*varxyyx, zvarx*varxyyx, zvary*varxyyx,...
                    zvary*varxyyx, zvary*varxxyy, zvary*varxxyy, tvar*vartxty, tvar*vartxty,...
                    tvar*vartxty, tvar*vartxty);            
            end
                fprintf(fid,'\n');
            end
        end
        %=======write scale ERMAP_Period========% 
        for i = 1:nfreq
            fprintf(fid,'ERMAP_Period:%10.4g\n',1/data(1).freq(ftable(i)));
            for j=1:Nsite
                fprintf(fid,'%g ',data(j).emap(ftable(i),[3 3 6 6 9 9 12 12 15 15 18 18]));
                fprintf(fid,'\n');
            end
        end    
    elseif (N_tensor==8)
        if get(handles.data(3),'value')==1
            %===============write data=============%
            for i = 1:nfreq
                fprintf(fid,'DATA_Period:%10.4g\n', 1/data(1).freq(ftable(i)));
                for j=1:Nsite       
                    fprintf(fid,'%12.4e ',data(j).tf(ftable(i),[4 5 7 8 13 14 16 17])./zmul);
                    fprintf(fid,'\n');
                end
            end
            %===============write data error=============%
            for i = 1:nfreq
                fprintf(fid,'ERROR_Period:%10.4g\n',1/data(1).freq(ftable(i)));
                for j=1:Nsite
                if get(handles.data(8),'value')==1
                   fprintf(fid,'%12.4e ',data(j).tf(ftable(i),[6 6 9 9 15 15 18 18])./zmul);% keep the var
            %        fprintf(fid,'%12.4e ',sprintercell{j}(ftable(i),[4 4 7 7 10 10 13
            %        13]).^.5);% default
                elseif get(handles.data(7),'value')==1
                    vartxty=str2num(get(handles.data(6),'string'))/100;                
                    varxyyx=str2num(get(handles.data(5),'string'))/100;                      
                    % take a varxxyy or varxyyx percent variance.
                    zvar1=(data(j).tf(ftable(i),4))^2+(data(j).tf(ftable(i),5))^2;
                    zvar2=(data(j).tf(ftable(i),7))^2+(data(j).tf(ftable(i),8))^2;
                    zvarx=sqrt(zvar1)./zmul;zvary=sqrt(zvar2)./zmul;
                    fprintf(fid,'%12.4e %12.4e %12.4e %12.4e %12.4e %12.4e %12.4e %12.4e ',...
                        zvarx*varxyyx, zvarx*varxyyx, zvary*varxyyx, zvary*varxyyx,...
                        vartxty, vartxty, vartxty, vartxty);
                end
                    fprintf(fid,'\n');
                end
            end
            %=======write scale ERMAP_Period========% 
            for i = 1:nfreq
                fprintf(fid,'ERMAP_Period:%10.4g\n',1/data(1).freq(ftable(i)));
                for j=1:Nsite
                    fprintf(fid,'%g ',data(j).emap(ftable(i),[6 6 9 9 15 15 18 18]));
                    fprintf(fid,'\n');
                end
            end    
        else 
            %===============write data=============%
            for i = 1:nfreq
                fprintf(fid,'DATA_Period:%10.4g\n', 1/data(1).freq(ftable(i)));
                for j=1:Nsite       
                    fprintf(fid,'%12.4e ',data(j).tf(ftable(i),[1 2 4 5 7 8 10 11])./zmul);
                    fprintf(fid,'\n');
                end
            end

            %===============write data error=============%
            for i = 1:nfreq
                fprintf(fid,'ERROR_Period:%10.4g\n',1/data(1).freq(ftable(i)));
                for j=1:Nsite
                if get(handles.data(8),'value')==1
                   fprintf(fid,'%12.4e ',data(j).tf(ftable(i),[3 3 6 6 9 9 12 12])./zmul);% keep the var
            %        fprintf(fid,'%12.4e ',sprintercell{j}(ftable(i),[4 4 7 7 10 10 13
            %        13]).^.5);% default
                elseif get(handles.data(7),'value')==1
                    varxxyy=str2num(get(handles.data(4),'string'))/100;                
                    varxyyx=str2num(get(handles.data(5),'string'))/100;                      
                    % take a varxxyy or varxyyx percent variance.
                    zvar1=(data(j).tf(ftable(i),4))^2+(data(j).tf(ftable(i),5))^2;
                    zvar2=(data(j).tf(ftable(i),7))^2+(data(j).tf(ftable(i),8))^2;
                    % zvar=sqrt(zvar1+zvar2)./zmul;
                    zvarx=sqrt(zvar1)./zmul;zvary=sqrt(zvar2)./zmul;
                    fprintf(fid,'%12.4e %12.4e %12.4e %12.4e %12.4e %12.4e %12.4e %12.4e ',...
                        zvarx*varxxyy, zvarx*varxxyy, zvarx*varxyyx, zvarx*varxyyx, zvary*varxyyx,...
                        zvary*varxyyx, zvary*varxxyy, zvary*varxxyy);
                end
                    fprintf(fid,'\n');
                end
            end
            %=======write scale ERMAP_Period========% 
            for i = 1:nfreq
                fprintf(fid,'ERMAP_Period:%10.4g\n',1/data(1).freq(ftable(i)));
                for j=1:Nsite
                    fprintf(fid,'%g ',data(j).emap(ftable(i),[3 3 6 6 9 9 12 12]));
                    fprintf(fid,'\n');
                end
            end    
        end
    else% if N_tensor==4
        %===============write data=============%
        for i = 1:nfreq
            fprintf(fid,'DATA_Period:%10.4g\n', 1/data(1).freq(ftable(i)));
            for j=1:Nsite       
                fprintf(fid,'%12.4e ',data(j).tf(ftable(i),[4 5 7 8])./zmul);
                fprintf(fid,'\n');
            end
        end
        %===============write data error=============%
        for i = 1:nfreq
            fprintf(fid,'ERROR_Period:%10.4g\n',1/data(1).freq(ftable(i)));
            for j=1:Nsite
                if get(handles.data(8),'value')==1
                   fprintf(fid,'%12.4e ',data(j).tf(ftable(i),[6 6 9 9])./zmul);% keep the var
                elseif get(handles.data(7),'value')==1
                    varxyyx=str2num(get(handles.data(5),'string'))/100;
                    zvar1=(data(j).tf(ftable(i),4))^2+(data(j).tf(ftable(i),5))^2;
                    zvar2=(data(j).tf(ftable(i),7))^2+(data(j).tf(ftable(i),8))^2;
                    zvarx=sqrt(zvar1)./zmul;zvary=sqrt(zvar2)./zmul;
                    fprintf(fid,'%12.4e %12.4e %12.4e %12.4e',...
                        zvarx*varxyyx, zvarx*varxyyx, zvary*varxyyx, zvary*varxyyx);
                end
                fprintf(fid,'\n');
            end
        end
        %=======write scale ERMAP_Period========% 
        for i = 1:nfreq
            fprintf(fid,'ERMAP_Period:%10.4g\n',1/data(1).freq(ftable(i)));
            for j=1:Nsite
                fprintf(fid,'%g ',data(j).emap(ftable(i),[6 6 9 9]));
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
