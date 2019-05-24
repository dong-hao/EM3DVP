function lock_rho_area(hObject,eventdata,h)
% drag a rubberband box to change the model resistivity inside of it
% finally i can get rid of the stupid click_and_drag functions...
global model custom
if get(h.viewbox(1),'value')==1
    view=1; % x direction
elseif get(h.viewbox(2),'value')==1
    view=2; % y direction
else
    view=3; % z direction
end
waitforbuttonpress; 
point1 = get(h.axis,'CurrentPoint');    % button clicked
rbbox;                             % return figure units 
point2 = get(h.axis,'CurrentPoint');    % button released 
point1 = point1(1,1:2);            % extract x
point2 = point2(1,1:2);            % and y
p1 = min(point1,point2);           % bottom left point
p2 = max(point1,point2);           % top right point
x1=p1(1);y1=p1(2);
x2=p2(1);y2=p2(2);
%==============now determine blocks to change=================%
switch view
        case 1 % view x plane
            initA=find(model.x>x1,1); % the leftmost mesh of the area
            initB=find(model.z<y2,1); % the bottommost mesh
            finalA=find(model.x>x2,1)-1; % the rightmost
            if isempty(finalA)
                finalA=size(model.x,1)+1;
            end
            finalB=find(model.z<y1,1)-1; % the topmost
            if isempty(initB)
                initB=size(model.z,1)+1;
            end
        case 2 % view y plane
            initA=find(model.y>x1,1); % the leftmost mesh of the area
            if isempty(initA)
                initA=1;
            end
            initB=find(model.z<y2,1); % the bottommost mesh
            if isempty(initB)
                initB=1;
            end
            finalA=find(model.y>x2,1)-1; % the rightmost
            if isempty(finalA)
                finalA=size(model.y,1)+1;
            end
            finalB=find(model.z<y1,1)-1; % the topmost
            if isempty(initB)
                initB=size(model.z,1)+1;
            end
        case 3 % view z plane
                initA=find(model.y>x1,1); % the leftmost mesh of the area
                initB=find(model.x>y1,1); % the topmost mesh
                finalA=find(model.y>x2,1)-1; % the rightmost
                if isempty(finalA)
                    finalA=size(model.y,1)+1;
                end
                finalB=find(model.x>y2,1)-1; % the bottommost mesh
                if isempty(finalB)
                    finalB=size(model.x,1)+1;
                end
end
if initA>finalA-1||initB>finalB-1
    msgbox('YUKI.N> Please, select more than one block...','Selection');
    beep;
    uiwait;
else
    fix = menu('please select','fix area','unfix area','cancel');
    switch fix
    	case 1
            vf=1;
        case 2
        	vf=0;
        case 3
            set(h.button(5),'value',1);
        	return
    end    
    switch view
        case 1
            BlockPara=blockdlg_fix(length(model.y)-1,custom.currentY);
            model.fix(initA:finalA-1,BlockPara(1):BlockPara(2),initB:finalB-1)=vf;
        case 2
            BlockPara=blockdlg_fix(length(model.x)-1,custom.currentX);
            model.fix(BlockPara(1):BlockPara(2),initA:finalA-1,initB:finalB-1)=vf;
        case 3
            BlockPara=blockdlg_fix(size(model.z,1)-1,custom.currentZ);
            model.fix(initB:finalB-1,initA:finalA-1,BlockPara(1):BlockPara(2))=vf;
    end    
    model.fix(end,end,end)=2;
    set(h.button(5),'value',1);
    d3_view(hObject,eventdata,h)
end
return


