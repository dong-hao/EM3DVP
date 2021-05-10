function batch_rhophs_output(hObject,eventdata,h)
% export rho/phs files for MT sites used in inversions
% in a format of "Freq Rhoxy Rhoxye Phsxy Phsxye Rhoyx Rhoyxe Phsyx Phsyxe" 
% to be used with external programs to plot... (probably GMT)
global nsite data resp sitename
% start calculating the normal onfes
prompt = {'Enter the tag string',...
    'Enter export mode (1 for data 2 for resp 3 for both)'};
dlg_title = 'Specify the responses you want to output';
num_lines = 2;
def = {'origin', '3'};
answer = inputdlg(prompt,dlg_title,num_lines,def);% dialog for freqencies input 
if isempty(answer)
    disp('user canceled...')
    return
end
tag = answer{1};
prefer=str2double(answer{2});
switch prefer
    case 1
        outdata = 1;
        outresp = 0;
    case 2
        outresp = 1;
        outdata = 0;
    case 3
        outdata = 1;
        outresp = 1;
    otherwise
        outdata = 0;
        outresp = 0;
end
outpath = pwd;
nfreq = data(1).nfreq;
rhophsmat = zeros(nfreq,9); % 1 freq 4 resp
set(h.selectionbox(3),'value',1);
for isite=1:nsite
    if outdata 
        rhophsmat(:,1)=data(isite).freq;
        rhophsmat(:,2)=data(isite).rho(:,3);
        rhophsmat(:,3)=data(isite).rho(:,4);
        rhophsmat(:,4)=data(isite).phs(:,3)/pi*180;
        rhophsmat(:,5)=data(isite).phs(:,4)/pi*180;
        rhophsmat(:,6)=data(isite).rho(:,5);
        rhophsmat(:,7)=data(isite).rho(:,6);
        rhophsmat(:,8)=data(isite).phs(:,5)/pi*180;
        rhophsmat(:,9)=data(isite).phs(:,6)/pi*180;
        outfile=[char(sitename{isite}) '-' tag '.data'];
        fid = fopen(fullfile(outpath, outfile), 'w');
        fprintf(fid,'%f %g %g %g %g %g %g %g %g\n',rhophsmat');
        % a little trick to avoid THE LOOP HELL...
        fclose(fid);
        disp(['data file ' char(sitename{isite}) ' outputed to current directory'])
    end
    if outresp
        rhophsmat(:,1)=resp(isite).freq;
        rhophsmat(:,2)=resp(isite).rho(:,3);
        rhophsmat(:,3)=resp(isite).rho(:,4);
        rhophsmat(:,4)=resp(isite).phs(:,3)/pi*180;
        rhophsmat(:,5)=resp(isite).phs(:,4)/pi*180;
        rhophsmat(:,6)=resp(isite).rho(:,5);
        rhophsmat(:,7)=resp(isite).rho(:,6);
        rhophsmat(:,8)=resp(isite).phs(:,5)/pi*180;
        rhophsmat(:,9)=resp(isite).phs(:,6)/pi*180;
        outfile=[char(sitename{isite}) '-' tag '.resp'];
        fid = fopen(fullfile(outpath, outfile), 'w');
        fprintf(fid,'%f %g %g %g %g %g %g %g %g\n',rhophsmat');
        % a little trick to avoid THE LOOP HELL...
        fclose(fid);
        disp(['resp file ' char(sitename{isite}) ' outputed to current directory'])
    end
end
return

% function export_xyzv(hObject, event, filename,x,y,z,v)
% % export xyzv files in "X Y Z logRHO" format
% % to be used with external programs to plot... (probably GMT)
% Nx=length(x)-1;
% Ny=length(y)-1;
% Nz=length(z)-1;
% t=1;
% xyzv=zeros(4,Nx*Ny*Nz);
% for k=1:Nz
%     for j=1:Ny
%         for i=Nx:-1:1
%             xyzv(1,t)=-(x(i)+x(i+1))/2;
%             xyzv(2,t)=(y(j)+y(j+1))/2;
%             xyzv(3,t)=(z(k)+z(k+1))/2;
%             xyzv(4,t)=v(i,j,k);
%             t=t+1;
%         end
%     end
% end
% xyzpath=pwd;
% xyzfile=[filename,'.xyzv'];
% if isequal(xyzfile,0) || isequal(xyzpath,0)
%     disp('user canceled...');
% else
%     disp('exporting xyzv...')
%     fid=fopen(fullfile(xyzpath,xyzfile),'w');
%     fprintf(fid,'%f %f %f %g\n',reshape(xyzv,4*Nx*Ny*Nz,1));
%     % a little trick to avoid THE LOOP HELL...
%     fclose(fid);
% end
% return

