function next_slice(hObject,eventdata,handles,opt)
%display the next or previous layer of current one 
global custom model xyz
x=model.x;
y=model.y;
z=model.z;

outx=custom.x2;
outy=custom.y2;
outz=custom.z5;
if get(handles.selectionbox(7),'value')==1&&get(handles.setbox(1),'value')~=1
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
    z=z(1:end-3);
    %please note here Z=(1:end-3)
elseif get(handles.selectionbox(7),'value')==1
    x=x(outx:(end-outx+1));
    y=y(outy:(end-outy+1));
    z=z(1:(end-outz+1));
end

switch opt
    case 'previous'
        step=-1;
    case 'next'
        step=1;
end
if get(handles.selectionbox(1),'value')==1
    if step==1&&custom.currentX<length(x)-1
        custom.currentX=custom.currentX+step;
    elseif 1<custom.currentX&&step==-1
        custom.currentX=custom.currentX+step;
    elseif custom.currentX==length(x)-1
            custom.currentX=1;
            msgbox('last layer reached, will restart from the first layer',...
                'Beware!','warn');
            beep;
            uiwait;
    elseif custom.currentX==1
            custom.currentX=length(x)-1;
            msgbox('first layer reached, will restart from the last layer',...
                    'Beware!','warn');
            beep;
            uiwait;
    end
    set(handles.selectionbox(4),'string',num2str((x(custom.currentX)+...
        x(custom.currentX+1))/2));
    plot_slice(hObject,eventdata,handles,'x');
elseif get(handles.selectionbox(2),'value')==1
    if step==1&&custom.currentY<length(y)-1
        custom.currentY=custom.currentY+step;
    elseif 1<custom.currentY&&step==-1
        custom.currentY=custom.currentY+step;
    elseif custom.currentY==length(y)-1
            custom.currentY=1;
            msgbox('last layer reached, will restart from the first layer',...
                'Beware!','warn');
            beep;
            uiwait;
    elseif custom.currentY==1
            custom.currentY=length(y)-1;
            msgbox('first layer reached, will restart from the last layer',...
                    'Beware!','warn');
            beep;
            uiwait;
    end
    set(handles.selectionbox(5),'string',num2str((y(custom.currentY)+...
        y(custom.currentY+1))/2));
    plot_slice(hObject,eventdata,handles,'y');
else
    if step==1&&custom.currentZ<length(z)-1
        custom.currentZ=custom.currentZ+step;
    elseif 1<custom.currentZ&&step==-1
        custom.currentZ=custom.currentZ+step;
    elseif custom.currentZ==length(z)-1
            custom.currentZ=1;
            msgbox('last layer reached, will restart from the first layer',...
                'Beware!','warn');
            beep;
            uiwait;
    elseif custom.currentZ==1
            custom.currentZ=length(z)-1;
            msgbox('first layer reached, will restart from the last layer',...
                    'Beware!','warn');
            beep;
            uiwait;
    end
    plot_slice(hObject,eventdata,handles,'z');
    set(handles.selectionbox(6),'string',num2str((z(custom.currentZ)+...
        z(custom.currentZ+1))/2));
end
return

