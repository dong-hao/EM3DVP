function save_idx()
% function for control model index writing
global model custom
pname = custom.projectname;
disp('start writing model files...');
Nx=size(model.x,1)-1;
Ny=size(model.y,1)-1;
Nz=size(model.z,1)-1;
[priorfile,priorpath] = uiputfile([pname 'model.idx'],'Save control model index file');
if isequal(priorfile,0) || isequal(priorpath,0)
    disp('user canceled...');
    return
else
    cd(priorpath)
    fid=fopen(fullfile(priorpath,priorfile),'w');
%   fprintf(fid,'# CONTROL MODEL INDEX WRITTEN BY EM3D @ %s\n',date);
    % reserved for future use
    fprintf(fid,'%i %i %i\n',Nx,Ny,Nz); %print X Y Z layers
    i=1;
    while(i<=Nz)
        for l=i+1:Nz 
            if model.fix(1:end-1,1:end-1,i)==model.fix(1:end-1,1:end-1,l) 
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
                fprintf(fid,'%d ',model.fix(j,k,i));
                % write out the prior model matrix
            end
            fprintf(fid,'\n');
        end
        i=l+1;
    end
    fprintf(fid,'\n\n\n\n');
    fprintf(fid,'10. 1. 100. 0.1  \n');
    fprintf(fid,'10. 1. 100. 0.1   ! used in data.3d\n');
    fclose(fid);
end

