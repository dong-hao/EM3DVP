function cindex=get_Colorindex(rho,rhomax,rhomin)            
% function to determine colormap by given (log10)rho index 
% colorindex range from -1 to 5(i.e. for rho from 0.1 to 10000) is
% acceptable.
% a 3 element numeric vector will be returned as color value
cmap = colormap;% change default colormap here
if rho>rhomax
    colorindex=64;    
else if rho<rhomin
        colorindex=1;        
    else
        colorindex=round((rho-rhomin)/(rhomax-rhomin)*63)+1;
    end
end
cindex=cmap(colorindex,:);
return

