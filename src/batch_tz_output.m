function batch_tz_output(hObject,eventdata,h)
% a silly script to batch output the tz response (for plotting induction
% arrows in third party programes (e.g. GMT)
% two files will be outputed for the observed and response induction 
% vectors
global nsite location data resp
prompt = {'Enter period(s) list to be exported',...
    'Enter mode index (1/2 for real/imag TZ)'};
dlg_title = 'Specify the TZ responses you want to output';
num_lines = 2;
def = {'1 10 100 1000', '1'};
answer = inputdlg(prompt,dlg_title,num_lines,def);% dialog for freqencies input 
if isempty(answer)
    disp('user canceled...')
    return
end
unitscale = 1.3;
list=str2num(answer{1});% get these freqencies to output. 
list=sort(list,1,'ascend'); % and sort the list to ascend direction.
opt=str2num(answer{2});
for Cper=list
    per = num2str(Cper);
    switch opt
        case 1            
            oid=fopen(['TZ_real_' per 's.obs'],'w');
            rid=fopen(['TZ_real_' per 's.res'],'w');
        case 2
            oid=fopen(['TZ_imag_' per 's.obs'],'w');
            rid=fopen(['TZ_imag_' per 's.res'],'w');
        otherwise
            error('option not recognized for TZ output');
    end
    for i=1:nsite
        % Tf=smooth_Tf(Tf,'b',5);
        lon=location(i,2);
        lat=location(i,1);
        periods=1./data(i).freq;
        [dper,k]=min(abs(periods-Cper));
        disp(periods(k))
        disp(dper)
        mro=sqrt(data(i).tf(k,13)^2+data(i).tf(k,16)^2);
        aro=atan2(-data(i).tf(k,16),-data(i).tf(k,13))/pi*180;
        mio=sqrt(data(i).tf(k,14)^2+data(i).tf(k,17)^2);
        aio=atan2(-data(i).tf(k,17),-data(i).tf(k,14))/pi*180;
        mrr=sqrt(resp(i).tf(k,13)^2+resp(i).tf(k,16)^2);
        arr=atan2(-resp(i).tf(k,16),-resp(i).tf(k,13))/pi*180;
        mir=sqrt(resp(i).tf(k,14)^2+resp(i).tf(k,17)^2);
        air=atan2(-resp(i).tf(k,17),-resp(i).tf(k,14))/pi*180;
        emro = sqrt(data(i).tf(k,15)^2+data(i).tf(k,18)^2);
        emio = sqrt(data(i).tf(k,15)^2+data(i).tf(k,18)^2);
        earo = asin(emro);
        eaio = asin(emio);
        if mro > 0.5
            mro = 0;
            mrr = 0;
        elseif emro > 0.2
            mro = 0;
            mrr = 0;
        end
        if mio > 0.5
            mio = 0;
            mir = 0;
        elseif emro > 0.2
            mro = 0;
            mrr = 0;            
        end

        scale = unitscale;
        switch opt
            case 1
                fprintf(oid, '%f %f %f %f %f %f\n',...
                        lon,lat,aro,scale*mro,earo,emro);
                fprintf(rid, '%f %f %f %f %f %f\n',...
                        lon,lat,arr,scale*mrr,earo,emro);
            case 2
                fprintf(oid, '%f %f %f %f %f %f\n',...
                        lon,lat,aio,scale*mio,eaio,emio);
                fprintf(rid, '%f %f %f %f %f %f\n',...
                        lon,lat,air,scale*mir,eaio,emio);
            otherwise
                error('option not recognized for TZ output');
        end
                
    end
    fclose(oid);
    fclose(rid);
end
return


