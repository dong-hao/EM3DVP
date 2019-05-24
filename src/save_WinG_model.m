function save_WinG_model()
% Write Randy Mackie's mesh output file (winGlink 3d format model)
% Please Note that winglink uses coordinates different from
% Weerachai's coordindate.
% i.e. N->S =Y, W->E =X, U->D =Z, the X1Y1Z1 cell will be the
% top, left, rear mesh cell
global model custom
Na=10;%set default air layers, it seems that Mackie's code use 10 for default
disp('start writing model files...');
Nx=size(model.y,1)-1;
Ny=size(model.x,1)-1;
Nz=size(model.z,1)-1;
X0=zeros(1,Nx);
Y0=zeros(1,Ny);
Z0=zeros(1,Nz);
for i=1:Nx
    X0(i)=model.y(i+1)-model.y(i);
end
for i=1:Ny
    Y0(i)=model.x(i+1)-model.x(i);
end
for i=1:Nz
    Z0(i)=model.z(i)-model.z(i+1);
end
[modelfile,modelpath] = uiputfile({'*.out','winGlink output files';...
    '*.*','All Files (*.*)'}...
    ,'load winglink *.out file');
if isequal(modelfile,0) || isequal(modelpath,0)
    disp('user canceled...');
else
    fid=fopen(fullfile(modelpath,modelfile),'w');
    fprintf(fid,'%i %i %i %i %s\n',Nx,Ny,Nz,Na,'VALUE');
    count=0;
    for i=1:Nx-1
        fprintf(fid,'%g ',round(X0(i)));
        count=count+1;
        if count==5
            fprintf(fid,'\n');
            count=0;
        end
    end
    fprintf(fid,'%g\n',round(X0(Nx)));
    count=0;
    for i=1:Ny-1
        fprintf(fid,'%g ',round(Y0(i)));
        count=count+1;
        if count==5
            fprintf(fid,'\n');
            count=0;
        end
    end
    fprintf(fid,'%g\n',round(Y0(Ny)));
    count=0;
    for i=1:Nz-1
        fprintf(fid,'%g ',round(Z0(i)));
        count=count+1;
        if count==5
            fprintf(fid,'\n');
            count=0;
        end
    end
    fprintf(fid,'%g\n',round(Z0(Nz)));
    for layer=1:Nz
        fprintf(fid,'%i\n',layer);
        for i=Ny:-1:1
            fprintf(fid,'%g ',model.rho(i,:,layer));
            fprintf(fid,'\n');
        end
    end
    fprintf(fid,'%s\n','WSINV3DMT');
    fprintf(fid,'%s\n','  LALALA  (site name)');
    fprintf(fid,'%s\n','             1             1  (i j block numbers)');
    %These coordinates have to be coorect otherwise stations would not be
    %on the mesh
    prompt = {'Enter real world coordinates(X):','Enter real world coordinates:(Y)','Enter mesh rotation:'};
    dlg_title = 'Read these numbers from *.out winglink exported original model';
    num_lines = 1;
    % try to calculate the real world coordinates for block 1,1,1;
    % 
    [x,y]=deg2utm(custom.centre(1),custom.centre(2));
    x1=model.x(end-1)+x;
    y1=model.y(1)+y;
    def = {num2str(x1),num2str(y1),'90'};
    answer = inputdlg(prompt,dlg_title,num_lines,def);
    coord=['  ',answer{1},'   ',answer{2},'  (real world coordinates)'];
    rota_syon=['             ',answer{3},'  (rotation)'];
    fprintf(fid,'%s\n',coord);
    fprintf(fid,'%s\n',rota_syon);
    fprintf(fid,'%s\n','             0  (top elevation)');
    fclose(fid);
    disp('model file written successfuly...');
end
return

