function rms=calc_rms(isite, ifreq, opt)
% function to calculate rms for single site.
% isite; site index
% ifreq: freq index
% opt: could by 'xyyx' 'xxyy' 'z' 'txty' or 'all'
global data resp
switch nargin
    case 0
        error('not enough input arguments, 2 at least')
    case 1
        error('not enough input arguments, 2 at least')       
    case 2
        opt='xyyx'; % by default, calculate Z off-diagnol rms
end
nfreq=length(ifreq);
switch opt
    case 'xyyx' % off diagnol impedance
        obs=data(isite).tf_o(ifreq,[4 5 7 8]);
        res=resp(isite).tf_o(ifreq,[4 5 7 8]);
        err=data(isite).tf_o(ifreq,[6 6 9 9]);
        Nres=4;
    case 'xxyy' % diagnol impedance
        obs=data(isite).tf_o(ifreq,[1 2 10 11]);
        res=resp(isite).tf_o(ifreq,[1 2 10 11]);
        err=data(isite).tf_o(ifreq,[3 3 12 12]);
        Nres=4;
    case 'txty' % tipper
        obs=data(isite).tf_o(ifreq,[13 14 16 17]);
        res=resp(isite).tf_o(ifreq,[13 14 16 17]);
        err=data(isite).tf_o(ifreq,[15 15 18 18]);
        Nres=4;
    case 'z'    % full impedance
        obs=data(isite).tf_o(ifreq,[1 2 4 5 7 8 10 11]);
        res=resp(isite).tf_o(ifreq,[1 2 4 5 7 8 10 11]);
        err=data(isite).tf_o(ifreq,[3 3 6 6 9 9 12 12]);
        Nres=8;
    case 'full' % everything
        obs=data(isite).tf_o(ifreq,[1 2 4 5 7 8 10 11 13 14 16 17]);
        res=resp(isite).tf_o(ifreq,[1 2 4 5 7 8 10 11 13 14 16 17]);
        err=data(isite).tf_o(ifreq,[3 3 6 6 9 9 12 12 15 15 18 18]);
        Nres=12;
end
misfit=abs(obs-res)./err;
misfit=misfit.*misfit;
misfit=sum(misfit(:));
N=nfreq*Nres;
rms=sqrt(misfit/N);
return

