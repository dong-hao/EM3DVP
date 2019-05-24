function set_colormap(hObject,eventdata,h)
% select different colormap from a pop up menu.
% change the default colormaps if you wish
% see matlab doc for colormap for further detail.
global custom
if ~isfield(h,'setbox')
    colormap(flipud(jet(64)))
    set(h.axis,'clim',[log10(custom.rhomin),log10(custom.rhomax)]);
    return
end
map=get(h.setbox(2),'value');
switch map
    case 1
        colormap(flipud(jet(64)))%use flipud to reverse the colormap column  
    case 2
        colormap(hsv(64))
    case 3
        colormap(gray(64))
    case 4 %for geomechanic guys
        colormap(jet(64))
    case 5
        colormap(flipud(hsv(64)))%use flipud to reverse the colormap column
    case 6 
        cmap=flipud(jet(64));
        cmap(end+1,:)=[1,1,1];
        % cmap(1,:)=[0,0,1];
        colormap(cmap)%use flipud to reverse the colormap column
    case 7
        % rainbow colormap script, from Jan
        % this is a balanced colour map with a very wide green zone. 
        R(128,1) = 0;
        G(128,1) = 0;
        B(128,1) = 0;
        dx = 0.8;
        for f=0:(1/128):1
          g = (6-2*dx)*f+dx;
          index = int16(f*128 + 1);
          R(index,1) = max(0,(3-abs(g-4)-abs(g-5))/2);
          G(index,1) = max(0,(4-abs(g-2)-abs(g-4))/2); 
          B(index,1) = max(0,(3-abs(g-1)-abs(g-2))/2);
        end
        %concatenate arrays horizontally
        farby = horzcat(R, G, B);    
        colormap(flipud(farby));
    case 8 
        colormap(flipud(jet(16)))%use flipud to reverse the colormap column 
end
set(h.axis,'clim',[log10(custom.rhomin),log10(custom.rhomax)]);
%colorbar('units','normalized','position',[0.78 0.12 0.05 0.2]),'yscale','log';
return


