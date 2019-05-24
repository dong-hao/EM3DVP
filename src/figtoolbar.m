function h=figtoolbar(handles)
% Set up the toolbar for main gui
% Camera toolbar sealed for now
  set(handles.figure,'toolbar','none');
  if exist('uitoolfactory','file') >= 2
    % Create a toolbar with just the elements useful for figure
    handles.toolbar = uitoolbar('parent',handles.figure);
    uitoolfactory(handles.toolbar, 'Annotation.InsertRectangle');
    uitoolfactory(handles.toolbar, 'Annotation.InsertEllipse');
    uitoolfactory(handles.toolbar, 'Annotation.InsertTextbox');
    uitoolfactory(handles.toolbar, 'Annotation.InsertArrow');
    uitoolfactory(handles.toolbar, 'Annotation.InsertLine');
    uitoolfactory(handles.toolbar, 'Exploration.ZoomIn');
    uitoolfactory(handles.toolbar, 'Exploration.ZoomOut');
    uitoolfactory(handles.toolbar, 'Exploration.Pan');
    uitoolfactory(handles.toolbar, 'Exploration.Rotate');
    
    %cameratoolbar('show');
    %cameratoolbar('togglescenelight');
    
  else

    % We are in R13 or earlier
    try
      %cameratoolbar('show');
      %cameratoolbar('togglescenelight');
      %cameratoolbar('setmode','orbit');
    catch ME
      disp('Could not display the camera toolbar.');
      rethrow(ME)
    end
    
  end
  
h = handles;
return