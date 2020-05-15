function export_visco_dlg(hObject,eventdata,h)
% a silly script to batch output xyz files from 3D slices
% edit this script if you want to output a lot of slices for comparation
% get the model dimensions
prompt = {'Enter the center lat',...
    'Enter the center lon',...
    'Enter upper boundary of the layer (km):',...
    'Enter lower boundary of the layer (km):',...
    'Enter the relative resistivity(Ohmm) :',...
    'Enter the reference viscosity (Pa s) :',...
    'Enter the C1 coefficient :',...
    };
dlg_title = 'Specify the depth range you want to calculate conductance';
num_lines = 1;
def = {'31','86.5','-25','-65', '100', '1e20', '1.2'};
answer = inputdlg(prompt,dlg_title,num_lines,def);% dialog to input depths
if isempty(answer)
    disp('user canceled...')
    return
end
latR=str2double(answer{1});
lonR=str2double(answer{2});
upper=str2double(answer{3});
lower=str2double(answer{4});
rres=str2double(answer{5});
rvis=str2double(answer{6});
C1 = str2double(answer{7});
prefix='Visco';
export_visco([prefix num2str(upper) num2str(lower) 'km'],...
    latR,lonR,upper,lower,rres,rvis,C1);
return

