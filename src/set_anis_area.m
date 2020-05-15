function set_anis_area(hObject,eventdata,h)
% drag a rubberband box to create a anistropic area within the area
% this is made with thin stripes of conductive and resistive blocks 
% like: 1 10 1 10 1 10 
%       1 10 1 10 1 10 
%       1 10 1 10 1 10 
%       1 10 1 10 1 10 
%       1 10 1 10 1 10 
% which will have a conductive axis striking from top to bottom, and a
% resistive axis from left to right
% apparently only orthogonal axes are supported with the nature of the
% hexahadron meshes. 
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
%=========================================================%
if initA>finalA-1||initB>finalB-1
    msgbox('YUKI.N> Please, select more than one block...','Selection');
    beep;
    uiwait;
else
    switch view
        case 1 % x-z
            BlockPara=anisdlg(length(model.y)-1,custom.currentY);
            width=BlockPara(6);
            j = 1;
            k = 1;
            if BlockPara(5)==0||BlockPara(5)==180
                st = initA;
                ed = finalA;
            elseif BlockPara(5)==270||BlockPara(5)==90
                st = initB;
                ed = finalB;
            else
                msgbox('YUKI.N> arbitary direction of anisotropy is not yet supported...','Selection');
                beep;
            end
            idx1 = zeros(floor((ed-st)/2),1);
            idx2 = zeros(floor((ed-st)/2),1);
            for i = st:ed
                re = mod(i-st+1,2*width);
                if re == 0
                    re = 2*width;
                end
                if re <= width
                    idx1(j) = i;
                    j = j+1;
                else
                    idx2(k) = i;
                    k = k+1;
                end
            end
            idx1(idx1==0)=[];
            idx2(idx2==0)=[];
            if BlockPara(5)==0||BlockPara(5)==180
                model.rho(idx1,BlockPara(1):BlockPara(2),initB:finalB-1)=BlockPara(3); 
                model.rho(idx2,BlockPara(1):BlockPara(2),initB:finalB-1)=BlockPara(4);
            elseif BlockPara(5)==270||BlockPara(5)==90
                model.rho(initA:finalA-1,BlockPara(1):BlockPara(2),idx1)=BlockPara(3); 
                model.rho(initA:finalA-1,BlockPara(1):BlockPara(2),idx2)=BlockPara(4);  
            else
                msgbox('YUKI.N> arbitary direction of anisotropy is not yet supported...','Selection');
                beep;
            end
        case 2 % y-z
            BlockPara=anisdlg(length(model.x)-1,custom.currentX);
            width=BlockPara(6);
            j = 1;
            k = 1;
            if BlockPara(5)==0||BlockPara(5)==180
                st = initA;
                ed = finalA;
            elseif BlockPara(5)==270||BlockPara(5)==90
                st = initB;
                ed = finalB;
            else
                msgbox('YUKI.N> arbitary direction of anisotropy is not yet supported...','Selection');
                beep;
            end
            idx1 = zeros(floor((ed-st)/2),1);
            idx2 = zeros(floor((ed-st)/2),1);
            for i = st:ed
                re = mod(i-st+1,2*width);
                if re == 0
                    re = 2*width;
                end
                if re <= width
                    idx1(j) = i;
                    j = j+1;
                else
                    idx2(k) = i;
                    k = k+1;
                end
            end
            idx1(idx1==0)=[];
            idx2(idx2==0)=[];
            if BlockPara(5)==0||BlockPara(5)==180
                model.rho(BlockPara(1):BlockPara(2),idx1,initB:finalB-1)=BlockPara(3);
                model.rho(BlockPara(1):BlockPara(2),idx2,initB:finalB-1)=BlockPara(4);
            elseif BlockPara(5)==270||BlockPara(5)==90
                model.rho(BlockPara(1):BlockPara(2),initA:finalA-1,idx1)=BlockPara(3);
                model.rho(BlockPara(1):BlockPara(2),initA:finalA-1,idx2)=BlockPara(4);
            else
                msgbox('YUKI.N> arbitary direction of anisotropy is not yet supported...','Selection');
                beep;                
            end
        case 3 % x-y
            BlockPara=anisdlg(size(model.z,1)-1,custom.currentZ);
            width=BlockPara(6);
            j = 1;
            k = 1;
            if BlockPara(5)==0||BlockPara(5)==180
                st = initA;
                ed = finalA;
            elseif BlockPara(5)==270||BlockPara(5)==90
                st = initB;
                ed = finalB;
            else
                msgbox('YUKI.N> arbitary direction of anisotropy is not yet supported...','Selection');
                beep;
            end
            idx1 = zeros(floor((ed-st)/2),1);
            idx2 = zeros(floor((ed-st)/2),1);
            for i = st:ed
                re = mod(i-st+1,2*width);
                if re == 0
                    re = 2*width;
                end
                if re <= width
                    idx1(j) = i;
                    j = j+1;
                else
                    idx2(k) = i;
                    k = k+1;
                end
            end
            idx1(idx1==0)=[];
            idx2(idx2==0)=[];
            if BlockPara(5)==0||BlockPara(5)==180
                model.rho(initB:finalB-1,idx1,BlockPara(1):BlockPara(2))=BlockPara(3);
                model.rho(initB:finalB-1,idx2,BlockPara(1):BlockPara(2))=BlockPara(4);
            elseif BlockPara(5)==270||BlockPara(5)==90
                model.rho(idx1,initA:finalA-1,BlockPara(1):BlockPara(2))=BlockPara(3);
                model.rho(idx2,initA:finalA-1,BlockPara(1):BlockPara(2))=BlockPara(4);            
            else
                msgbox('YUKI.N> arbitary direction of anisotropy is not yet supported...','Selection');
                beep;                
            end
    end
    set(h.button(5),'value',0);    
    d3_view(hObject,eventdata,h);%plot currentlayer                   
end
return

