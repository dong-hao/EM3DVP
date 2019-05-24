function [screen_pos,font_weight]=check_res()
% a simple function to 
% check screen resolution and set proper figure location and font weight
% 
oldUnits = get(0,'units');
set(0,'units','pixels');
ScreenSize = get(0,'ScreenSize');
set(0,'units',oldUnits);
if ScreenSize(4)>1000
    screen_pos = [120 80 1350 900];
    font_weight = 'normal';
elseif ScreenSize(4)>=800
    screen_pos = [80 60 1080 720];
    font_weight = 'normal';
elseif ScreenSize(4)>700
    screen_pos = [45 0 1080 680];
    font_weight = 'normal';
else
    msgbox('You will have better experience on a larger screen resolution',...
        'YUKI.N>')
    screen_pos = [20 30 768 512];
    font_weight = 'demi';
end
return
% 

