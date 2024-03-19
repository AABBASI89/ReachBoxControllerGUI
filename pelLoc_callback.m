function pelLoc_callback(hObject,eventdata)
% SHAKTHI VISAGAN
% Handedness

global fh
global hand

if strcmp(get(fh.pelLoc,'String'),'R Handed Rat')
    set(fh.pelLoc,'BackgroundColor',[1 0.2 0.2],'String','L Handed Rat')
    hand = 2;
else
    set(fh.pelLoc,'BackgroundColor',[0.2 1 0.2],'String','R Handed Rat')
    hand = 1;
end
    
end