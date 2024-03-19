function TDTsig (num)
global ARD_BOARD

for n = 1:num
    
    writeDigitalPin(ARD_BOARD, 'D3', 1);
    pause(0.05);
    writeDigitalPin(ARD_BOARD, 'D3', 0);    
    pause(0.05);
    
end