function pause_callback(hObject,eventData)
% SHAKTHI VISAGAN

global fh

if get(fh.pause,'Value')
    set(fh.pause,'String','RESUME')
    uiwait
else
    set(fh.pause,'String','PAUSE')
    uiresume
end
    
end
