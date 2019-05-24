function weight=makewin(xs,x,loghbw,opt)
% a silly function to make windows for downsampling data series 
% the weight will be automatically determined by the distance from the
% supposed centre frequency
% xs: the "centre frequency", which is to be smoothed from its neighbouring
%     frequencies
% x:  the frequencies of the neighbouring data points
% loghbw: the half bandwidth for xs 
% opt: the type of windows to be designed. 'b' for boxcar, 't' for
% triangle, 'h' for hanning (sin) window.
nw=length(x);
weight=ones(1,nw);
for i=1:nw
    dis=abs(xs-x(i));
    switch opt
        case 't'
            weight(i)=(loghbw-dis)/loghbw;
        case 'b'
            %do nothing (for we already have boxcar window of ones)
        case 's'
            weight(i)=sin((loghbw-dis)/loghbw*pi/2);     
        otherwise
            %do nothing (for we already have boxcar window of ones)
    end
end
weight=weight./sum(weight);
return

