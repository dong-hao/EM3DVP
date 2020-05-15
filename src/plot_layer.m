function h=plot_layer(layer,res,resl,resu)
% a barn door function to plot 1d layered model
% 
if nargin<3
    opt = 'mean';
elseif nargin == 4
    opt = 'range';
else
    error('unsupported number of input parameters');
end
if size(res)~=size(layer)
    error('the number of layer must be the same of number of res')
end
NL=length(layer);
depth=0;
figure;
h=gca;
for i=1:NL-1
    if strcmp(opt,'range')
        fill([resl(i) resl(i) resu(i) resu(i)],...
            [depth layer(i) layer(i) depth],...
            [0.6 0.6 0.6],'Linestyle','none');
        hold(h,'on')
    end
    plot(h,[res(i) res(i)],[depth layer(i)],'k','linewidth',2)
    hold(h,'on');
    plot(h,[res(i) res(i+1)],[layer(i) layer(i)],'k','linewidth',2)
    depth=layer(i);
end
plot(h,[res(NL) res(NL)],[depth depth+layer(NL)],'k','linewidth',2);
hold(h,'off');
set(h, 'xscale', 'log')
set(h, 'xlim', [1 10000])
set(h, 'ylim', [depth 0])
xlabel(h,'Resistivity(\Omega m)');
ylabel(h,'Depth(km)');
daspect([100 1 1])
grid on;
return 

