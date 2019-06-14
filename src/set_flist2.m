function set_flist2(hObject,eventdata,handles)
% set a two-segment piecewise frequncy list
global custom nsite data 
pmin1=str2double(get(handles.smooth(2),'string'));
pmax1=str2double(get(handles.smooth(3),'string'));
ppd1=str2double(get(handles.smooth(4),'string'));
pmin2=str2double(get(handles.smooth(5),'string'));
pmax2=str2double(get(handles.smooth(6),'string'));
ppd2=str2double(get(handles.smooth(7),'string'));
if custom.origin==1
    % try to use original data
    % find the frequencies within given range
    idx=find(data(1).freq_o>=1/pmax1); % last freq in the first piece
    lastidx=idx(end);
    if isempty(lastidx)
        lastidx=data(1).nfreq_o;
    end
    idx=find(data(1).freq_o<=1/pmin1); % first freq in the first piece
    firstidx=idx(1);
    if isempty(firstidx)
        firstidx=1;
        custom.pmin=1./data(1).freq_o(1);
    else
        custom.pmin=1./data(1).freq_o(firstidx);
    end
    idx1=pick_freq(data(1).freq_o,firstidx,lastidx,ppd1);
    idx=find(data(1).freq_o>=1/pmax2); % last freq in the second piece
    lastidx=idx(end);
    if isempty(lastidx)
        lastidx=data(1).nfreq_o;
        custom.pmax=1./data(1).freq_o(lastidx);
    else
        custom.pmax=1./data(1).freq_o(lastidx);
    end
    idx=find(data(1).freq_o<=1/pmin2); % first freq in the second piece
    firstidx=idx(1);
    if isempty(firstidx)
        firstidx=1;
    end
    idx2=pick_freq(data(1).freq_o,firstidx,lastidx,ppd2);
    custom.ppd=[ppd1 ppd2];
    idx=[idx1 idx2(2:end)];
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
    % try to use smoothed data
    ftable1=[];ftable2=[];
    for index=1:nsite
        data(index)=TFsmooth2(data(index),ftable1,pmin1,pmax1,ppd1,ftable2,pmin2,pmax2,ppd2);
        data(index)=calc_rhophs(data(index),1);
        disp(['smoothing site #' num2str(index)]);
    end
    custom.flist=1:data(1).nfreq;
    custom.ftable=data(1).freq;
end
refresh_status(hObject,eventdata,handles.parent)
return;

