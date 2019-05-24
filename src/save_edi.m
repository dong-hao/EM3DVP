function save_edi(hObject,eventdata,h)
% modified form my old wsi2edi script
% a script to convert Weerachai's data files to edi files (do not ask me 
% why!) 
%  
% edis will be outputed as a 5-component MT site (Ex, Ey, Hx, Hy, Hz)
%
% version: 0.4a
% author : DONG Hao
global location sitename data custom nsite platform xyz model
istr = inputdlg('select site to save(0 for all sites)','save as edi',1,{'1'});
if isempty(istr)
    disp('user canceled...')
    return
end
slist=str2num(istr{1});
if max(slist)>nsite||min(slist)<0
    disp('site index exceed boundary')
    return
elseif min(slist)==0
    slist=1:nsite;
end

if isempty(strfind(platform,'windows'))
    sdir = uigetdir('./','Pick a Directory for edi output');
    sdir=[sdir '/'];
else 
    sdir = uigetdir('.\','Pick a Directory for edi output');
    sdir=[sdir '\'];
end
for isite=1:length(slist)
    nfreq=length(custom.flist);
    flist=data(slist(isite)).freq(custom.flist);% period -> freq
    lat=location(slist(isite),1);
    lon=location(slist(isite),2);
    elev=location(slist(isite),3);
    %convert lat to degree:minute:second 
    if lat<0
        latD=ceil(lat);
        latM=ceil((lat-latD)*60);
        latS=(lat-latD-latM/60)*3600;
        if latD<0
            latM=-latM;
            latS=-latS;
        else
            if latM<0
                latS=-latS;
            end
        end
    else 
        latD=floor(lat);
        latM=floor((lat-latD)*60);
        latS=(lat-latD-latM/60)*3600;
    end
    %convert lon to degree:minute:second 
    if lon<0
        lonD=ceil(lon);
        lonM=ceil((lon-lonD)*60);
        lonS=(lon-lonD-lonM/60)*3600;
        if lonD<0
            lonM=-lonM;
            lonS=-lonS;
        else
            if lonM<0
                lonS=-lonS;
            end
        end
    else 
        lonD=floor(lon);
        lonM=floor((lon-lonD)*60);
        lonS=(lon-lonD-lonM/60)*3600;
    end
    % =============now start calculating Z location of the stations===========%
    % here we use a 'sink station' technique as intruduced by Randie's 2D code 
    % and Weerachai's 3d code. 
    % find which grid mesh the station lies in 
    xi=find(model.x>xyz(isite,1),1)-1;
    yi=find(model.y>xyz(isite,2),1)-1;
    if model.rho(xi,yi,1)>=1e7 % please note we only sink stations with topography (air)
        zi=find(model.rho(xi,yi,:)<1e7,1);
        sink=model.z(zi);
        elev=elev+sink;
    end
    outid=fopen([sdir char(sitename{slist(isite)}) '.edi'],'w');
    %===========output file head===============%
    fprintf(outid,'>HEAD\n');
    fprintf(outid,'DATAID="%s"\n',char(sitename{slist(isite)})); 
    fprintf(outid,'ACQBY="unknown"\n');
    fprintf(outid,'FILEBY="wsi2edi/EM3D"\n');
    fprintf(outid,'ACQDATE=12/21/12\n');
    fprintf(outid,'FILEDATE=12/21/12\n');
    fprintf(outid,['PROSPECT= ' custom.projectname '\n']);
    fprintf(outid,'LOC="HARMONIC SOCIETY"\n');    
    fprintf(outid,'LAT=%2i:%02i:%06.4f\n',latD,latM,latS);
    fprintf(outid,'LONG=%3i:%02i:%06.4f\n',lonD,lonM,lonS);
    fprintf(outid,'ELEV=%i\n',elev);
    fprintf(outid,'STDVERS="SEG 1.0"\n');
    fprintf(outid,'PROGVERS="wsi2edi 0.2"\n');
    fprintf(outid,'PROGDATE=04/01/10\n');
    fprintf(outid,'MAXSECT=999\n');
    fprintf(outid,'EMPTY=1.0e+32\n\n');
    %===========output info==============%
    fprintf(outid,'>INFO\n');
    fprintf(outid,'MAXINFO=999\n');
    fprintf(outid,'SURVEY ID:Area Name\n');
    fprintf(outid,'SURVEY CO:CUGB\n');
    fprintf(outid,'CLIENT CO:\n');
    fprintf(outid,'AREA:Area Name\n');
    fprintf(outid,'ROTATION=FIX\n\n');
    %===========output definations==============%
    fprintf(outid,'>=DEFINEMEAS\n');
    fprintf(outid,'MAXCHAN=5\n');
    fprintf(outid,'MAXRUN=999\n');
    fprintf(outid,'MAXMEAS=9999\n');
    fprintf(outid,'UNITS=M\n');
    fprintf(outid,'REFTYPE=CART\n');
    fprintf(outid,'REFLOC="%s"\n',char(sitename{slist(isite)}));
    fprintf(outid,'REFLAT=%2i:%02i:%06.4f\n',latD,latM,latS);
    fprintf(outid,'REFLONG=%3i:%02i:%06.4f\n',lonD,lonM,lonS);
    fprintf(outid,'REFELEV=%i\n',elev);
    fprintf(outid,'>HMEAS ID=101.001 CHTYPE=HX X=0.0 Y=0.0 Z=0.0 AZM=0.0 \n');
    fprintf(outid,'>HMEAS ID=102.001 CHTYPE=HY X=0.0 Y=0.0 Z=0.0 AZM=90.0 \n');
    fprintf(outid,'>HMEAS ID=103.001 CHTYPE=HZ X=0.0 Y=0.0 Z=0.0 AZM=0.0 \n');
    fprintf(outid,'>EMEAS ID=104.001 CHTYPE=EX X=0.0 Y=0.0 Z=0.0 X2=0.0 Y2=0.0 Z2=0.0 \n');
    fprintf(outid,'>EMEAS ID=105.001 CHTYPE=EY X=0.0 Y=0.0 Z=0.0 X2=0.0 Y2=0.0 Z2=0.0 \n\n');    
    %===========output mt section==============%
    fprintf(outid,'>=MTSECT\n');
    fprintf(outid,'SECTID="%s"\n',char(sitename{slist(isite)}));
    fprintf(outid,'NFREQ=%i\n',nfreq);   
    fprintf(outid,'HX=101.001\n');
    fprintf(outid,'HY=102.001\n');
    fprintf(outid,'HZ=103.001\n');
    fprintf(outid,'EX=104.001\n');
    fprintf(outid,'EY=105.001\n\n');
    %===========output freq table==============%
    fprintf(outid,'>!****FREQUENCIES****!\n');
    fprintf(outid,'>FREQ //%i\n',nfreq);   
    fprintf(outid,'% e % e % e % e % e % e\n',flist);
    fprintf(outid,'\n');
    %===========output rotation angle==============%
    fprintf(outid,'>!****IMPEDANCE ROTATION ANGLES****!\n');
    fprintf(outid,'>ZROT //%i\n',nfreq);
    fprintf(outid,'% e % e % e % e % e % e\n',zeros(1,nfreq));
    fprintf(outid,'\n');
    %===========output impedances==============%    
    fprintf(outid,'>!****IMPEDANCES****!\n');
    fprintf(outid,'>ZXXR ROT=ZROT //%i\n',nfreq);
    fprintf(outid,'% e % e % e % e % e % e\n',data(slist(isite)).tf(custom.flist,1));
    fprintf(outid,'\n');
    fprintf(outid,'>ZXXI ROT=ZROT //%i\n',nfreq);
    fprintf(outid,'% e % e % e % e % e % e\n',-data(slist(isite)).tf(custom.flist,2));
    fprintf(outid,'\n');
    fprintf(outid,'>ZXX.VAR ROT=ZROT //%i\n',nfreq);
    if get(h.data(7),'value')==1 %output given error floor
        varxxyy=str2num(get(h.data(4),'string'))/100;
        fprintf(outid,'% e % e % e % e % e % e\n',...
            sqrt((data(slist(isite)).tf(custom.flist,1)).^2+...
            (data(slist(isite)).tf(custom.flist,2)).^2)*varxxyy);
    else
        fprintf(outid,'% e % e % e % e % e % e\n',data(slist(isite)).tf(custom.flist,3));
    end
    fprintf(outid,'\n');
    fprintf(outid,'>ZXYR ROT=ZROT //%i\n',nfreq);
    fprintf(outid,'% e % e % e % e % e % e\n',data(slist(isite)).tf(custom.flist,4));
    fprintf(outid,'\n');
    fprintf(outid,'>ZXYI ROT=ZROT //%i\n',nfreq);
    fprintf(outid,'% e % e % e % e % e % e\n',-data(slist(isite)).tf(custom.flist,5));
    fprintf(outid,'\n');
    fprintf(outid,'>ZXY.VAR ROT=ZROT //%i\n',nfreq);
    if get(h.data(7),'value')==1 %output given error floor
        varxyyx=str2num(get(h.data(5),'string'))/100;
        fprintf(outid,'% e % e % e % e % e % e\n',...
            sqrt((data(slist(isite)).tf(custom.flist,4)).^2+...
            (data(slist(isite)).tf(custom.flist,5)).^2)*varxyyx);
    else
        fprintf(outid,'% e % e % e % e % e % e\n',data(slist(isite)).tf(custom.flist,6));
    end
    fprintf(outid,'\n');
    fprintf(outid,'>ZYXR ROT=ZROT //%i\n',nfreq);
    fprintf(outid,'% e % e % e % e % e % e\n',data(slist(isite)).tf(custom.flist,7));
    fprintf(outid,'\n');
    fprintf(outid,'>ZYXI ROT=ZROT //%i\n',nfreq);
    fprintf(outid,'% e % e % e % e % e % e\n',-data(slist(isite)).tf(custom.flist,8));
    fprintf(outid,'\n');
    fprintf(outid,'>ZYX.VAR ROT=ZROT //%i\n',nfreq);
    if get(h.data(7),'value')==1 %output given error floor
        varxyyx=str2num(get(h.data(5),'string'))/100;
        fprintf(outid,'% e % e % e % e % e % e\n',...
            sqrt((data(slist(isite)).tf(custom.flist,7)).^2+...
            (data(slist(isite)).tf(custom.flist,8)).^2)*varxyyx);
    else
        fprintf(outid,'% e % e % e % e % e % e\n',data(slist(isite)).tf(custom.flist,9));
    end
    fprintf(outid,'\n');
    fprintf(outid,'>ZYYR ROT=ZROT //%i\n',nfreq);
    fprintf(outid,'% e % e % e % e % e % e\n',data(slist(isite)).tf(custom.flist,10));
    fprintf(outid,'\n');
    fprintf(outid,'>ZYYI ROT=ZROT //%i\n',nfreq);
    fprintf(outid,'% e % e % e % e % e % e\n',-data(slist(isite)).tf(custom.flist,11));
    fprintf(outid,'\n');
    fprintf(outid,'>ZYY.VAR ROT=ZROT //%i\n',nfreq);
    if get(h.data(7),'value')==1 %output given error floor
        varxxyy=str2num(get(h.data(4),'string'))/100;
        fprintf(outid,'% e % e % e % e % e % e\n',...
            sqrt((data(slist(isite)).tf(custom.flist,10)).^2+...
            (data(slist(isite)).tf(custom.flist,11)).^2)*varxxyy);
    else
        fprintf(outid,'% e % e % e % e % e % e\n',data(slist(isite)).tf(custom.flist,12));
    end
    fprintf(outid,'\n');       
    %===========output tippers==============%    
    fprintf(outid,'>!****TIPPER PARAMETERS****!\n');
    %===========output tipper rotation angle==============%
    fprintf(outid,'>TROT.EXP //%i\n',nfreq);
    fprintf(outid,'% e % e % e % e % e % e\n',zeros(1,nfreq));
    fprintf(outid,'\n');
    %===========output tx==============%  
    fprintf(outid,'>TXR.EXP  //%i\n',nfreq);
    fprintf(outid,'% e % e % e % e % e % e\n',data(slist(isite)).tf(custom.flist,13));
    fprintf(outid,'\n');
    fprintf(outid,'>TXI.EXP  //%i\n',nfreq);
    fprintf(outid,'% e % e % e % e % e % e\n',data(slist(isite)).tf(custom.flist,14));
    fprintf(outid,'\n');
    fprintf(outid,'>TXVAR.EXP  //%i\n',nfreq);
    if get(h.data(7),'value')==1 %output given error floor
        vartxty=str2num(get(h.data(6),'string'))/100;
        fprintf(outid,'% e % e % e % e % e % e\n',...
            sqrt((data(slist(isite)).tf(custom.flist,13)).^2+...
            (data(slist(isite)).tf(custom.flist,14)).^2)*vartxty);
    else
        fprintf(outid,'% e % e % e % e % e % e\n',data(slist(isite)).tf(custom.flist,15));
    end
    fprintf(outid,'\n');
    %===========output ty==============%  
    fprintf(outid,'>TYR.EXP  //%i\n',nfreq);
    fprintf(outid,'% e % e % e % e % e % e\n',data(slist(isite)).tf(custom.flist,16));
    fprintf(outid,'\n');
    fprintf(outid,'>TYI.EXP  //%i\n',nfreq);
    fprintf(outid,'% e % e % e % e % e % e\n',data(slist(isite)).tf(custom.flist,17));
    fprintf(outid,'\n');
    fprintf(outid,'>TYVAR.EXP  //%i\n',nfreq);
    if get(h.data(7),'value')==1 %output given error floor
        vartxty=str2num(get(h.data(6),'string'))/100;
        fprintf(outid,'% e % e % e % e % e % e\n',...
            sqrt((data(slist(isite)).tf(custom.flist,16)).^2+...
            (data(slist(isite)).tf(custom.flist,17)).^2)*vartxty);
    else
        fprintf(outid,'% e % e % e % e % e % e\n',data(slist(isite)).tf(custom.flist,18));
    end
    fprintf(outid,'\n');    
    fprintf(outid,'>END');  
    fclose(outid);
    disp([char(sitename{slist(isite)}) ' converted' ]);
end
return

