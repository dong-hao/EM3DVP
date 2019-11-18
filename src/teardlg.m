function BondPara=teardlg(currentdepth)
% a simple dialog for inputing the boundary, cov index and resistivity of 
% the tear layer
parastr={'depth of the other boundary of the layer (m):',...
    'the cov index of the layer (0,9 are reserved)',...
    'resistivity of layer (ohm m):'};
while(1)
    BondPara=inputdlg(parastr,'bound Parameter',1,{... 
        num2str(currentdepth),'2','300'});
    BondPara = str2num(char(BondPara));
    if BondPara(1)<0
         msgbox('The depth value should be positive '...
             ,'tear Parameter');
         beep;
         uiwait;
    elseif BondPara(2) < 2 || BondPara(2) > 8
         msgbox('The index value should be 1 < i < 9 '...
             ,'tear Parameter');
         beep;
         uiwait;
    elseif BondPara(3)<=0
         msgbox('The Resistivity value should be positive '...
             ,'tear Parameter');
         beep;
         uiwait;
    else
         BondPara(1)=round(BondPara(1));
         BondPara(2)=round(BondPara(2));
         break;
    end
end
return