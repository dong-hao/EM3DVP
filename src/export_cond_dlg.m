function export_cond_dlg(hObject,eventdata,h)
% a silly script to batch output xyz files from 3D slices
% edit this script if you want to output a lot of slices for comparation
% get the model dimensions
prompt = {'Enter the center lat',...
    'Enter the center lon',...
    'Enter upper boundary of the layer (km):',...
    'Enter lower boundary of the layer (km):',...
    'Enter the conductivity of the fluid phase (S):'};
dlg_title = 'Specify the depth range you want to calculate conductance';
num_lines = 4;
def = {'30.5','95','-25','-70', '2'};
answer = inputdlg(prompt,dlg_title,num_lines,def);% dialog to input depths
if isempty(answer)
    disp('user canceled...')
    return
end
latR=str2double(answer{1});
lonR=str2double(answer{2});
upper=str2double(answer{3});
lower=str2double(answer{4});
cf=str2double(answer{5});
prefix='Cond';
export_cond([prefix num2str(upper) num2str(lower) 'km'],...
    latR,lonR,upper,lower,cf);
return

