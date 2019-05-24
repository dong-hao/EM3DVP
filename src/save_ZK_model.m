function save_ZK_model(hObject,eventdata,handles)
% function for exporting model for Zhang Kun's format
% please note in Zhang Kun 's format, z is the fastest changing element! 
% probably because that's developed from Mackie's 2D code - in which z
% changes faster than y.
% Here 
% z is faster than y, y is faster than x.
% S->N=X, W->E=Y, U->D =Z, the X1Y1Z1 cell will be the
% top, left, front mesh cell
global model custom
pname = custom.projectname;
disp('start writing ZK model files...');
Nx=size(model.x,1)-1;
Ny=size(model.y,1)-1;
Nz=size(model.z,1)-1;
X0=zeros(1,Nx);
Y0=zeros(1,Ny);
Z0=zeros(1,Nz);
for i=1:Nx
    X0(i)=model.x(i+1)-model.x(i);
end
for i=1:Ny
    Y0(i)=model.y(i+1)-model.y(i);
end
for i=1:Nz
    Z0(i)=model.z(i)-model.z(i+1);
end
% ================================================= %
[modelfile,modelpath] = uiputfile({'*.block','ZK3D model';...
          '*.*','All Files' },'Save model file',[pname '.block']);
if isequal(modelfile,0) || isequal(modelpath,0)
    disp('user canceled...');
    return
else
    cd(modelpath)
    fid=fopen(fullfile(modelpath,modelfile),'w');
    fprintf(fid,'%i %i %i \n',Nx,Ny,Nz);
    %please note that Xs and Ys here are reversed
    count=0;
    for i=1:Nx-1
        fprintf(fid,'%g ',X0(i));
        count=count+1;
        if count==10
            fprintf(fid,'\n');
            count=0;
        end
    end
    fprintf(fid,'%g\n',X0(Nx));
    count=0;
    for i=1:Ny-1
        fprintf(fid,'%g ',Y0(i));
        count=count+1;
        if count==10
            fprintf(fid,'\n');
            count=0;
        end
    end
    fprintf(fid,'%g\n',Y0(Ny));
    count=0;    
    for i=1:Nz-1
        fprintf(fid,'%g ',Z0(i));
        count=count+1;
        if  count==10
            fprintf(fid,'\n');
            count=0;
        end
    end
    fprintf(fid,'%g\n',Z0(Nz));
    fprintf(fid,'0 \n'); % use real value instead of index here
    for i=1:Nx
        for j=1:Ny
            for k=1:Nz
                fprintf(fid,'%12.4e ',model.rho(i,j,k));
            end
            fprintf(fid,'\n');
        end
    end
    fprintf(fid,'# \n');
    fprintf(fid,'# ksurf values \n');
    fprintf(fid,'# \n');
    for i=1:Nx
        for j=1:Ny
            for k=1:Nz
                fprintf(fid,'%i ',1);
            end
            fprintf(fid,'\n');
        end
    end    
    % from Anna's write_WS3D_model script
    if model.x(1)==-sum(X0)/2&&model.y(1)==-sum(Y0)/2
        origin = [-sum(X0)/2 -sum(Y0)/2 custom.zero(3)];
    else
        origin = [model.x(1) model.y(1) custom.zero(3)];
    end
    rotation = 0;
    fprintf(fid, '%d %d %d\n', origin);
    fprintf(fid, '%d\n', rotation);
    fclose(fid);
    disp('model file written successfuly...');
end
return

