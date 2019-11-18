function save_cov()
% function for exporting covariance file for ModEM (optional)
% FOR NOW one can just specify ONE UNIFORM COV for each direction, X, Y, Z
% As I am too lazy to intergrate a more intutive interface... 
% one has to MANUALLY change his/her own file to get different covs for
% different layers and to MANUALLY add exceptions to selected meshes. 
global model custom
pname = custom.projectname;
disp('start writing cov file...');
Nx=size(model.x,1)-1;
Ny=size(model.y,1)-1;
Nz=size(model.z,1)-1;
[priorfile,priorpath] = uiputfile([pname '.cov'],'Save model covariance file');
if isequal(priorfile,0) || isequal(priorpath,0)
    disp('user canceled...');
    return
else
    cd(priorpath)
    fid=fopen(fullfile(priorpath,priorfile),'w');
    fprintf(fid,'+-----------------------------------------------------------------------------+\n');
    fprintf(fid,'| This file defines model covariance for a recursive autoregression scheme.   |\n');
    fprintf(fid,'| The model space may be divided into distinct areas using integer masks.     |\n');
    fprintf(fid,'| Mask 0 is reserved for air; mask 9 is reserved for ocean. Smoothing between |\n');
    fprintf(fid,'| air, ocean and the rest of the model is turned off automatically. You can   |\n');
    fprintf(fid,'| also define exceptions to override smoothing between any two model areas.   |\n');
    fprintf(fid,'| To turn off smoothing set it to zero. This header is 16 lines long.         |\n');
    fprintf(fid,'| 1. Grid dimensions excluding air layers (Nx, Ny, NzEarth)                   |\n');
    fprintf(fid,'| 2. Smoothing in the X direction (NzEarth real values)                       |\n');
    fprintf(fid,'| 3. Smoothing in the Y direction (NzEarth real values)                       |\n');
    fprintf(fid,'| 4. Vertical smoothing (1 real value)                                        |\n');
    fprintf(fid,'| 5. Number of times the smoothing should be applied (1 integer >= 0)         |\n');
    fprintf(fid,'| 6. Number of exceptions (1 integer >= 0)                                    |\n');
    fprintf(fid,'| 7. Exceptions in the form e.g. 2 3 0. (to turn off smoothing between 3 & 4) |\n');
    fprintf(fid,'| 8. Two integer layer indices and Nx x Ny block of masks, repeated as needed.|\n');
    fprintf(fid,'+-----------------------------------------------------------------------------+\n');
    fprintf(fid,'');
    % Cov by default, now reserved for future use
    % Cx=0.3;Cy=0.3;Cz=0.3;
    prompt = {'X direction',...
        'Y direction:',...
        'Z direction:'};
    dlg_title = 'Enter the the model covariance...';
    num_lines = 3;
    def = {'0.3','0.3','0.3'};
    answer = inputdlg(prompt,dlg_title,num_lines,def);% dialog for cov
    if isempty(answer)
        disp('user canceled...')
        return
    end
    Cx=str2double(answer{1});
    Cy=str2double(answer{2});
    Cz=str2double(answer{3}); % now get them from user input
    fprintf(fid,'\n %i %i %i\n',Nx,Ny,Nz); % print X Y Z layers
    fprintf(fid,'\n'); %
    count=0;
    for l=1:Nz 
        fprintf(fid,'%5.2f ',Cx); %        
        count=count+1;
        if count==10
            fprintf(fid,'\n');
            count=0;
        end
    end
    fprintf(fid,'\n'); %
    count=0;
    for l=1:Nz
        fprintf(fid,'%5.2f ',Cy); %
        count=count+1;
        if count==10
            fprintf(fid,'\n');
            count=0;
        end                
    end
    fprintf(fid,'\n'); %
    fprintf(fid,'%5.2f\n',Cz); %    
    fprintf(fid,'\n\n');
    fprintf(fid,'1 \n\n'); %number of the number of smooth to do 
    fprintf(fid,'0 \n\n'); %number of exceptions 
    i=1;
    % the mask policy is a little bit different in ModEM (comparing with
    % wsinv3d, which is more straight forward)
    % The only place you can find some information is the ambigious 
    % 16-line header up there...
    % "0"s are reserved for air,"9"s are reserved for ocean, while "1-8"s
    % can be customized to distingush different part of models. 
    % I WILL HAVE TO REWRITE ALL THE MODEL MASKING CODE IN THE SCRIPT TO
    % ADAPT THIS POLICY.
    % FOR NOW, I WILL JUST TREAT ALL MASKED AREA AS "9" (OCEAN, WHICH IS
    % OFFICALLY SUPPORTED) OR "1" 
    % AND ALL UNMASKED AREA AS "1".
    fixmat=model.fix;
    while(i<=Nz)
        for l=i+1:Nz 
            if isequal(fixmat(1:end-1,1:end-1,i),fixmat(1:end-1,1:end-1,l)) 
                % see if the next layer is the same with this layer
                continue
            else
                % if not, start a new section to write
                l=l-1;
                break
            end
        end
        fprintf(fid,'%d %d\n',i,l); %
        for j=Nx:-1:1
            for k=1:Ny
                fprintf(fid,'%d ',fixmat(j,k,i));
                % write out the model mask matrix
            end
            fprintf(fid,'\n');
        end
        i=l+1;
    end
    fclose(fid);
    disp('...done!')
end