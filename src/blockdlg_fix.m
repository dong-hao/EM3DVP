function BlockPara=blockdlg_fix(Nz,currentz)
% dialog function to input the fix model index parameters
parastr={'top layer of the block:','bottom layer of the block:'};
while(1)
    BlockPara=inputdlg(parastr,'Block Parameter',1,{num2str(currentz),num2str(currentz)});
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
    else    
         BlockPara(1)=round(BlockPara(1));
         BlockPara(2)=round(BlockPara(2));         
         break;
    end
end


