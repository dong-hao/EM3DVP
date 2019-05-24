function quit_this(hObject,eventdata,h)
% function quit
% a (almost) universal quit dialog function
% for most of guis in EM3D
queststr=get(h,'name');
yorn=questdlg('Are you sure to leave?',queststr,'yes','no','yes');
if strcmp(yorn,'yes')
    close(h);
else
    return;
end
return;

