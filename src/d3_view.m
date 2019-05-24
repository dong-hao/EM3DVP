function d3_view(hObject,eventdata,h)
% a universal mesh plot function in model creating interface
% call function plot_mesh and plot_mesh3 to
% view model in 3d/2d mode(using slices)
% and call plot_fix/plot_fix3 to 
% plot the fix matrix
global custom model
h3d=h.button(3);
hfix=h.button(5);
hzoomin=h.viewbox(5);
if get(hfix,'value')==1
    if get(h3d,'value')==1
        opt='3dfix';
    else
        opt='2dfix';
    end
else
    if get(h3d,'value')==1
        opt='3d';
    else
        opt='2d';
    end
end
if get(h.viewbox(1),'value')==1
    view=1; % x direction
elseif get(h.viewbox(2),'value')==1
    view=2; % y direction
else
    view=3; % z direction
end
switch opt
    case '3d'
          set(h3d,'value',1);
          switch view
              case 1 % view x plane, so currentY will change as we move on   
                  plot_mesh3(h,'x',custom.currentY);
                  set(h.button(4),'string',num2str(model.y(custom.currentY)));
              case 2 % view y plane, so currentX will change as we move on 
                  plot_mesh3(h,'y',custom.currentX);
                  set(h.button(4),'string',num2str(model.x(custom.currentX)));
              case 3 % view y plane, this is easier to understand
                  plot_mesh3(h,'z',custom.currentZ);
                  set(h.button(4),'string',num2str(model.z(custom.currentZ)));
          end
          hold(h.axis,'on');
          % plotting sites.
          plot_site(hObject,eventdata,h,'noname');
          hold(h.axis,'off');
    case '2d'
        set(h3d,'value',0);
        switch view
            case 1 % view x plane, so currentY will change as we move on 
                plot_mesh(h,'x',custom.currentY);
                set(h.button(4),'string',num2str(model.y(custom.currentY)));
            case 2 % view y plane, so currentX will change as we move on 
                plot_mesh(h,'y',custom.currentX); 
                set(h.button(4),'string',num2str(model.x(custom.currentX)));
            case 3 
                plot_mesh(h,'z',custom.currentZ);
                set(h.button(4),'string',num2str(model.z(custom.currentZ)));
        end
        hold(h.axis,'on');
        % plotting sites.
%         if custom.currentZ==1&&view==3
        if view==3
            plot_site(hObject,eventdata,h,'noname');
        else
            plot_site(hObject,eventdata,h,'off');
        end
        hold(h.axis,'off');
    case '3dfix'
          set(h3d,'value',1);
          switch view
              case 1 % view x plane, so currentY will change as we move on   
                  plot_fix3(h,'x',custom.currentY);
                  set(h.button(4),'string',num2str(model.y(custom.currentY)));
              case 2 % view y plane, so currentX will change as we move on 
                  plot_fix3(h,'y',custom.currentX);
                  set(h.button(4),'string',num2str(model.x(custom.currentX)));
              case 3 % view y plane, this is easier to understand
                  plot_fix3(h,'z',custom.currentZ);
                  set(h.button(4),'string',num2str(model.z(custom.currentZ)));
          end
          hold(h.axis,'on');
          % plotting sites.
          plot_site(hObject,eventdata,h,'noname');
          hold(h.axis,'off');
    case '2dfix'
        set(h3d,'value',0);
        switch view
            case 1 % view x plane, so currentY will change as we move on 
                plot_fix(h,'x',custom.currentY);
                set(h.button(4),'string',num2str(model.y(custom.currentY)));
            case 2 % view y plane, so currentX will change as we move on 
                plot_fix(h,'y',custom.currentX); 
                set(h.button(4),'string',num2str(model.x(custom.currentX)));
            case 3 
                plot_fix(h,'z',custom.currentZ);
                set(h.button(4),'string',num2str(model.z(custom.currentZ)));
        end
        hold(h.axis,'on');
        % plotting sites.
%         if custom.currentZ==1&&view==3
        if view==3
            plot_site(hObject,eventdata,h,'noname');
        else
            plot_site(hObject,eventdata,h,'off');
        end
        hold(h.axis,'off');
end
if get(hzoomin,'value')==1&&get(h3d,'value')==0
    xpadding=custom.x2;
    ypadding=custom.y2;
    zpadding=custom.z4;
    x0=model.x(xpadding+1);
    y0=model.y(ypadding+1);
    xe=model.x(end-xpadding);
    ye=model.y(end-ypadding);
    ze=model.z(end-zpadding);
    if get(h.viewbox(1),'value')==1
        set(h.axis,'xlim',[x0,xe]);
        set(h.axis,'ylim',[ze,0]);
    elseif get(h.viewbox(2),'value')==1
        set(h.axis,'xlim',[y0,ye]);
        set(h.axis,'ylim',[ze,0]);        
    elseif get(h.viewbox(3),'value')==1
    	set(h.axis,'ylim',[x0,xe]);
        set(h.axis,'xlim',[y0,ye]);
    end
else
    axis(h.axis, 'tight');
end
return

