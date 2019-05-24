function popEdit_Row(hObject,eventdata,handles)
% callback for Row mesh editing (add delete and move rows)
global model
todo=get(handles.edit(2),'value');
if todo~=1
    set(handles.viewbox(:),'value',0);
    set(handles.viewbox(3),'value',1);
    d3_view(hObject,eventdata,handles);
end
h=findobj(handles.axis,'type','surface');
switch todo
    case 1
        disp('do nothing');
    case 2 
        % add row (horizonally) to mesh displayed on main interface
        % must click the "finish" pushbutton to save changes to the model
        addgrid(hObject,eventdata,handles,'x');
        msbox=msgbox('click when finish','note');
        %disp('lala')
        uiwait(msbox);
        addgrid(hObject,eventdata,handles,'off');
        model0=model.x; % save the original mesh of x
        xx=get(h,'ydata');%N-S direction
        model.x=xx(:,1);
        model1=model.x; % save the new mesh of x
        rho=model.rho;
        index=find_new(model0,model1); % find the index of new meshes
        for i=1:length(index)
            rho(index(i)+1:end+1,:,:)=rho(index(i):end,:,:);%create new columns sequently
        end
        model.rho=rho;
    case 3
        % del row (horizonally) to mesh displayed on main interface
        % must click the "finish" pushbutton to save changes to the model
        removegrid(hObject,eventdata,handles,'x');
        msbox=msgbox('click when finish','note');
        %disp('lala')
        uiwait(msbox);
        removegrid(hObject,eventdata,handles,'off');
        LengthX0=length(model.x);% save the original length of N-S direction
        xx=get(h,'ydata');%N-S direction
        model.x=xx(:,1);
        LengthX1=length(model.x);% save the present length of N-S direction
        rho=model.rho;
        for i=LengthX0:-1:LengthX1+1
            rho(i,:,:)=[];%del the rows sequently
        end
        model.rho=rho;
    case 4 
        % move row (horizonally) to mesh displayed on main interface
        % must click the "finish" pushbutton to save changes to the model
        movegrid(hObject,eventdata,handles,'x');
        msbox=msgbox('click when finish','note');
        %disp('lala') %for debug
        uiwait(msbox);
        movegrid(hObject,eventdata,handles,'off');
        xx=get(h,'ydata');%N-S direction
        model.x=xx(:,1);
end
refresh_status(hObject,eventdata,handles)
set(handles.edit(2),'value',1);
return

