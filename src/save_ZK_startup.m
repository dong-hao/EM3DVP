function save_ZK_startup(hObject,eventdata,handles)
% set startup file here
% the format for the startup is a turmoil to me. 
% basicly it is one line for identifier and one line for parameter.
% with many 
global custom nsite xyz model
pname = custom.projectname;
[x,y]=locate_site(xyz,model,nsite);
s_prompt = {'root name for project:',...
    'inverting for Z: (y/n)',...
    'inverting for T: (y/n)',...  
    'data file:',...
    'initial model file:',...    
    'regularization:(1 for laplacian, 2 for gradient)',...
    'Lagrange factor(lambda):',...
    'Source location (x,y,z)',... 
    'Source current: (A)',...
    'Source dipole length: (m)',...
    'Source direction: (1 for x, 2 for y, 3 for z)'};
s_titles  = 'Enter Startup Parameters';
% try to determine which direction is the source...
lx = abs(custom.sloc0(1)-custom.sloc1(1));
ly = abs(custom.sloc0(2)-custom.sloc1(2));
lz = abs(custom.sloc0(3)-custom.sloc1(3));
if lx > ly && lx > lz % x direction
    dipole=lx;
    direction=1;
elseif ly > lx && ly > lz % y direction
    dipole=ly;
    direction=2;
else % z direction
    dipole=lz;
    direction=3;
end

if custom.dselect(1)==1||custom.dselect(2)==1
    usez='y';
else
    usez='n';
end
if custom.dselect(3)==1
    uset='y';
else
    uset='n';
end
s_def= {pname,usez,uset,[pname '.dat'],[pname '.mod'],'1','3',...
    [num2str(custom.sloc0(1)+custom.sloc1(1)), ' ', ...
     num2str(custom.sloc0(2)+custom.sloc1(2)), ' ', ...
     num2str(custom.sloc0(3)+custom.sloc1(3))], ... 
    num2str(custom.scurrent),num2str(dipole),...
    num2str(direction)};
def_lim =inputdlg(s_prompt,s_titles,1,s_def);
if isempty(def_lim)
    disp('user canceled...')
    return
end
[cfilename,cdir] = uiputfile('a','Save startup');
cd(cdir)
fid=fopen([cdir,cfilename],'w');
fprintf(fid,['# startup file for ', def_lim{1}, '\n']);
fprintf(fid,'ROOT:\n');
fprintf(fid,'%s \n',def_lim{1});
fprintf(fid,'Z DATA(yes-y;no-n;):\n');
fprintf(fid,'%s \n',def_lim{2});
fprintf(fid,'T DATA(yes-y;no-n;):\n');
fprintf(fid,'%s \n',def_lim{3});
fprintf(fid,'INITIAL MODEL FILE: \n');
fprintf(fid,'%s \n',def_lim{5});
fprintf(fid,'REGULARIZATION OPERATOR: \n');
fprintf(fid,'%s \n',def_lim{6});
fprintf(fid,'LAGRANGE FACTOR(LAMBDA): \n');
fprintf(fid,'%s \n',def_lim{7});
fprintf(fid,'INVERSION ERROR FLOOR: \n');
fprintf(fid,'Z: \n');
fprintf(fid,'%f \n',custom.zxyzyxe/100);
fprintf(fid,'INPUT EXISTING MODEL FILE OR NOT(yes-y;no-n;):\n');
fprintf(fid,'n\n');
fprintf(fid,'INPUT EXISTING MODEL FILE OR NOT(yes-y;no-n;):\n');
fprintf(fid,'n\n');
fprintf(fid,'STATION LOCATION IN THE MESH (IN MESH NUMBERING AS 1 2):\n');
fprintf(fid,'TM: \n');
fprintf(fid,'%i %i\n',x,y);
fprintf(fid,'expandx y z small than 3 3 2 \n');
fprintf(fid,'1\n');
fprintf(fid,'1\n');
fprintf(fid,'1\n');
fprintf(fid,'stations expand coherience <1');
fprintf(fid,'0.0\n');
fprintf(fid,'0.\n');
fprintf(fid,'c <1  <1  >1\n');
fprintf(fid,'1\n');
fprintf(fid,'1\n');
fprintf(fid,'1\n');
fprintf(fid,'good\n');
fprintf(fid,'0\n');
fprintf(fid,'SOURCE PARAMETERS:\n');
sloc = str2num(def_lim{8});
fprintf(fid,'%f \n',sloc(1));
fprintf(fid,'%f \n',sloc(2));
fprintf(fid,'%s \n',def_lim{9});
fprintf(fid,'%s \n',def_lim{10});
if direction==1
    fprintf(fid,'%i \n',1);
    fprintf(fid,'%i \n',0);
else
    fprintf(fid,'%i \n',1);
    fprintf(fid,'%i \n',0);
end
fprintf(fid,'END');
fclose(fid);
disp('startup file written successfully...')
refresh_status(hObject,eventdata,handles)
return

