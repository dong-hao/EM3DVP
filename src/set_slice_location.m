function set_slice_location(hObject,eventdata,handles,opt)
% set slice location by loading location from editbox.
global custom model xyz
current=str2num(get(hObject,'string'));
x=model.x;
y=model.y;
z=model.z;
if get(handles.selectionbox(7),'value')==1
    if get(handles.setbox(1),'value')==1
        xbd=str2double(get(handles.setbox(6),'string'));
        ybd=str2double(get(handles.setbox(7),'string'));
        zbd=str2double(get(handles.setbox(8),'string'));
        x=x(xbd+1:end-xbd);
        y=y(ybd+1:end-ybd);
        z=z(1:end-zbd+1);
    else
        Lprofile_X=max(xyz(:,1))-min(xyz(:,1));
        Lprofile_Y=max(xyz(:,2))-min(xyz(:,2));
        Nx=length(x);
        for i=1:Nx;
            if abs(x(i)-x(end-i))<=Lprofile_X;
                ix=i-3;
                break;
            end
        end
        x=x(ix:(end-ix+1));
        Ny=length(y);
        for i=1:Ny;
            if abs(y(i)-y(end-i))<=Lprofile_Y;
                iy=i-3;
                break;
            end
        end
        y=y(iy:(end-iy+1));
        z=z(1:end-5);
        %please note here z=z(1:end-5)
    end
end
switch opt
    case 'x'
        if current>min(x)&&current<max(x)
            custom.currentX=find(x>current,1);
            plot_slice(hObject,eventdata,handles,'x');
        else
            msgbox('invalid location(out of the model)','Beware!','warn');
            beep;
            return
        end
    case 'y'
        if current>min(y)&&current<max(y)
            custom.currentY=find(y>current,1);
            plot_slice(hObject,eventdata,handles,'y');
        else
            msgbox('invalid location(out of the model)','Beware!','warn');
            beep;
            return
        end
    case 'z'
        if current>min(z)&&current<=max(z)
            custom.currentZ=find(z<current,1)-1;
            plot_slice(hObject,eventdata,handles,'z');
        else
            msgbox('invalid location(out of the model)','Beware!','warn');
            beep;
            return
        end
end

