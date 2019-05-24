function BosPara=bosdlg(Nz,currentz)
% dialog to input parametres for random structure generation
parastr={...
    'top layer of the 1d structures:',...
    'bottom layer of the 1d structures:',...
    'Highest Resistivity to be generated(ohm m):',...
    'Lowest Resistivity to be generated(ohm m):',...
    'interp algorthm to use (1 linear, 2 for nearest,3 for natural)'
    };
while(1)
    BosPara=inputdlg(parastr,'Block Parameter',1,{'1',...
        num2str(currentz),'10000','1','1'});
    BosPara = str2num(char(BosPara));
    if isempty(BosPara)
        disp('user canceled')
        return
    end
    if BosPara(1)>BosPara(2)
         msgbox('The first layer number should be no larger than the bottom layer number'...
             ,'Block Parameter');
         beep;
         uiwait;
    elseif BosPara(1)<1||BosPara(2)>Nz
         msgbox(['The Layer numbers should be positive between 1 and ',num2str(Nz)]...
             ,'Block Parameter');
         beep;
         uiwait;
    elseif BosPara(3)<=0||BosPara(4)<=0;
         msgbox('The Resistivity value should be positive '...
             ,'Block Parameter');
         beep;
         uiwait;
    elseif BosPara(3)<=BosPara(4);
         msgbox('Here is the deal: The High Resitivity should be larger than the low...'...
             ,'Block Parameter');
         beep;
         uiwait;
    else    
         BosPara(1)=round(BosPara(1));
         BosPara(2)=round(BosPara(2));
         if BosPara(5)>3||BosPara(5)<1
             BosPara(5)=1;
             msgbox('algorithm code not recognized, using default instead'...
             ,'Block Parameter');
            beep;
         end
         break;
    end
end
return

