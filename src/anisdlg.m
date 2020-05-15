function AnisPara=anisdlg(Nz,currentz)
% a simple dialog for inputing the top, bottom and resistivity of the
% Block
parastr={'top layer of the anisotropic body:',...
    'bottom layer of the anisotropic body:',...
    'high resistivity of the anisotropic body(ohm m):',...
    'low resisitivity of the anisotropic body(ohm m):',...
    'anisotropic axis direction (north/up is zero):',...
    'width of anisotropic stripes:'};
while(1)
    AnisPara=inputdlg(parastr,'Anis Parameter',1,{num2str(currentz),...
        num2str(currentz),'1000','10','0','1'});
    AnisPara = str2num(char(AnisPara));
    if AnisPara(1)>AnisPara(2)
         msgbox('The first layer number should be no larger than the bottom layer number'...
             ,'Anis Parameter');
         beep;
         uiwait;
    elseif AnisPara(1)<1||AnisPara(2)>Nz
         msgbox(['The Layer numbers should be positive between 1 and ',num2str(Nz)]...
             ,'Anis Parameter');
         beep;
         uiwait;
    elseif AnisPara(3)<=0||AnisPara(4)<=0;
         msgbox('The Resistivity value should be positive '...
             ,'Anis Parameter');
         beep;
         uiwait;
    elseif AnisPara(3)<=AnisPara(4);
         msgbox('The High Resitivity should be larger than low... Got it?'...
             ,'Anis Parameter');
         beep;
         uiwait;
    elseif AnisPara(6) < 0
        msgbox('Anisotropic stripes should be wider than 1...'...
             ,'Anis Parameter');
        beep;
        uiwait;
    else
         AnisPara(1)=round(AnisPara(1));
         AnisPara(2)=round(AnisPara(2));
         break;
    end
end
return

