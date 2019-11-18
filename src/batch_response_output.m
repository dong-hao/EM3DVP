function batch_response_output(hObject,eventdata,h)
% a silly script to batch output data and response of 3D inversions at a
% series of periods. 
% three files will be outputed, namely data, response and residual of the
% two. 
global data
freq=data(1).freq;
nfreq=length(freq);
prompt = {'Enter the center lat',...
    'Enter the center lon',...
    'Enter period(s) list to be exported',...
    'Enter mode index (1-6 for xx, yy, xy, yx, tx, ty)'};
dlg_title = 'Specify the responses you want to output';
num_lines = 3;
def = {'31','86.5',num2str(1:length(freq)), '3'};
answer = inputdlg(prompt,dlg_title,num_lines,def);% dialog for freqencies input 
if isempty(answer)
    disp('user canceled...')
    return
end
latR=str2double(answer{1});
lonR=str2double(answer{2});
list=str2num(answer{3});% get these freqencies to output. 
list=sort(list,1,'ascend'); % and sort the list to ascend direction.
opt=str2num(answer{4});
nopt = length(opt);
set(h.selectionbox(3),'value',1);
prefix='TBT_';
for i=1:length(list)
    if (list(i)>=1&&list(i)<=nfreq)
        for j = 1:nopt 
            export_resp(hObject,eventdata,[prefix 'resp_' ...
                num2str(1/freq(list(i))) 's'],...
                list(i),latR,lonR,opt(j));
        end
    else 
        disp('period not found in the list')
    end
end
return

