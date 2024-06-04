function TDTsig3_n (num)
global ARD_BOARD

if ~exist('num')
    num = 1;
end

for n = 1:num
    
    writeDigitalPin(ARD_BOARD, 'D11', 1);
    pause(0.05);
    writeDigitalPin(ARD_BOARD, 'D11', 0);    
    pause(0.05);
    
end