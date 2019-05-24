function batch_xyr_output(hObject,eventdata,h)
% a silly script to batch output xyr (misfit) files from 3D inversion
% edit this script if you want to output a lot of files for comparation
global data
freq=data(1).freq;
prompt = {'Enter the center lat',...
    'Enter the center lon',...
    'Enter freqs of the misfit to be exported'};
dlg_title = 'Specify the misfit you want to output';
num_lines = 3;
def = {'31','86.5',num2str(1:length(freq))};
answer = inputdlg(prompt,dlg_title,num_lines,def);% dialog to input freqencies
if isempty(answer)
    disp('user canceled...')
    return
end
latR=str2double(answer{1});
lonR=str2double(answer{2});
list=str2num(answer{3});% get these freqencies to output
list=sort(list,1,'ascend'); % and sort the list to ascend direction.
set(h.selectionbox(3),'value',1);
prefix='Misfit_';
export_rms(hObject,eventdata,[prefix num2str(1/freq(list(1))) '-' num2str(1/freq(list(end))) 's'],list,latR,lonR);
return

