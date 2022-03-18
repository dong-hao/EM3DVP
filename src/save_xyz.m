function save_xyz(hObject,eventdata,handles)
% a function to save current axis(!) as xyz file
% current axis must have a (2d) surface object on it
% x: horizonal y: vertical z: resistivity(log)
% add a function to output the site location on the profile to a single
% dat file
if ~isfield(handles,'selectionbox')% see if we have multiple axes
    i=1;
elseif get(handles.selectionbox(1),'value')==1
    i=1;
elseif get(handles.selectionbox(2),'value')==1
    i=2;
elseif get(handles.selectionbox(3),'value')==1
    i=3;
else 
    msgbox('weird...')
    return
end 

h=findobj(handles.axis(i),'type','surface');% find current object
if isempty(h)
    msgbox('nothing to save...');
    return;
end
xx=get(h,'xdata');
yy=get(h,'zdata');
cc=get(h,'cdata');
[m, n]=size(xx);
xyz=zeros(3,m*n);
xyz(1,:)=reshape(xx,1,m*n);
xyz(2,:)=reshape(yy,1,m*n);
xyz(3,:)=reshape(cc,1,m*n);
[xyzfile,xyzpath] = uiputfile({'*.xyz',... 
    'xyz Files (*.xyz)'; '*.*','All Files (*.*)'},...
    'Save xyz file(of current figure) for plotting in other applications');
if isequal(xyzfile,0) || isequal(xyzpath,0)
    disp('user canceled...');
    return
else
    fid=fopen(fullfile(xyzpath,xyzfile),'w');
    fprintf(fid,'%i %i %g\n',reshape(xyz,3*m*n,1));
    % a little trick to avoid THE LOOP HELL...
    fclose(fid);
end
hsite=findobj(handles.axis(i),'type','line');
if ~isempty(hsite)
    stype=length(hsite);
    if stype == 1 % see if this comes from an old Matlab plot parameter
        nos=length(hsite.XData);
    else
        nos=stype;
    end
    siteloc=zeros(nos,3);
    for i=1:nos
        if stype==1
            siteloc(i,1)=i;
            siteloc(i,2)=hsite.XData(i);
            siteloc(i,3)=hsite.ZData(i);
        else
            siteloc(i,1)=nos-i+1;
            siteloc(i,2)=get(hsite(i),'XData');
            siteloc(i,3)=get(hsite(i),'ZData');
        end
    end    
    if stype~=1
        siteloc=flipud(siteloc);
    end
else
    disp('no sites found on this plot')
    return
end
[locfile,locpath] = uiputfile({'*.dat',... 
    'location Files (*.dat)'; '*.*','All Files (*.*)'},...
    'Save site location(of current figure) for plotting in other applications');
if isequal(locfile,0) || isequal(locpath,0)
    disp('user canceled...');
else
    fid=fopen(fullfile(locpath,locfile),'w');
    fprintf(fid,'%i %8.3f %8.3f\n',reshape(siteloc',3*nos,1));
    % a little trick to avoid THE LOOP HELL...
    fclose(fid);
end
return
