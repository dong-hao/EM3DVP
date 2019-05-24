function projectname=set_project_name()
prompt = 'please specify a project name';
titles  = 'input project name';
default={'survey_01'};
dlg =inputdlg(prompt,titles,3,default);
if isempty(dlg)
    disp('user canceled...')
    disp('use default project name...')
    projectname='survey_01';
    return
end
projectname=dlg{1};
return

