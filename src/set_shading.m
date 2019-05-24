function set_shading(hObject,eventdata,h)
% setting shading, select different shadings from a pop up menu.
% there are only 3 shadings by default.
% interp, flat, and faceted.
% see matlab doc for shadings for further detail.
shade=get(h.setbox(3),'value');
switch shade
    case 1
        for i=1:length(h.axis)
            shading(h.axis(i),'interp')
        end
    case 2   
        for i=1:length(h.axis)        
            shading(h.axis(i),'flat')
        end
    case 3
        for i=1:length(h.axis)        
            shading(h.axis(i),'faceted')
        end
end

