function batch_plot_resp4(hObject,eventdata,h)
% a silly script to batch output data and response of 3D inversions at a
% series of periods. 
% three files will be outputed, namely data, response and residual of the
% two. 
global data
freq=data(1).freq;
nfreq=length(freq);
prompt = {'Enter period(s) list to be exported'};
dlg_title = 'Specify the responses you want to output';
num_lines = 1;
def = {num2str(1:length(freq))};
answer = inputdlg(prompt,dlg_title,num_lines,def);% dialog for freqencies input 
if isempty(answer)
    disp('user canceled...')
    return
end
list=str2num(answer{1});% get these freqencies to output. 
list=sort(list,1,'ascend'); % and sort the list to ascend direction.
set(h.selectionbox(3),'value',1);
suffix='-topo';
for i=1:length(list)
    if (list(i)>=1&&list(i)<=nfreq)
        plot_resp4(hObject,eventdata,['@' num2str(freq(list(i))) 's' suffix],...
            list(i));
    else 
        disp('period not found in the list')
    end
end
return

