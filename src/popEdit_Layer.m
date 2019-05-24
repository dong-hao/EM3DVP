function popEdit_Layer(hObject,eventdata,handles)
% callback for layer mesh editing (add delete and move layers)
global model
todo=get(handles.edit(3),'value');
if todo~=1
    set(handles.viewbox(:),'value',0);
    set(handles.viewbox(2),'value',1);
    d3_view(hObject,eventdata,handles);
end
h=findobj(handles.axis,'type','surface');
switch todo
    case 1
        disp('do nothing');
    case 2         
        % add layer (vertically) to mesh displayed on main interface
        % must click the "finish" pushbutton to save changes to the model
        addgrid(hObject,eventdata,handles,'z');
        msbox=msgbox('click when finish','note');
        uiwait(msbox);
        addgrid(hObject,eventdata,handles,'off');
        model0=model.z; % save the original mesh of z
        zz=get(h,'ydata');%U-D direction
        model.z=zz(:,1);
        model1=model.z; % save the new mesh of x
        rho=model.rho;
        index=find_new(model0,model1); % find the index of new meshes
        for i=1:length(index)
            rho(:,:,index(i)+1:end+1)=rho(:,:,index(i):end);%create new columns sequently
        end
        model.rho=rho;
    case 3         
        % del layer (vertically) to mesh displayed on main interface
        % must click the "finish" pushbutton to save changes to the model
        removegrid(hObject,eventdata,handles,'z');
        msbox=msgbox('click when finish','note');
        uiwait(msbox);
        removegrid(hObject,eventdata,handles,'off');
        LengthZ0=length(model.z);% save the original length of T-B direction
        zz=get(h,'ydata');%T-B direction
        model.z=zz(:,1);
        LengthZ1=length(model.z);% save the present length of T-B direction
        rho=model.rho;
        for i=LengthZ0:-1:LengthZ1+1
            rho(:,:,i)=[];%del the layers sequently
        end
        model.rho=rho;
    case 4         
        % move layer (vertically) to mesh displayed on main interface
        % must click the "finish" pushbutton to save changes to the model
        movegrid(hObject,eventdata,handles,'z');
        msbox=msgbox('click when finish','note');
        uiwait(msbox);
        movegrid(hObject,eventdata,handles,'off');
        zz=get(h,'ydata');%U-D direction
        model.z=zz(:,1);
end
refresh_status(hObject,eventdata,handles)
set(handles.edit(3),'value',1);
return

