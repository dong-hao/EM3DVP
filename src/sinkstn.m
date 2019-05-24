function [elev,rho,fix]=sinkstn(elev,x,y,z,rho,fix,xyz,rair,rsea)
nsite=length(elev);
for isite=1:nsite
    xi=find(x>xyz(isite,1),1)-1;
    yi=find(y>xyz(isite,2),1)-1;
    if rho(xi,yi,1)>=rair % we have air layers
            zi=find(rho(xi,yi,:)<rair,1);
            if rho(xi,yi,zi)==rsea  % we have sea layers below air layers
                zi=zi+find(rho(xi,yi,zi:end)>0.3,1)-1;
                sink=-z(zi);
                if elev(isite)~=sink
                    elev(isite)=sink;
                end
                %elev(isite)=elev(isite)+250; % sink the station into the earth
            else
                sink=-z(zi);
                rho0 = rho(xi,yi,zi);
                rho(xi-1:xi+1,yi,zi:zi+2) = rho0;
                fix(xi-1:xi+1,yi,zi:zi+2) = 0;
                rho(xi,yi-1:yi+1,zi:zi+2) = rho0;
                fix(xi,yi-1:yi+1,zi:zi+2) = 0;
                if elev(isite)~=sink
                    elev(isite)=sink;
                end
            end
    elseif rho(xi,yi,1)==rsea % we have sea layers
            zi=find(rho(xi,yi,:)>rsea,1);
            sink=-z(zi);
            if elev(isite)~=sink;
                elev(isite)=sink;
                % disp(sitename{isite});
            end
    end
end
