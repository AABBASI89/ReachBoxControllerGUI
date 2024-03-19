function doorOpen_callback(hObject,eventdata)
% SHAKTHI VISAGAN

global sDOOR;
global sDOOR_open_position;
global sDOOR_close_position;

if readPosition(sDOOR) ~= sDOOR_open_position
    for steps = 1:75
        writePosition(sDOOR,...
            (sDOOR_close_position+...
            (steps*((sDOOR_open_position-sDOOR_close_position)/75))));
    end
end

end