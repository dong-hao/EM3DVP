function SpherePara = spheredlg()
% a simple dialog for inputing the location, radius and resistivity of the
% sphere
parastr={'X(N-S direction) in meter:','Y(E-W direction) in meter:',...
    'Z(depth direction) in meter','Radius in meter: ',...
    'Sphere resistivity(ohm m):'};
while(1)
    SpherePara=inputdlg(parastr,'Sphere Parameter',1,{'0','0','0','1000','1000'});
    SpherePara = str2num(char(SpherePara));
    if SpherePara(4)<=0
         msgbox('The Radius of the Sphere should be positive'...
             ,'Sphere Parameter');
         beep;
         uiwait;    
    else    
         SpherePara(1)=round(SpherePara(1));
         SpherePara(2)=round(SpherePara(2));       
         SpherePara(3)=round(SpherePara(3));
         SpherePara(4)=round(SpherePara(4));  
         break;
    end
end
return

