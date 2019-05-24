function idx=istrap(x,a,b)
% a silly function to find the elements of array x, which fall in a and b 
% interval
% return the index of the array
[a,b]=swap(a,b);
ix1=find(x>a);
ix2=find(x<b);
idx=intersect(ix1,ix2);
return


