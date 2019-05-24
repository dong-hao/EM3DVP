function save_model()
% function for exporting model for Weerachai's format/ModEM format
% please note the Weerachai's coordindate is:
% S->N=X, W->E=Y, U->D =Z, the X1Y1Z1 cell will be the
% top, left, front mesh cell
global model custom
pname = custom.projectname;
disp('start writing model files...');
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
mrho=model.rho;
% mrho(mrho>20)=200;
% ============== zero point shift =========== %
% Please note that if the x or y blocks are NOT symmetric(of length),
% the model space coordinate will be SHIFTED.
% for example, if x blocks are 100 50 50 100(which is symmetric),
% since WSINVMT3D take the centre of the profile as the zero point
% the zero point would be the boundary of the 2nd and 3rd block
% But if x blocks are 150 50 50 100, the zero point will be at the 
% centre of the 2nd block.
% Here we modify the outmost blocks 
% (the first and the last)a little to make the profile symmetric in length
% xshift=(abs(model.x(1))-sum(X0)/2);
% X0(1)=X0(1)-xshift;
% X0(end)=X0(end)+xshift;
% yshift=(abs(model.y(1))-sum(Y0)/2);
% Y0(1)=Y0(1)-yshift;
% Y0(end)=Y0(end)+yshift;
% ================================================= %
[modelfile,modelpath] = uiputfile({'*.ws;*.mod','WS3D model';...
          '*.*','All Files' },'Save model file',[pname '.ws']);
if isequal(modelfile,0) || isequal(modelpath,0)
    disp('user canceled...');
    return
else
    cd(modelpath)
    fid=fopen(fullfile(modelpath,modelfile),'w');
    fprintf(fid,'# INITIAL MODEL WRITTEN BY EM3D @ %s\n',date);
    fprintf(fid,'%i %i %i %i\n',Nx,Ny,Nz,0);
    %please note that Xs and Ys here are reversed
    count=0;
    for i=1:Nx-1
        fprintf(fid,'%g ',X0(i));
        count=count+1;
        if abs(floor(log10(X0(i+1)))-floor(log10(X0(i))))>=1
            fprintf(fid,'\n');
            count=0;
        elseif count==10
            fprintf(fid,'\n');
            count=0;
        end
    end
    fprintf(fid,'%g\n',X0(Nx));
    count=0;
    for i=1:Ny-1
        fprintf(fid,'%g ',Y0(i));
        count=count+1;
        if abs(floor(log10(Y0(i+1)))-floor(log10(Y0(i))))>=1
            fprintf(fid,'\n');
            count=0;
        elseif count==10
            fprintf(fid,'\n');
            count=0;
        end
    end
    fprintf(fid,'%g\n',Y0(Ny));
    count=0;    
    for i=1:Nz-1
        fprintf(fid,'%g ',Z0(i));
        count=count+1;
        if abs(floor(log10(Z0(i+1)))-floor(log10(Z0(i))))>=1
            fprintf(fid,'\n');
            count=0;
        elseif count==10
            fprintf(fid,'\n');
            count=0;
        end
    end
    fprintf(fid,'%g\n',Z0(Nz));
    for k=1:Nz
        for j=1:Ny
            for i=Nx:-1:1
                fprintf(fid,'%12.4e ',mrho(i,j,k));
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

