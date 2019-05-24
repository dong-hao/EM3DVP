function set_flist(hObject,eventdata,handles)
% set default frequency list used here
global custom nsite data
pmin=str2double(get(handles.data(4),'string'));
pmax=str2double(get(handles.data(5),'string'));
ppd=str2double(get(handles.data(6),'string'));

if custom.origin==1
    % try to use original data
    % find the frequencies within given range
    idx=find(data(1).freq_o>=1/pmax); %last frequency
    lastidx=idx(end);
    if isempty(lastidx)
        lastidx=data(1).nfreq_o;
        custom.pmax=data(1).freq_o(end);
    else
        custom.pmax=1./data(1).freq_o(lastidx);
    end
    idx=find(data(1).freq_o<=1/pmin); %first frequency
    firstidx=idx(1);
    if isempty(firstidx)
        firstidx=1;
        custom.pmin=1./data(1).freq_o(1);
    else
        custom.pmin=1./data(1).freq_o(firstidx);
    end
    %idx=pick_freq(data(1).freq_o,firstidx,lastidx,ppd);
    idx=firstidx:lastidx;
    custom.ppd=ppd;
    nfreq=length(idx);
    flist=data(1).freq_o(idx);
    for isite=1:nsite
        last=find(idx>data(isite).nfreq_o,1);
        idx2=idx;
        idx2(idx>data(isite).nfreq_o)=data(isite).nfreq_o;
        data(isite).tf=data(isite).tf_o(idx2,:);
        data(isite).freq=flist;
        data(isite).nfreq=nfreq;
        data(isite).emap=data(isite).emap_o(idx2,:);
        data(isite).emap(last:end,:)=0;
        data(isite)=calc_rhophs(data(isite),1);
    end
    custom.ftable=flist;
    custom.flist=1:nfreq;
else
    % try to use interpolated data
    ftable=[];
    for index=1:nsite
        data(index)=TFsmooth(data(index),ftable,pmin,pmax,ppd);
        data(index)=calc_rhophs(data(index),1);
        disp(['smoothing site #' num2str(index)]);
    end
    bands=log10(pmax/pmin);
    nfreq=round(bands*ppd)+1;
    custom.pmin=pmin;
    custom.pmax=pmax;
    custom.ppd=ppd;
    custom.flist=1:nfreq;
end
refresh_status(hObject,eventdata,handles.parent)
return;

