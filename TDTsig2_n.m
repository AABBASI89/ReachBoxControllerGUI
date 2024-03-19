function TDTsig2_n(num)
global ARD_BOARD
global fh
global pelLoc
global R_mot_pellet
global L_mot_pellet
global Door_open
global Door_close
global stopState

if ~exist('num')
    num = 1;
end

for n = 1:num
    
    writeDigitalPin(ARD_BOARD, 'D4', 1);
    pause(0.05);
    writeDigitalPin(ARD_BOARD, 'D4', 0);    
    pause(0.05);
    
end
