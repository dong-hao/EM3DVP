function next_layer(hObject,eventdata,h)
% plot "next" layer of the model
% the current layer is determined by the custom.currentX/Y/Z
%
global custom model
if get(h.viewbox(1),'value')==1
    view=1; % x direction
elseif get(h.viewbox(2),'value')==1
    view=2; % y direction
else
    view=3; % z direction
end
switch view
    case 1 % view x plane, so currentY will change as we move on 
        if custom.currentY<length(model.y)-1
            custom.currentY=custom.currentY+1;
        else if custom.currentY>=length(model.y)-1
                custom.currentY=1;
                msgbox('last layer reached, will restart from the first layer',...
                    'Beware!','warn');
                beep;
                uiwait;
            end
        end
    case 2 % view y plane, so currentX will change as we move on
        if custom.currentX<length(model.x)-1
            custom.currentX=custom.currentX+1;
        else if custom.currentX>=length(model.x)-1
                custom.currentX=1;
                msgbox('last layer reached, will restart from the first layer',...
                    'Beware!','warn');
                beep;
                uiwait;
            end
        end
    case 3 % view z plane, so currentZ will change as we move on
        if custom.currentZ<length(model.z)-1
            custom.currentZ=custom.currentZ+1;
        else if custom.currentZ>=length(model.z)-1
                custom.currentZ=1;
                msgbox('last layer reached, will restart from the first layer',...
                    'Beware!','warn');
                beep;
                uiwait;
            end
        end        
end
% if get(h.button(3),'value')==0
%     plot_mesh(h,'z',custom.currentZ);
% else
%     plot_mesh3(h,'z',custom.currentZ);
% end
d3_view(hObject,eventdata,h);
return

