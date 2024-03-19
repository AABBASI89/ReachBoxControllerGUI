function TDTsig2(num)
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

CHAN=3;c

for n = 1:num
    
    ARD_BOARD.digitalWrite(CHAN,1) % TDT two pulses DOOR OPEN
    pause(0.05);
    ARD_BOARD.digitalWrite(CHAN,0) 
    pause(0.05);
end
