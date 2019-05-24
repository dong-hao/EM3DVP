function prev_layer(hObject,eventdata,h)
% plot previous layer of (the "current" layer of )the model
% in both 2d and 3d mode
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
        if custom.currentY>1
            custom.currentY=custom.currentY-1;
        else if custom.currentY<=1;                
                custom.currentY=length(model.y)-1;
                msgbox('the first layer reached, will restart from last layer',...
                    'Beware!','warn');
                beep;
                uiwait;
            end
        end
    case 2 % view y plane, so currentX will change as we move on 
        if custom.currentX>1
            custom.currentX=custom.currentX-1;
        else if custom.currentX<=1
                custom.currentX=length(model.x)-1;
                msgbox('the first layer reached, will restart from last layer',...
                    'Beware!','warn');
                beep;
                uiwait;
            end
        end
    case 3        
        if custom.currentZ>1
            custom.currentZ=custom.currentZ-1;
        else if custom.currentZ<=1
                custom.currentZ=length(model.z)-1;
                msgbox('the first layer reached, will restart from last layer',...
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
% set(h.button(4),'string',num2str(model.z(custom.currentZ)));
return

