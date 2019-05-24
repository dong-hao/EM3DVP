function save_startup()
% set startup file here
% please note that you should leave the first and third line blank if you
% are using an old (single cpu) version of WSINV3DMT
global custom
pname = custom.projectname;
s_prompt = {'inversion type(leave empty for old version):',...
    'data file:',...
    'error floor for Z(leave empty for old version): (%)',...
    'error floor for T(leave empty for old version): (%)',...  
    'output file:',...
    'initial model file:',...    
    'priori model file(leave empty for default):',...
    'control model index(leave empty for default):',...
    'Target R.M.S.:','Max number of iterations:',...
    'Model length scale(leave empty for default):',...
    'Lagrange info(leave empty for default):',...
    'Error tol. level(leave empty for default):'};
s_titles  = 'Enter Startup Parameters';
s_def= {'1',[pname 'data'],'5','10',pname,[pname 'model'],'','',...
    '1.','5','5 0.1 0.1 0.1','10 0.5',''};
def_lim =inputdlg(s_prompt,s_titles,1,s_def);
if isempty(def_lim)
    disp('user canceled...')
    return
end
for spa=7:13
    if isempty(def_lim{spa})
        def_lim{spa}='default';
    end
end
line0=['INVERSION_TYPE      ',def_lim{1}];
line1=['DATA_FILE           ',def_lim{2}];
line2=['MIN_ERROR_Z         ',def_lim{3}];
line3=['MIN_ERROR_T         ',def_lim{4}];
line4=['OUTPUT_FILE         ',def_lim{5}];
line5=['INITIAL_MODEL_FILE  ',def_lim{6}];
line6=['PRIOR_MODEL_FILE    ',def_lim{7}];
line7=['CONTROL_MODEL_INDEX ',def_lim{8}];
line8=['TARGET_RMS          ',def_lim{9}];
line9=['MAX_NO_ITERATION    ',def_lim{10}];
line10=['MODEL_LENGTH_SCALE  ',def_lim{11}];
line11=['LAGRANGE_INFO       ',def_lim{12}];
line12=['ERROR_TOL_LEVEL     ',def_lim{13}];
lines={line0;line1;line2;line3;line4;line5;line6;line7;line8;line9;line10;line11;line12};
[cfilename,cdir] = uiputfile('startup','Save startup');
cd(cdir)
fid=fopen([cdir,cfilename],'w');
for poi=1:13
    if ~isempty(def_lim{poi})
        fprintf(fid,'%s\n',lines{poi});
    end
end
fclose(fid);
disp('startup file written successfully...')
return

