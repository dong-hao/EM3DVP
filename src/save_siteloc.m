function save_siteloc(hObject,eventdata,handles)
% a function to save current site locations as a file 
% to be used in third party applications (e.g. GMT)
global nsite sitename location
[datafile,datapath] = uiputfile({'*.stn','site location files (*.stn)'; '*.*','All Files (*.*)'},...
        'Save ModEM data file', 'sites.stn');
if isequal(datafile,0) || isequal(datapath,0)
    disp('user canceled...');
    return
else
    fid = fopen([datapath datafile],'w');
    for isite = 1:nsite
        fprintf(fid,'%s\t%f\t%f\t%f\n',char(sitename{isite}),location(isite,1),...
            location(isite,2),location(isite,3));
    end
    fclose(fid);
end

return