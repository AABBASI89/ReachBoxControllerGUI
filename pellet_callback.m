function pellet_callback(hObject,eventdata)
% SHAKTHI VISAGAN

global ARD_BOARD

% writeDigitalPin(a,pin,value)
writeDigitalPin(ARD_BOARD,'D7',0);
writeDigitalPin(ARD_BOARD,'D7',1);
writeDigitalPin(ARD_BOARD,'D7',0);

end