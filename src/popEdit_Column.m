function popEdit_Column(hObject,eventdata,handles)
% callback for Column mesh editing( add delete and move columns)
global model
todo=get(handles.edit(1),'value');
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
        % add column (vertically) to mesh displayed on main interface
        % must click the "finish" pushbutton to save changes to the model
        addgrid(hObject,eventdata,handles,'y');
        msbox=msgbox('click when finish','note');
        uiwait(msbox);
        addgrid(hObject,eventdata,handles,'off');
        model0=model.y; % save the original mesh of y
        yy=get(h,'xdata');%E-W direction        
        model.y=yy(1,:)';
        model1=model.y; % save the new mesh of y
        rho=model.rho;
        index=find_new(model0,model1); % find the index of new meshes
        for i=1:length(index)
            rho(:,index(i)+1:end+1,:)=rho(:,index(i):end,:);%create new columns sequently
        end
        model.rho=rho;
    case 3 
        % del column (vertically) to mesh displayed on main interface
        % must click the "finish" pushbutton to save changes to the model        
        removegrid(hObject,eventdata,handles,'y');
        msbox=msgbox('click when finish','note');
        uiwait(msbox);
        removegrid(hObject,eventdata,handles,'off');
        LengthY0=length(model.y);% save the original length of E-W direction
        yy=get(h,'xdata');%E-W direction
        model.y=yy(1,:)';
        LengthY1=length(model.y);% save the present length of E-W direction
        rho=model.rho;
        for i=LengthY0:-1:LengthY1+1
            rho(:,i,:)=[];%del the columns sequently
        end
        model.rho=rho;
    case 4 
        % move column (vertically) to mesh displayed on main interface
        % must click the "finish" pushbutton to save changes to the model
        movegrid(hObject,eventdata,handles,'y');
        msbox=msgbox('click when finish','note');
        uiwait(msbox);
        movegrid(hObject,eventdata,handles,'off');
        yy=get(h,'xdata');%E-W direction
        model.y=yy(1,:)';
end
refresh_status(hObject,eventdata,handles)
set(handles.edit(1),'value',1);
return

