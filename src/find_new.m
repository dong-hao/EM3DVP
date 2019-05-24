function index=find_new(array1,array2)
% find new elements in array2 comparing to array1
% the location of the new elements will be returned
% 
if length(array1)>=length(array2)
    index=[];
    disp('array 2 must be no shorter than array1')
    return 
end

index=ones(length(array2)-length(array1),1); % allocating memory
j=1;
for i=1:length(array2) % loop throught array2 to find elements not equal to array1.
    if find(array1==array2(i))
        continue
    else        
        index(j)=i;
        j=j+1;
    end
end
if length(index)>(length(array2)-length(array1))
    error('please check the elements of array2 and array1')
end
return

