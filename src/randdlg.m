function RandPara=randdlg(Nz,currentz)
% dialog to input parametres for random structure generation
parastr={...
    'top layer of the random structure(s):',...
    'bottom layer of the random structure(s):',...
    'Highest Resistivity to be generated(ohm m):',...
    'Lowest Resistivity to be generated(ohm m):',...
    '(N-S) size of minimum structure (in blocks)',...
    '(E-W) size of minimum structure (in blocks)',...
    'algorthm to use (1 for full random, 2 for fractal)'
    };
while(1)
    RandPara=inputdlg(parastr,'Block Parameter',1,{num2str(currentz),...
        num2str(currentz),'3000','3','1','1','2'});
    RandPara = str2num(char(RandPara));
    if isempty(RandPara)
        disp('user canceled')
        return
    end
    if RandPara(1)>RandPara(2)
         msgbox('The first layer number should be no larger than the bottom layer number'...
             ,'Block Parameter');
         beep;
         uiwait;
    elseif RandPara(1)<1||RandPara(2)>Nz
         msgbox(['The Layer numbers should be positive between 1 and ',num2str(Nz)]...
             ,'Block Parameter');
         beep;
         uiwait;
    elseif RandPara(3)<=0||RandPara(4)<=0;
         msgbox('The Resistivity value should be positive '...
             ,'Block Parameter');
         beep;
         uiwait;
    elseif RandPara(3)<=RandPara(4);
         msgbox('The High Resitivity should be larger than low... Got it?'...
             ,'Block Parameter');
         beep;
         uiwait;
    elseif RandPara(5)<=0||RandPara(6)<=0
         msgbox('The structure dimensions should be positive'...
             ,'Block Parameter');
         beep;
         uiwait;
    else    
         RandPara(1)=round(RandPara(1));
         RandPara(2)=round(RandPara(2));
         RandPara(5)=ceil(RandPara(5));
         RandPara(6)=ceil(RandPara(6));
         if RandPara(7)~=1&&RandPara(7)~=2
             RandPara(7)=1;
             msgbox('algorithm code not recognized, using default instead'...
             ,'Block Parameter');
            beep;
         end
         break;
    end
end
return

