function set_depth(hObject,eventdata,h)
% set layer depth of the model (could be x,y,z)
% plot the model at a given depth
% can plot "depth" at x, y, or z direction
global custom model
depth=str2double(get(h.button(4),'string'));
if get(h.viewbox(1),'value')==1
    view=1; % x direction
elseif get(h.viewbox(2),'value')==1
    view=2; % y direction
else
    view=3; % z direction
end
switch view
    case 1
        model_d=model.y;
    case 2
        model_d=model.x;
    case 3
        model_d=model.z;
end
if (depth<=min(model_d))
    i=1;
    if view==3 % when in z mode, the model start at a bigger value (0) and end with
           % smaller value. so the index should be reversed
    	i=length(model_d)-1;
    end
    disp('depth falls out of the model border')
elseif(depth>=max(model_d))
    i=length(model_d)-1;
    if view==3 % when in z mode, the model start at a bigger value (0) and end with
               % smaller value. so the index should be reversed
        i=1;
    end
    disp('depth falls out of the model border')
else
    i=find(model_d>=depth,1)-1;
    if view==3 % when in z mode, the model start at a bigger value (0) and end with
               % smaller value. so the index should be reversed
        i=find(model_d<=depth,1)-1;
    end
end
switch view
    case 1
        custom.currentY=i;
    case 2
        custom.currentX=i;
    case 3
        custom.currentZ=i;
end
    d3_view(hObject,eventdata,h);
return

