function CheckerPara=checkerdlg(Nz,currentz)
% a simple dialog for inputing the top, bottom and resistivity of the
% Block
parastr={...
    'top layer of the checkerboard:',...
    'bottom layer of the checkerboard:',...
    'High Resistivity(ohm m):',...
    'Low Resistivity(ohm m):',...
    'length(x) of each block(in blocks)',...
    'width(y) of each block(in blocks)',...
    'interval in x(in blocks)',...
    'interval in y(in blocks)',...
    'first block to be (-1 for conductive and 1 for resistive)'
    };
while(1)
    CheckerPara=inputdlg(parastr,'Block Parameter',1,{num2str(currentz),...
        num2str(currentz),'1000','10','5','5','1','1','1'});
    CheckerPara = str2num(char(CheckerPara));
    if isempty(CheckerPara)
        disp('user canceled')
        return
    end
    if CheckerPara(1)>CheckerPara(2)
         msgbox('The first layer number should be no larger than the bottom layer number'...
             ,'Block Parameter');
         beep;
         uiwait;
    elseif CheckerPara(1)<1||CheckerPara(2)>Nz
         msgbox(['The Layer numbers should be positive between 1 and ',num2str(Nz)]...
             ,'Block Parameter');
         beep;
         uiwait;
    elseif CheckerPara(3)<=0||CheckerPara(4)<=0;
         msgbox('The Resistivity value should be positive '...
             ,'Block Parameter');
         beep;
         uiwait;
    elseif CheckerPara(3)<=CheckerPara(4);
         msgbox('The High Resitivity should be larger than low... Got it?'...
             ,'Block Parameter');
         beep;
         uiwait;
    elseif CheckerPara(5)<=0||CheckerPara(6)<=0||CheckerPara(7)<=0||CheckerPara(8)<=0
         msgbox('The Block dimensions should be positive'...
             ,'Block Parameter');
         beep;
         uiwait;
    else    
         CheckerPara(1)=round(CheckerPara(1));
         CheckerPara(2)=round(CheckerPara(2));
         CheckerPara(5)=ceil(CheckerPara(5));
         CheckerPara(6)=ceil(CheckerPara(6));
         CheckerPara(7)=ceil(CheckerPara(7));
         CheckerPara(8)=ceil(CheckerPara(8));
         if CheckerPara(9)>=0
             CheckerPara(9)=1;
         else
             CheckerPara(9)=-1;
         end
         break;
    end
end
return

