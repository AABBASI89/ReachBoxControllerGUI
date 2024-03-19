function doorClose_callback(hObject,eventdata)
% SHAKTHI VISAGAN

global sDOOR;
global sDOOR_open_position;
global sDOOR_close_position;
    
if readPosition(sDOOR) ~= sDOOR_close_position
    for steps = 1:100
        writePosition(sDOOR,...
            (sDOOR_open_position-...
            (steps*((sDOOR_open_position-sDOOR_close_position)/100))));
    end
end

end