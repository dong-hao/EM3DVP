function BlockPara=blockdlg(Nz,currentz)
% a simple dialog for inputing the top, bottom and resistivity of the
% Block
parastr={'top layer of the anomaly body:','bottom layer of the anomaly body:',...
    'resistivity of the anomaly body(ohm m):'};
while(1)
    BlockPara=inputdlg(parastr,'Block Parameter',1,{num2str(currentz),num2str(currentz),'1000'});
    BlockPara = str2num(char(BlockPara));
    if BlockPara(1)>BlockPara(2)
         msgbox('The first layer number should be no larger than the bottom layer number'...
             ,'Block Parameter');
         beep;
         uiwait;
    elseif BlockPara(1)<1||BlockPara(2)>Nz
         msgbox(['The Layer numbers should be positive between 1 and ',num2str(Nz)]...
             ,'Block Parameter');
         beep;
         uiwait;
    elseif BlockPara(3)<=0;
         msgbox('The Resistivity value should be positive '...
             ,'Block Parameter');
         beep;
         uiwait;
    else    
         BlockPara(1)=round(BlockPara(1));
         BlockPara(2)=round(BlockPara(2));         
         break;
    end
end
return

